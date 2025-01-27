/mob/living/carbon/human/npc/proc/Aggro(var/mob/victim, var/attacked = FALSE)
	if(attacked && danger_source != victim)
		walk(src,0)
	if(victim == src)
		return
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		if(H.vampire_faction == vampire_faction || presence_master == H)
			return
	if(istype(victim,/mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/H = victim
		if(H && !H.presence_master)
			return
	if((stat != DEAD) && !HAS_TRAIT(victim, TRAIT_DEATHCOMA))
		danger_source = victim
		if(attacked)
			last_attacker = victim
			if(health != last_health)
				last_health = health
				last_damager = victim
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
