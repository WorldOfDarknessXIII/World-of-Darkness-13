/datum/job/vamp/giovannielder
	title = "Capo"
	department_head = list("Uncle Augie")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Family and the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/giovannielder

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_GIOVANNI
	exp_type_department = EXP_TYPE_GIOVANNI

	minimal_generation = 11	//Uncomment when players get exp enough

	v_duty = "Pure blood runs through your veins and, with it, old power. Throughout your long life you have learnt to hold onto two things and never let go: money, and family."
	minimal_masquerade = 0
	experience_addition = 10
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Giovanni", "Cappadocian")

/datum/outfit/job/giovannielder
	name = "Capo"
	jobtype = /datum/job/vamp/giovannielder

	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/capo
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/giovanniboss=1)

/datum/outfit/job/giovannielder/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Giovanni"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/giovannielder
	name = "Capo"

/datum/job/vamp/giovanni
	title = "La Squadra"
	department_head = list("Capo")
	faction = "Vampire"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Family and the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/giovanni

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_GIOVANNI
	exp_type_department = EXP_TYPE_GIOVANNI

	v_duty = "Whether born or Embraced into the family, you are one of the Giovanni. Be you a necromancer, financier or lowly fledgling, remember that so long as you stand with your family, they too will stand with you."
	minimal_masquerade = 0
	experience_addition = 10
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Giovanni", "Cappadocian")

/datum/outfit/job/giovanni
	name = "La Squadra"
	jobtype = /datum/job/vamp/giovanni

	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/giovanni/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Giovanni"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/giovanni
	name = "La Squadra"

/datum/job/vamp/giovannimafia
	title = "La Famiglia"
	department_head = list("Capo")
	faction = "Vampire"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Family"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/giovannimafia

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_GIOVANNI
	exp_type_department = EXP_TYPE_GIOVANNI

//	minimal_generation = 11	//Uncomment when players get exp enough

	allowed_species = list("Ghoul", "Human")
	duty = "Your family is a strange one. Maybe you are strange too, because sitting next to your great uncles as an equal is something you are greatly interested in."
	minimal_masquerade = 0
	experience_addition = 10


/datum/outfit/job/giovannimafia
	name = "La Famiglia"
	jobtype = /datum/job/vamp/giovannimafia
	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/giovannimafia/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/giovannimafia
	name = "La Famiglia"
