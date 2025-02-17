
/datum/job/vamp/anarch/sweeper
	title = JOB_SWEEPER
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/sweeper

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SWEEPER
	known_contacts = list("Baron")
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Nosferatu", "Gangrel", "Tremere", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian", "Ministry")

	v_duty = "You are the observer of the anarchs. You watch out for any new kindred, suspicious individuals, and any new rumors near the anarch turf, and then report it to your anarchs."
	minimal_masquerade = 2
	experience_addition = 15

AddTimelock(/datum/job/vamp/anarch/sweeper, list(
	JOB_LIVING_ROLES = 2 HOURS,
))

/datum/outfit/job/sweeper
	name = "Sweeper"
	jobtype = /datum/job/vamp/anarch/sweeper

	id = /obj/item/card/id/anarch
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/anarch
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1, /obj/item/binoculars = 1)

/obj/effect/landmark/start/sweeper
	name = "Sweeper"
	icon_state = "Bouncer"
