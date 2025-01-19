/mob/living/carbon/human/npc/proc/Aggro(var/mob/M, var/attacked = FALSE)
	if(M == src)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.vampire_faction == vampire_faction || presence_master == H)
			return
	if(istype(M,/mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/H = M
		if(H && !H.presence_master)
			return
	if((stat != DEAD) && !HAS_TRAIT(M, TRAIT_DEATHCOMA))
		danger_source = M
		if(attacked)
			last_attacker = M
			if(health != last_health)
				last_health = health
				last_damager = M
	if(CheckMove(hardlock = TRUE))
		return
	if((last_danger_meet + 2 SECONDS) < world.time)
		last_danger_meet = world.time
		if(prob(50))
			if(!my_weapon)
				if(prob(50))
					emote("scream")
				else
					RealisticSay(pick(socialrole.help_phrases))
			else
				RealisticSay(pick(socialrole.help_phrases))
