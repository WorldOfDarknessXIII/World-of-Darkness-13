//Additional game logic should be stored in the component
GLOBAL_LIST_INIT(basic_disciplines, list(/datum/discipline/animalism)) //write here the main disciplines when I do them [Lucia] - god fucking damn it flavrius
/*
This datum stores a declarative description of clans, in order to make an instance of the clan component from this implementation in runtime
And it also helps for the character set panel
*/
/datum/vampireclane
	var/name = "Caitiff"
	var/desc = "The clanless. The rabble. Of no importance."
	var/list/clane_disciplines = list() //discipline datums
	var/list/restricted_disciplines = list()
	var/datum/outfit/clane_outfit
	var/curse = "None."
	var/list/allowed_jobs = list()
	var/list/denied_jobs = list()
	var/clane_curse //There should be a reference here.
	///The Clan's unique body sprite
	var/alt_sprite
	///If the Clan's unique body sprites need to account for skintone
	var/alt_sprite_greyscale = FALSE
	var/no_hair
	var/no_facial
	var/humanitymod = 1
	var/frenzymod = 1
	var/start_humanity = 7
	var/haircuts
	var/violating_appearance
	var/male_clothes
	var/female_clothes
	var/enlightenment = FALSE
	var/whitelisted = FALSE
	var/accessories = list()
	var/accessories_layers = list()
	var/current_accessory
	var/clan_keys //Keys to your hideout

/datum/vampireclane/proc/on_gain(var/mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)

	if(length(accessories))
		if(current_accessory)
			H.remove_overlay(accessories_layers[current_accessory])
			var/mutable_appearance/acc_overlay = mutable_appearance('code/modules/wod13/icons.dmi', current_accessory, -accessories_layers[current_accessory])
			H.overlays_standing[accessories_layers[current_accessory]] = acc_overlay
			H.apply_overlay(accessories_layers[current_accessory])
	if(alt_sprite)
		if (!alt_sprite_greyscale)
			H.skin_tone = "albino"
		H.dna.species.limbs_id = alt_sprite
		H.update_body_parts()
		H.update_body()
		H.update_icon()

/datum/vampireclane/proc/post_gain(var/mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)

	if(violating_appearance && H.roundstart_vampire)
		if(length(GLOB.masquerade_latejoin))
			var/obj/effect/landmark/latejoin_masquerade/LM = pick(GLOB.masquerade_latejoin)
			if(LM)
				H.forceMove(LM.loc)

	if(clan_keys)
		H.put_in_r_hand(new clan_keys(H))

/mob/living/carbon
	var/datum/relationship/Myself

/datum/relationship/proc/publish()
	GLOB.relationship_list += src
	generate_relationships()

/datum/relationship
	var/need_friend = FALSE
	var/need_enemy = FALSE
	var/need_lover = FALSE

	var/datum/relationship/Friend
	var/datum/relationship/Enemy
	var/datum/relationship/Lover

	var/friend_text
	var/enemy_text
	var/lover_text

	var/phone_number

	var/mob/living/carbon/human/owner

/datum/relationship/proc/generate_relationships()
	if(!owner)
		return
	if(need_friend)
		for(var/datum/relationship/R in GLOB.relationship_list)
			if(R)
				if(R != src)
					if(R.need_friend && need_friend && !R.Friend && !Friend && R.Enemy != src && Enemy != R && R.Lover != src && Lover != R)
						Friend = R
						R.Friend = src
						to_chat(owner, "Your friend, <b>[R.owner.real_name]</b>, is now in the city!")
						to_chat(R.owner, "Your friend, <b>[owner.real_name]</b>, is now in the city!")
						need_friend = FALSE
	if(need_enemy)
		for(var/datum/relationship/R in GLOB.relationship_list)
			if(R)
				if(R != src)
					if(R.need_enemy && need_enemy && !R.Enemy && !Enemy && R.Friend != src && Friend != R && R.Lover != src && Lover != R)
						Enemy = R
						R.Enemy = src
						to_chat(owner, "Your enemy, <b>[R.owner.real_name]</b>, is now in the city!")
						to_chat(R.owner, "Your enemy, <b>[owner.real_name]</b>, is now in the city!")
						need_enemy = FALSE
	if(need_lover)
		for(var/datum/relationship/R in GLOB.relationship_list)
			if(R)
				if(R != src)
					if(R.need_lover && need_lover && !R.Lover && !Lover && R.Friend != src && Friend != R && R.Enemy != src && Enemy != R)
						if((R.owner.gender == owner.gender) && HAS_TRAIT(R.owner, TRAIT_HOMOSEXUAL) && HAS_TRAIT(owner, TRAIT_HOMOSEXUAL))
							Lover = R
							R.Lover = src
							to_chat(owner, "Your lover, <b>[R.owner.real_name]</b>, is now in the city!")
							to_chat(R.owner, "Your lover, <b>[owner.real_name]</b>, is now in the city!")
							need_lover = FALSE
						else if(!HAS_TRAIT(R.owner, TRAIT_HOMOSEXUAL) && !HAS_TRAIT(owner, TRAIT_HOMOSEXUAL) && (R.owner.gender != owner.gender))
							Lover = R
							R.Lover = src
							to_chat(owner, "Your lover, <b>[R.owner.real_name]</b>, is now in the city!")
							to_chat(R.owner, "Your lover, <b>[owner.real_name]</b>, is now in the city!")
							need_lover = FALSE

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
 * Arguments
 * * rot_stage - how much to rot the vampire, on a scale from 1 to 4.
 */
/datum/vampireclane/proc/rot_body(rot_stage)
	if (alt_sprite)
		if (!findtext(alt_sprite, "rotten") && (rot_stage <= 2))
			return

	switch (rot_stage)
		if (1)
			alt_sprite = "rotten1"
			alt_sprite_greyscale = TRUE
			violating_appearance = FALSE
			no_hair = FALSE
			no_facial = FALSE
		if (2)
			alt_sprite = "rotten2"
			alt_sprite_greyscale = TRUE
			violating_appearance = FALSE
			no_hair = FALSE
			no_facial = TRUE
		if (3)
			alt_sprite = "rotten3"
			alt_sprite_greyscale = FALSE
			violating_appearance = TRUE
			no_hair = TRUE
			no_facial = TRUE
		if (4)
			alt_sprite = "rotten4"
			alt_sprite_greyscale = FALSE
			violating_appearance = TRUE
			no_hair = TRUE
			no_facial = TRUE
