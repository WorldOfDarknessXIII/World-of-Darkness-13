
/datum/job/vamp/city_services/graveyard
	title = JOB_GRAVEYARD_KEEPER
	department_head = list("Seneschal")
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Camarilla or the Anarchs"
	selection_color = "#e3e3e3"
	exp_type_department = EXP_TYPE_SERVICES


	outfit = /datum/outfit/job/graveyard

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_GRAVEYARD
	bounty_types = CIV_JOB_MINE

	v_duty = "A vile curse has gripped the dead of this city. You must keep the graveyard clean and the Masquerade intact."
	minimal_masquerade = 0
	experience_addition = 15
	allowed_species = list("Vampire", "Ghoul", "Kuei-Jin")
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Cappadocian")

AddTimelock(/datum/job/vamp/city_services/graveyard, list(
	JOB_LIVING_ROLES = 2 HOURS,
))

/datum/outfit/job/graveyard
	name = "Graveyard Keeper"
	jobtype = /datum/job/vamp/city_services/graveyard

	id = /obj/item/card/id/graveyard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
//	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/vampire/graveyard
	suit = /obj/item/clothing/suit/vampire/trench
	glasses = /obj/item/clothing/glasses/vampire/yellow
	gloves = /obj/item/clothing/gloves/vampire/work
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/graveyard
	r_hand = /obj/item/melee/vampirearms/shovel
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/melee/vampirearms/katana/kosa=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/graveyardkeeper
	name = "Graveyard Keeper"
	icon_state = "Graveyard Keeper"
