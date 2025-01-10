
/datum/job/vamp/reeve
	title = "Reeve"
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/reeve

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_REEVE
	known_contacts = list(
		"Prince",
		"Scourge",
		"Sheriff",
		"Reeve",
		"Emissary",
		"Harpy",
		"Dealer"
	)

	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Nosferatu", "Gangrel", "Tremere", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian", "Ministry")

	v_duty = "You are the chief problem solver among the unruly anarchs. Adjacent to the Sheriff, the position you are burdened carries much scrutiny within the Free State. Saying you demand immediate authority isn't going to cut it -- it is earned."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/reeve
	name = "Reeve"
	jobtype = /datum/job/vamp/reeve

	id = /obj/item/card/id/anarch
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/reeve
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/radio=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1, /obj/item/binoculars = 1)

/datum/outfit/job/reeve/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Anarchs"

/obj/effect/landmark/start/reeve
	name = "Reeve"
	icon_state = "Bouncer"
