/datum/job/vamp/sheriff
	title = "Sheriff"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Prince")
	head_announce = list(RADIO_CHANNEL_SECURITY)
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the prince"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 300
	exp_required_type = PAYCHECK_CREW
	exp_granted_type = EXP_TYPE_CAMARILLA

	outfit = /datum/outfit/job/sheriff

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_SHERIFF
	bounty_types = CIV_JOB_SEC

	minimal_generation = 12	//Uncomment when players get exp enough
	minimal_masquerade = 5
	allowed_species = list("Vampire")
	allowed_bloodlines = list("True Brujah", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Lasombra")

	my_contact_is_important = TRUE
	known_contacts = list("Prince","Seneschal","Dealer")

	v_duty = "Protect the Prince and the Masquerade. You are their sword."
	experience_addition = 20

/datum/outfit/job/sheriff
	name = "Sheriff"
	jobtype = /datum/job/vamp/sheriff

	ears = /obj/item/p25radio
	id = /obj/item/card/id/sheriff
	uniform = /obj/item/clothing/under/vampire/sheriff
	belt = /obj/item/storage/belt/vampire/sheathe/rapier
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest
	gloves = /obj/item/clothing/gloves/vampire/leather
//	head = /obj/item/clothing/head/hos/beret
	glasses = /obj/item/clothing/glasses/vampire/sun
	r_pocket = /obj/item/vamp/keys/sheriff
	l_pocket = /obj/item/vamp/phone/sheriff
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/vampire_stake=3, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/elder=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/sheriff/pre_equip(mob/living/carbon/human/H)
	..()
	H.ignores_warrant = TRUE
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/sheriff/female

/obj/effect/landmark/start/sheriff
	name = "Sheriff"
	icon_state = "Sheriff"
