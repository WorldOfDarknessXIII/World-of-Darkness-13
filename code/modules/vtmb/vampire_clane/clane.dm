/*
This datum stores a declarative description of clans, in order to make an instance of the clan component from this implementation in runtime
And it also helps for the character set panel
*/
/datum/vampireclane
	var/name = "Caitiff"
	var/desc = "The clanless. The rabble. Of no importance."
	var/curse = "None."
	var/list/clane_disciplines = list() //discipline datums
	var/list/restricted_disciplines = list()
	var/list/clan_traits
	var/datum/outfit/clane_outfit
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

/datum/vampireclane/proc/on_gain(mob/living/carbon/human/vampire)
	SHOULD_CALL_PARENT(TRUE)

	if (length(accessories) && current_accessory)
		vampire.remove_overlay(accessories_layers[current_accessory])
		var/mutable_appearance/acc_overlay = mutable_appearance('code/modules/wod13/icons.dmi', current_accessory, -accessories_layers[current_accessory])
		vampire.overlays_standing[accessories_layers[current_accessory]] = acc_overlay
		vampire.apply_overlay(accessories_layers[current_accessory])

	if (alt_sprite)
		if (!alt_sprite_greyscale)
			vampire.skin_tone = "albino"
		vampire.unique_body_sprite = alt_sprite

	if (no_hair)
		vampire.hairstyle = "Bald"

	if (no_facial)
		vampire.facial_hairstyle = "Shaved"

	// Add unique Clan features as traits
	for (var/trait in clan_traits)
		ADD_TRAIT(vampire, trait, CLAN_TRAIT)

	vampire.update_body_parts()
	vampire.update_body()
	vampire.update_icon()

/datum/vampireclane/proc/post_gain(mob/living/carbon/human/vampire)
	SHOULD_CALL_PARENT(TRUE)

	if(violating_appearance && vampire.roundstart_vampire)
		if(length(GLOB.masquerade_latejoin))
			var/obj/effect/landmark/latejoin_masquerade/LM = pick(GLOB.masquerade_latejoin)
			if(LM)
				vampire.forceMove(LM.loc)

	if(clan_keys)
		vampire.put_in_r_hand(new clan_keys(vampire))

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
