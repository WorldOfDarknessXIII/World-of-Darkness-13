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
