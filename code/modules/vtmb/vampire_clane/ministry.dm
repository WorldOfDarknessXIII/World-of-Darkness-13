/datum/vampireclane/ministry
	name = "Ministry"
	desc = "The Ministry, also called the Ministry of Set, Followers of Set, or Setites, are a clan of vampires who believe their founder was the Egyptian god Set."
	curse = "Decreased moving speed in lighted areas."
	clane_disciplines = list(
		/datum/discipline/obfuscate = 1,
		/datum/discipline/presence = 2,
		/datum/discipline/serpentis = 3
	)
	male_clothes = /obj/item/clothing/under/vampire/slickback
	female_clothes = /obj/item/clothing/under/vampire/burlesque

/datum/vampireclane/ministry/on_gain(mob/living/carbon/human/H)
	. = ..()
	H.add_quirk(/datum/quirk/lightophobia)

/datum/vampireclane/ministry/post_gain(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
