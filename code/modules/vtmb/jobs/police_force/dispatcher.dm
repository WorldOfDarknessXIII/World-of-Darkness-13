
/datum/job/vamp/police_force/dispatcher
	title = JOB_DISPATCHER 
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = " the SF local government."
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/dispatcher
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_type_department = EXP_TYPE_POLICE

	allowed_species = list("Ghoul", "Human")
	species_slots = list("Ghoul" = 1)

	duty = "Report emergencies to the correct emergency service."
	minimal_masquerade = 0
	known_contacts = list("Police Chief")

AddTimelock(/datum/job/vamp/police_force/dispatcher, list(
	JOB_LIVING_ROLES = 2 HOURS,
))
/datum/outfit/job/dispatcher
	name = "Dispatcher"
	jobtype = /datum/job/vamp/police_force/dispatcher
	uniform = /obj/item/clothing/under/vampire/office
	ears = /obj/item/p25radio/police/dispatch
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/government
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/dispatch
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/flashlight=1)
