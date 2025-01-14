/datum/job/vamp/hound
	title = "Hound"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 5 // you get other slots that equal 11
	spawn_positions = 5
	supervisors = "the prince"
	selection_color = "#bd3327"
	minimal_player_age = 7
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/hound

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM) // See /datum/job/officer/get_access()
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_HOUND
	bounty_types = CIV_JOB_SEC
	known_contacts = list(
		"Prince",
		"Sheriff",
		"Scourge",
		"Harpy",
		"Keeper",
		"Dealer"
	)

	v_duty = "You are the Prince's enforcer. You report to the sheriff and scourge! You don't get a fancy open-carry long-arms permit like the Sheriff or Scourge though..."
	minimal_masquerade = 4
	experience_addition = 10
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Lasombra", "Gargoyle", "Kiasyd", "Cappadocian")

/datum/outfit/job/hound
	name = "Hound"
	jobtype = /datum/job/vamp/hound

	ears = /obj/item/p25radio
	id = /obj/item/cockclock // no more open longarm carry for you!
	uniform = /obj/item/clothing/under/vampire/agent
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/camarilla
	l_pocket = /obj/item/vamp/phone/camarilla
	backpack_contents = list(/obj/item/passport=1, /obj/item/radio=1, /obj/item/vampire_stake=3, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/hound/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = FACTION_CAMARILLA

/obj/effect/landmark/start/hound
	name = "Hound"
	icon_state = "Camarilla Agent"
