/*
 *										INTEGRITY
 *
 *		Using the term from Chronicles of Darkness; Integrity is the "default" morality for human characters.
 * For our splats, integrity is:
 * 1) the default name for "morality" for humans
 * 2) the code variable name for "morality" for all splats
 * 		For this explanation, "integrity" will refer to the system and variables hereon.
 * 		Integrity is tracked and catalogued through the following methods:
 * 		/datum/integrity_tracker: The datum that actually does the integrity tracking, subtyped for a given splat. Made its own type to avoid cluttering splat
 * logic with integrity tracking logic.
 * 			Example subtyping:
 * 			/datum/integrity_tracker/humanity	(Kindred),		/datum/integrity_tracker/integrity	(Humans/Ghouls)
 * 			/datum/integrity_tracker/torment 	(Demons),		/datum/integrity_tracker/harmony	(Garou)
 * 		.integrity_name: The name of integrity for that splat. So, Humanity for Kindred, Integrity for Humans (and Ghouls),
 * Torment for Demons, Harmony for Garou, etc
 * 		.integrity_level: Their current integrity for that splat. If, down the line, we allow people to be multi-splatted
 * (god please no), their different splat integrities will not always (and usually won't) be same.
 * 		.integrity_max: Their max possible integrity for a splat. In most cases 10, but some splats (Geist, as a CofD example)
 * loses integrity max when they die and are revived.
 * 		INTEGRITY SIGNALS
 *
 * 		Integrity can be modified by admins at their leisure for a given splat, but will otherwise typically be modified
 * as a response to a signal from a given act. This should usually be kept clear from signals that cause actual effects from their
 * splat. If their splat causes a particular effect at a particular integrity level (Kindred social penalties at low humanity), that
 * should be registered on their splat signals instead.
 * 		.sin_hierarchy: An associated list of signals to the integrity_level they will degenerate to.
 * 			Example:
 * 			/datum/integrity_tracker/integrity	(Human)
 * 			sin_hierarchy = list(
 * 				list(COMSIG_ACT_MURDER, COMSIG_ACT_TORTURE) = 3,
 * 				list(COMSIG_ACT_ASSAULT) = 6,
 *				)
 *		Does not need to be ordered in any particular way but we'll probably want to order it numerically for readability on our end.
 *		There is no equivalent signal system for raising integrity, as per the spirit of the TT: raising integrity should require XP
 *	and, down the line, will likely require having a record of signalled acts pursuant to their given tracker (Enlightenment requiring whatever debauchery and XP investment)
 *
 */

/datum/integrity_tracker
	///The name of integrity for that splat. So, Humanity for Kindred, Integrity for Humans (and Ghouls), Torment for Demons, Harmony for Garou, etc
	var/integrity_name = "Integrity"
	///Their current integrity for that splat. If, down the line, we allow people to be multi-splatted
	///(god please no), their different splat integrities will not always (and usually won't) be same.
	var/integrity_level = 7
	///Usually 10, but some circumstances (Geist from CofD revival) lower your possible max integrity
	var/integrity_max = 10
	///At Initialization, a typepath, and after Initialization, should be a splat
	var/datum/splat/my_splat = null
	///An associated list, of lists of signals denoting various actions (performed or witnessed), and the integrity level that they will degenerate you to
	var/list/sin_hierarchy = null
	///The heavy lifter for the sin hierarchy, where we keep track of the callback datums that should be the handlers for sin adjustment
	///to keep the codespace uncluttered
	var/list/callback/guilt_callbacks = null
	///Unimplemented at this time; future implementation is to unlock buying integrity to given levels with XP, but only after performing given acts in-game
	var/list/virtuous_acts = null

/datum/integrity_tracker/proc/Initialize(datum/splat/my_new_splat = null)
	if(!my_new_splat || !istype(my_new_splat) || !istype(my_new_splat, my_splat))
		CRASH("[src] improperly Initialized!")
	my_splat = my_new_splat
	if(!length(sin_hierarchy))
		log_admin("[src] initialized for [my_new_splat] without a hierarchy of sins.")
		log_runtime("[src] initialized with no hierarchy of sins.")
		my_splat = null
		qdel(src)
		return FALSE
	guilt_callbacks = list()
	commence_guilt_registration()

/*
 * Create callbacks for adjusting our integrity down to a given level; the reason we do so in this fashion
 * is to eliminate the need to iterate through our sin_hierarchy if we perform/witness integrity generating acts;
 * instead, created callbacks register to us, and we register to our splat. One signal is shuttled twice and the
 * callback is performed to adjust, if necessary, instead of the signal being shuttled twice, then iterating over
 * the list until we find that sin's place in our hierarchy.
 * The list of callbacks is just for book-keeping.
 *
 * Plain language explanation:
 * Iterate through our sin_signals associated list (each key is also a list)
 * For each key, create a callback to adjust our integrity down to a given level
 * 		NOTE: During callback creation, define the requisite three args
 * Register our callback to listen to us for the sin in question.
 * 		NOTE: Receiving a signal also receives any args that a call to SendSignal provides; we avoid this mucking up
 * 		our callback behavior by defining the args ahead of time.
 */
/datum/integrity_tracker/proc/commence_guilt_registration()
	for(var/list/sin_signals as anything in sin_hierarchy)
		if(!length(sin_signals))
			continue
		var/datum/callback/adjustment_callback = CALLBACK(//<-callback creation!
			src,
			PROC_REF(_adjust_integrity),
			list(//args for the callback!
			/*value =*/-1,
			/*associated_level =*/sin_hierarchy[sin_signals],
			/*admin_override =*/FALSE
			)
		)//<-callback creation close!
		adjustment_callback.RegisterSignal(src, sin_signals, PROC_REF(Invoke))
		guilt_callbacks[adjustment_callback] = sin_signals

/*
 * Should usually not be called by itself, but is instead meant
 * to be a helper proc for particular acts communicated via signals.
 * value - how much it's being adjusted
 * associated_level - the level of a given act we need to be over or under
 * admin_override - if we're disregarding having an associated_level
 */
/datum/integrity_tracker/proc/_adjust_integrity(value, associated_level, admin_override = FALSE)
	if(!value)
		return
	if(!isnum(associated_level))
		if(!admin_override)
			CRASH("[src]/adjust_integrity() needs to be called with a level correlated to a given sinful or virtuous act.")
		log_admin("[usr] adjusted [my_character]'s [integrity_name] by [value].")
	if(value > 1 || value < -1)
		log_admin("[my_character]'s [integrity_name] was adjusted by more than one level.")

/datum/integrity_tracker/proc/_try_increase_integrity(value, associated_level)
	if(integrity_level == integrity_max)
		return FALSE
	if(integrity_level >= associated_level)
		return FALSE
	integrity_level = min(integrity_level + value, associated_level)
	SEND_SIGNAL(my_splat, COMSIG_SPLAT_INTEGRITY_INCREASED, src, value, integrity_level)
	SEND_SIGNAL(src, COMSIG_SPLAT_INTEGRITY_INCREASED, value, integrity_level)
	log_admin("[my_splat.my_character]'s [integrity_name] was increased by [value].")
	return TRUE

/datum/integrity_tracker/proc/_try_decrease_integrity(value, associated_level)
	if(integrity_level < associated_level)
		return FALSE
	integrity_level = max(integrity_level + value, associated_level) //Remember, value is negative here.
	SEND_SIGNAL(my_splat, COMSIG_SPLAT_INTEGRITY_DECREASED, src, value, integrity_level)
	SEND_SIGNAL(src, COMSIG_SPLAT_INTEGRITY_DECREASED, my_character, value, integrity_level)
	log_admin("[my_splat.my_character]'s [integrity_name] was decreased by [value][associated_level ? " after a level [associated_level] sin." : "."]")


/datum/integrity_tracker/proc/_record_virtuous_act(associated_level)
	if(!associated_level)
		CRASH("[src]/_record_virtuous_act() called without specifying the requisite level!")
