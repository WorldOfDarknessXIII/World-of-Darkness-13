/datum/vampire_clan
	/// Name of the Clan
	var/name
	/// Description of the Clan
	var/desc
	/// Description of the Clan's supernatural curse
	var/curse

	/// List of Disciplines that are innate to this Clan
	var/list/clan_disciplines
	/// List of Disciplines that are rejected by this Clan
	var/list/restricted_disciplines
	/// List of traits that are applied to members of this Clan
	var/list/clan_traits

	/// The Clan's unique body sprite
	var/alt_sprite
	/// If the Clan's unique body sprites need to account for skintone
	var/alt_sprite_greyscale
	/// If members of this Clan can't have hair
	var/no_hair
	/// If members of this Clan can't have facial hair
	var/no_facial

	/// Default clothing for male members of this Clan
	var/male_clothes
	/// Default clothing for female members of this Clan
	var/female_clothes
	/// Keys for this Clan's exclusive hideout
	var/clan_keys

	/// List of unnatural features that members of this Clan can choose
	var/list/accessories
	/// Associative list of layers for unnatural features that members of this Clan can choose
	var/list/accessories_layers
	/// Clan accessory that's selected by default
	var/default_accessory

	/// Morality level that characters of this Clan start with
	var/start_humanity = 7
	/// If members of this Clan are on a Path of Enlightenment by default
	var/enlightenment

	/// If this Clan needs a whitelist to select and play
	var/whitelisted

/datum/vampire_clan/proc/on_gain(mob/living/carbon/human/vampire)
	SHOULD_CALL_PARENT(TRUE)

	// Apply alternative sprites
	if (alt_sprite)
		if (!alt_sprite_greyscale)
			vampire.skin_tone = "albino"
		vampire.set_body_sprite(alt_sprite)

	// Remove hair if the Clan demands it
	if (no_hair)
		vampire.hairstyle = "Bald"

	// Remove facial hair if the Clan demands it
	if (no_facial)
		vampire.facial_hairstyle = "Shaved"

	// Add unique Clan features as traits
	for (var/trait in clan_traits)
		ADD_TRAIT(vampire, trait, CLAN_TRAIT)

	vampire.update_body_parts()
	vampire.update_body()
	vampire.update_icon()

/datum/vampire_clan/proc/post_gain(mob/living/carbon/human/vampire)
	SHOULD_CALL_PARENT(TRUE)

	if (HAS_TRAIT(vampire, TRAIT_MASQUERADE_VIOLATING_FACE) && vampire.roundstart_vampire)
		if (length(GLOB.masquerade_latejoin))
			var/obj/effect/landmark/latejoin_masquerade/LM = pick(GLOB.masquerade_latejoin)
			if (LM)
				vampire.forceMove(LM.loc)

	if (clan_keys)
		vampire.put_in_r_hand(new clan_keys(vampire))
