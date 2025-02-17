
/datum/job/vamp/clinic/vdoctor
	title = JOB_DOCTOR
	department_head = list("Clinic Director")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Camarilla or the Anarchs"
	selection_color = "#80D0F4"
	exp_type_department = EXP_TYPE_CLINIC


	outfit = /datum/outfit/job/vdoctor

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf", "Kuei-Jin")
	display_order = JOB_DISPLAY_ORDER_DOCTOR
	bounty_types = CIV_JOB_MED

	v_duty = "Help your fellow kindred in all matters medicine related. Sell blood. Keep your human colleagues ignorant."
	duty = "Collect blood by helping mortals at the Clinic."
	experience_addition = 15
	allowed_bloodlines = list("Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Kiasyd")
	known_contacts = list("Clinic Director")

AddTimelock(/datum/job/vamp/clinic/vdoctor, list(
	JOB_LIVING_ROLES = 2 HOURS,
))

/datum/outfit/job/vdoctor
	name = "Doctor"
	jobtype = /datum/job/vamp/clinic/vdoctor

	ears = /obj/item/p25radio
	id = /obj/item/card/id/clinic
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/clinic
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/storage/firstaid/medical=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/quickcarry)

/obj/effect/landmark/start/vdoctor
	name = "Doctor"
	icon_state = "Doctor"


/datum/job/vamp/clinic/vdirector
	title = "Clinic Director"
	department_head = list("Seneschal")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Camarilla or the Anarchs"
	selection_color = "#80D0F4"
	exp_type_department = EXP_TYPE_CLINIC


	outfit = /datum/outfit/job/vdirector

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf")
	display_order = JOB_DISPLAY_ORDER_CLINICS_DIRECTOR
	bounty_types = CIV_JOB_MED

	v_duty = "Keep Saint John's clinic up and running. Sell blood. Keep your human colleagues ignorant."
	duty = "Keep Saint John's clinic up and running. Collect blood by helping mortals at the Clinic."
	experience_addition = 15
	allowed_bloodlines = list("Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Kiasyd")

AddTimelock(/datum/job/vamp/clinic/vdirector, list(
	JOB_LIVING_ROLES = 2 HOURS,
	JOB_CLINIC_ROLES = 10 HOURS,
))

/datum/outfit/job/vdirector
	name = JOB_CLINIC_DIRECTOR
	jobtype = /datum/job/vamp/clinic/vdirector

	ears = /obj/item/p25radio
	id = /obj/item/card/id/clinic/director
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat/director
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/clinics_director
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/storage/firstaid/medical=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/quickcarry)

/obj/effect/landmark/start/vdirector
	name = "Director"
	icon_state = "Doctor"
