
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
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Old Clan Tzimisce", "Kiasyd", "Cappadocian")

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
