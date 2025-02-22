
/datum/job/vamp/triad_soldier
	title = "Triad Soldier"
	department_head = list("Triad Leadership")
	faction = "Vampire"
	total_positions = 8
	spawn_positions = 8
	supervisors = " the Triads"
	selection_color = "#bb9d3d"

	outfit = /datum/outfit/job/triad_soldier

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TRIAD_GANGSTER
	exp_type_department = EXP_TYPE_GANG

	allowed_species = list("Human", "Werewolf", "Kuei-Jin")
	minimal_generation = 13

	duty = "Make money, do drugs, fight law. Your hideout is the laundromat in Chinatown."
	experience_addition = 10
	minimal_masquerade = 0
	my_contact_is_important = FALSE

/datum/outfit/job/triad_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/cantonese)
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/triad_soldier
	name = "Triad Soldier"
	jobtype = /datum/job/vamp/triad_soldier
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
//	suit = /obj/item/clothing/suit/vampire/vest
//	belt = /obj/item/melee/classic_baton
	id = /obj/item/cockclock
//	gloves = /obj/item/cockclock
//	id = /obj/item/card/id/police
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/triads
//	r_hand = /obj/item/police_radio
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/clothing/mask/vampire/balaclava =1, /obj/item/gun/ballistic/automatic/vampire/beretta=2,/obj/item/ammo_box/magazine/semi9mm=2, /obj/item/melee/vampirearms/knife)
