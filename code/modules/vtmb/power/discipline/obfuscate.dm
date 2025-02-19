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

//CLOAK OF SHADOWS
/datum/discipline_power/obfuscate/cloak_of_shadows
	name = "Cloak of Shadows"
	desc = "Meld into the shadows and stay unnoticed so long as you draw no attention."

	level = 1

	duration_length = 10 SECONDS

/datum/discipline_power/obfuscate/cloak_of_shadows/activate()
	. = ..()
	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if(NPC)
			if(NPC.danger_source == owner)
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
		if(NPC)
			if(NPC.danger_source == owner)
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
		if(NPC)
			if(NPC.danger_source == owner)
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
		if(NPC)
			if(NPC.danger_source == owner)
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
		if(NPC)
			if(NPC.danger_source == owner)
				NPC.danger_source = null
	owner.alpha = 10
	owner.obfuscate_level = 5

/datum/discipline_power/obfuscate/cloak_the_gathering/deactivate()
	. = ..()
	owner.alpha = 255

