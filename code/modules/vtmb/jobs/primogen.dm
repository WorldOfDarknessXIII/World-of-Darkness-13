/datum/job/vamp/primogen_malkavian
	title = "Primogen Malkavian"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"

	outfit = /datum/outfit/job/malkav

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_MALKAVIAN
	exp_granted_type = EXP_TYPE_COUNCIL

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

	ears = /obj/item/p25radio
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

	outfit = /datum/outfit/job/nosferatu

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_NOSFERATU
	exp_granted_type = EXP_TYPE_COUNCIL

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

	outfit = /datum/outfit/job/ventrue

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_VENTRUE
	exp_granted_type = EXP_TYPE_COUNCIL

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

	outfit = /datum/outfit/job/toreador

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TOREADOR
	exp_granted_type = EXP_TYPE_COUNCIL

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

	outfit = /datum/outfit/job/brujah

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BRUJAH
	exp_granted_type = EXP_TYPE_COUNCIL

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
