
/datum/job/vamp/clerk
	title = "Seneschal"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Prince")
	head_announce = list(RADIO_CHANNEL_SUPPLY, RADIO_CHANNEL_SERVICE)
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the prince"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_NEUTRALS

	outfit = /datum/outfit/job/clerk

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	bounty_types = CIV_JOB_RANDOM

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CLERK

//	minimal_generation = 12	//Uncomment when players get exp enough
	minimal_masquerade = 5

	my_contact_is_important = TRUE
	known_contacts = list("Prince","Sheriff","Tremere Regent","Dealer","Primogens")

	v_duty = "You are the right hand man or woman of the most powerful vampire in the city. The Camarilla trusts you to run the city, even in their stead."
	duty = "You are the right hand man or woman of the most powerful vampire in the city. The Camarilla trusts you to run the city, even in their stead."
	experience_addition = 15
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Lasombra", "Gargoyle", "Kiasyd")

/datum/outfit/job/clerk
	name = "Seneschal"
	jobtype = /datum/job/vamp/clerk

	ears = /obj/item/p25radio
	id = /obj/item/card/id/clerk
	uniform = /obj/item/clothing/under/vampire/clerk
	shoes = /obj/item/clothing/shoes/vampire/brown
//	head = /obj/item/clothing/head/hopcap
	l_pocket = /obj/item/vamp/phone/clerk
	r_pocket = /obj/item/vamp/keys/clerk
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/seneschal=1)

/datum/outfit/job/clerk/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/clerk/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/clerk
	name = "Seneschal"
	icon_state = "Clerk"
