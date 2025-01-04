
/datum/job/vamp/dispatcher
	title = "Emergency Dispatcher"
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = " the SF local government."
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/dispatcher

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_ARMORY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_type_department = EXP_TYPE_POLICE

	allowed_species = list("Ghoul", "Human")
	species_slots = list("Ghoul" = 1)

	duty = "Report emergencies to the correct emergency service."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
	known_contacts = list("Police Chief")


/datum/outfit/job/dispatcher
	name = "Dispatcher"
	jobtype = /datum/job/vamp/dispatcher
	uniform = /obj/item/clothing/under/vampire/office
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/government
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/police_radio
	l_hand = /obj/item/vamp/keys/dispatch
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/flashlight=1)
