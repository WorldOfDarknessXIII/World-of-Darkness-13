/**
 * Rots the vampire's body along four stages of decay.
 *
 * Vampire bodies are either pre-decayed if they're Cappadocians,
 * or they decay on death to what their body should naturally
 * be according to their chronological age. Stage 1 is
 * fairly normal looking with discoloured skin, stage 2 is
 * somewhat decayed-looking, stage 3 is very decayed, and stage
 * 4 is a long-dead completely decayed corpse. This has no effect
 * on Clans that already have alt_sprites unless they're being
 * rotted to stage 3 and above.
 *
 * Arguments:
 * * rot_stage - how much to rot the vampire, on a scale from 1 to 4.
 */
/mob/living/carbon/human/proc/rot_body(rot_stage)
	// Won't replace other Clans' alternative sprites unless it's advanced decay
	if (clane?.alt_sprite)
		if (!findtext(clane.alt_sprite, "rotten") && (rot_stage <= 2))
			return

	// TODO: [Lucia] add TRAIT_MASQUERADE_VIOLATING_FACE here
	// Apply rotten sprite and rotting effects
	switch (rot_stage)
		if (1)
			dna.species.limbs_id = base_body_mod + "rotten1"
		if (2)
			dna.species.limbs_id = base_body_mod + "rotten2"
		if (3)
			dna.species.limbs_id = base_body_mod + "rotten3"
			skin_tone = "albino"
			hairstyle = "Bald"
			facial_hairstyle = "Shaved"
		if (4)
			dna.species.limbs_id = base_body_mod + "rotten4"
			skin_tone = "albino"
			hairstyle = "Bald"
			facial_hairstyle = "Shaved"

			// Rotten body will lose weight if it can
			if (base_body_mod == FAT_BODY_MODEL)
				set_body_model(NORMAL_BODY_MODEL)
			else if (base_body_mod == NORMAL_BODY_MODEL)
				set_body_model(SLIM_BODY_MODEL)

	// Update icons to reflect new body sprite
	update_body()
