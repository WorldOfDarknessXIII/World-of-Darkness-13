
/datum/job/vamp/police_force/police_officer
	title = JOB_POLICE_OFFICER
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 5
	spawn_positions = 5
	supervisors = " the SFPD Chief and your Sergeant."
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_officer

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_ARMORY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_type_department = EXP_TYPE_POLICE

	allowed_species = list("Ghoul", "Human")
	species_slots = list("Ghoul" = 1)

	duty = "Enforce the Law."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
	known_contacts = list("Police Chief")

AddTimelock(/datum/job/vamp/police_force/police_officer, list(
	JOB_LIVING_ROLES = 2 HOURS,
))

/datum/outfit/job/police_officer
	name = "Police Officer"
	jobtype = /datum/job/vamp/police_force/police_officer

	ears = /obj/item/p25radio/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police
	belt = /obj/item/storage/belt/holster/detective/vampire/police
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/police
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm = 1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1, /obj/item/storage/firstaid/ifak = 1)

/datum/job/vamp/police_force/police_sergeant
	title = JOB_POLICE_SERGEANT
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = " the SFPD Chief"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_sergeant

	access = list(ACCESS_HYDROPONICS, ACCESS_ARMORY, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE_SERGEANT
	exp_type_department = EXP_TYPE_POLICE

	allowed_species = list("Human")

	duty = "Enforce the law. Keep the officers in line. Follow what the Chief says."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
	known_contacts = list("Police Chief")

AddTimelock(/datum/job/vamp/police_force/police_sergeant, list(
	JOB_POLICE_ROLES = 5 HOURS,
	JOB_LIVING_ROLES = 2 HOURS,
))

/datum/outfit/job/police_sergeant
	name = "Police Sergeant"
	jobtype = /datum/job/vamp/police_force/police_sergeant

	ears = /obj/item/p25radio/police/supervisor
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/sergeant
	belt = /obj/item/storage/belt/holster/detective/vampire/officer
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/police/sergeant
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police/secure
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm = 1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1, /obj/item/storage/firstaid/ifak = 1)

/datum/job/vamp/police_force/police_chief
	title = JOB_POLICE_CHIEF
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the SFPD"
	selection_color = "#7e7e7e"

	outfit = /datum/outfit/job/police_chief

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_ARMORY, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE_CHIEF
	exp_type_department = EXP_TYPE_POLICE

	allowed_species = list("Human")

	duty = "Underpaid, overworked, and understrength. Do your best to keep the order in San Francisco. Keep the officers in line."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
//	known_contacts = list("Investigator")

AddTimelock(/datum/job/vamp/police_force/police_chief, list(
	JOB_POLICE_ROLES = 10 HOURS,
	JOB_LIVING_ROLES = 2 HOURS,
))

/datum/outfit/job/police_chief
	name = "Police Chief"
	jobtype = /datum/job/vamp/police_force/police_chief

	ears = /obj/item/p25radio/police/command
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/chief
	belt = /obj/item/storage/belt/holster/detective/vampire/officer
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/police/chief
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police/secure/chief
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm = 1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1, /obj/item/storage/firstaid/ifak = 1)

/datum/outfit/job/police_officer/post_equip(mob/living/carbon/human/H)
	..()
	H.ignores_warrant = TRUE

/datum/outfit/job/police_chief/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/martial_art/martial_art = new /datum/martial_art/cqc
	H.ignores_warrant = TRUE
	martial_art.teach(H)

/datum/outfit/job/police_sergeant/post_equip(mob/living/carbon/human/H)
	..()
	H.ignores_warrant = TRUE
