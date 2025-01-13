
/datum/job/vamp/supply
	title = "Supply Technician"
	department_head = list("Dealer")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Dealer"
	selection_color = "#edc009"
	exp_type_department = EXP_TYPE_WAREHOUSE

	outfit = /datum/outfit/job/supply

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_MECH_MINING)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_SUPPLY
	bounty_types = CIV_JOB_RANDOM
	allowed_species = list("Vampire", "Ghoul", "Human")
	known_contacts = list("Dealer")
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian")

	v_duty = "You work for the Dealer, or are a part of their coterie. They pay well and the job is easy. Don't disappoint them."
	duty = "Though your boss is odd and only works late night hours, they pay you well enough that you avoid questioning it."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/supply
	name = "Supply Technician"
	jobtype = /datum/job/vamp/supply

	id = /obj/item/card/id/supplytech
	uniform = /obj/item/clothing/under/vampire/supply
	gloves = /obj/item/clothing/gloves/vampire/work
	l_pocket = /obj/item/vamp/phone/supply_tech
	r_pocket = /obj/item/vamp/keys/supply
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/supply/pre_equip(mob/living/carbon/human/H)
	..()
	//H.vampire_faction = FACTION_ANARCHS

/obj/effect/landmark/start/supplytechnician
	name = "Supply Technician"
	icon_state = "Supply Technician"
