
/datum/job/vamp/police_officer
	title = "Police Officer"
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 5
	spawn_positions = 5
	supervisors = " the SFPD Chief and your Sergeant."

	outfit = /datum/outfit/job/police_officer

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_granted_type = EXP_TYPE_POLICE

	allowed_species = list("Ghoul", "Human")
	species_slots = list("Ghoul" = 1)

	duty = "Enforce the Law."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
	known_contacts = list("Police Chief")

/datum/outfit/job/police_officer
	name = "Police Officer"
	jobtype = /datum/job/vamp/police_officer

	ears = /obj/item/p25radio/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police
	belt = /obj/item/storage/belt/holster/detective/vampire/police
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/police
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm = 1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1, /obj/item/storage/medkit/ifak = 1)

/datum/job/vamp/police_sergeant
	title = "Police Sergeant"
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = " the SFPD Chief"

	outfit = /datum/outfit/job/police_sergeant

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE_SERGEANT
	exp_granted_type = EXP_TYPE_POLICE

	allowed_species = list("Human")

	duty = "Enforce the law. Keep the officers in line. Follow what the Chief says."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
	known_contacts = list("Police Chief")

/datum/outfit/job/police_sergeant
	name = "Police Sergeant"
	jobtype = /datum/job/vamp/police_sergeant

	ears = /obj/item/p25radio/police/supervisor
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/sergeant
	belt = /obj/item/storage/belt/holster/detective/vampire/officer
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/police/sergeant
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police/secure
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm = 1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1, /obj/item/storage/medkit/ifak = 1)

/datum/job/vamp/police_chief
	title = "Police Chief"
	department_head = list("Police Department")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the SFPD"

	outfit = /datum/outfit/job/police_chief

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_POLICE_CHIEF
	exp_granted_type = EXP_TYPE_POLICE

	allowed_species = list("Human")

	duty = "Underpaid, overworked, and understrength. Do your best to keep the order in San Francisco. Keep the officers in line."
	minimal_masquerade = 0
	my_contact_is_important = FALSE
//	known_contacts = list("Investigator")

/datum/outfit/job/police_chief
	name = "Police Chief"
	jobtype = /datum/job/vamp/police_chief

	ears = /obj/item/p25radio/police/command
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/chief
	belt = /obj/item/storage/belt/holster/detective/vampire/officer
	gloves = /obj/item/cockclock
	id = /obj/item/card/id/police/chief
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/police/secure/chief
	backpack_contents = list(/obj/item/passport=1, /obj/item/implant/radio=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm = 1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1, /obj/item/storage/medkit/ifak = 1)

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
