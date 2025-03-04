/datum/controller/master/proc/give_players_experience()
	for(var/mob/living/carbon/werewolf/W in GLOB.player_list)
		if(!W)
			continue
		if(W.stat == DEAD)
			continue
		if(!W.key)
			continue
		var/datum/preferences/P = GLOB.preferences_datums[ckey(W.key)]
		if(P)
			P.add_experience(3)

	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H)
			continue
		if(H.stat == DEAD)
			continue
		if(!H.key)
			continue
		var/datum/preferences/P = GLOB.preferences_datums[ckey(H.key)]
		if(!P)
			continue
		P.add_experience(1)
		if(H.mind)
			if("[H.mind.assigned_role]" == "Prince" || "[H.mind.assigned_role]" == "Sheriff" || "[H.mind.assigned_role]" == "Hound" ||  "[H.mind.assigned_role]" == "Seneschal" || "[H.mind.assigned_role]" == "Chantry Regent" || "[H.mind.assigned_role]" == "Baron" || "[H.mind.assigned_role]" == "Dealer")
				P.add_experience(2)
		if(H.total_erp > 9000)
			P.add_experience(2)
		if(H.total_cleaned > 25)
			P.add_experience(1)
			call_dharma("cleangrow", H)
		if(H.mind)
			if(H.mind.assigned_role == "Graveyard Keeper")
				if(SSgraveyard.total_good > SSgraveyard.total_bad)
					P.add_experience(1)
			if(H.mind.special_role)
				var/datum/antagonist/A = H.mind.special_role
				if(A.check_completed())
					P.add_experience(3)
		P.save_preferences()
		P.save_character()
