/datum/job/vamp/chunk
	title = "Millenium Tower Security"
	department_head = list("Millenium Tower Administration")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Prince"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/chunk

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Human")

	duty = "Make sure no one sees your unusually pale boss without an appointment. Keep the tower premises safe and clean for it's occupants."
	minimal_masquerade = 0
	my_contact_is_important = FALSE

/datum/outfit/job/chunk
	name = "Millenium Tower Security"
	jobtype = /datum/job/vamp/police_officer

	gloves = /obj/item/cockclock
	uniform = /obj/item/clothing/under/vampire/guard
	shoes = /obj/item/clothing/shoes/vampire
	belt = /obj/item/gun/ballistic/automatic/vampire/m1911
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/card/id/chunk
	r_pocket = /obj/item/vamp/keys/camarilla
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/flashlight=1, /obj/item/vamp/creditcard=1,/obj/item/food/vampire/donut=5)
