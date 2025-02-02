//Called on /mob/living/carbon/Initialize(), for the carbon mobs to register relevant signals.
/mob/living/carbon/human/register_init_signals()
	. = ..()

	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_FACE_ACT, PROC_REF(clean_face))
	RegisterSignal(src, COMSIG_ADDRECIPE_KLAIVE, PROC_REF(add_recipe_klaive))

/**
 * On gaining crafting recipes for garou klaives
 *
 * This grants a specific silver klaive crafting recipe depending on tribe.
 */
/mob/living/carbon/human/proc/add_recipe_klaive(datum/source)
	SIGNAL_HANDLER

	if(auspice.tribe == "Glasswalkers")
		mind.teach_crafting_recipe(/datum/crafting_recipe/klaive/glasswalker)

	if(auspice.tribe == "Wendigo")
		mind.teach_crafting_recipe(/datum/crafting_recipe/klaive/wendigo)

	if(auspice.tribe == "Black Spiral Dancers")
		mind.teach_crafting_recipe(/datum/crafting_recipe/klaive/bsd)

	UnregisterSignal(src, COMSIG_ADDRECIPE_KLAIVE)

/**
 * Called on the COMSIG_COMPONENT_CLEAN_FACE_ACT signal
 */
/mob/living/carbon/human/proc/clean_face(datum/source, clean_types)
	SIGNAL_HANDLER

	if(!is_mouth_covered() && clean_lips())
		. = TRUE

	if(glasses && is_eyes_covered(FALSE, TRUE, TRUE) && glasses.wash(clean_types))
		update_inv_glasses()
		. = TRUE

	var/obscured = check_obscured_slots()
	if(wear_mask && !(obscured & ITEM_SLOT_MASK) && wear_mask.wash(clean_types))
		update_inv_wear_mask()
		. = TRUE
