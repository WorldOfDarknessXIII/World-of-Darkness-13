/datum/vampire_clan/ventrue
	name = "Ventrue"
	desc = "The Ventrue are not called the Clan of Kings for nothing. Carefully choosing their progeny from mortals familiar with power, wealth, and influence, the Ventrue style themselves the aristocrats of the vampire world. Their members are expected to assume command wherever possible, and they’re willing to endure storms for the sake of leading from the front."
	curse = "Low-rank and animal blood is disgusting."
	clan_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/fortitude,
		/datum/discipline/presence
	)
	clan_traits = list(
		TRAIT_FEEDING_RESTRICTION
	)
	male_clothes = /obj/item/clothing/under/vampire/ventrue
	female_clothes = /obj/item/clothing/under/vampire/ventrue/female
	clan_keys = /obj/item/vamp/keys/ventrue
