
/datum/job/vamp/city_services/vjanitor
	title = JOB_STREET_JANITOR
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Camarilla."
	selection_color = "#e3e3e3"

	outfit = /datum/outfit/job/vjanitor

	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	allowed_species = list("Vampire", "Ghoul", "Human")

	display_order = JOB_DISPLAY_ORDER_STREETJAN
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff")

	v_duty = "Clean up all traces of Masquerade violations as the Camarilla has instructed you to."
	duty = "Keep the streets clean. You are paid to keep your mouth shut about the things you see."
	minimal_masquerade = 0
	experience_addition = 15

/datum/outfit/job/vjanitor
	name = "Street Janitor"
	jobtype = /datum/job/vamp/city_services/vjanitor

	id = /obj/item/card/id/cleaning
	uniform = /obj/item/clothing/under/vampire/janitor
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/cleaning
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	gloves = /obj/item/clothing/gloves/vampire/cleaning
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/vjanitor
	name = "Street Janitor"
	icon_state = "Street Janitor"
