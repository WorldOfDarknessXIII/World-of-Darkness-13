/datum/job
	var/experience_addition = 5

/datum/outfit/job/post_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.clane)
		if(H.clane.name == "Ventrue")
			var/obj/item/stack/dollar/hundred/HUN = new(H.loc)
			for(var/obj/item/storage/backpack/B in H)
				if(B)
					HUN.forceMove(B)

	var/obj/item/storage/backpack/b = locate() in H
	if(b)
		var/obj/item/vamp/creditcard/card = locate() in b.contents
		if(card && card.has_checked == FALSE)
			for(var/obj/item/vamp/creditcard/caard in b.contents)
				if(caard)
					H.bank_id = caard.account.bank_id
					caard.has_checked = TRUE
//CAMARILLA

/datum/job/vamp/prince
	title = "Prince"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Camarilla and the Traditions"
	selection_color = "#bd3327"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_CAMARILLIA

	outfit = /datum/outfit/job/prince

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PRINCE

	minimal_generation = 10	//Uncomment when players get exp enough
	minimal_masquerade = 5
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Tremere", "Ventrue", "Nosferatu", "Toreador", "Malkavian", "Brujah", "Lasombra", "Gangrel", "True Brujah")

	my_contact_is_important = TRUE
	known_contacts = list(
		"Sheriff",
		"Seneschal",
		"Baron"
	)

	v_duty = "You are the top dog of this city. You hold Praxis over San Francisco, and your word is law. Make sure the Masquerade is upheld, and your status is respected."
	experience_addition = 25

/datum/job/vamp/prince/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, PROC_REF(minor_announce), "Prince [H.real_name] is in the city!"))

/datum/outfit/job/prince
	name = "Prince"
	jobtype = /datum/job/vamp/prince

	id = /obj/item/card/id/prince
	glasses = /obj/item/clothing/glasses/vampire/sun
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform =  /obj/item/clothing/under/vampire/prince
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/prince
	r_pocket = /obj/item/vamp/keys/prince
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/prince=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)
//	accessory = /obj/item/clothing/accessory/medal/gold/captain

/datum/outfit/job/prince/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Camarilla"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/prince/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/prince
	name = "Prince"
	icon_state = "Prince"

/datum/job/vamp/sheriff
	title = "Sheriff"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Prince")
	head_announce = list(RADIO_CHANNEL_SECURITY)
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the prince"
	selection_color = "#bd3327"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/sheriff

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM, TRAIT_ROYAL_METABOLISM)

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY,
					ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_AUX_BASE,
					ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING, ACCESS_EVA, ACCESS_TELEPORTER,
					ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY,
					ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_AUX_BASE,
					ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING, ACCESS_EVA,
					ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_SHERIFF
	bounty_types = CIV_JOB_SEC

	minimal_generation = 12	//Uncomment when players get exp enough
	minimal_masquerade = 5
	allowed_species = list("Vampire")
	allowed_bloodlines = list("True Brujah", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry")

	my_contact_is_important = TRUE
	known_contacts = list("Prince")

	v_duty = "Protect the Prince and the Masquerade. You are their sword."
	experience_addition = 20

/datum/outfit/job/sheriff
	name = "Sheriff"
	jobtype = /datum/job/vamp/sheriff

	id = /obj/item/card/id/sheriff
	uniform = /obj/item/clothing/under/vampire/sheriff
	belt = /obj/item/melee/vampirearms/katana
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest
	gloves = /obj/item/clothing/gloves/vampire/leather
//	head = /obj/item/clothing/head/hos/beret
	glasses = /obj/item/clothing/glasses/vampire/sun
	r_pocket = /obj/item/vamp/keys/sheriff
	l_pocket = /obj/item/vamp/phone/sheriff
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/vampire_stake=3, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/elder=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/sheriff/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Camarilla"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/sheriff/female

/obj/effect/landmark/start/sheriff
	name = "Sheriff"
	icon_state = "Sheriff"

/datum/job/vamp/clerk
	title = "Seneschal"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Prince")
	head_announce = list(RADIO_CHANNEL_SUPPLY, RADIO_CHANNEL_SERVICE)
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the prince"
	selection_color = "#bd3327"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_NEUTRALS

	outfit = /datum/outfit/job/clerk

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
						ACCESS_MEDICAL, ACCESS_PSYCHOLOGY, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
						ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
						ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
						ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_VAULT, ACCESS_MINING_STATION,
						ACCESS_MECH_MINING, ACCESS_MECH_ENGINE, ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY, ACCESS_MECH_MEDICAL,
						ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE, ACCESS_TELEPORTER)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_WEAPONS,
						ACCESS_MEDICAL, ACCESS_PSYCHOLOGY, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_HEADS,
						ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION, ACCESS_MORGUE,
						ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_QM, ACCESS_HYDROPONICS, ACCESS_LAWYER,
						ACCESS_MECH_MINING, ACCESS_MECH_ENGINE, ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY, ACCESS_MECH_MEDICAL,
						ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_VAULT, ACCESS_MINING_STATION,
						ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE, ACCESS_TELEPORTER)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SRV
	bounty_types = CIV_JOB_RANDOM

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CLERK

//	minimal_generation = 12	//Uncomment when players get exp enough
	minimal_masquerade = 5

	my_contact_is_important = TRUE
	known_contacts = list("Prince")

	v_duty = "You are the right hand man or woman of the most powerful vampire in the city. The Camarilla trusts you to run the city, even in their stead."
	duty = "You are the right hand man or woman of the most powerful vampire in the city. The Camarilla trusts you to run the city, even in their stead."
	experience_addition = 15
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Lasombra", "Gargoyle", "Kiasyd")

/datum/outfit/job/clerk
	name = "Seneschal"
	jobtype = /datum/job/vamp/clerk

	id = /obj/item/card/id/clerk
	uniform = /obj/item/clothing/under/vampire/clerk
	shoes = /obj/item/clothing/shoes/vampire/brown
//	head = /obj/item/clothing/head/hopcap
	l_pocket = /obj/item/vamp/phone/clerk
	r_pocket = /obj/item/vamp/keys/clerk
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/clerk/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Camarilla"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/clerk/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/clerk
	name = "Seneschal"
	icon_state = "Clerk"

/datum/job/vamp/agent
	title = "Scourge"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 7
	spawn_positions = 7
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

	display_order = JOB_DISPLAY_ORDER_AGENT
	bounty_types = CIV_JOB_SEC
	known_contacts = list("Prince")

	v_duty = "You are the Prince's enforcer. You report to the sheriff and uphold the Traditions."
	minimal_masquerade = 4
	experience_addition = 10
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Lasombra", "Gargoyle", "Kiasyd")

/datum/outfit/job/agent
	name = "Scourge"
	jobtype = /datum/job/vamp/agent

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

//NEUTRALS

/datum/job/vamp/graveyard
	title = "Graveyard Keeper"
	department_head = list("Seneschal")
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Camarilla or the Anarchs"
	selection_color = "#e3e3e3"

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
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff")

/datum/outfit/job/graveyard
	name = "Graveyard Keeper"
	jobtype = /datum/job/vamp/graveyard

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

/datum/job/vamp/vdoctor
	title = "Doctor"
	department_head = list("Seneschal")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Camarilla or the Anarchs"
	selection_color = "#e3e3e3"

	outfit = /datum/outfit/job/vdoctor

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf")
	display_order = JOB_DISPLAY_ORDER_DOCTOR
	bounty_types = CIV_JOB_MED

	v_duty = "Help your fellow kindred in all matters medicine related. Sell blood. Keep your human colleagues ignorant."
	duty = "Collect blood by helping mortals at the Clinic."
	experience_addition = 15
	allowed_bloodlines = list("Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Kiasyd")

/datum/outfit/job/vdoctor
	name = "Doctor"
	jobtype = /datum/job/vamp/vdoctor

	id = /obj/item/card/id/clinic
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_hand = /obj/item/storage/firstaid/medical
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/clinic
	r_hand = /obj/item/radio/clinic
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/quickcarry)

/obj/effect/landmark/start/vdoctor
	name = "Doctor"
	icon_state = "Doctor"

/datum/job/vamp/vjanitor
	title = "Street Janitor"
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Camarilla."
	selection_color = "#e3e3e3"

	outfit = /datum/outfit/job/vjanitor

	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	allowed_species = list("Vampire", "Ghoul", "Human")

	display_order = JOB_DISPLAY_ORDER_STREETJAN
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff")

	v_duty = "Clean up all traces of Masquerade violations as the Camarilla has instructed you to."
	duty = "Keep the streets clean. You are paid to keep your mouth shut and keep questions to yourselves."
	minimal_masquerade = 0
	experience_addition = 15

/datum/outfit/job/vjanitor
	name = "Street Janitor"
	jobtype = /datum/job/vamp/vjanitor

	id = /obj/item/card/id/cleaning
	uniform = /obj/item/clothing/under/vampire/janitor
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/cleaning
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	gloves = /obj/item/clothing/gloves/vampire/cleaning
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/vjanitor
	name = "Street Janitor"
	icon_state = "Street Janitor"

/datum/job/vamp/regent
	title = "Chantry Regent"
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Pyramid"
	selection_color = "#ab2508"

	outfit = /datum/outfit/job/regent

	access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	exp_type_department = EXP_TYPE_INDEPENDENT

	display_order = JOB_DISPLAY_ORDER_REGENT
	v_duty = "Lead the Chantry. You serve as both the Regent and Tremere Primogen. You report to the Tremere Lord of this region first, Prince second."
	minimal_masquerade = 4
	minimal_generation = 7
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Tremere")
	experience_addition = 20
	known_contacts = list("Prince")

/datum/outfit/job/regent
	name = "Chantry Regent"
	jobtype = /datum/job/vamp/regent

	id = /obj/item/card/id/archive
	glasses = /obj/item/clothing/glasses/vampire/perception
	suit = /obj/item/clothing/suit/vampire/trench/archive
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/archivist
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/vamp/phone
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/arcane_tome=1, /obj/item/vamp/creditcard/elder=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/regent/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Chantry"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/archivist/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/regent
	name = "Chantry Regent"
	icon_state = "Archivist"

/datum/job/vamp/archivist
	title = "Chantry Archivist"
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Traditions and the Regent"
	selection_color = "#ab2508"

	outfit = /datum/outfit/job/archivist

	access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	exp_type_department = EXP_TYPE_INDEPENDENT

	display_order = JOB_DISPLAY_ORDER_ARCHIVIST

	v_duty = "Keep a census of events and provide information to neonates. Listen to the Regent Carefully. Study blood magic and protect the chantry."
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Tremere", "Gargoyle")
	experience_addition = 15

/datum/outfit/job/archivist
	name = "Archivist"
	jobtype = /datum/job/vamp/archivist

	id = /obj/item/card/id/archive
	glasses = /obj/item/clothing/glasses/vampire/perception
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/archivist
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/vamp/phone
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/arcane_tome=1, /obj/item/vamp/creditcard=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/archivist/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Chantry"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/archivist/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/archivist
	name = "Archivist"
	icon_state = "Archivist"

//ANARCHS

/datum/job/vamp/barkeeper
	title = "Baron"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Anarchs and the Traditions"
	selection_color = "#434343"

	outfit = /datum/outfit/job/barkeeper

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BARKEEPER
	bounty_types = CIV_JOB_DRINK

//	minimal_generation = 11	//Uncomment when players get exp enough

	my_contact_is_important = TRUE
	known_contacts = list(
		"Prince",
		"Dealer"
	)

	v_duty = "You lead the Anarchs in the City. A Camarilla faction that values freedom and individuality. While not a fan of the traditions, you still respect the Masquerade."
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Ventrue", "Lasombra", "Gargoyle")
	experience_addition = 20

/datum/outfit/job/barkeeper
	name = "Baron"
	jobtype = /datum/job/vamp/barkeeper

	id = /obj/item/card/id/anarch
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/bar
	suit = /obj/item/clothing/suit/vampire/jacket/better
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/work
	l_pocket = /obj/item/vamp/phone/barkeeper
	r_pocket = /obj/item/vamp/keys/bar
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/barkeeper/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Anarch"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/bar/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/barkeeper
	name = "Baron"
	icon_state = "Barkeeper"

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
	allowed_bloodlines = list("Daughters of Cacophony", "True Brujah", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Lasombra", "Gargoyle", "Kiasyd")

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

/datum/job/vamp/dealer
	title = "Dealer"
	department_head = list("Yourself")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "None. You are beholden only to yourself."
	selection_color = "#434343"
	exp_type_department = EXP_TYPE_SUPPLY // This is so the jobs menu can work properly

	outfit = /datum/outfit/job/dealer

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_DEALER
	bounty_types = CIV_JOB_RANDOM

//	minimal_generation = 12	//Uncomment when players get exp enough

	my_contact_is_important = TRUE
	known_contacts = list("Baron", "Prince", "Sheriff")
	allowed_bloodlines = list("True Brujah", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Ventrue", "Ministry", "Kiasyd")

	v_duty = "You provide supplies to other kindred. The warehouse is yours, and it's your business who you'll deal with."
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	experience_addition = 20

/datum/outfit/job/dealer
	name = "Dealer"
	jobtype = /datum/job/vamp/dealer

	id = /obj/item/card/id/dealer
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/brown
	glasses = /obj/item/clothing/glasses/vampire/sun
	l_pocket = /obj/item/vamp/phone/dealer
	r_pocket = /obj/item/vamp/keys/supply
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/dealer/pre_equip(mob/living/carbon/human/H)
	..()
	//H.vampire_faction = "Anarch"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels/red

/obj/effect/landmark/start/dealer
	name = "Dealer"
	icon_state = "Dealer"

/datum/job/vamp/supply
	title = "Supply Technician"
	department_head = list("Dealer")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Dealer"
	selection_color = "#434343"

	outfit = /datum/outfit/job/supply

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_MECH_MINING)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_SUPPLY
	bounty_types = CIV_JOB_RANDOM
	allowed_species = list("Vampire", "Ghoul", "Human")
	known_contacts = list("Baron", "Prince", "Sheriff")
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Brujah", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Tzimisce", "Caitiff", "Lasombra", "Gargoyle", "Kiasyd")

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
	l_pocket = /obj/item/vamp/phone/anarch
	r_pocket = /obj/item/vamp/keys/supply
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/supply/pre_equip(mob/living/carbon/human/H)
	..()
	//H.vampire_faction = "Anarch"

/obj/effect/landmark/start/supplytechnician
	name = "Supply Technician"
	icon_state = "Supply Technician"

//ASSISTANTS

/datum/job/vamp/citizen
	title = "Citizen"
	faction = "Vampire"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the Traditions"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/citizen
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_CITIZEN

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf")

	v_duty = "Follow the traditions of the Camarilla. Obey the Prince and their authority. The city belongs to him. Aligning yourself with your clan members would be of benefit."
	duty = "Obey the authorities... Or don't. You are up late tonight for one reason or another."
	minimal_masquerade = 0
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Old Clan Tzimisce", "Kiasyd")

/datum/outfit/job/citizen
	name = "Citizen"
	jobtype = /datum/job/vamp/citizen
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock

/datum/outfit/job/citizen/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = text2path(H.clane.male_clothes)
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = text2path(H.clane.female_clothes)
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
	if(H.clane)
		if(H.clane.name == "Lasombra")
			backpack_contents = list(/obj/item/passport =1, /obj/item/vamp/creditcard=1)
	if(!H.clane)
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.clane && H.clane.name != "Lasombra")
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/citizen
	name = "Citizen"
	icon_state = "Assistant"

/datum/job/vamp/strip
	title = "Stripper"
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Camarilla or the Anarchs"
	selection_color = "#df7058"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/strip
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	exp_type_department = EXP_TYPE_NEUTRALS

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_STRIP
	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf")

	v_duty = "Offer strip club services to humans or undead."
	duty = "Offer strip club services."
	minimal_masquerade = 3
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Kiasyd")
	experience_addition = 10

/datum/outfit/job/strip
	name = "Stripper"
	jobtype = /datum/job/vamp/citizen
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/strip
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/strip/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire/white
		uniform = /obj/item/clothing/under/vampire/pimp
	else
		shoes = /obj/item/clothing/shoes/vampire/heels
		uniform = /obj/item/clothing/under/vampire/whore

/obj/effect/landmark/start/strip
	name = "Strip"
	icon_state = "Assistant"

//ID

/obj/item/card/id/prince/AltClick(mob/user)
	return

/obj/item/card/id/sheriff/AltClick(mob/user)
	return

/obj/item/card/id/camarilla/AltClick(mob/user)
	return

/obj/item/card/id/clerk/AltClick(mob/user)
	return

/obj/item/card/id/anarch/AltClick(mob/user)
	return

/obj/item/card/id/clinic/AltClick(mob/user)
	return

/obj/item/card/id/archive/AltClick(mob/user)
	return

/obj/item/card/id/cleaning/AltClick(mob/user)
	return

/obj/item/card/id/dealer/AltClick(mob/user)
	return

/obj/item/card/id/supplytech/AltClick(mob/user)
	return

/obj/item/card/id/hunter/AltClick(mob/user)
	return

/obj/item/card/id/primogen/AltClick(mob/user)
	return

/obj/item/card/id/police/AltClick(mob/user)
	return

/obj/item/card/id/hunter
	var/last_detonated = 0

/obj/item/card/id/hunter/attack_self(mob/user)
	. = ..()
	if(last_detonated+300 > world.time)
		return
	if(!user.mind)
		return
	if(user.mind.holy_role != HOLY_ROLE_PRIEST)
		return
	last_detonated = world.time
	do_sparks(rand(5, 9), FALSE, user)
	playsound(user.loc, 'code/modules/wod13/sounds/cross.ogg', 100, FALSE, 8, 0.9)
	for(var/mob/living/M in get_hearers_in_view(4, user.loc))
		bang(get_turf(M), M, user)

/obj/item/card/id/hunter/proc/bang(turf/T, mob/living/M, var/mob/living/user)
	if(M.stat == DEAD)	//They're dead!
		return
	var/mob/living/carbon/human/H
	if(ishuman(M))
		H = M
	if(H)
		for(var/obj/item/card/id/hunter/HUNT in H.contents)
			if(HUNT)
				if(H.mind)
					if(H.mind.holy_role == HOLY_ROLE_PRIEST)
						return
		if(iskindred(H))
			if(H.clane)
				if(H.clane.name == "Baali")
					H.emote("scream")
					H.pointed(user)
	M.show_message("<span class='warning'><b>GOD SEES YOU!</b></span>", MSG_AUDIBLE)
	var/distance = max(0,get_dist(get_turf(src),T))

	if(M.flash_act(affect_silicon = 1))
		M.Immobilize(max(10/max(1,distance), 5))

/obj/item/card/id/hunter/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	if(last_detonated+300 > world.time)
		return
	if(iskindred(target))
		var/mob/living/carbon/human/H = target
		if(H.clane)
			if(H.clane.name == "Baali")
				last_detonated = world.time
				var/turf/lightning_source = get_step(get_step(H, NORTH), NORTH)
				lightning_source.Beam(H, icon_state="lightning[rand(1,12)]", time = 5)
				H.adjustFireLoss(100)
				H.electrocution_animation(50)
				to_chat(H, "<span class='userdanger'>The God has punished you for your sins!</span>", confidential = TRUE)

/obj/item/card/id/prince
	name = "leader badge"
	id_type_name = "leader badge"
	desc = "King in the castle!"
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id6"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id6"

/obj/item/card/id/sheriff
	name = "head security badge"
	id_type_name = "head security badge"
	desc = "A badge which shows honour and dedication."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id4"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id4"

/obj/item/card/id/camarilla
	name = "security badge"
	id_type_name = "security badge"
	desc = "A badge which shows honour and dedication."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id3"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id3"

/obj/item/card/id/clerk
	name = "clerk badge"
	id_type_name = "clerk badge"
	desc = "A badge which shows buerocracy qualification."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id1"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id1"

/obj/item/card/id/anarch
	name = "biker badge"
	id_type_name = "biker badge"
	desc = "A badge which shows protest and anarchy."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id5"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id5"

/obj/item/card/id/clinic
	name = "medical badge"
	id_type_name = "medical badge"
	desc = "A badge which shows medical qualification."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id2"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id2"

/obj/item/card/id/archive
	name = "librarian badge"
	id_type_name = "librarian badge"
	desc = "A badge which shows the love to books."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id7"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id7"

/obj/item/card/id/cleaning
	name = "janitor badge"
	id_type_name = "janitor badge"
	desc = "A badge which shows cleaning employment."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id8"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id8"

/obj/item/card/id/graveyard
	name = "keeper badge"
	id_type_name = "keeper badge"
	desc = "A badge which shows graveyard employment."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id8"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id8"

/obj/item/card/id/dealer
	name = "business badge"
	id_type_name = "business badge"
	desc = "A badge which shows business."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id9"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id9"

/obj/item/card/id/supplytech
	name = "technician badge"
	id_type_name = "technician badge"
	desc = "A badge which shows supply employment."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id10"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id10"

/obj/item/card/id/hunter
	name = "cross"
	id_type_name = "cross"
	desc = "When you come into the land that the Lord your God is giving you, you must not learn to imitate the abhorrent practices of those nations. No one shall be found among you who makes a son or daughter pass through fire, or who practices divination, or is a soothsayer, or an augur, or a sorcerer, or one who casts spells, or who consults ghosts or spirits, or who seeks oracles from the dead. For whoever does these things is abhorrent to the Lord; it is because of such abhorrent practices that the Lord your God is driving them out before you (Deuteronomy 18:9-12)."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id11"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id11"

/obj/item/card/id/primogen
	name = "mysterious primogen badge"
	id_type_name = "mysterious primogen badge"
	desc = "Sponsored by the Shadow Government."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id12"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id12"

/obj/item/card/id/police
	name = "law department badge"
	id_type_name = "law department badge"
	desc = "Sponsored by the Government."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id13"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id13"

/obj/item/card/id/voivode
	name = "ancient badge"
	id_type_name ="ancient badge"
	desc = "You have to wear this filthy thing to be recognized."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id12"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id12"

/obj/item/card/id/bogatyr
	name = "dusty badge"
	id_type_name ="dusty badge"
	desc = "You have to wear this because the Voivode wants you to."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id12"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id12"

/datum/outfit/job/caitiff
	name = "Caitiff"
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=1, /obj/item/vamp/keys/hack=1)

/datum/outfit/job/caitiff/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire
		if(H.clane)
			if(H.clane.male_clothes)
				uniform = text2path(H.clane.male_clothes)
	else
		shoes = /obj/item/clothing/shoes/vampire/heels
		if(H.clane)
			if(H.clane.female_clothes)
				uniform = text2path(H.clane.female_clothes)

/datum/outfit/job/caitiff/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/caitiff)

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

	var/my_name = "Tyler"
	if(H.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	H.fully_replace_character_name(null,"[my_name] [my_surname]")

/obj/effect/landmark/start/caitiff
	name = "Caitiff"
	delete_after_roundstart = FALSE

/datum/antagonist/caitiff
	name = "Caitiff"
	roundend_category = "caitiffs"
	antagpanel_category = "Caitiff"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "traitor"

/datum/antagonist/caitiff/on_gain()
	owner.special_role = src
	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = owner
	kill_objective.find_target()
	objectives += kill_objective
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/sad_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/caitiff/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the Caitiff!</span>")
	owner.special_role = null

/datum/antagonist/caitiff/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the Caitiff.</span>")
	owner.announce_objectives()

/datum/outfit/job/hunter
	name = "Hunter"
	uniform = /obj/item/clothing/under/vampire/graveyard
	r_pocket = /obj/item/flashlight
	id = /obj/item/card/id/hunter
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/keys/church
	backpack_contents = list(
		/obj/item/storage/book/bible = 1,
		/obj/item/vampire_stake = 3,
		/obj/item/molotov = 1,
		/obj/item/gas_can/full = 1,
		/obj/item/vamp/keys/hack=1
		)

/datum/outfit/job/hunter/post_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		qdel(H.clane)
	H.set_species(/datum/species/human)
	H.generation = 13
	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.health)-initial(H.health)/4)+(initial(H.health)/4)*(H.physique+13-H.generation))
	var/my_name = "Tyler"
	if(H.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	H.fully_replace_character_name(null,"[my_name] [my_surname]")
//	for(var/atom/movable/screen/blood/B in H.hud_used.infodisplay)
//		B.icon_state = null
//	for(var/atom/movable/screen/healths/HE in H.hud_used.infodisplay)
//		HE.icon = 'code/modules/wod13/ghoul_health.dmi'
//	for(var/atom/movable/screen/drinkblood/DB in H.hud_used.static_inventory)
//		DB.icon_state = null
//	for(var/atom/movable/screen/bloodheal/BH in H.hud_used.static_inventory)
//		BH.icon_state = null
//	for(var/atom/movable/screen/bloodpower/BP in H.hud_used.static_inventory)
//		BP.icon_state = null
//	for(var/atom/movable/screen/disciplines/DI in H.hud_used.static_inventory)
//		DI.icon_state = null
	for(var/datum/action/A in H.actions)
		if(A.vampiric)
			A.Remove(H)
	H.thaumaturgy_knowledge = FALSE
	QDEL_NULL(H.clane)
	var/obj/item/organ/eyes/NV = new()
	NV.Insert(H, TRUE, FALSE)
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/hunter)

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

	var/list/loadouts = list("Fire Fighter", "EOD Suit", "Holy Presence")
	spawn()
		var/loadout_type = input(H, "Choose the Lord's gift for you:", "Loadout") as anything in loadouts
		switch(loadout_type)
			if("Fire Master")
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vampire/helmet(H), ITEM_SLOT_HEAD)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/vest(H), ITEM_SLOT_OCLOTHING)
				H.put_in_r_hand(new /obj/item/vampire_flamethrower(H))
				H.put_in_l_hand(new /obj/item/melee/vampirearms/fireaxe(H))
			if("EOD Suit")
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/eod(H), ITEM_SLOT_OCLOTHING)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/vampire/eod(H), ITEM_SLOT_HEAD)
				H.put_in_r_hand(new /obj/item/gun/ballistic/shotgun/vampire(H))
				H.put_in_l_hand(new /obj/item/ammo_box/vampire/c12g(H))
			if("Holy Presence")
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/vampire/vest/army(H), ITEM_SLOT_OCLOTHING)
				H.put_in_r_hand(new /obj/item/melee/vampirearms/chainsaw(H))
				H.resistant_to_disciplines = TRUE
				to_chat(H, "<b>You are no longer vulnerable to vampire blood powers...</b>")

/obj/effect/landmark/start/hunter
	name = "Hunter"
	delete_after_roundstart = FALSE

/datum/antagonist/hunter
	name = "Hunter"
	roundend_category = "hunters"
	antagpanel_category = "Hunter"
	job_rank = ROLE_OPERATIVE
	antag_hud_type = ANTAG_HUD_OPS
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE

/datum/antagonist/hunter/on_gain()
	owner.holy_role = HOLY_ROLE_PRIEST
	add_antag_hud(ANTAG_HUD_OPS, "synd", owner.current)
	owner.special_role = src
	var/datum/objective/custom/custom_objective = new
	custom_objective.owner = owner
	custom_objective.explanation_text = "Exterminate all evil spirits in the city. Let the Hunt begin!"
	objectives += custom_objective
	var/datum/objective/martyr/die_objective = new
	die_objective.owner = owner
	objectives += die_objective
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/orthodox_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/hunter/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the Hunter!</span>")
	owner.special_role = null

/datum/antagonist/hunter/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the Hunter.</span>")
	owner.announce_objectives()

/datum/outfit/job/sabbatist
	name = "Sabbatist"
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	suit = /obj/item/clothing/suit/vampire/trench
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/vampire_stake=3, /obj/item/gun/ballistic/vampire/revolver=1, /obj/item/melee/vampirearms/knife=1, /obj/item/vamp/keys/hack=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/sabbatist/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Sabbat"
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire
		if(H.clane)
			if(H.clane.male_clothes)
				uniform = text2path(H.clane.male_clothes)
	else
		shoes = /obj/item/clothing/shoes/vampire/heels
		if(H.clane)
			if(H.clane.female_clothes)
				uniform = text2path(H.clane.female_clothes)

/datum/outfit/job/sabbatist/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist)
	GLOB.sabbatites += H

	var/my_name = "Tyler"
	if(H.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	H.fully_replace_character_name(null,"[my_name] [my_surname]")
//Commented out code for future sabbat character setup
/*
	H.generation = 13
	H.clane = null

	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.health)-initial(H.health)/4)+(initial(H.health)/4)*(H.physique+13-H.generation))
	H.thaumaturgy_knowledge = FALSE
	QDEL_NULL(H.clane)
	var/obj/item/organ/eyes/NV = new()
	NV.Insert(H, TRUE, FALSE)
	add_verb(H, /datum/job/sabbatist/verb/setup_character)
*/

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

//Commented out code for future sabbat character setup
/*
/datum/job/sabbatist/verb/setup_character()
	set category = "Sabbat"
	set name = "Set Up Character"
	set desc = "Prepare your character."
	var/list/clans = list("Tzimisce", "Lasombra", "Gangrel", "Brujah", "Toreador", "Ventrue")
	var/list/generations = list(8, 9, 10, 11, 12, 13)
	var/total_points = 10
	var/points_spent = 0

	var/clan_choice = input("Choose your clan:", "Clan Selection") in clans
	var/generation_choice = input("Choose your generation:", "Generation Selection") in generations

	var/discipline1
	var/discipline2
	var/discipline3
	switch(clan_choice)
		if("Tzimisce")
			discipline1 = "Animalism"
			discipline2 = "Auspex"
			discipline3 = "Vicissitude"
		if("Lasombra")
			discipline1 = "Dominate"
			discipline2 = "Obtenebration"
			discipline3 = "Potence"
		if("Gangrel")
			discipline1 = "Animalism"
			discipline2 = "Fortitude"
			discipline3 = "Protean"
		if("Brujah")
			discipline1 = "Celerity"
			discipline2 = "Potence"
			discipline3 = "Presence"
		if("Toreador")
			discipline1 = "Auspex"
			discipline2 = "Celerity"
			discipline3 = "Presence"
		if("Ventrue")
			discipline1 = "Dominate"
			discipline2 = "Fortitude"
			discipline3 = "Presence"
	var/discipline1_level = 0
	var/discipline2_level = 0
	var/discipline3_level = 0

	var/list/generation_costs = list(8 = 5, 9 = 4, 10 = 3, 11 = 2, 12 = 1, 13 = 0)
	generation_choice = 13

	while(points_spent < total_points)
		var/list/choices = list("Discipline 1: [discipline1] (Level: [discipline1_level])", "Discipline 2: [discipline2] (Level: [discipline2_level])", "Discipline 3: [discipline3] (Level: [discipline3_level])", "Finish")
		var/choice = input("Allocate your points. Points remaining: [total_points - points_spent]", "Discipline Allocation") in choices

		if(choice == "Finish")
			break

		if(choice == "Discipline 1: [discipline1] (Level: [discipline1_level])")
			if(points_spent < total_points)
				discipline1_level += 1
				points_spent += 1
		if(choice == "Discipline 2: [discipline2] (Level: [discipline2_level])")
			if(points_spent < total_points)
				discipline2_level += 1
				points_spent += 1
		if(choice == "Discipline 3: [discipline3] (Level: [discipline3_level])")
			if(points_spent < total_points)
				discipline3_level += 1
				points_spent += 1
		if(choice == "Choose Generation (Current: [generation_choice])")
			var/new_generation = input("Choose your generation:", "Generation Selection") in generation_costs
			var/cost = generation_costs[new_generation]
			if(points_spent + cost <= total_points)
				points_spent += cost
				generation_choice = new_generation

	H.skin_tone = get_vamp_skin_color(H.skin_tone)
	H.update_body()
	H.clane = new H.clane.type()
	H.clane.on_gain(H)
	if(H.clane.alt_sprite)
		H.skin_tone = "albino"
		H.update_body()
	H.create_disciplines(FALSE, discipline1, discipline2, discipline3)

//	H.discipline1 = discipline1_level
//	H.discipline2 = discipline2_level
//	H.discipline3 = discipline3_level

	H.generation = generation_choice
	H.maxbloodpool = 10+((13-min(13, H.generation))*3)
	H.clane.enlightenment = H.clane.enlightenment
	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))

	to_chat(H, "You have chosen [clan_choice] with generation [generation_choice]. Your disciplines are [discipline1] (Level: [discipline1_level]), [discipline2] (Level: [discipline2_level]) and [discipline3] (Level: [discipline3_level]).")
	remove_verb(H, /datum/job/sabbatist/verb/setup_character)

*/

/obj/effect/landmark/start/sabbatist
	name = "Sabbatist"
	delete_after_roundstart = FALSE

/datum/antagonist/sabbatist
	name = "Sabbatist"
	roundend_category = "sabbattites"
	antagpanel_category = "Sabbat"
	job_rank = ROLE_REV
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev"

/datum/antagonist/sabbatist/on_gain()
	add_antag_hud(ANTAG_HUD_REV, "rev", owner.current)
	owner.special_role = src
	var/datum/objective/custom/custom_objective = new
	custom_objective.owner = owner
	custom_objective.explanation_text = "Sow chaos, maim, butcher and kill. When you're done The Ivory Tower should be but a distant memory."
	objectives += custom_objective
	var/datum/objective/survive/survive_objective = new
	survive_objective.owner = owner
	objectives += survive_objective
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	return ..()

/datum/antagonist/sabbatist/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You are no longer the part of Sabbat!</span>")
	owner.special_role = null

/datum/antagonist/sabbatist/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the part of Sabbat.</span>")
	owner.announce_objectives()

/datum/job/vamp/giovannielder
	title = "Capo"
	department_head = list("Uncle Augie")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Family and the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/giovannielder

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_GIOVANNI
	exp_type_department = EXP_TYPE_INDEPENDENT

	minimal_generation = 11	//Uncomment when players get exp enough

	v_duty = "Pure blood runs through your veins and, with it, old power. Throughout your long life you have learnt to hold onto two things and never let go: money, and family."
	minimal_masquerade = 0
	experience_addition = 10
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Giovanni")

/datum/outfit/job/giovannielder
	name = "Capo"
	jobtype = /datum/job/vamp/giovannielder

	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/giovanniboss=1)

/datum/outfit/job/giovannielder/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Giovanni"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/giovannielder
	name = "Capo"

/datum/job/vamp/giovanni
	title = "La Squadra"
	department_head = list("Capo")
	faction = "Vampire"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Family and the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/giovanni

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_GIOVANNI
	exp_type_department = EXP_TYPE_INDEPENDENT

	v_duty = "Whether born or Embraced into the family, you are one of the Giovanni. Be you a necromancer, financier or lowly fledgling, remember that so long as you stand with your family, they too will stand with you."
	minimal_masquerade = 0
	experience_addition = 10
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Giovanni")

/datum/outfit/job/giovanni
	name = "La Squadra"
	jobtype = /datum/job/vamp/giovanni

	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/giovanni/pre_equip(mob/living/carbon/human/H)
	..()
	H.vampire_faction = "Giovanni"
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/giovanni
	name = "La Squadra"

/datum/job/vamp/giovannimafia
	title = "La Famiglia"
	department_head = list("Capo")
	faction = "Vampire"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Family"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/giovannimafia

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_GIOVANNI
	exp_type_department = EXP_TYPE_INDEPENDENT

//	minimal_generation = 11	//Uncomment when players get exp enough

	allowed_species = list("Ghoul", "Human")
	duty = "Your family is a strange one. Maybe you are strange too, because sitting next to your great uncles as an equal is something you are greatly interested in."
	minimal_masquerade = 0
	experience_addition = 10


/datum/outfit/job/giovannimafia
	name = "La Famiglia"
	jobtype = /datum/job/vamp/giovannimafia
	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/giovannimafia/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/giovannimafia
	name = "La Famiglia"

/datum/job/vamp/taxi
	title = "Taxi Driver"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = " the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/taxi

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TAXI
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf")

	v_duty = "Drive people in the city."
	duty = "Drive people in the city."
	minimal_masquerade = 0
	experience_addition = 10
	allowed_bloodlines = list("Daughters of Cacaphony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Kiasyd")

/datum/job/vamp/taxi/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	..()
	H.taxist = TRUE

/datum/outfit/job/taxi
	name = "Taxi Driver"
	jobtype = /datum/job/vamp/taxi

	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/taxi
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/taxi/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = text2path(H.clane.male_clothes)
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = text2path(H.clane.female_clothes)
	else
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			uniform = /obj/item/clothing/under/vampire/sport
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			uniform = /obj/item/clothing/under/vampire/red

/obj/effect/landmark/start/taxi
	name = "Taxi Driver"

/datum/antagonist/ambitious
	name = "Ambitious"
	roundend_category = "ambitious"
	antagpanel_category = "Ambitious"
	job_rank = ROLE_SYNDICATE
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = FALSE

/datum/antagonist/ambitious/on_gain()
	owner.special_role = src
	var/objectve = rand(1, 4)
	switch(objectve)
		if(1)
			var/list/ambitious = list()
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(H.stat != DEAD && H.true_real_name != owner.current.true_real_name && H.vampire_faction != "Sabbat")
					ambitious += H
			if(length(ambitious))
				var/datum/objective/blood/blood_objective = new
				blood_objective.owner = owner
				var/mob/living/carbon/human/HU = pick(ambitious)
				blood_objective.owner = owner
				blood_objective.target_name = HU.true_real_name
				objectives += blood_objective
				blood_objective.update_explanation_text()
			else
				var/datum/objective/money/money_objective = new
				money_objective.owner = owner
				money_objective.amount = rand(500, 5000)
				objectives += money_objective
				money_objective.update_explanation_text()
		if(2)
			var/datum/objective/money/money_objective = new
			money_objective.owner = owner
			money_objective.amount = rand(300, 1000)
			objectives += money_objective
			money_objective.update_explanation_text()
		if(3)
			var/list/ambitious = list()
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(H.stat != DEAD && H.true_real_name != owner.current.true_real_name && H.vampire_faction != "Sabbat")
					ambitious += H
			if(length(ambitious))
				var/datum/objective/protect_niga/protect_objective = new
				protect_objective.owner = owner
				var/mob/living/carbon/human/HU = pick(ambitious)
				protect_objective.mine_target = HU
				objectives += protect_objective
				protect_objective.update_explanation_text()
			else
				var/datum/objective/money/money_objective = new
				money_objective.owner = owner
				money_objective.amount = rand(300, 1000)
				objectives += money_objective
				money_objective.update_explanation_text()
		if(4)
			var/list/available_factions = list("Camarilla", "Anarch", "Sabbat")
			if(ishuman(owner))
				var/mob/living/carbon/human/H = owner
				if(H.vampire_faction == "Camarilla" || H.vampire_faction == "Anarch" || H.vampire_faction == "Sabbat")
					available_factions -= H.vampire_faction
			var/datum/objective/become_member/member_objective = new
			member_objective.owner = owner
			member_objective.faction = pick(available_factions)
			objectives += member_objective
			member_objective.update_explanation_text()
	return ..()

/datum/antagonist/ambitious/on_removal()
	..()
	to_chat(owner.current,"<span class='userdanger'>You don't have ambitions anymore.</span>")
	owner.special_role = null

/datum/antagonist/ambitious/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You got some goals that night.</span>")
	owner.announce_objectives()

/datum/job/vamp/primogen_malkavian
	title = "Primogen Malkavian"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/malkav

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_MALKAVIAN
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Malkavian")
	minimal_generation = 7	//Uncomment when players get exp enough

	v_duty = "Offer your infinite knowledge to Prince of the City."
	experience_addition = 20
	minimal_masquerade = 5
	my_contact_is_important = TRUE
	known_contacts = list("Prince")

/datum/outfit/job/malkav
	name = "Primogen Malkavian"
	jobtype = /datum/job/vamp/primogen_malkavian

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/primogen_malkavian
	suit = /obj/item/clothing/suit/vampire/trench/malkav
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	head = /obj/item/clothing/head/vampire/malkav
	l_pocket = /obj/item/vamp/phone/malkavian
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/malkav/primogen=1, /obj/item/vamp/keys/clinic, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1)

/datum/outfit/job/malkav/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		suit = null
		head = null
		uniform = /obj/item/clothing/under/vampire/primogen_malkavian/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/job/vamp/primogen_nosferatu
	title = "Primogen Nosferatu"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/nosferatu

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_NOSFERATU
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Nosferatu")
	minimal_generation = 7	//Uncomment when players get exp enough

	v_duty = "Offer your infinite knowledge to Prince of the City."
	experience_addition = 20
	minimal_masquerade = 5
	my_contact_is_important = TRUE
	known_contacts = list("Prince")

/datum/outfit/job/nosferatu
	name = "Primogen Nosferatu"
	jobtype = /datum/job/vamp/primogen_nosferatu

	id = /obj/item/card/id/primogen
	mask = /obj/item/clothing/mask/vampire/shemagh
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/nosferatu
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/nosferatu/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1)

/datum/outfit/job/nosferatu/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/job/vamp/primogen_ventrue
	title = "Primogen Ventrue"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/ventrue

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_VENTRUE
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Ventrue")
	minimal_generation = 7	//Uncomment when players get exp enough

	v_duty = "Offer your infinite knowledge to Prince of the City."
	experience_addition = 20
	minimal_masquerade = 5
	my_contact_is_important = TRUE
	known_contacts = list("Prince")

/datum/outfit/job/ventrue
	name = "Primogen Ventrue"
	jobtype = /datum/job/vamp/primogen_ventrue

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/ventrue
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/ventrue/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1)

/datum/outfit/job/ventrue/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/job/vamp/primogen_toreador
	title = "Primogen Toreador"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/toreador

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TOREADOR
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Toreador")
	minimal_generation = 7	//Uncomment when players get exp enough

	v_duty = "Offer your infinite knowledge to Prince of the City."
	experience_addition = 20
	minimal_masquerade = 5
	my_contact_is_important = TRUE
	known_contacts = list("Prince")

/datum/outfit/job/toreador
	name = "Primogen Toreador"
	jobtype = /datum/job/vamp/primogen_toreador

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/primogen_toreador
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/toreador
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/toreador/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1)

/datum/outfit/job/toreador/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/primogen_toreador/female
		shoes = /obj/item/clothing/shoes/vampire/heels/red


/datum/job/vamp/primogen_brujah
	title = "Primogen Brujah"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#cb4aad"

	outfit = /datum/outfit/job/brujah

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BRUJAH
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Brujah")
	minimal_generation = 7	//Uncomment when players get exp enough

	v_duty = "Offer your infinite knowledge to Prince of the City."
	experience_addition = 20
	minimal_masquerade = 5
	my_contact_is_important = TRUE
	known_contacts = list("Prince")

/datum/outfit/job/brujah
	name = "Primogen Brujah"
	jobtype = /datum/job/vamp/primogen_brujah

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/punk
	suit = /obj/item/clothing/suit/vampire/jacket/punk
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone/brujah
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/brujah/primogen=1, /obj/item/melee/vampirearms/eguitar=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1)

//HUMANS

/datum/job/vamp/police_officer
	title = "Police Officer"
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 5
	spawn_positions = 5
	supervisors = " the SFPD"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_officer

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Ghoul", "Human")
	species_slots = list("Ghoul" = 1)

	duty = "Enforce the Law."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
//	known_contacts = list("Investigator")

/datum/outfit/job/police_officer
	name = "Police Officer"
	jobtype = /datum/job/vamp/police_officer

	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest
	belt = /obj/item/storage/belt/holster/detective/vampire/police
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/police
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/radio/cop
	l_hand = /obj/item/vamp/keys/police
	r_hand = /obj/item/police_radio
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm = 1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1,/obj/item/vamp/keys/police = 1)


/datum/job/vamp/fbi
	title = "Federal Investigator"
	department_head = list("Federal Bureau of Investigation")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = " the FBI"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/fbi

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_FBI
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Human")
	minimal_generation = 13

	duty = "Enforce the Law."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
//	known_contacts = list("Investigator")

/datum/outfit/job/fbi
	name = "Federal Investigator"
	jobtype = /datum/job/vamp/fbi

	uniform = /obj/item/clothing/under/vampire/office
	shoes = /obj/item/clothing/shoes/vampire
	suit = /obj/item/clothing/suit/vampire/jacket/fbi
//	belt = /obj/item/melee/classic_baton
	id = /obj/item/card/id/police
	gloves = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/radio/cop
	l_hand = /obj/item/vamp/keys/police
	r_hand = /obj/item/police_radio
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/gun/ballistic/automatic/vampire/m1911=1, /obj/item/camera/detective=1, /obj/item/camera_film=1, /obj/item/taperecorder=1, /obj/item/tape=1, /obj/item/vamp/creditcard=1)

/datum/job/vamp/priest
	title = "Priest"
	department_head = list("Bishop")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "God"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/priest

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_FBI
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Human")
	minimal_generation = 13

	duty = "Be the shepherd of the flock in San Francisco, lead them to salvation, piety and righteousness."
	v_duty = "The mortals believe you to be their savior. The kindred look at you with suspicion. Yours is the charge of this church."
	minimal_masquerade = 0
	my_contact_is_important = FALSE

/datum/outfit/job/priest
	name = "Priest"
	jobtype = /datum/job/vamp/priest

	uniform = /obj/item/clothing/under/vampire/graveyard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/id/hunter
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/church
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/priest/pre_equip(mob/living/carbon/human/H)
	..()
	add_verb(H, /datum/job/vampire/priest/verb/choose_special)

/datum/job/vampire/priest/verb/choose_special()
	set category = "Priest"
	set name = "Choose Special"
	set desc = "Select Priest special ability."
	var/list/loadouts = list("Numina", "True Faith")
	spawn()
		var/mob/living/carbon/human/H = src
		if(is_species(H, /datum/species/human))
			if(H.client)
				var/loadout_type = input(H, "Choose what makes you special:", "Loadout") as anything in loadouts
				remove_verb(H, /datum/job/vampire/priest/verb/choose_special)
				switch(loadout_type)
					if("Numina")
						to_chat(H, "<span class='alertsyndie'>You have been blessed with psychic powers. They make you extraordinary among mortals, yet you still fear the horrors lurking unknown.</span>")
						var/obj/effect/proc_holder/spell/targeted/numina_freeze/n_freeze = new(H)
						var/obj/effect/proc_holder/spell/self/numina_heal/n_heal = new(H)
						H.mind.AddSpell(n_freeze)
						H.mind.AddSpell(n_heal)
					if("True Faith")
						H.mind.holy_role = HOLY_ROLE_PRIEST
						H.resistant_to_disciplines = TRUE
						to_chat(H, "<span class='alertsyndie'>Your faith in God is made of iron. None could shake it, and even in the darkest moments it holds you up.</span>")

/obj/effect/landmark/start/priest
	name = "Priest"

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
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Human", "Werewolf")
	minimal_generation = 13

	duty = "Make money, do drugs, fight law. Your hideout is the laundromat in Chinatown."
	experience_addition = 10
	minimal_masquerade = 0
	my_contact_is_important = FALSE

/datum/outfit/job/triad_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/chinese)
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
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/clothing/mask/vampire/balaclava =1, /obj/item/gun/ballistic/automatic/vampire/glock19, /obj/item/melee/vampirearms/knife)

//TZIMISCE ROLES
/datum/job/vamp/voivode
	title = "Voivode"
	department_head = list("Eldest")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Laws of Hospitality"
	selection_color = "#953d2d"

	outfit = /datum/outfit/job/voivode

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_VOIVODE
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Old Clan Tzimisce")
	minimal_generation = 7

	v_duty = "You are a Childe of the Voivode-in-Waiting, the ancient Tzimisce Elder who has rested beneath the Earth for an age longer than the city that now rests on their bones. Honor them in all your actions, and remember that you walk with their favor."
	experience_addition = 20
	minimal_masquerade = 2
	my_contact_is_important = TRUE
	known_contacts = list("Prince", "Baron", "Sheriff")



/datum/outfit/job/voivode
	name = "Voivode"
	jobtype = /datum/job/vamp/voivode
	id = /obj/item/card/id/voivode
	//glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/voivode
	suit = /obj/item/clothing/suit/vampire/trench/voivode
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone
	//r_pocket =
	backpack_contents = list(/obj/item/vamp/keys/old_clan_tzimisce=1, /obj/item/melee/vampirearms/eguitar=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1)

/datum/job/vamp/bogatyr
	title = "Bogatyr"
	department_head = list("Voivode")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = " the Laws of Hospitality"
	selection_color = "#953d2d"

	outfit = /datum/outfit/job/bogatyr

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BOGATYR
	exp_type_department = EXP_TYPE_INDEPENDENT

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Old Clan Tzimisce")
	minimal_generation = 13	//Uncomment when players get exp enough

	v_duty = "Whether you are of Voivode-in-Waiting's blood or if you've been honored, you are one of the Kin of the Voivode. Protect your Family, as your Family would protect you."
	experience_addition = 15
	minimal_masquerade = 2
	my_contact_is_important = TRUE
	known_contacts = list("Prince", "Baron", "Sheriff")

/datum/outfit/job/bogatyr/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/bogatyr/female
		shoes = /obj/item/clothing/shoes/vampire/heels


/datum/outfit/job/bogatyr
	name = "Bogatyr"
	jobtype = /datum/job/vamp/bogatyr
	id = /obj/item/card/id/bogatyr
	//glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/bogatyr
	//suit = /obj/item/clothing/suit/vampire/jacket/punk
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone
	//r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/old_clan_tzimisce=1, /obj/item/melee/vampirearms/fireaxe=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/job/vamp/zadruga
	title = "Zadruga"
	department_head = list("Voivode")
	faction = "Ghoul" //[Lucifernix] - Change this to vampire when I actually fix this.
	total_positions = 2
	spawn_positions = 2
	supervisors = " the Laws of Hospitality"
	selection_color = "#953d2d"

	outfit = /datum/outfit/job/zadruga

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_ZADRUGA
	exp_type_department = EXP_TYPE_INDEPENDENT

	//ghoul_only = TRUE
	//allowed_bloodlines = list("Old Clan Tzimisce", "Tzimisce")
	//minimal_generation = 7	//Uncomment when players get exp enough

	duty = "You were born in servitude to the Master of the Manor: your father served the Voivode, as did his father. Now, you carry their blood, and with it their responsibilities."
	experience_addition = 20
	minimal_masquerade = 2
	my_contact_is_important = FALSE
	known_contacts = list("Prince", "Baron", "Sheriff")




/datum/outfit/job/zadruga
	name = "zadruga"
	jobtype = /datum/job/vamp/zadruga
	id = /obj/item/card/id/bogatyr
	//glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/bogatyr
	//suit = /obj/item/clothing/suit/vampire/jacket/punk
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone
	//r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/old_clan_tzimisce=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/voivode
	name = "Voivode"

/obj/effect/landmark/start/bogatyr
	name = "Bogatyr"

/obj/effect/landmark/start/zadruga
	name = "Zadruga"
