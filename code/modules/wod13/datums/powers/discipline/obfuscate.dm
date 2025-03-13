#define COMBAT_COOLDOWN_LENGTH 45 SECONDS
#define REVEAL_COOLDOWN_LENGTH 15 SECONDS

/datum/discipline/obfuscate
	name = "Obfuscate"
	desc = "Makes you less noticable for living and un-living beings."
	icon_state = "obfuscate"
	power_type = /datum/discipline_power/obfuscate

/datum/discipline_power/obfuscate
	name = "Obfuscate power name"
	desc = "Obfuscate power description"

	activate_sound = 'code/modules/wod13/sounds/obfuscate_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/obfuscate_deactivate.ogg'

	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_MOB_ATTACKED_HAND,
		COMSIG_MOB_MELEE_SWING,
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_THREW_MOVABLE,
		COMSIG_MOB_ATTACKING_MELEE,
		COMSIG_MOB_ATTACKED_BY_MELEE,
	)

/datum/discipline_power/obfuscate/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your Obfuscate falls away as you reveal yourself!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/obfuscate/proc/is_seen_check()
	for (var/mob/living/viewer in oviewers(7, owner))
		//cats cannot stop you from Obfuscating
		if (!istype(viewer, /mob/living/carbon) && !viewer.client)
			continue

		//the corpses are not watching you
		if (HAS_TRAIT(viewer, TRAIT_BLIND) || viewer.stat >= UNCONSCIOUS)
			continue

		to_chat(owner, span_warning("You cannot use [src] while you're being observed!"))
		return FALSE

	return TRUE

//CLOAK OF SHADOWS
/datum/discipline_power/obfuscate/cloak_of_shadows
	name = "Cloak of Shadows"
	desc = "Meld into the shadows and stay unnoticed so long as you draw no attention."

	level = 1
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/mask_of_a_thousand_faces,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/cloak_of_shadows/pre_activation_checks()
	. = ..()
	return is_seen_check()

/datum/discipline_power/obfuscate/cloak_of_shadows/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10

/datum/discipline_power/obfuscate/cloak_of_shadows/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.alpha = 255

/datum/discipline_power/obfuscate/cloak_of_shadows/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your [src] falls away as you move from your position!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

//UNSEEN PRESENCE
/datum/discipline_power/obfuscate/unseen_presence
	name = "Unseen Presence"
	desc = "Move among the crowds without ever being noticed. Achieve invisibility."

	level = 2
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/mask_of_a_thousand_faces,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/unseen_presence/pre_activation_checks()
	. = ..()
	return is_seen_check()

/datum/discipline_power/obfuscate/unseen_presence/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null

	owner.alpha = 10

/datum/discipline_power/obfuscate/unseen_presence/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.alpha = 255

//remove this when Mask of a Thousand Faces is made tabletop accurate
/datum/discipline_power/obfuscate/unseen_presence/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.m_intent != MOVE_INTENT_WALK)
		to_chat(owner, span_danger("Your [src] falls away as you move too quickly!"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

//MASK OF A THOUSAND FACES
/datum/discipline_power/obfuscate/mask_of_a_thousand_faces
	name = "Mask of a Thousand Faces"
	desc = "Be noticed, but incorrectly. Hide your identity but nothing else."

	level = 3
	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/mask_of_a_thousand_faces,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/pre_activation_checks()
	. = ..()
	return is_seen_check()

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)

	owner.alpha = 255

//VANISH FROM THE MIND'S EYE
/datum/discipline_power/obfuscate/vanish_from_the_minds_eye
	name = "Vanish from the Mind's Eye"
	desc = "Disappear from plain view, and possibly wipe your past presence from recollection."

	level = 4
	check_flags = DISC_CHECK_CAPABLE

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/mask_of_a_thousand_faces,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/vanish_from_the_minds_eye/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10

/datum/discipline_power/obfuscate/vanish_from_the_minds_eye/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)

	owner.alpha = 255

//CLOAK THE GATHERING
/datum/discipline_power/obfuscate/cloak_the_gathering
	name = "Cloak the Gathering"
	desc = "Hide yourself and others, scheme in peace."

	level = 5
	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 0

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/obfuscate/cloak_of_shadows,
		/datum/discipline_power/obfuscate/unseen_presence,
		/datum/discipline_power/obfuscate/mask_of_a_thousand_faces,
		/datum/discipline_power/obfuscate/vanish_from_the_minds_eye,
		/datum/discipline_power/obfuscate/cloak_the_gathering
	)

/datum/discipline_power/obfuscate/cloak_the_gathering/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10

/datum/discipline_power/obfuscate/cloak_the_gathering/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)

	owner.alpha = 255

#undef COMBAT_COOLDOWN_LENGTH
#undef REVEAL_COOLDOWN_LENGTH
