/datum/discipline_power
	/// Name of the Discipline power
	var/name = "Discipline power name"
	/// Description of the Discipline power
	var/desc = "Discipline power description"

	/* BASIC INFORMATION */
	/// What rank of the Discipline this Discipline power belongs to.
	var/level = 1
	/// Bitflags determining the requirements to cast this power
	var/check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	/// How many blood points this power costs to activate
	var/vitae_cost = 1
	/// Bitflags determining what types of entities this power is allowed to target. NONE if self-targeting only.
	var/target_type = NONE
	/// How many tiles away this power can be used from.
	var/range = 0

	/* EXTRA BEHAVIOUR ON ACTIVATION AND DEACTIVATION */
	/// Sound file that plays to the user when this power is activated.
	var/activate_sound
	/// Sound file that plays to the user when this power is deactivated.
	var/deactivate_sound
	/// Sound file that plays to all nearby players when this power is activated.
	var/effect_sound
	/// If this power will upset NPCs when used on them.
	var/aggravating = FALSE
	/// If this power is an aggressive action and logged as such.
	var/hostile = FALSE
	/// If use of this power creates a visible Masquerade breach.
	var/violates_masquerade = FALSE

	/* HOW AND WHEN IT'S ACTIVATED AND DEACTIVATED */
	/// If this Discipline doesn't automatically expire, but rather periodically drains blood.
	var/toggled = FALSE
	/// If this power can be turned on and off.
	var/cancelable = FALSE
	/// If this power can (theoretically, not in reality) have multiple of its effects active at once.
	var/multi_activate = FALSE
	/// Amount of time it takes until this Discipline deactivates itself. 0 if instantaneous.
	var/duration_length = 0
	/// Amount of time it takes until this Discipline can be used again after activation.
	var/cooldown_length = 0
	/// If this power uses its own duration/deactivation handling rather than the default handling
	var/duration_override = FALSE
	/// If this power uses its own cooldown handling rather than the default handling
	var/cooldown_override = FALSE
	/// List of Discipline power types that cannot be activated alongside this power and share a cooldown with it.
	var/list/grouped_powers

	/* NOT MEANT TO BE OVERRIDDEN */
	/// Timer(s) tracking the duration of the power. Can have multiple if multi_activate is true.
	var/list/duration_timers = list()
	/// Timer tracking the cooldown of the power. Starts after deactivation if it has a duration and multi_active isn't true, after activation otherwise.
	var/cooldown_timer
	/// If this Discipline is currently in use.
	var/active = FALSE
	/// The Discipline that this power is part of.
	var/datum/discipline/discipline
	/// The player using this Discipline power.
	var/mob/living/carbon/human/owner

/datum/discipline_power/New(datum/discipline/discipline)
	if(!discipline)
		CRASH("discipline_power [src.name] created without a parent discipline!")

	src.discipline = discipline
	src.owner = discipline.owner

/**
 * Returns the time left the cooldown timer, or
 * 0 if there is none. Returning 0 means not on
 * cooldown.
 */
/datum/discipline_power/proc/get_cooldown()
	var/time_left = timeleft(cooldown_timer)
	if (isnull(time_left))
		time_left = 0

	return time_left

/**
 * Returns the highest time left on any duration
 * timers, or 0 if there are none. Returning 0
 * means not active.
 */
/datum/discipline_power/proc/get_duration()
	var/highest_timeleft = 0
	for (var/timer_id in duration_timers)
		var/time_left = timeleft(timer_id)
		if (isnull(time_left))
			continue
		if (time_left > highest_timeleft)
			highest_timeleft = time_left

	return highest_timeleft

/**
 * Returns a boolean of if the caster can afford
 * this power's vitae cost.
 */
/datum/discipline_power/proc/can_afford()
	return (owner.bloodpool >= vitae_cost)

/**
 * Returns if this power can currently be activated
 * without accounting for target restrictions.
 *
 * This is where all checks according to check_flags for if a
 * power can be activated that don't concern the target are handled.
 * This is almost entirely checking traits on the owner to see if they're
 * incapacitated or whatnot, but some backend like deactivation
 * is also handled here. This is what's checked to see if the
 * power is selectable or unselectable (red).
 *
 * Arguments:
 * * alert - if this is being checked by the user and should give feedback on why it can't activate.
 */
/datum/discipline_power/proc/can_activate_untargeted(alert = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	//can't be casted without an actual caster
	if (!owner)
		return FALSE

	//can always be deactivated if that's an option
	if (active && (toggled || cancelable))
		if (can_deactivate_untargeted())
			return TRUE
		else
			return FALSE

	//the power is currently active
	if (active && !multi_activate)
		if (alert)
			to_chat(owner, span_warning("[src] is already active!"))
		return FALSE

	//a mutually exclusive power is already active or on cooldown
	if (islist(grouped_powers))
		for (var/exclude_power in grouped_powers)
			var/datum/discipline_power/found_power = discipline.get_power(exclude_power)
			if (!found_power || (found_power == src))
				continue

			if (found_power.active)
				if (found_power.cancelable || found_power.toggled)
					if (alert)
						found_power.try_deactivate(direct = TRUE, alert = TRUE)
					return TRUE
				else
					if (alert)
						to_chat(owner, span_warning("You cannot have [src] and [found_power] active at the same time!"))
					return FALSE
			if (found_power.get_cooldown())
				if (alert)
					to_chat(owner, span_warning("You cannot activate [src] before [found_power]'s cooldown expires in [DisplayTimeText(found_power.get_cooldown())]."))
				return FALSE

	//the user cannot afford the power's vitae expenditure
	if (!can_afford())
		if (alert)
			to_chat(owner, span_warning("You do not have enough blood to cast [src]!"))
		return FALSE

	//the power's cooldown has not elapsed
	if (get_cooldown())
		if (alert)
			to_chat(owner, span_warning("[src] is still on cooldown for [DisplayTimeText(get_cooldown())]!"))
		return FALSE

	//status checks
	if ((check_flags & DISC_CHECK_TORPORED) && HAS_TRAIT(owner, TRAIT_TORPOR))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] while in Torpor!"))
		return FALSE

	if ((check_flags & DISC_CHECK_CONSCIOUS) && HAS_TRAIT(owner, TRAIT_KNOCKEDOUT))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] while unconscious!"))
		return FALSE

	if ((check_flags & DISC_CHECK_CAPABLE) && HAS_TRAIT(owner, TRAIT_INCAPACITATED))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] while incapacitated!"))
		return FALSE

	if ((check_flags & DISC_CHECK_IMMOBILE) && HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] while immobilised!"))
		return FALSE

	if ((check_flags & DISC_CHECK_LYING) && HAS_TRAIT(owner, TRAIT_FLOORED))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] while lying on the floor!"))
		return FALSE

	if ((check_flags & DISC_CHECK_SEE) && HAS_TRAIT(owner, TRAIT_BLIND))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] without your sight!"))
		return FALSE

	if ((check_flags & DISC_CHECK_SPEAK) && HAS_TRAIT(owner, TRAIT_MUTE))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] without speaking!"))
		return FALSE

	if ((check_flags & DISC_CHECK_FREE_HAND) && HAS_TRAIT(owner, TRAIT_HANDS_BLOCKED))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] without free hands!"))
		return FALSE

	//respect pacifism, prevent hostile Discipline usage from pacifists
	if (hostile && HAS_TRAIT(owner, TRAIT_PACIFISM))
		if (alert)
			to_chat(owner, span_warning("You cannot cast [src] as a pacifist!"))
		return FALSE

	//nothing found, it can be casted
	return TRUE

/**
 * Activation requirement checking proc that determines
 * if a given target is valid while also checking
 * can_activate_untargeted().
 *
 * When activating a power, this is called to get the final
 * result on if it can be activated or not. It first checks
 * can_activate_untargeted(), then if the power is targeted,
 * it handles logic for determining if a given target is valid
 * according to the given target_type.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 * * alert - if this is being checked by the user and should give feedback on why it can't activate.
 */
/datum/discipline_power/proc/can_activate(atom/target, alert = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	var/signal_return = SEND_SIGNAL(src, COMSIG_POWER_TRY_ACTIVATE, src, target) | SEND_SIGNAL(owner, COMSIG_POWER_TRY_ACTIVATE, src, target)
	if (target)
		signal_return |= SEND_SIGNAL(target, COMSIG_POWER_TRY_ACTIVATE_ON, src)
	if (signal_return & POWER_PREVENT_ACTIVATE)
		//feedback is sent by the proc preventing activation
		return FALSE

	//can't activate if the owner isn't capable of it
	if (!can_activate_untargeted(alert))
		return FALSE

	//self activated so target doesn't matter
	if (target_type == NONE)
		return TRUE

	//check if distance is in range
	if (get_dist(owner, target) > range)
		if (alert)
			to_chat(owner, span_warning("[target] is out of range!"))
		return FALSE

	//handling for if a ranged Discipline is being used on its caster
	if (target == owner)
		if (target_type & TARGET_SELF)
			return TRUE
		else
			if (alert)
				to_chat(owner, span_warning("You can't use this power on yourself!"))
			return FALSE

	//account for complete supernatural resistance
	if (HAS_TRAIT(target, TRAIT_ANTIMAGIC))
		if (alert)
			to_chat(owner, span_warning("[target] resists your Disciplines!"))
		return FALSE

	//check target type
	// mob/living with a bunch of extra conditions
	if ((target_type & MOB_LIVING_TARGETING) && isliving(target))
		//make sure our LIVING target isn't DEAD
		var/mob/living/living_target = target
		if ((target_type & TARGET_LIVING) && (living_target.stat == DEAD))
			if (alert)
				to_chat(owner, span_warning("You cannot cast [src] on dead things!"))
			return FALSE

		if ((target_type & TARGET_PLAYER) && !living_target.client)
			if (alert)
				to_chat(owner, span_warning("You can only cast [src] on other players!"))
			return FALSE

		if ((target_type & TARGET_VAMPIRE) && !iskindred(target))
			if (alert)
				to_chat(owner, span_warning("You can only cast [src] on Kindred!"))
			return FALSE

		if (ishuman(target))
			var/mob/living/carbon/human/human_target = living_target
			//todo: remove this variable and refactor it into TRAIT_ANTIMAGIC
			if (human_target.resistant_to_disciplines)
				if (alert)
					to_chat(owner, span_warning("[target] resists your Disciplines!"))
				return FALSE

			if (target_type & TARGET_HUMAN)
				return TRUE

		if (target_type & TARGET_HUMAN)
			if (alert)
				to_chat(owner, span_warning("You can only cast [src] on humans!"))
			return FALSE

		return TRUE

	if ((target_type & TARGET_OBJ) && istype(target, /obj))
		return TRUE

	if ((target_type & TARGET_GHOST) && istype(target, /mob/dead))
		return TRUE

	if ((target_type & TARGET_TURF) && istype(target, /turf))
		return TRUE

	//target doesn't match any targeted types, so can't activate on them
	if (alert)
		to_chat(owner, span_warning("You cannot cast [src] on [target]!"))
	return FALSE

/**
 * Spends necessary resources (vitae) and makes sure activation is valid
 * before fully activating the power.
 *
 * The intermediary between can_activate() and activate(), this proc spends
 * resources, sends signals, checks an overridable proc to see if it should
 * continue or not, then fully activates the power. This can only fail
 * if an override of pre_activation_checks() or a signal handler forces it to.
 * This is useful for code that should trigger after activation is initiated, but
 * before the effects (probably) start.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/discipline_power/proc/pre_activation(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	//resources are still spent if activation is theoretically possible, but it gets prevented
	spend_resources()

	var/signal_return = SEND_SIGNAL(src, COMSIG_POWER_PRE_ACTIVATION, src, target) | SEND_SIGNAL(owner, COMSIG_POWER_PRE_ACTIVATION, src, target)
	if (target)
		signal_return |= SEND_SIGNAL(target, COMSIG_POWER_PRE_ACTIVATION_ON, src)
	if (signal_return & POWER_CANCEL_ACTIVATION)
		//feedback is sent by the proc cancelling activation
		return

	if (!pre_activation_checks(target))
		return

	activate(target)

/**
 * An overridable proc that allows for custom pre_activation() behaviour.
 *
 * This is meant to be overridden by powers to allow for extra checks
 * on activation (eg. Social vs. Mentality for mental disciplines), to
 * delay activation with a do_after() (eg. Valeren 5 taking 10 seconds),
 * or possibly to hijack the pre_activation() proc by returning FALSE and
 * using its own logic instead (like activating on several targets in an
 * AoE rather than on one). Don't be fooled by the name, this is not just
 * for checks.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/discipline_power/proc/pre_activation_checks(atom/target)
	return TRUE

/**
 * Triggers all the effects of the power being fully activated.
 *
 * An overridable proc where the effects of the power are stored.
 * This being called means that activation has fully succeeded, so
 * duration and cooldown (when multi_activate is true) also begin
 * here. Specific basic activation behaviour (like the sound it makes
 * or the message it logs) can be modified by overriding the relevant
 * proc.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/discipline_power/proc/activate(atom/target)
	SHOULD_CALL_PARENT(TRUE)

	//ensure everything is in place for activation to be possible
	if(!target && (target_type != NONE))
		return FALSE
	if(!discipline?.owner)
		return FALSE

	SEND_SIGNAL(src, COMSIG_POWER_ACTIVATE, src, target)
	SEND_SIGNAL(owner, COMSIG_POWER_ACTIVATE, src, target)
	if (target)
		SEND_SIGNAL(target, COMSIG_POWER_ACTIVATE_ON, src)

	//make it active if it can only have one active instance at a time
	if (!multi_activate)
		active = TRUE

	if (!cooldown_override)
		do_cooldown(TRUE)

	if (!duration_override)
		do_duration(target)

	do_activate_sound()

	do_effect_sound(target)

	INVOKE_ASYNC(src, PROC_REF(do_npc_aggro), target)

	INVOKE_ASYNC(src, PROC_REF(do_masquerade_violation), target)

	do_caster_notification(target)
	do_logging(target)

	owner.update_action_buttons()

	return TRUE

/**
 * Overridable proc handling the sound played to the owner
 * only when using powers.
 */
/datum/discipline_power/proc/do_activate_sound()
	if (activate_sound)
		owner.playsound_local(owner, activate_sound, 50, FALSE)

/**
 * Overridable proc handling the sound caused by the power's
 * effects, audible to everyone around it.
 */
/datum/discipline_power/proc/do_effect_sound(atom/target)
	if (effect_sound)
		playsound(target ? target : owner, effect_sound, 50, FALSE)

/**
 * Overridable proc handling how the power aggravates NPCs
 * it's used on.
 */
/datum/discipline_power/proc/do_npc_aggro(atom/target)
	if (aggravating && isnpc(target))
		var/mob/living/carbon/human/npc/npc = target
		npc.Aggro(owner, hostile)

/**
 * Overridable proc handling Masquerade violations as a result
 * of using this power amongst NPCs.
 */
/datum/discipline_power/proc/do_masquerade_violation(atom/target)
	if (violates_masquerade)
		if (owner.CheckEyewitness(target ? target : owner, owner, 7, TRUE))
			//TODO: detach this from being a human
			if (ishuman(owner))
				var/mob/living/carbon/human/human = owner
				human.AdjustMasquerade(-1)

/**
 * Overridable proc handling the spending of resources (vitae/blood)
 * when casting the power. Returns TRUE if successfully spent,
 * returns FALSE otherwise.
 */
/datum/discipline_power/proc/spend_resources()
	if (can_afford())
		owner.bloodpool = owner.bloodpool - vitae_cost
		owner.update_action_buttons()
		return TRUE
	else
		return FALSE

/**
 * Overridable proc handling the message sent to the user when activating
 * the power.
 */
/datum/discipline_power/proc/do_caster_notification(target)
	to_chat(owner, span_warning("You cast [name][target ? " on [target]!" : "."]"))

/**
 * Overridable proc handling the combat log created by using this power.
 */
/datum/discipline_power/proc/do_logging(target)
	log_combat(owner, target ? target : owner, "casted the power [src.name] of the Discipline [discipline.name] on")

/**
 * Overridable proc handling the power's duration, which is a timer that triggers the
 * duration_expire proc when it ends, and is saved in duration_timers then deleted and cut
 * when it ends. The duration_override variable stops this from being triggered by activate()
 * and allows for extra modular behaviour. Duration expiring can be done manually by calling
 * try_deactivate(direct = TRUE).
 */
/datum/discipline_power/proc/do_duration(atom/target)
	if (toggled && (duration_length == 0))
		return

	duration_timers.Add(addtimer(CALLBACK(src, PROC_REF(duration_expire), target), duration_length, TIMER_STOPPABLE | TIMER_DELETE_ME))

/**
 * Overridable proc handling the power's cooldown, which is a timer that triggers the cooldown_expire
 * proc when it ends, and is saved in cooldown_timer. This is called by both activate() and deactivate(),
 * but it only actually starts the cooldown in deactivate() unless multi_activate is TRUE. The
 * cooldown_override variable stops this from being triggered by activate() and deactivate() and allows
 * for extra modular behaviour. Cooldowns can manually be started by calling try_deactivate(), then deltimer()
 * and starting a new cooldown timer with your own length.
 *
 * Arguments:
 * * on_activation - if this proc is being called by activate(), which will stop it from triggering unless multi_activate is true.
 */
/datum/discipline_power/proc/do_cooldown(on_activation = FALSE)
	if (multi_activate && !on_activation)
		return

	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), cooldown_length, TIMER_STOPPABLE | TIMER_DELETE_ME)

/**
 * Checks if activation is possible through can_activate(), then calls pre_activation() if it is.
 * Returns if activation successfully begun or not.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/discipline_power/proc/try_activate(atom/target)
	if (can_activate(target, TRUE))
		pre_activation(target)
		return TRUE

	return FALSE

/**
 * Overridable proc called by the duration timer to handle
 * duration expiring. Will refresh if toggled, or deactivate
 * otherwise after deleting the timer calling it.
 */
/datum/discipline_power/proc/duration_expire(atom/target)
	//clean up the expired timer, which SHOULD be the first in the list
	clear_duration_timer()

	//proceed to deactivation or refreshing
	if (toggled)
		refresh(target)
	else
		try_deactivate(target)

	owner.update_action_buttons()

/**
 * Overridable proc called by the cooldown timer to handle
 * cooldown expiring. Has no behaviour besides making the action
 * visibly available again.
 */
/datum/discipline_power/proc/cooldown_expire()
	owner.update_action_buttons()

/**
 * Overridable proc called by try_deactivate() to make sure that
 * deactivating won't result in a runtime in case of the power
 * targeting the owner with them not existing. The equivalent
 * of can_activate_untargeted().
 */
/datum/discipline_power/proc/can_deactivate_untargeted()
	SHOULD_CALL_PARENT(TRUE)

	if (target_type == NONE)
		if (isnull(owner))
			return FALSE

	return TRUE

/**
 * Overridable proc mirroring can_activate(), making sure
 * that deactivation won't result in a runtime in case of
 * the target not existing anymore while also checking
 * can_deactivate_untargeted(). Also sends signals that
 * allow for manual prevention of deactivation.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/discipline_power/proc/can_deactivate(atom/target)
	SHOULD_CALL_PARENT(TRUE)

	var/signal_return = SEND_SIGNAL(src, COMSIG_POWER_TRY_DEACTIVATE, src, target) | SEND_SIGNAL(owner, COMSIG_POWER_TRY_DEACTIVATE, src, target)
	if (target)
		signal_return |= SEND_SIGNAL(target, COMSIG_POWER_TRY_DEACTIVATE_ON, src)
	if (signal_return & POWER_PREVENT_DEACTIVATE)
		//feedback is sent by the proc cancelling activation
		return FALSE

	if (!can_deactivate_untargeted())
		return FALSE

	if (target_type != NONE)
		if (!target)
			return FALSE

	return TRUE

/**
 * Cancels the effects of the previously activated power.
 *
 * Handles all logic for deactivating the power, including
 * playing the deactivation sound, sending relevant signals,
 * and starting the cooldown. If directly called rather
 * than as a result of duration_expire, this also deletes
 * the relevant duration timer. Still called if duration_length
 * is 0.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 * * direct - if this is being directly called instead of by duration_expire, and should delete the timer.
 */
/datum/discipline_power/proc/deactivate(atom/target, direct = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	if (direct)
		clear_duration_timer()

	SEND_SIGNAL(src, COMSIG_POWER_DEACTIVATE, src, target)
	SEND_SIGNAL(owner, COMSIG_POWER_DEACTIVATE, src, target)
	if (target)
		SEND_SIGNAL(target, COMSIG_POWER_DEACTIVATE_ON, src)

	if (!multi_activate)
		active = FALSE

	if (!cooldown_override)
		do_cooldown()

	if (deactivate_sound)
		owner.playsound_local(owner, deactivate_sound, 50, FALSE)

	owner.update_action_buttons()

/**
 * Checks if the power can_deactivate() and deactivate()s if it can.
 * Also sends feedback the user if they successfully manually cancel it.
 * The deactivation equivalent of try_activate().
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 * * direct - if the power is being directly deactivated or as a result of duration_expire.
 * * alert - if the caster is manually deactivating and feedback should be sent on success.
 */
/datum/discipline_power/proc/try_deactivate(atom/target, direct = FALSE, alert = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if (can_deactivate(target))
		deactivate(target, direct)

		if (alert)
			to_chat(owner, span_warning("You deactivate [src]."))

/**
 * Overridable proc that allows for code to affect the power's owner
 * when it is gained. Triggered by parent /datum/discipline/post_gain().
 */
/datum/discipline_power/proc/post_gain()
	return

/**
 * Handles refreshing toggled powers on a loop, spending necessary
 * resources and restarting the duration timer if it can proceed. If
 * it can't proceed, it directly deactivates the power.
 *
 * Arguments:
 * * target - what the targeted Discipline (null otherwise) is being used on.
 */
/datum/discipline_power/proc/refresh(atom/target)
	if (!active)
		return
	if (!owner)
		return

	//cancels if overridable proc returns FALSE
	if (!do_refresh_checks(target))
		return

	if (spend_resources())
		to_chat(owner, span_warning("[src] consumes your blood to stay active."))
		if (!duration_override)
			do_duration(target)
	else
		to_chat(owner, span_warning("You don't have enough blood to keep [src] active!"))
		try_deactivate(target)

/**
 * Overridable proc that allows for extra modular code
 * in refreshing behaviour. Can do custom checks to see if activation
 * proceeds or not (must give its own feedback!) or can hijack
 * the refresh proc for its own behaviour.
 */
/datum/discipline_power/proc/do_refresh_checks(atom/target)
	return TRUE

/**
 * Clears the last active timer (usually the first in the list).
 * If called before it expires, this immediately makes the
 * duration_timer expire without calling the relevant proc.
 */
/datum/discipline_power/proc/clear_duration_timer(to_clear = 1)
	if (toggled && (duration_length == 0))
		return

	deltimer(duration_timers[to_clear])
	duration_timers.Cut(to_clear, to_clear + 1)
