/datum/splat/human
	splat_id = "human"
	integrity = /datum/integrity_tracker/integrity
	splat_flag = PURE_HUMAN_SPLAT
	splat_actions = list(
		/datum/action/my_info
	)
	selectable = TRUE

/datum/splat/human/on_apply()
	. = ..()
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED_TO, PROC_REF(dehumanize))

/datum/splat/human/proc/dehumanize(datum/source, datum/splat/new_splat)
	SIGNAL_HANDLER

	if(!istype(new_splat, /datum/splat/supernatural))	//you don't belong in this world!
		return NONE
	log_game("[my_character] is no longer human as a result of gaining the [splat_id] splat.")
	Remove(my_character)

/datum/splat/human/on_remove()
	UnregisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED_TO)
	..()
