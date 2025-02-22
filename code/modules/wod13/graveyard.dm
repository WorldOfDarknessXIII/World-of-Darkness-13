SUBSYSTEM_DEF(graveyard)
	name = "Graveyard"
	init_order = INIT_ORDER_DEFAULT
	wait = 3000
	priority = FIRE_PRIORITY_DEFAULT

	var/alive_zombies = 0	//MAX - 20, respawn every 5 minutes
	var/lost_points = 0
	var/clear_runs = 0
	var/list/graves = list()

	var/total_good = 0
	var/total_bad = 0

/datum/controller/subsystem/graveyard/fire()
	var/continue_the_shift = FALSE
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L)
			if(L.mind)
				if(L.mind.assigned_role == "Graveyard Keeper")
					if(L.client)
						continue_the_shift = TRUE
	if(!continue_the_shift)
		return
	if(alive_zombies < 10)
		for(var/mob/living/carbon/human/L in GLOB.player_list)
			if(L)
				if(L.mind)
					if(L.mind.assigned_role == "Graveyard Keeper")
						if(L.client)
							to_chat(L, "WALKING DEAD ARE RISING...")
		for(var/i in 1 to 30-alive_zombies)
			var/atom/grave = pick(graves)
			new /mob/living/simple_animal/hostile/zombie(grave.loc)
			alive_zombies = max(0, alive_zombies+1)
		clear_runs = max(0, clear_runs+1)
	else
		lost_points = max(0, lost_points+1)
		clear_runs = 0

//	if(lost_points > 2)
//		for(var/mob/living/carbon/human/L in GLOB.player_list)
//			if(L)
//				if(L.mind)
//					if(L.mind.assigned_role == "Graveyard Keeper")
//						if(L.client)
//							if(istype(get_area(L), /area/vtm/graveyard))
//								L.AdjustMasquerade(-1)
//								total_bad += 1
//		lost_points = 0

	if(clear_runs > 2)
		clear_runs = 0
		for(var/mob/living/carbon/human/L in GLOB.player_list)
			if(L)
				if(L.mind)
					if(L.mind.assigned_role == "Graveyard Keeper")
						if(L.client && L.key)
							total_good += 1
//							var/datum/preferences/P = GLOB.preferences_datums[ckey(L.key)]
//							if(P)
//								L.AdjustMasquerade(1)
//								var/mode = 1
//								if(HAS_TRAIT(L, TRAIT_NON_INT))
//									mode = 2
//								P.exper = min(calculate_mob_max_exper(L), P.exper+((250+L.experience_plus)/mode))

/obj/vampgrave
	icon = 'icons/wod13/props.dmi'
	icon_state = "grave1"
	name = "grave"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/vampgrave/Initialize()
	. = ..()
	SSgraveyard.graves += src
	icon_state = "grave[rand(1, 10)]"
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "grave[rand(1, 10)]-snow"

/obj/vampgrave/Destroy()
	. = ..()
