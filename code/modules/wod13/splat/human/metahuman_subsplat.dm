/// It seems an arbitrary distinction but these will be splats or splat-likes that don't render you technically not human while still giving
/// more(or less?) than human abilities or characteristics; Hunters, Immortals from CofD, Slashers, etc
/datum/splat/metahuman

/datum/splat/metahuman/on_apply()
	. = ..()
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_REMOVED_FROM, PROC_REF(exclusive_to_humans))

/datum/splat/metahuman/proc/exclusive_to_humans(datum/source, datum/splat/removing_splat)
	SIGNAL_HANDLER

	if(!istype(removing_splat, /datum/splat/human))
		return NONE
	log_game("[my_character] lost the [splat_id] splat along with their humanity.")
	Remove(my_character)

/datum/splat/metahuman/on_remove()
	UnregisterSignal(my_character, COMSIG_SPLAT_SPLAT_REMOVED_FROM)
	..()
