/**
 * Changes the body model (weight) of a human
 * between slim, normal, and fat, then updates icons
 * and limbs_id to match.
 *
 * Arguments:
 * * new_body_model - Body model the human is being given.
 */
/mob/living/carbon/human/proc/set_body_model(new_body_model = NORMAL_BODY_MODEL)
	// Remove old body model if it was found in limbs_id
	if (base_body_mod && (findtext(dna.species.limbs_id, base_body_mod) == 1))
		dna.species.limbs_id = copytext(dna.species.limbs_id, 2)

	// Add body model to limbs_id
	base_body_mod = new_body_model
	dna.species.limbs_id = base_body_mod + dna.species.limbs_id

	// Assign clothing sprites for new body model
	switch (base_body_mod)
		if (SLIM_BODY_MODEL)
			if (gender == FEMALE)
				body_sprite = 'code/modules/wod13/worn_slim_f.dmi'
			else
				body_sprite = 'code/modules/wod13/worn_slim_m.dmi'
		if (NORMAL_BODY_MODEL)
			body_sprite = null
		if (FAT_BODY_MODEL)
			body_sprite = 'code/modules/wod13/worn_fat.dmi'

	// Update icon to reflect new body model
	update_body()
