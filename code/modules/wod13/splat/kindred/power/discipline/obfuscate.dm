/datum/discipline/obfuscate
	name = "Obfuscate"
	desc = "Makes you less noticable for living and un-living beings."
	icon_state = "obfuscate"
	power_type = /datum/discipline_power/obfuscate

/datum/discipline_power/obfuscate
	name = "Obfuscate power name"
	desc = "Obfuscate power description"

	check_flags = DISC_CHECK_CAPABLE

	activate_sound = 'code/modules/wod13/sounds/obfuscate_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/obfuscate_deactivate.ogg'

	toggled = TRUE
	COOLDOWN_DECLARE(obfuscate_combat_cooldown)
	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_MOB_ATTACKED_HAND,
		COMSIG_MOB_MELEE_SWING,
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_THREW_MOVABLE,
		COMSIG_MOB_ATTACKING_MELEE,
		COMSIG_MOB_ATTACKED_BY_MELEE,
	)

/datum/discipline_power/obfuscate/activate()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal))
	. = ..()

/datum/discipline_power/obfuscate/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER
	to_chat(owner, span_danger("The concept of your obfuscation is disrupted by such a conspicuous act! You're exposed!"))
	COOLDOWN_START(src, obfuscate_combat_cooldown, (65 - ( level * 5)) SECONDS)
	deactivate()
	active = FALSE
	RegisterSignal(src, COMSIG_POWER_TRY_ACTIVATE, PROC_REF(on_try_activate))

/datum/discipline_power/obfuscate/proc/on_try_activate(datum/source, datum/target)
	SIGNAL_HANDLER

	if (COOLDOWN_FINISHED(src, obfuscate_combat_cooldown))
		UnregisterSignal(src, COMSIG_POWER_TRY_ACTIVATE)
		return NONE
	to_chat(owner, span_warning("You're still too exposed to activate your cloak of obfuscation!"))
	return POWER_PREVENT_ACTIVATE


/datum/discipline_power/obfuscate/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)


//CLOAK OF SHADOWS
/datum/discipline_power/obfuscate/cloak_of_shadows
	name = "Cloak of Shadows"
	desc = "Meld into the shadows and stay unnoticed so long as you draw no attention."

	level = 1

	duration_length = 10 SECONDS

/datum/discipline_power/obfuscate/cloak_of_shadows/activate()
	. = ..()
	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10
	owner.obfuscate_level = 1

/datum/discipline_power/obfuscate/cloak_of_shadows/deactivate()
	. = ..()
	owner.alpha = 255

//UNSEEN PRESENCE
/datum/discipline_power/obfuscate/unseen_presence
	name = "Unseen Presence"
	desc = "Move among the crowds without ever being noticed. Achieve invisibility."

	level = 2

	duration_length = 20 SECONDS

/datum/discipline_power/obfuscate/unseen_presence/activate()
	. = ..()
	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10
	owner.obfuscate_level = 2

/datum/discipline_power/obfuscate/unseen_presence/deactivate()
	. = ..()
	owner.alpha = 255

//MASK OF A THOUSAND FACES
/datum/discipline_power/obfuscate/mask_of_a_thousand_faces
	name = "Mask of a Thousand Faces"
	desc = "Be noticed, but incorrectly. Hide your identity but nothing else."

	level = 3

	duration_length = 30 SECONDS

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/activate()
	. = ..()
	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10
	owner.obfuscate_level = 3

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/deactivate()
	. = ..()
	owner.alpha = 255

//VANISH FROM THE MIND'S EYE
/datum/discipline_power/obfuscate/vanish_from_the_minds_eye
	name = "Vanish from the Mind's Eye"
	desc = "Disappear from plain view, and possibly wipe your past presence from recollection."

	level = 4

	duration_length = 40 SECONDS

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/activate()
	. = ..()
	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10
	owner.obfuscate_level = 4

/datum/discipline_power/obfuscate/mask_of_a_thousand_faces/deactivate()
	. = ..()
	owner.alpha = 255

//CLOAK THE GATHERING
/datum/discipline_power/obfuscate/cloak_the_gathering
	name = "Cloak the Gathering"
	desc = "Hide yourself and others, scheme in peace."

	level = 5

	duration_length = 50 SECONDS

/datum/discipline_power/obfuscate/cloak_the_gathering/activate()
	. = ..()
	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	owner.alpha = 10
	owner.obfuscate_level = 5

/datum/discipline_power/obfuscate/cloak_the_gathering/deactivate()
	. = ..()
	owner.alpha = 255

