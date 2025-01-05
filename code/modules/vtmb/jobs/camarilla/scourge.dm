/datum/job/vamp/agent
	title = "Scourge"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the prince"
	selection_color = "#bd3327"
	minimal_player_age = 7
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/agent

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM) // See /datum/job/officer/get_access()
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SCOURGE
	bounty_types = CIV_JOB_SEC
	known_contacts = list("Prince")

	v_duty = "The foremost member of the Camarilla. You are the hammer that the Prince brings when an investigation is not needed. You enforce the traditions and cooperate with the Sheriff."
	minimal_masquerade = 4
	experience_addition = 10
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian")

/datum/outfit/job/agent
	name = "Scourge"
	jobtype = /datum/job/vamp/agent

	ears = /obj/item/p25radio
	id = /obj/item/card/id/camarilla
	uniform = /obj/item/clothing/under/vampire/agent
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/camarilla
	l_pocket = /obj/item/vamp/phone/camarilla
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/vampire_stake=3, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/agent/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Camarilla"

/obj/effect/landmark/start/camarillaagent
	name = "Scourge"
	icon_state = "Camarilla Agent"
