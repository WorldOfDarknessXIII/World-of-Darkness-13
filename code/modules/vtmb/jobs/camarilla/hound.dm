/datum/job/vamp/cammember
	title = "Hound"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 7
	spawn_positions = 7
	supervisors = "the traditions"
	selection_color = "#bd3327"
	minimal_player_age = 7
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/cammember

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM) // See /datum/job/officer/get_access()
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_HOUND
	bounty_types = CIV_JOB_SEC
	known_contacts = list("Prince")

	v_duty = "You are a Hound; Tasked with serving either the Sheriff, Scourge or even the Keeper of Elysium, you are here to ensure Camarilla law is enforced."
	minimal_masquerade = 4
	experience_addition = 10
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian")

/datum/outfit/job/hound
	name = "Hound"
	jobtype = /datum/job/vamp/hound

	uniform = /obj/item/clothing/under/vampire/agent
	id = /obj/item/cockclock
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/camarilla
	l_pocket = /obj/item/vamp/phone/camarilla
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=3, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/agent/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Camarilla"

/obj/effect/landmark/start/hound
	name = "Hound"
	icon_state = "Camarilla Agent"
