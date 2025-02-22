
/datum/job/vamp/priest
	title = "Priest"
	department_head = list("Bishop")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "God"

	outfit = /datum/outfit/job/priest

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_PRIEST
	exp_granted_type = EXP_TYPE_CHURCH

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
						var/datum/action/cooldown/spell/pointed/numina_freeze/n_freeze = new(H)
						var/datum/action/cooldown/spell/numina_heal/n_heal = new(H)
						n_freeze.Grant(H)
						n_heal.Grant(H)

					if("True Faith")
						H.mind.holy_role = HOLY_ROLE_PRIEST
						H.resistant_to_disciplines = TRUE
						to_chat(H, "<span class='alertsyndie'>Your faith in God is made of iron. None could shake it, and even in the darkest moments it holds you up.</span>")

/obj/effect/landmark/start/priest
	name = "Priest"
