/datum/job/vamp/reeve
	title = "Reeve"
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/bruiser

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_REEVE
	known_contacts = list("Baron")
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian")

	v_duty = "You are the Reeve of the Anarch Free State. You keep order within Anarch territory and act as a Judge in place of the Baron which is investigative in nature."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/reeve
	name = "Revee"
	jobtype = /datum/job/vamp/reeve

	id = /obj/item/card/id/anarch
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/anarch
	r_hand = /obj/item/melee/vampirearms/baseball
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/vampire_stake=3, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/bruiser/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Anarchs"

/obj/effect/landmark/start/reeve
	name = "Reeve"
	icon_state = "Bouncer"
