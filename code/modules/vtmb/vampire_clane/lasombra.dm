/datum/vampireclane/lasombra
	name = "Lasombra"
	desc = "The Lasombra exist for their own success, fighting for personal victories rather than solely for a crown to wear or a throne to sit upon. They believe that might makes right, and are willing to sacrifice anything to achieve their goals. A clan that uses spirituality as a tool rather than seeking honest enlightenment, their fickle loyalties are currently highlighted by half their clan's defection from the Sabbat."
	curse = "Technology refuse."
	clane_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/dominate,
		/datum/discipline/obtenebration
	)
	male_clothes = /obj/item/clothing/under/vampire/emo
	female_clothes = /obj/item/clothing/under/vampire/business
	enlightenment = TRUE
	whitelisted = TRUE

/datum/vampireclane/lasombra/post_gain(mob/living/carbon/human/H)
	..()
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
	H.vis_flags |= VIS_HIDE
	H.faction |= "Lasombra"
