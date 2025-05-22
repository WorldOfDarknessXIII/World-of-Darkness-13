/datum/keybinding/human/bite
	hotkey_keys = list("F")
	name = "bite"
	full_name = "Bite"
	description = "Bite whoever you're aggressively grabbing, and feed on them if possible."
	keybind_signal = COMSIG_KB_HUMAN_BITE_DOWN

/datum/keybinding/human/bite/down(client/user)
	. = ..()
	if (.)
		return

	if (!ishuman(user.mob))
		return TRUE
	var/mob/living/carbon/human/drinker = user.mob

	if (drinker.grab_state < GRAB_AGGRESSIVE)
		return TRUE
	if (!isliving(drinker.pulling))
		return TRUE
	var/mob/living/victim = drinker.pulling

	drinker.bite(victim)
