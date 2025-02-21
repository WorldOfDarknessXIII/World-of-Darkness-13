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
