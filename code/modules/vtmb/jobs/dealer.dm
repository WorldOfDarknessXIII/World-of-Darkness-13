
/datum/job/vamp/dealer
	title = "Dealer"
	department_head = list("Yourself")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "None. You are beholden only to yourself."
	selection_color = "#edc009"
	exp_type_department = EXP_TYPE_WAREHOUSE // This is so the jobs menu can work properly

	outfit = /datum/outfit/job/dealer

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_DEALER
	bounty_types = CIV_JOB_RANDOM

//	minimal_generation = 12	//Uncomment when players get exp enough

	my_contact_is_important = TRUE
	known_contacts = list("Prince","Seneschal", "Sheriff", "Baron")
	allowed_bloodlines = list("True Brujah", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Ministry", "Kiasyd")

	v_duty = "You provide supplies to other kindred. The warehouse is yours, and it's your business who you'll deal with."
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	experience_addition = 20

/datum/outfit/job/dealer
	name = "Dealer"
	jobtype = /datum/job/vamp/dealer

	id = /obj/item/card/id/dealer
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/brown
	glasses = /obj/item/clothing/glasses/vampire/sun
	l_pocket = /obj/item/vamp/phone/dealer
	r_pocket = /obj/item/vamp/keys/supply
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/dealer/pre_equip(mob/living/carbon/human/H)
	..()
	//H.vampire_faction = "Anarch"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels/red

/obj/effect/landmark/start/dealer
	name = "Dealer"
	icon_state = "Dealer"
