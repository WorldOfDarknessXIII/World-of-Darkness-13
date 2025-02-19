/datum/discipline/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	power_type = /datum/discipline_power/auspex

/datum/discipline_power/auspex
	name = "Auspex power name"
	desc = "Auspex power description"

	check_flags = DISC_CHECK_CONSCIOUS

	activate_sound = 'code/modules/wod13/sounds/auspex.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/auspex_deactivate.ogg'

	toggled = TRUE
	duration_length = 30 SECONDS

/datum/discipline_power/auspex/activate()
	. = ..()
	owner.add_client_colour(/datum/client_colour/glass_colour/lightblue)
	owner.update_sight()

//HEIGHTENED SENSES
/datum/discipline_power/auspex/heightened_senses
	name = "Heightened Senses"
	desc = "Enhances your senses far past human limitations."

	level = 1

/datum/discipline_power/auspex/heightened_senses/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC)

/datum/discipline_power/auspex/heightened_senses/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC)

//AURA PERCEPTION
/datum/discipline_power/auspex/aura_perception
	name = "Aura Perception"
	desc = "Allows you to perceive the auras of those near you."

	level = 2

/datum/discipline_power/auspex/aura_perception/activate()
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.add_hud_to(owner)

/datum/discipline_power/auspex/aura_perception/deactivate()
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.remove_hud_from(owner)

//THE SPIRIT'S TOUCH
/datum/discipline_power/auspex/the_spirits_touch
	name = "The Spirit's Touch"
	desc = "Allows you to feel the physical wellbeing of those near you."

	level = 3

/datum/discipline_power/auspex/the_spirits_touch/activate()
	. = ..()
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.add_hud_to(owner)

/datum/discipline_power/auspex/the_spirits_touch/deactivate()
	. = ..()
	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.add_hud_to(owner)

//TELEPATHY
/datum/discipline_power/auspex/telepathy
	name = "Telepathy"
	desc = "Feel the psychic resonances left on objects you can touch."

	level = 4

/datum/discipline_power/auspex/telepathy/activate()
	. = ..()
	owner.auspex_examine = TRUE

/datum/discipline_power/auspex/telepathy/deactivate()
	. = ..()
	owner.auspex_examine = FALSE

//PSYCHIC PROJECTION
/datum/discipline_power/auspex/psychic_projection
	name = "Psychic Projection"
	desc = "Leave your body behind and fly across the land."

	level = 5

	toggled = FALSE

/datum/discipline_power/auspex/psychic_projection/activate()
	. = ..()
	owner.ghostize(can_reenter_corpse = TRUE, aghosted = FALSE, auspex_ghosted = TRUE)
	owner.soul_state = SOUL_PROJECTING
