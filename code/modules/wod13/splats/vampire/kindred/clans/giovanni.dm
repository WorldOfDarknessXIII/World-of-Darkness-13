/datum/vampireclan/giovanni
	name = "Giovanni"
	desc = "The Giovanni are the usurpers of Clan Cappadocian and one of the youngest clans. The Giovanni has historically been both a clan and a family. They Embrace almost exclusively within their family, and are heavily focused on the goals of money and necromantic power."
	curse = "Harmful bites."
	clan_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/dominate,
		/datum/discipline/necromancy
	)
	clan_traits = list(TRAIT_PAINFUL_VAMPIRE_KISS)
	male_clothes = /obj/item/clothing/under/vampire/suit
	female_clothes = /obj/item/clothing/under/vampire/suit/female
	whitelisted = FALSE

/datum/vampireclan/giovanni/post_gain(mob/living/carbon/human/H)
	. = ..()
	H.grant_language(/datum/language/italian)
