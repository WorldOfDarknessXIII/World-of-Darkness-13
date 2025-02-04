
/datum/job/vamp/priest
	title = "Priest"
	department_head = list("Bishop")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "God"
	selection_color = "#fff700"

	outfit = /datum/outfit/job/priest

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_PRIEST
	exp_type_department = EXP_TYPE_CHURCH

	allowed_species = list("Human")
	minimal_generation = 13

	duty = "Be the local spiritual leader of those within this district of San Francisco. You are old and have some basic education about theology."
	minimal_masquerade = 0
	my_contact_is_important = FALSE

/datum/outfit/job/priest
	name = "Priest"
	jobtype = /datum/job/vamp/priest

	uniform = /obj/item/clothing/under/vampire/graveyard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/id/hunter
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/church
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/priest
	name = "Priest"
