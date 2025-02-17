
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
	exp_type_department = EXP_TYPE_TZIMISCE

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
	head = /obj/item/clothing/head/vampire/bogatyr
	suit = /obj/item/clothing/suit/vampire/bogatyr
	belt = /obj/item/storage/belt/vampire/sheathe/longsword
	l_pocket = /obj/item/vamp/phone
	//r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/old_clan_tzimisce=1, /obj/item/melee/vampirearms/fireaxe=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/bogatyr
	name = "Bogatyr"
