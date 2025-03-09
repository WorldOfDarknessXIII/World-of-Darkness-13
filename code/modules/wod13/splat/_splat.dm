
#define SPLATTED(M, S) SEND_SIGNAL(SSsplats, COMSIG_SPLAT_SPLAT_APPLIED_TO, M, S)
#define UNSPLATTED(M, S) SEND_SIGNAL(SSsplats, COMSIG_SPLAT_SPLAT_REMOVED_FROM, M, S)

/datum/splat
	///We change this when applied to track people's splat assignments
	var/name = null
	///For record keeping and sanity
	var/splat_id = null
	/// Pretty much every splat has a power stat; vitae, gnosis, etc
	var/power_stat_name = null
	var/power_stat_max = 0
	var/power_stat_current = 0
	///Traits to apply/remove in their respective instances
	var/list/splat_traits = null
	/*
	 * PROC_REFs and signal(s) to listen for, respectively. Defined here for organization
	 * list(
	 *		proc_ref1 = signal_name1,
	 *		proc_ref2 = list(signal_name2,signal_name3),
	 *	...)
	 * Will always register to listen to our character for the signal; this is NOT for boilerplate signals like splat_applied_to
	 * RegisterSignal(my_character, signal_name(s), PROC_REF(proc_ref))
	 * It's not exactly the most optimized way to do this, but I'm trading optimization for
	 * readability and ease of use. Supports TYPE_PROC and GLOBAL_PROC refs.
	 */
	var/list/splat_signals = null
	var/integrity_name = "Integrity"
	var/integrity_level = 7
	/// Some things can cause your max integrity to be lower than 10, so let's make sure we track it
	var/integrity_max = 10
	///A bitflag that this splat will return in response to anything that splat checks us, which will usually be the helpers.
	var/splat_flag = null
	///Our very special lady, gentleman, theydie, gentlethem, or horrifying monstrosity that should not be
	var/mob/living/my_character = null
	///Whether this splat can be selected when creating a character
	var/selectable = FALSE
	///Damage mods that this splat gives the user (vamps take more burn, less brute, no cold, etc)
	var/list/damage_mods = null
	///refer to code\modules\mob\living\carbon\human\physiology.dm

/* Primarily for signal registration and a handle for SSsplats to make and apply a new splat, we want to do most of the effect
 * work of a splat application using my_character since it SHOULD be getting assigned.
 * my_character = who or whatever is getting the splat. Note that it is mob/living and not carbon or human; ghoul pets comes to mind.
 * splat_response is a signal handler for splat checking.
 * then we do all our important work in on_apply
*/
/datum/splat/proc/Apply(mob/living/character)
	SHOULD_CALL_PARENT(TRUE)
	my_character = character
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_CHECKED, PROC_REF(splat_response))
	on_apply(my_character)

/* In a perfect world this would have no args and function off of my_character but we want to future proof for whatever circumstance
 * may call for mass splat removal or something.
 * Unregisters the signals then does any heavy_lifting in on_remove
*/
/datum/splat/proc/Remove(mob/living/character)
	SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(character, COMSIG_SPLAT_SPLAT_CHECKED)
	on_remove(character)

/* Name the splat helpfully, apply splat inherent effects, signal the character for any possible listeners, then start tracking on the splat
 * subsystem.
*/
/datum/splat/proc/on_apply()
	SHOULD_CALL_PARENT(TRUE)
	name = "[my_character]'s [splat_id] splat"
	for(var/trait in splat_traits)
		ADD_TRAIT(my_character, trait, splat_id)
	//Only fuss with applying damage mods to humanoids, who are (in our current code) the only ones with physiology
	if(ishuman(my_character) && !isnull(damage_mods))
		handle_damage_mods(my_character, /*applying =*/TRUE)
		var/mob/living/carbon/human/my_human = my_character
		var/datum/physiology/my_physiology = my_human.physiology
		for(var/mod in damage_mods)
			my_physiology.vars["[mod]_mod"] *= damage_mods[mod]
	SEND_SIGNAL(my_character, COMSIG_SPLAT_SPLAT_APPLIED_TO, src)
	SPLATTED(my_character, src)

/* Signal our removal, null out our character, null out the reference to us in SSsplats, then journey into the void. */
/datum/splat/proc/on_remove()
	SHOULD_CALL_PARENT(TRUE)
	for(var/trait in splat_traits)
		REMOVE_TRAIT(my_character, trait, splat_id)
	if(ishuman(my_character)) && !isnull(damage_mods)
		handle_damage_mods(my_character, /*applying =*/FALSE)
	SEND_SIGNAL(my_character, COMSIG_SPLAT_SPLAT_REMOVED_FROM, src)
	UNSPLATTED(my_character, src)
	my_character = null
	qdel(src)
#undef SPLATTED

#define CRASH_IF_UNHANDLED "CRASH THIS PLANE WITH NO SURVIVORS IF THIS IS NOT HANDLED SPECIFICALLY"
/datum/splat/proc/handle_damage_mods(mob/living/carbon/human/modding_character, applying = CRASH_IF_UNHANDLED)
	if(applying == CRASH_IF_UNHANDLED)
		CRASH("[src]/handle_damage_mods() did not have its applying parameter handled correctly!")
	if(applying)
		for(var/mod in damage_mods)
			modding_character.physiology.vars["[mod]_mod"] *= damage_mods[mod]
		return TRUE
	else
		for(var/mod in damage_mods)
			modding_character.physiology.vars["[mod]_mod"] /= damage_mods[mod]
		return TRUE
	CRASH("[src]/handle_damage_mods() has reached an undefined state!")
#undef CRASH_IF_UNHANDLED

/datum/splat/proc/splat_response(datum/source)
	SIGNAL_HANDLER

	return splat_flag

/datum/splat/human

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

/*
 * Should usually not be called by itself, but is instead meant
 * to be a helper proc for particular acts communicated via signals.
 * value - how much it's being adjusted
 * associated_level - the level of a given act we need to be over or under
 * admin_override - if we're disregarding having an associated_level
 */
/datum/splat/proc/_adjust_integrity(value, associated_level, admin_override = FALSE)
	if(!value)
		return
	if(!isnum(associated_level))
		if(!admin_override)
			CRASH("[src]/adjust_integrity() needs to be called with a level correlated to a given sinful or virtuous act.")
		log_admin("[usr] adjusted [my_character]'s [integrity_name] by [value].")
	if(value > 1 || value < -1)
		log_admin("[my_character]'s [integrity_name] was adjusted by more than one level.")
	log_admin("[my_character]'s [integrity_name] was adjusted by [value].")

/datum/splat/proc/_try_increase_integrity(value, associated_level)
	if(integrity_level < integrity_max)
		if(integrity_level < associated_level)
			integrity_level = min(integrity_level + value, associated_level)
		else
			integrity_level = min(integrity_level + value, integrity_max)
		SEND_SIGNAL(my_character, COMSIG_SPLAT_INTEGRITY_INCREASED, src, value, integrity_level)
		SEND_SIGNAL(src, COMSIG_SPLAT_INTEGRITY_INCREASED, my_character, value, integrity_level)

/datum/splat/proc/_try_decrease_integrity(value, associated_level)
	if(integrity_level > 0)
		if(integrity_level > associated_level)
			integrity_level = max(integrity_level + value, associated_level) //Remember, value is negative here.
		else
			integrity_level = max(integrity_level + value, 0)
		SEND_SIGNAL(my_character, COMSIG_SPLAT_INTEGRITY_DECREASED, src, value, integrity_level)
		SEND_SIGNAL(src, COMSIG_SPLAT_INTEGRITY_DECREASED, my_character, value, integrity_level)


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
	UnregisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED_TO)
	..()


/// We'll use this for signals to fuck with supernaturals and whatever else
/datum/splat/supernatural
