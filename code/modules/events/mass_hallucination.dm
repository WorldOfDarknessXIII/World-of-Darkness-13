/datum/round_event_control/mass_hallucination
	name = "Mass Hallucination"
	typepath = /datum/round_event/mass_hallucination
	weight = 10
	max_occurrences = 2
	min_players = 1

/datum/round_event/mass_hallucination
	fakeable = FALSE

/datum/round_event/mass_hallucination/start()
	switch(rand(1,4))
		if(1) //same sound for everyone
			var/sound = pick("airlock","airlock_pry","console","explosion","far_explosion","mech","glass","alarm","beepsky","mech","wall_decon","door_hack","tesla")
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				if(C.z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))//not for admin/ooc stuff
					continue
				new /datum/hallucination/sounds(C, TRUE, sound)
		if(2)
			var/weirdsound = pick("phone","hallelujah","highlander","hyperspace","game_over","creepy","tesla")
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				if(C.z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))//not for admin/ooc stuff
					continue
				new /datum/hallucination/weird_sounds(C, TRUE, weirdsound)
		if(3 to 5)
			var/picked_hallucination = pick(	/datum/hallucination/chat,
												/datum/hallucination/message,
												/datum/hallucination/battle,
												/datum/hallucination/fire,
												/datum/hallucination/self_delusion,
												/datum/hallucination/death,
												/datum/hallucination/delusion,
												/datum/hallucination/oh_yeah)
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				if(C.z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))//not for admin/ooc stuff
					continue
				new picked_hallucination(C, TRUE)
