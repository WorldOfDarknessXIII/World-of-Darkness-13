
/datum/job/vamp/emissary
	title = "Emissary"
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/emissary

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_EMISSARY
	known_contacts = list("Baron")
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Nosferatu", "Gangrel", "Tremere", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian", "Ministry")

	v_duty = "You are a diplomat for the anarchs. Make deals, keep the peace, all through words, not violence. But the latter may come to pass if the former fails."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/emissary
	name = "emissary"
	jobtype = /datum/job/vamp/emissary

	id = /obj/item/card/id/anarch
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/anarch
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/emissary/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = FACTION_ANARCHS

/obj/effect/landmark/start/emissary
	name = "Emissary"
	icon_state = "Bouncer"
