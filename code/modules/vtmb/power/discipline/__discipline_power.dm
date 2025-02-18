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
	/// If this power can spend more blood per turn than is normally allowed
	var/bypass_spending_limits = FALSE
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
	/// If this power's duration is maintained by the caster, or simply casted on something else and then not used by the caster again.
	var/fire_and_forget = FALSE
	/// Amount of time it takes until this Discipline deactivates itself. 0 if instantaneous.
	var/duration_length = 0
	/// Amount of time it takes until this Discipline can be used again after activation.
	var/cooldown_length = 0
	/// If this power uses its own duration/deactivation handling rather than the default handling
	var/duration_override = FALSE
	/// If this power uses its own cooldown handling rather than the default handling
	var/cooldown_override = FALSE
	/// List of Discipline power types that cannot be activated alongside this power and share a cooldown with it.
	var/list/grouped_powers = list()

	/* NOT MEANT TO BE OVERRIDDEN */
	/// Timer tracking the duration of the power. Not used if fire_and_forget is TRUE.
	COOLDOWN_DECLARE(duration)
	/// Timer tracking the cooldown of the power. Starts after deactivation if cancellable or toggled, after activation otherwise.
	COOLDOWN_DECLARE(cooldown)
	/// If this Discipline is currently in use.
	var/active = FALSE
	/// The Discipline that this power is part of.
	var/datum/discipline/discipline
	/// The player using this Discipline power.
	var/mob/living/carbon/human/owner

/datum/discipline_power/New(datum/discipline/discipline)
	if (discipline)
		src.discipline = discipline
		src.owner = discipline.owner

/datum/discipline_power/proc/get_cooldown()
	return COOLDOWN_TIMELEFT(src, cooldown)

/datum/discipline_power/proc/get_duration()
	return COOLDOWN_TIMELEFT(src, duration)

/datum/discipline_power/proc/can_afford()
	return owner.can_adjust_blood_points(-vitae_cost)

/datum/discipline_power/proc/can_activate_untargeted(alert = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	//can't be casted without an actual caster
	if (!owner)
		return FALSE

	//can always be deactivated if that's an option
	if (active && (toggled || cancelable))
		return TRUE

	//the power is currently active
	if (active)
		if (alert)
			to_chat(owner, "<span class='warning'>[src] is already active!</span>")
		return FALSE

	//a mutually exclusive power is already active or on cooldown
	for (var/exclude_power in grouped_powers)
		var/datum/discipline_power/found_power = discipline.get_power(exclude_power)
		if (!found_power)
			continue

		if (found_power.active)
			if (alert)
				to_chat(owner, "<span class='warning'>You cannot have [src] and [found_power] active at the same time!")
			return FALSE
		if (!COOLDOWN_FINISHED(found_power, cooldown))
			if (alert)
				to_chat(owner, "<span class='warning'>You cannot activate [src] before [found_power]'s cooldown expires in [DisplayTimeText(COOLDOWN_TIMELEFT(found_power, cooldown))].")
			return FALSE

	//the user cannot afford the power's vitae expenditure
	if (!can_afford())
		if (alert)
			to_chat(owner, "<span class='warning'>You do not have enough blood to cast [src]!</span>")
		return FALSE

	//the power's cooldown has not elapsed
	if (!COOLDOWN_FINISHED(src, cooldown))
		if (alert)
			to_chat(owner, "<span class='warning'>[src] is still on cooldown for [DisplayTimeText(COOLDOWN_TIMELEFT(src, cooldown))]!</span>")
		return FALSE

	//status checks
	if ((check_flags & DISC_CHECK_TORPORED) && HAS_TRAIT(owner, TRAIT_TORPOR))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] while in Torpor!</span>")
		return FALSE

	if ((check_flags & DISC_CHECK_CONSCIOUS) && HAS_TRAIT(owner, TRAIT_KNOCKEDOUT))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] while unconscious!</span>")
		return FALSE

	if ((check_flags & DISC_CHECK_CAPABLE) && HAS_TRAIT(owner, TRAIT_INCAPACITATED))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] while incapacitated!</span>")
		return FALSE

	if ((check_flags & DISC_CHECK_IMMOBILE) && HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] while immobilised!</span>")
		return FALSE

	if ((check_flags & DISC_CHECK_LYING) && HAS_TRAIT(owner, TRAIT_FLOORED))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] while lying on the floor!</span>")
		return FALSE

	if ((check_flags & DISC_CHECK_SEE) && HAS_TRAIT(owner, TRAIT_BLIND))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] without your sight!</span>")
		return FALSE

	if ((check_flags & DISC_CHECK_SPEAK) && HAS_TRAIT(owner, TRAIT_MUTE))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] without speaking!</span>")
		return FALSE

	if ((check_flags & DISC_CHECK_FREE_HAND) && HAS_TRAIT(owner, TRAIT_HANDS_BLOCKED))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] without free hands!</span>")
		return FALSE

	//respect pacifism, prevent hostile Discipline usage from pacifists
	if (hostile && HAS_TRAIT(owner, TRAIT_PACIFISM))
		if (alert)
			to_chat(owner, "<span class='warning'>You cannot cast [src] as a pacifist!</span>")
		return FALSE

	//TODO: separate this from being a human????
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		var/datum/species/kindred/species = human.dna.species
		if (!species.can_spend_blood(owner, bypass_spending_limits ? 1 : vitae_cost))
			if (alert)
				to_chat(owner, "<span class='warning'>You cannot spend blood fast enough to cast [name] now!</span>")
			return FALSE

	//nothing found, it can be casted
	return TRUE

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
			to_chat(owner, "<span class='warning'>[target] is out of range!</span>")
		return FALSE

	//handling for if a ranged Discipline is being used on its caster
	if (target == owner)
		if (target_type & TARGET_SELF)
			return TRUE
		else
			if (alert)
				to_chat(owner, "<span class='warning'>You can't use this power on yourself!</span>")
			return FALSE

	//check target type
	if (((target_type & TARGET_MOB) || (target_type & TARGET_LIVING)) && istype(target, /mob/living))
		//make sure our LIVING target isn't DEAD
		var/mob/living/living = target
		if ((target_type & TARGET_LIVING) && (living.stat == DEAD))
			if (alert)
				to_chat(owner, "<span class='warning'>You cannot cast [name] on dead things!</span>")
			return FALSE

		//make sure they can be targeted by Disciplines
		if (ishuman(target))
			var/mob/living/carbon/human/human = living
			if (human.resistant_to_disciplines || HAS_TRAIT(human, TRAIT_ANTIMAGIC))
				if (alert)
					to_chat(owner, "<span class='warning'>[target] resists your Disciplines!</span>")
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
		to_chat(owner, "<span class='warning'>You cannot cast [src] on [target]!</span>")
	return FALSE

/datum/discipline_power/proc/pre_activation(atom/target)
	SHOULD_CALL_PARENT(FALSE)

	//overrides should take care to still send and receive these signals! copy and paste this!
	var/signal_return = SEND_SIGNAL(src, COMSIG_POWER_PRE_ACTIVATION, src, target) | SEND_SIGNAL(owner, COMSIG_POWER_PRE_ACTIVATION, src, target)
	if (target)
		signal_return |= SEND_SIGNAL(target, COMSIG_POWER_PRE_ACTIVATION_ON, src)
	if (signal_return & POWER_CANCEL_ACTIVATION)
		//feedback is sent by the proc cancelling activation
		return

	activate(target)

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
	if (!fire_and_forget && (duration_length != 0))
		active = TRUE

	//start the cooldown if there is one, instead triggers on deactivate() if it has a duration and isn't fire and forget
	if (cooldown_length && !cancelable && !cooldown_override && (!duration_length || fire_and_forget))
		COOLDOWN_START(src, cooldown, cooldown_length)

	//handle Discipline power duration, start duration timer if it can't have multiple effects running at once
	if (duration_length && !duration_override)
		if (!fire_and_forget)
			COOLDOWN_START(src, duration, duration_length)
		if (toggled)
			addtimer(CALLBACK(src, PROC_REF(refresh), target), duration_length)
		else
			addtimer(CALLBACK(src, PROC_REF(deactivate), target), duration_length)

	//play the Discipline power's activation sound to the user if there is one
	if (activate_sound)
		owner.playsound_local(owner, activate_sound, 50, FALSE)

	//play the Discipline power's effect sound on the user or target if there is one
	if (effect_sound)
		playsound(target ? target : owner, effect_sound, 50, FALSE)

	//make NPCs aggro if the power is aggravating, and do so as an attack if the power is hostile
	if (aggravating && isnpc(target))
		var/mob/living/carbon/human/npc/npc = target
		spawn()
			npc.Aggro(owner, hostile)

	//causes a Masquerade violation if masquerade violating power is used around NPCs
	if (violates_masquerade)
		spawn()
			if(owner.CheckEyewitness(target ? target : owner, owner, 7, TRUE))
				//TODO: detach this from being a human
				if (ishuman(owner))
					var/mob/living/carbon/human/human = owner
					human.AdjustMasquerade(-1)

	//spend the necessary blood points, TODO: god I hate this
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		var/datum/species/kindred/species = human.dna.species
		species.spend_blood(human, vitae_cost)
	else
		owner.adjust_blood_points(-vitae_cost)

	to_chat(owner, "<span class='warning'>You cast [name][target ? " on [target]!" : "."]")
	//TODO: rewrite this to be sane
	log_attack("[key_name(owner)] casted [name], level [discipline.level_casting] of the Discipline [discipline.name][!target_type ? "." : " on [key_name(discipline.owner)]"]")

	return TRUE

/datum/discipline_power/proc/try_activate(atom/target)
	if (can_activate(target, TRUE))
		pre_activation(target)
		return TRUE

	return FALSE

/datum/discipline_power/proc/can_deactivate_untargeted()
	SHOULD_CALL_PARENT(TRUE)

	if (target_type == NONE)
		if (!owner)
			return FALSE

	return TRUE

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

/datum/discipline_power/proc/deactivate(atom/target)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_POWER_DEACTIVATE, src, target)
	SEND_SIGNAL(owner, COMSIG_POWER_DEACTIVATE, src, target)
	if (target)
		SEND_SIGNAL(target, COMSIG_POWER_DEACTIVATE_ON, src)

	if (!fire_and_forget && (duration_length != 0))
		active = FALSE

	if (duration_length)
		COOLDOWN_RESET(src, duration)
	if (!fire_and_forget)
		COOLDOWN_START(src, cooldown, cooldown_length)
	if (deactivate_sound)
		owner.playsound_local(owner, deactivate_sound, 50, FALSE)

/datum/discipline_power/proc/try_deactivate(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	if (can_deactivate(target))
		deactivate(target)

/datum/discipline_power/proc/post_gain()
	return

/datum/discipline_power/proc/refresh(atom/target)
	if (!active)
		return
	if (!owner)
		return

	var/repeat = FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		var/datum/species/kindred/species = human.dna.species
		if (species.try_spend_blood(human, vitae_cost))
			repeat = TRUE
		else
			to_chat(owner, "<span class='warning'>You can't spend enough blood to keep [src] active!")
	else
		if (owner.try_adjust_blood_points(-vitae_cost))
			repeat = TRUE
		else
			to_chat(owner, "<span class='warning'>You can't spend enough blood to keep [src] active!")

	if (repeat)
		if (!fire_and_forget && !duration_override)
			COOLDOWN_START(src, duration, duration_length)
		addtimer(CALLBACK(src, PROC_REF(refresh), target), duration_length)
		to_chat(owner, "<span class='warning'>[src] consumes your blood to stay active.</span>")
		return

	try_deactivate(target)
