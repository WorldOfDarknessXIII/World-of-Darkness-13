/datum/job/vamp/prince
	title = "Prince"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Camarilla and the Traditions"
	selection_color = "#bd3327"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_CAMARILLIA

	outfit = /datum/outfit/job/prince

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PRINCE

	minimal_generation = 10	//Uncomment when players get exp enough
	minimal_masquerade = 5
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Tremere", "Ventrue", "Nosferatu", "Toreador", "Malkavian", "Brujah", "Lasombra", "Gangrel", "True Brujah")

	my_contact_is_important = TRUE
	known_contacts = list(
		"Sheriff",
		"Seneschal",
		"Dealer",
		"Tremere Regent",
		"Primogens",
		"Baron"
	)

	v_duty = "You are the top dog of this city. You hold Praxis over San Francisco, and your word is law. Make sure the Masquerade is upheld, and your status is respected."
	experience_addition = 25

/datum/job/vamp/prince/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, PROC_REF(minor_announce), "Prince [H.real_name] is in the city!"))

/datum/outfit/job/prince
	name = "Prince"
	jobtype = /datum/job/vamp/prince

	ears = /obj/item/p25radio
	id = /obj/item/card/id/prince
	glasses = /obj/item/clothing/glasses/vampire/sun
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform =  /obj/item/clothing/under/vampire/prince
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/prince
	r_pocket = /obj/item/vamp/keys/prince
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/prince=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)
//	accessory = /obj/item/clothing/accessory/medal/gold/captain

/datum/outfit/job/prince/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Camarilla"
	H.ignores_warrant = TRUE
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/prince/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/prince
	name = "Prince"
	icon_state = "Prince"
