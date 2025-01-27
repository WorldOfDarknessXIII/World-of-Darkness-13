
/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	mouse_drag_pointer = MOUSE_INACTIVE_POINTER
	var/in_use = FALSE

INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy)

/mob/living/carbon/human/dummy/Destroy()
	in_use = FALSE
	return ..()

/mob/living/carbon/human/dummy/Life()
	return

/mob/living/carbon/human/dummy/attach_rot(mapload)
	return

/mob/living/carbon/human/dummy/proc/wipe_state()
	delete_equipment()
	cut_overlays(TRUE)

/mob/living/carbon/human/dummy/setup_human_dna()
	create_dna()
	randomize_human(src)
	dna.initialize_dna(skip_index = TRUE) //Skip stuff that requires full round init.

/proc/create_consistent_human_dna(mob/living/carbon/human/target)
	target.create_dna()
	target.dna.initialize_dna(skip_index = TRUE)
	target.dna.features["body_markings"] = "None"
	target.dna.features["ears"] = "None"
	target.dna.features["ethcolor"] = COLOR_WHITE
	target.dna.features["frills"] = "None"
	target.dna.features["horns"] = "None"
	target.dna.features["mcolor"] = COLOR_VIBRANT_LIME
	target.dna.features["moth_antennae"] = "Plain"
	target.dna.features["moth_markings"] = "None"
	target.dna.features["moth_wings"] = "Plain"
	target.dna.features["snout"] = "Round"
	target.dna.features["spines"] = "None"
	target.dna.features["tail_cat"] = "None"
	target.dna.features["tail_lizard"] = "Smooth"

/// Provides a dummy that is consistently bald, white, naked, etc.
/mob/living/carbon/human/dummy/consistent

/mob/living/carbon/human/dummy/consistent/setup_human_dna()
	create_consistent_human_dna(src)

/// Provides a dummy for unit_tests that functions like a normal human, but with a standardized appearance
/// Copies the stock dna setup from the dummy/consistent type
/mob/living/carbon/human/consistent

/mob/living/carbon/human/consistent/setup_human_dna()
	create_consistent_human_dna(src)

/mob/living/carbon/human/consistent/update_body(is_creating)
	..()
	if(is_creating)
		fully_replace_character_name(real_name, "John Doe")

//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
	if(QDELETED(D))
		D = new
		GLOB.human_dummy_list[slotkey] = D
		GLOB.dummy_mob_list += D
	D.in_use = TRUE
	return D

/proc/unset_busy_human_dummy(slotnumber)
	if(!slotnumber)
		return
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotnumber]
	if(istype(D))
		D.wipe_state()
		D.in_use = FALSE
