/datum/species/cyborg
	name = "Human"
	id = "cyborg"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LIMBATTACHMENT, TRAIT_VIRUSIMMUNE, TRAIT_NOBLEED, TRAIT_NOHUNGER)
	mutant_bodyparts = list("wings" = "None")
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/durathread
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1
	punchdamagelow = 15
	punchdamagehigh = 25
	brutemod = 0.35	// or change to 0.8
	heatmod = 0.35
	coldmod = 0.35
	burnmod = 0.35
	stunmod = 0.35
	bodypart_overides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/robot/flesh,\
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/robot/flesh,\
		BODY_ZONE_HEAD = /obj/item/bodypart/head,\
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/robot,\
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/robot,\
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot)
	mutantheart = /obj/item/organ/heart/cybernetic/tier3
	mutantears = /obj/item/organ/ears/invincible
	mutanteyes = /obj/item/organ/eyes/robotic/xray
	mutantlungs = /obj/item/organ/lungs/cybernetic/tier3
	mutantliver =  /obj/item/organ/liver/cybernetic/tier3
	selectable = FALSE


/obj/item/bodypart/l_arm/robot/flesh/is_organic_looking()
	return TRUE

/obj/item/bodypart/r_arm/robot/flesh/is_organic_looking()
	return TRUE