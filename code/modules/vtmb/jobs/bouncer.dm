
/datum/job/vamp/bouncer
	title = "Bouncer"
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 7
	spawn_positions = 7
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/bouncer

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BOUNCER
	known_contacts = list("Baron")
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian")

	v_duty = "You work with the baron - whether because of your own ideals or friendship, or other reasons. That doesn't mean you will let someone disregard the one tradition you do agree with - the Masquerade."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/bouncer
	name = "Bouncer"
	jobtype = /datum/job/vamp/bouncer

	id = /obj/item/card/id/anarch
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/anarch
	r_hand = /obj/item/melee/vampirearms/baseball
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/vampire_stake=3, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/bouncer/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Anarch"

/obj/effect/landmark/start/bouncer
	name = "Bouncer"
	icon_state = "Bouncer"
