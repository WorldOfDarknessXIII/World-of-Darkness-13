/datum/vampireclane/nosferatu
	name = "Nosferatu"
	desc = "The Nosferatu wear their curse on the outside. Their bodies horribly twisted and deformed through the Embrace, they lurk on the fringes of most cities, acting as spies and brokers of information. Using animals and their own supernatural capacity to hide, nothing escapes the eyes of the so-called Sewer Rats."
	curse = "Masquerade-violating appearance."
	alt_sprite = "nosferatu"
//	no_hair = TRUE		//Pyotr from Hunter the Parenting had hair and it didn't go out of place in the setting. I'll do limited hairstyles
	no_facial = TRUE
	clane_disciplines = list(
		/datum/discipline/animalism = 1,
		/datum/discipline/potence = 2,
		/datum/discipline/obfuscate = 3
	)
	haircuts = list(
		"Bald",
		"Pyotr",
		"Balding Hair",
		"Boddicker",
		"Feather",
		"Gelled Back",
		"Cornrows",
		"Cornrows 2",
		"Cornrow Bun",
		"Cornrow Braid",
		"Cornrow Tail"
	)
	violating_appearance = TRUE
	male_clothes = /obj/item/clothing/under/vampire/nosferatu
	female_clothes = /obj/item/clothing/under/vampire/nosferatu/female
	accessories = list("nosferatu_ears")
	accessories_layers = list("nosferatu_ears" = UPPER_EARS_LAYER)
	current_accessory = "nosferatu_ears"
	clan_keys = /obj/item/vamp/keys/nosferatu

/datum/vampireclane/nosferatu/on_gain(mob/living/carbon/human/H)
	..()
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
	H.ventcrawler = VENTCRAWLER_ALWAYS

/datum/vampireclane/nosferatu/post_gain(mob/living/carbon/human/H)
	..()
	if(H.vampire_faction != "Camarilla" && H.vampire_faction != "Anarch" && H.vampire_faction != "Sabbat")
		H.vampire_faction = "Nosferatu"
