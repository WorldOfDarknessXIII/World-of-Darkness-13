
/datum/job/vamp/salubri
	title = "Veterinarian"
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Traditions"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/salubri
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_CITIZEN

	allowed_species = list("Vampire")

	v_duty = "Follow the traditions of the Camarilla. Obey the Prince and their authority. The city belongs to him. Aligning yourself with your clan members would be of benefit."
	duty = "One of the few Healer Salubri left within the city, maybe even in the city! You operate the Vet for any diseased or sick animals. You may have been an escaped member of The Seven or not. Regardless, you must hide and lay low."
	minimal_masquerade = 0
	allowed_bloodlines = list("Salubri")

/datum/outfit/job/salubri
	name = "salubri"
	jobtype = /datum/job/vamp/salubri
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock

/datum/outfit/job/salubri/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/salubri
	name = "salubri"
	icon_state = "Assistant"
