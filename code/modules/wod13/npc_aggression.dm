/mob/living/carbon/human/npc/proc/Aggro(var/mob/M, var/attacked = FALSE)
	if(attacked && danger_source != M)
		walk(src,0)
	if(M == src)
		return
	if((stat != DEAD) && !HAS_TRAIT(M, TRAIT_DEATHCOMA))
		danger_source = M
		if(attacked)
			last_attacker = M
			if(health != last_health)
				last_health = health
				last_damager = M
	if(CheckMove())
		return
	if((last_danger_meet + 5 SECONDS) < world.time)
		last_danger_meet = world.time
		if(prob(50))
			if(!my_weapon)
				if(prob(50))
					emote("scream")
				else
					RealisticSay(pick(socialrole.help_phrases))
			else
				RealisticSay(pick(socialrole.help_phrases))
