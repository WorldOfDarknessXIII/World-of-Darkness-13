/obj/item/barrier_tape
	name = "barrier tape roll"
	icon = 'icons/obj/barriertape.dmi'
	icon_state = "rollstart"
	w_class = WEIGHT_CLASS_SMALL
	var/turf/start
	var/turf/end
	var/tape_type = /obj/structure/barrier_tape
	var/icon_base
	var/placing = FALSE

/obj/structure/barrier_tape
	name = "barrier tape"
	icon = 'icons/obj/barriertape.dmi'
	anchored = TRUE
	density = TRUE
	var/lifted = FALSE
	var/crumpled = FALSE
	var/icon_base
	var/tape_dir


/obj/item/barrier_tape/police
	name = "police tape"
	desc = "A roll of police tape used to block off crime scenes from the public."
	icon_state = "police_start"
	tape_type = /obj/structure/barrier_tape/police
	icon_base = "police"

/obj/structure/barrier_tape/police
	name = "police tape"
	desc = "A length of police tape.  Do not cross."
	req_access = list(ACCESS_SECURITY)
	icon_base = "police"


/obj/structure/barrier_tape/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return
	if(mover.pass_flags & PASSGLASS)
		return TRUE
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat)	// Allow dragging unconscious/dead people
			return TRUE
		if(lifted)
			return TRUE
	return FALSE

/obj/structure/barrier_tape/attack_hand(mob/living/user)
	if(user.a_intent != INTENT_HARM)
		user.visible_message("<span class='notice'>[user] lifts [src], allowing passage.</span>")
		lift_tape()
	else
		user.visible_message("<span class='notice'>[user] tears down [src]!</span>")
		playsound(src, 'sound/items/poster_ripped.ogg', 100, TRUE)
		qdel(src)

/obj/structure/barrier_tape/proc/lift_tape()
	lifted = TRUE
	density = FALSE
	addtimer(CALLBACK(src, PROC_REF(drop_tape)), 2 SECONDS)

/obj/structure/barrier_tape/proc/drop_tape()
	lifted = FALSE
	density = TRUE

/obj/structure/barrier_tape/Bumped(atom/movable/AM)
	if(iscarbon(AM))
		var/mob/living/carbon/C = AM
		to_chat(C, "<span class='notice'>You can lift [src] by right-clicking on it.</span>")

/obj/item/barrier_tape/attack_self(mob/user)
	if(!placing)
		start = get_turf(src)
		to_chat(user, "<span class='notice'>You place the first end of [src].</span>")
		icon_state = "[icon_base]_stop"
		placing = TRUE
	else
		placing = FALSE
		icon_state = "[icon_base]_start"
		end = get_turf(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			to_chat(user, "<span class='notice'>[src] can only be laid horizontally or vertically.</span>")
			return

		var/turf/cur = start
		var/dir
		if(start.x == end.x)
			var/d = end.y-start.y
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x,end.y+d,end.z))
			dir = "v"
		else
			var/d = end.x-start.x
			if(d) d = d/abs(d)
			end = get_turf(locate(end.x+d,end.y,end.z))
			dir = "h"

		var/can_place = TRUE
		while(cur != end && can_place)
			if(cur.density || istype(cur, /turf/open/space))
				can_place = FALSE
			else
				for(var/obj/O in cur)
					if(!istype(O, /obj/structure/barrier_tape) && O.density)
						can_place = FALSE
						break
			cur = get_step_towards(cur,end)

		if(!can_place)
			to_chat(user, "<span class='notice'>You can't run \the [src] through that!</span>")
			return

		cur = start
		var/tapetest = FALSE
		while(cur != end)
			for(var/obj/structure/barrier_tape/Ptest in cur)
				if(Ptest.tape_dir == dir)
					tapetest = TRUE
			if(!tapetest)
				var/obj/structure/barrier_tape/P = new tape_type(cur)
				P.icon_state = "[P.icon_base]_[dir]"
				P.tape_dir = dir
			cur = get_step_towards(cur,end)
		to_chat(user, "<span class='notice'>You finish placing [src].</span>")

/obj/item/barrier_tape/afterattack(atom/A, mob/user, proximity)
	if(proximity && istype(A, /obj/structure/vampdoor))
		var/turf/T = get_turf(A)
		var/obj/structure/barrier_tape/P = new tape_type(T)
		P.icon_state = "[icon_base]_door"
		P.layer = ABOVE_ALL_MOB_LAYER + 0.1
		to_chat(user, "<span class='notice'>You finish placing [src].</span>")

/obj/structure/barrier_tape/proc/crumple()
	if(!crumpled)
		crumpled = TRUE
		icon_state = "[icon_state]_c"
		name = "crumpled [name]"
