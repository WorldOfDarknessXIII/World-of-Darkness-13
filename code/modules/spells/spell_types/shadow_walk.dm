#define SHADOW_REGEN_RATE 1.5

/obj/effect/proc_holder/spell/targeted/shadowwalk
	name = "Shadow Walk"
	desc = "Grants unlimited movement in darkness."
	charge_max = 0
	clothes_req = FALSE
	antimagic_allowed = TRUE
	phase_allowed = TRUE
	selection_type = "range"
	range = -1
	include_user = TRUE
	cooldown_min = 0
	overlay = null
	action_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	action_icon_state = "ninja_cloak"
	action_background_icon_state = "bg_alien"
	var/activating = FALSE

/obj/effect/proc_holder/spell/targeted/shadowwalk/cast(list/targets,mob/living/user = usr)
	var/L = user.loc

	//If used in front of a mirror, allows you to teleport through it to other non-broken mirrors
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(locate(/obj/structure/mirror) in L)
			var/new_mirror = input(user, "Choose the mirror to travel:","Enter Mirror",null) as null|anything in GLOB.las_mirrors
			if(new_mirror)
				if(istype(new_mirror, /obj/structure/mirror))
					var/obj/structure/mirror/M = new_mirror
					H.bloodpool = max(0, H.bloodpool-2)
					H.Stun(10)
					animate(H, color = "#000000", time = 10)
					playsound(user.loc, 'code/modules/wod13/sounds/necromancy.ogg', 50, FALSE)
					spawn(10)
						H.forceMove(M.loc)
						H.Stun(10)
						animate(H, color = initial(H.color), time = 10)
						playsound(L, 'code/modules/wod13/sounds/necromancy.ogg', 50, FALSE)
					return
			//Proceed to normal activation if they didn't select a mirror

	if(istype(user.loc, /obj/effect/dummy/phased_mob/shadow))
		var/obj/effect/dummy/phased_mob/shadow/S = L
		S.end_jaunt(FALSE)
		return

	//If activated on a dark tile, makes you invisible and lets you phase through walls until you hit a lit up tile
	else
		var/turf/T = get_turf(user)
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			if(!activating)
				activating = TRUE
				if(do_mob(user, user, 50))
					activating = FALSE
					playsound(get_turf(user), 'sound/magic/ethereal_enter.ogg', 50, TRUE, -1)
					visible_message("<span class='boldwarning'>[user] melts into the shadows!</span>")
					user.SetAllImmobility(0)
					user.setStaminaLoss(0, 0)
					var/obj/effect/dummy/phased_mob/shadow/S2 = new(get_turf(user.loc))
					user.forceMove(S2)
					S2.jaunter = user
				else
					activating = FALSE
		else
			to_chat(user, "<span class='warning'>It isn't dark enough here!</span>")

/obj/effect/dummy/phased_mob/shadow
	var/mob/living/jaunter
	var/last_go = 0

/obj/effect/dummy/phased_mob/shadow/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/dummy/phased_mob/shadow/Destroy()
	jaunter = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/dummy/phased_mob/shadow/process(delta_time)
//	var/turf/T = get_turf(src)
//	var/light_amount = T.get_lumcount()
	if(!jaunter || jaunter.loc != src)
		qdel(src)
//	if (light_amount < 0.2 && (!QDELETED(jaunter))) //heal in the dark
//		jaunter.heal_overall_damage((SHADOW_REGEN_RATE * delta_time), (SHADOW_REGEN_RATE * delta_time), 0, BODYPART_ORGANIC)
	check_light_level()


/obj/effect/dummy/phased_mob/shadow/relaymove(mob/living/user, direction)
	if(last_go+5 > world.time)
		return
	last_go = world.time
	var/turf/oldloc = loc
	. = ..()
	if(loc != oldloc)
		if(!check_light_level())
			user.forceMove(oldloc)

/obj/effect/dummy/phased_mob/shadow/phased_check(mob/living/user, direction)
	. = ..()
	if(. && isspaceturf(.))
		to_chat(user, "<span class='warning'>It really would not be wise to go into space.</span>")
		return FALSE

/obj/effect/dummy/phased_mob/shadow/proc/check_light_level()
	var/turf/T = get_turf(src)
	var/light_amount = T.get_lumcount()
	if(light_amount > 0.2) // jaunt ends
		end_jaunt(TRUE)
		return FALSE
	else
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.name == "San Francisco")
				end_jaunt(TRUE)
				return FALSE
		else
			end_jaunt(TRUE)
			return FALSE
	return TRUE

/obj/effect/dummy/phased_mob/shadow/proc/end_jaunt(forced = FALSE)
	if(jaunter)
		if(forced)
			visible_message("<span class='boldwarning'>[jaunter] is revealed by the light!</span>")
		else
			visible_message("<span class='boldwarning'>[jaunter] emerges from the darkness!</span>")
		playsound(loc, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	qdel(src)


#undef SHADOW_REGEN_RATE
