
/datum/splat
	///We change this when applied to track people's splat assignments
	var/name = null
	///For record keeping and sanity
	var/splat_id = null
	/// Pretty much every splat has a power stat; vitae, gnosis, etc
	var/power_stat_name = null
	var/power_stat_max = null
	var/power_stat_current = null
	///Traits to apply/remove in their respective instances
	var/list/splat_traits = null
	/*
	 * PROC_REFs and signal(s) to listen for, respectively. Defined here for organization
	 * Will always register to listen to our character for the signal; this is NOT for boilerplate signals like splat_applied_to
	 * 		Example definition:
	 *	 list(
	 *			proc_ref1 = signal_name1,
	 *			proc_ref2 = list(signal_name2,signal_name3),
	 *		...)
	 *
	 * 		Implementation logic:
	 * 		RegisterSignal(my_character, signal_name(s), PROC_REF(proc_ref))
	 *
	 * Supports TYPE_PROC and GLOBAL_PROC refs.
	 * Should be implemented in a given splat's on_apply() before ..() is called
	 */
	var/list/splat_signals = null
	///A list of actions that holders of this splat receive
	var/list/splat_actions = null
	///A type-path before Initialization, before becoming a datum after. Tracks the given splat's "morality". See integrity/_integrity.dm
	var/datum/integrity = null
	///A bitflag that this splat will return in response to anything that splat checks us, which will usually be the helpers.
	var/splat_flag = null
	///Our very special lady, gentleman, theydie, gentlethem, or horrifying monstrosity that should not be
	var/mob/living/my_character = null
	///Whether this splat can be selected when creating a character
	var/selectable = FALSE
	///Damage mods that this splat gives the user (vamps take more burn, less brute, no cold, etc)
	///refer to code\modules\mob\living\carbon\human\physiology.dm
	var/list/damage_mods = null

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
	on_apply()

/* In a perfect world this would have no args and function off of my_character but we want to future proof for whatever circumstance
 * may call for mass splat removal or something.
 * Unregisters the signals then does any heavy_lifting in on_remove
*/
/datum/splat/proc/Remove(mob/living/character)
	SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(my_character, COMSIG_SPLAT_SPLAT_CHECKED)
	on_remove()

#define SPLATTED(M, S) SEND_SIGNAL(SSsplats, COMSIG_SPLAT_SPLAT_APPLIED_TO, M, S)
#define UNSPLATTED(M, S) SEND_SIGNAL(SSsplats, COMSIG_SPLAT_SPLAT_REMOVED_FROM, M, S)
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
	if(length(splat_actions))
		var/list/created_actions = list()
		for(var/datum/action/action_path as anything in splat_actions)
			var/datum/action/new_action = new action_path
			created_actions += new_action
			new_action.Give(my_character)
		splat_actions = created_actions
	if(length(splat_signals))
		for(var/splat_proc_ref in splat_signals)
			RegisterSignal(my_character, splat_signals[splat_proc_ref], splat_proc_ref)
	if(integrity)
		integrity = new integrity
		if(!integrity.Initialize(my_new_splat = src))
			integrity = null
	SEND_SIGNAL(my_character, COMSIG_SPLAT_SPLAT_APPLIED_TO, src)
	SPLATTED(my_character, src)

/* Signal our removal, null out our character, null out the reference to us in SSsplats, then journey into the void. */
/datum/splat/proc/on_remove()
	SHOULD_CALL_PARENT(TRUE)
	for(var/trait in splat_traits)
		REMOVE_TRAIT(my_character, trait, splat_id)
	if(ishuman(my_character) && !isnull(damage_mods))
		handle_damage_mods(my_character, /*applying =*/FALSE)
		damage_mods = null
	if(length(splat_actions))
		for(var/datum/action/splat_action as anything in splat_actions)
			splat_action.Remove(my_character)
			splat_actions -= splat_action
		splat_actions = null
	if(length(splat_signals))
		for(var/splat_proc_ref in splat_signals)
			UnregisterSignal(my_character, splat_signals[splat_proc_ref])
	if(integrity)
		qdel(integrity)
		integrity = null
	SEND_SIGNAL(my_character, COMSIG_SPLAT_SPLAT_REMOVED_FROM, src)
	UNSPLATTED(my_character, src)
	my_character = null
	qdel(src)
#undef UNSPLATTED
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
#undef CRASH_IF_UNHANDLED

/datum/splat/proc/splat_response(datum/source)
	SIGNAL_HANDLER

	return splat_flag

/datum/splat/supernatural
