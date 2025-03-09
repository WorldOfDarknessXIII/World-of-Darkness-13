/datum/splat/supernatural/kindred/ghoul
	splat_id = "ghoul"
	splat_traits = list(
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOCRITDAMAGE
		)
	var/mob/living/master
	splat_flag = GHOUL_SPLAT
	torpor_timer = null
	//We're subtyping ghouls under kindred since most of their abilities are just kindred if they were weak
	damage_mods = null
	clane = null
	splat_actions = list(
		/datum/action/my_info/ghoul
	)
	splat_signals = null
	generation = null
	power_stat_max = 3
	integrity = /datum/integrity_tracker/integrity
	selectable = TRUE

/datum/splat/supernatural/kindred/ghoul/on_apply()
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED_TO, PROC_REF(check_ghoulish_validity))
	..()

/datum/splat/supernatural/kindred/ghoul/proc/ghoul_splat_special_handling()
	return TRUE

/datum/splat/supernatural/kindred/ghoul/proc/check_ghoulish_validity(datum/source, datum/splat/supernatural/kindred/splat_gained)
	SIGNAL_HANDLER

	if(!istype(splat_gained, /datum/splat/supernatural/kindred))
		return NONE

	splat_gained.handle_ghoul_uplift(src)
	Remove(my_character)

/datum/action/my_info/ghoul
	name = "About Me"
	desc = "Check assigned role, master, humanity, masquerade, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/my_info/ghoul/Trigger()
	#warn "implement this"

/datum/action/take_vitae
	#warn "implement this"
