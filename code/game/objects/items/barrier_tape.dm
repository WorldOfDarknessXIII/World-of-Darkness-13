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

/obj/item/barrier_tape/afterattack(atom/A, mob/user, proximity)
	if(proximity && istype(A, /obj/machinery/door))
		var/turf/T = get_turf(A)
		var/obj/structure/barrier_tape/P = new tape_type(T)
		P.icon_state = "[icon_base]_door"
		to_chat(user, "<span class='notice'>You finish placing [src].</span>")

/obj/structure/barrier_tape/proc/crumple()
	if(!crumpled)
		crumpled = TRUE
		icon_state = "[icon_state]_c"
		name = "crumpled [name]"