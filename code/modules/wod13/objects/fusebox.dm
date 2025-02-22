/obj/fusebox
	name = "fuse box"
	desc = "Power the controlled area with pure electricity."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "fusebox"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	pixel_y = 32
	var/damaged = 0
	var/repairing = FALSE

/obj/fusebox/proc/check_damage(var/mob/living/user)
	if(damaged > 100 && icon_state != "fusebox_open")
		icon_state = "fusebox_open"
		var/area/A = get_area(src)
		A.requires_power = TRUE
		A.fire_controled = FALSE
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, get_turf(src))
		s.start()
		for(var/obj/machinery/light/L in A)
			L.update(FALSE)
		playsound(loc, 'code/modules/wod13/sounds/explode.ogg', 100, TRUE)
		if(user)
			user.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)

/obj/fusebox/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/wire_cutters))
		if(!repairing)
			repairing = TRUE
			if(do_after(user, 100, src))
				icon_state = "fusebox"
				damaged = 0
				playsound(get_turf(src),'code/modules/wod13/sounds/fix.ogg', 75, FALSE)
				var/area/A = get_area(src)
				A.requires_power = FALSE
				if(initial(A.fire_controled))
					A.fire_controled = TRUE
				for(var/obj/machinery/light/L in A)
					L.update(FALSE)
				repairing = FALSE
			else
				repairing = FALSE
	else
		..()
		if(I.force)
			damaged += I.force
			check_damage(user)
