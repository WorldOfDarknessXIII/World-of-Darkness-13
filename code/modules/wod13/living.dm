/mob/living/proc/get_total_strength()
	return strength + additional_strength

/mob/living/proc/get_total_dexterity()
	return dexterity + additional_dexterity

/mob/living/proc/get_total_social()
	if(iscathayan(src))
		if(mind?.dharma?.animated == "Yin")
			return max(0, social + additional_social - 2)
	return social + additional_social

/mob/living/proc/get_total_mentality()
	return mentality + additional_mentality

/mob/living/proc/get_total_blood()
	return blood + additional_blood

/mob/living/proc/get_total_lockpicking()
	return lockpicking + additional_lockpicking

/mob/living/proc/get_total_athletics()
	return athletics + additional_athletics

/mob/living/verb/untorpor()
	set hidden = TRUE
	if(HAS_TRAIT(src, TRAIT_TORPOR))
		if(iskindred(src))
			if (bloodpool > 0)
				bloodpool -= 1
				cure_torpor()
				to_chat(src, "<span class='notice'>You have awoken from your Torpor.</span>")
			else
				to_chat(src, "<span class='warning'>You have no blood to re-awaken with...</span>")
		if(iscathayan(src))
			if (yang_chi > 0)
				yang_chi -= 1
				cure_torpor()
				to_chat(src, "<span class='notice'>You have awoken from your Little Death.</span>")
			else if (yin_chi > 0)
				yin_chi -= 1
				cure_torpor()
				to_chat(src, "<span class='notice'>You have awoken from your Little Death.</span>")
			else
				to_chat(src, "<span class='warning'>You have no Chi to re-awaken with...</span>")

/mob/living/proc/torpor(source)
	if (HAS_TRAIT(src, TRAIT_TORPOR))
		return
	if (fakedeath(source))
		to_chat(src, "<span class='danger'>You have fallen into Torpor. Use the button in the top right to learn more, or attempt to wake up.</span>")
		ADD_TRAIT(src, TRAIT_TORPOR, source)
		if (iskindred(src))
			var/mob/living/carbon/human/vampire = src
			var/datum/species/kindred/vampire_species = vampire.dna.species
			var/torpor_length = 0 SECONDS
			switch(humanity)
				if(10)
					torpor_length = 1 MINUTES
				if(9)
					torpor_length = 3 MINUTES
				if(8)
					torpor_length = 4 MINUTES
				if(7)
					torpor_length = 5 MINUTES
				if(6)
					torpor_length = 10 MINUTES
				if(5)
					torpor_length = 15 MINUTES
				if(4)
					torpor_length = 30 MINUTES
				if(3)
					torpor_length = 1 HOURS
				if(2)
					torpor_length = 2 HOURS
				if(1)
					torpor_length = 3 HOURS
				else
					torpor_length = 5 HOURS
			COOLDOWN_START(vampire_species, torpor_timer, torpor_length)
		if (iscathayan(src))
			var/mob/living/carbon/human/cathayan = src
			var/datum/dharma/dharma = cathayan.mind.dharma
			var/torpor_length = 1 MINUTES * max_yin_chi
			COOLDOWN_START(dharma, torpor_timer, torpor_length)

/mob/living/proc/cure_torpor(source)
	if (!HAS_TRAIT(src, TRAIT_TORPOR))
		return

	while(health <= HEALTH_THRESHOLD_CRIT)
		if(getStaminaLoss() > 0)
			heal_overall_damage(stamina = 10)
		else if(getOxyLoss() > 0)
			adjustOxyLoss(-10)
		else if(getBruteLoss() > 0)
			heal_overall_damage(brute = 10)
		else if(getToxLoss() > 0)
			adjustToxLoss(-10)
		else if(getFireLoss() > 0)
			heal_overall_damage(burn = 10)

	cure_fakedeath(source)
	REMOVE_TRAIT(src, TRAIT_TORPOR, source)
	if(iskindred(src))
		to_chat(src, "<span class='notice'>You have awoken from your Torpor.</span>")
	if(iscathayan(src))
		to_chat(src, "<span class='notice'>You have awoken from your Little Death.</span>")
