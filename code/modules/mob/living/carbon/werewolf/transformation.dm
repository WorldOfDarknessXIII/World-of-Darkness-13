/obj/werewolf_holder/transformation
	var/mob/living/carbon/human/human_form
	var/mob/living/carbon/werewolf/crinos/crinos_form
	var/mob/living/carbon/werewolf/lupus/lupus_form

	var/transformating = FALSE
	var/given_quirks = FALSE

/obj/werewolf_holder/transformation/Initialize()
	. = ..()
	crinos_form = new()
	crinos_form.transformator = src
//	crinos_form.forceMove(src)
	lupus_form = new()
	lupus_form.transformator = src
//	lupus_form.forceMove(src)

/obj/werewolf_holder/transformation/proc/transfer_damage(mob/living/carbon/first, mob/living/carbon/second)
	second.masquerade = first.masquerade
	var/percentage = (100/first.maxHealth)*second.maxHealth
	second.adjustBruteLoss(round((first.getBruteLoss()/100)*percentage)-second.getBruteLoss())
	second.adjustFireLoss(round((first.getFireLoss()/100)*percentage)-second.getFireLoss())
	second.adjustToxLoss(round((first.getToxLoss()/100)*percentage)-second.getToxLoss())
	second.adjustCloneLoss(round((first.getCloneLoss()/100)*percentage)-second.getCloneLoss())

/obj/werewolf_holder/transformation/proc/trans_gender(mob/living/carbon/trans, form)
	if(!given_quirks)
		given_quirks = TRUE/*
		if(HAS_TRAIT(trans, TRAIT_ACROBATIC))
			var/datum/action/acrobate/DA = new()
			DA.Grant(lupus_form)
			var/datum/action/acrobate/NE = new()
			NE.Grant(crinos_form)
			*/
		if(HAS_TRAIT(trans, TRAIT_DANCER))
			var/datum/action/dance/DA = new()
			DA.Grant(lupus_form)
			var/datum/action/dance/NE = new()
			NE.Grant(crinos_form)
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	if(trans.auspice.rage == 0 && form != trans.auspice.base_breed)
		to_chat(trans, "Not enough rage to transform into anything but [trans.auspice.base_breed].")
		return
	if(trans.in_frenzy)
		to_chat(trans, "You can't transform while in frenzy.")
		return
	trans.inspired = FALSE
	if(ishuman(trans))
		var/datum/species/garou/G = trans.dna.species
		var/mob/living/carbon/human/H = trans
		if(G.glabro)
			H.remove_overlay(PROTEAN_LAYER)
			H.attributes.strength_bonus -= 2
			H.attributes.stamina_bonus -= 2
			H.attributes.dexterity_bonus -= 2
			var/matrix/M = matrix()
			M.Scale(1)
			H.transform = M
			G.glabro = FALSE
			H.update_icons()
	switch(form)
		if("Lupus")
			if(iscrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(ishuman(trans))
				ntransform.Scale(1, 0.75)
		if("Crinos")
			if(islupus(trans))
				ntransform.Scale(1.75, 1.75)
			if(ishuman(trans))
				ntransform.Scale(1.25, 1.5)
		if("Homid")
			if(iscrinos(trans))
				ntransform.Scale(0.75, 0.5)
			if(islupus(trans))
				ntransform.Scale(1, 1.5)
	if(!transformating)
		transformating = TRUE
		switch(form)
			if("Lupus")
				if(trans == lupus_form)
					transformating = FALSE
					return
				animate(trans, transform = ntransform, color = "#000000", time = 30)
				playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
				for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
					if(B)
						qdel(B)
				spawn(30)
					if(trans.stat == DEAD || !trans.client) // [ChillRaccoon] - preventing non-player transform issues
						animate(trans, transform = null, color = "#FFFFFF")
						return
					var/items = trans.get_contents()
					for(var/obj/item/item_worn in items)
						if(item_worn)
							if(!ismob(item_worn.loc))
								continue
							trans.dropItemToGround(item_worn, TRUE)
					var/current_loc = get_turf(trans)
					lupus_form.color = "#000000"
					lupus_form.forceMove(current_loc)
					animate(lupus_form, color = "#FFFFFF", time = 10)
					lupus_form.key = trans.key
					forceMove(lupus_form)
					lupus_form.bloodpool = trans.bloodpool
					lupus_form.masquerade = trans.masquerade
					lupus_form.nutrition = trans.nutrition
					lupus_form.mind = trans.mind
					lupus_form.update_blood_hud()
					transfer_damage(trans, lupus_form)
					lupus_form.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)
					trans.forceMove(src)
					transformating = FALSE
					animate(trans, transform = null, color = "#FFFFFF", time = 1)
					lupus_form.update_icons()
//					if(lupus_form.auspice.base_breed != "Lupus")
//						adjust_rage(-1, lupus_form)
			if("Crinos")
				if(trans == crinos_form)
					transformating = FALSE
					return
				animate(trans, transform = ntransform, color = "#000000", time = 30)
				playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
				for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
					if(B)
						qdel(B)
				spawn(30)
					if(trans.stat == DEAD || !trans.client) // [ChillRaccoon] - preventing non-player transform issues
						animate(trans, transform = null, color = "#FFFFFF")
						return
					var/items = trans.get_contents()
					for(var/obj/item/item_worn in items)
						if(item_worn)
							if(!ismob(item_worn.loc))
								continue
							trans.dropItemToGround(item_worn, TRUE)
					var/current_loc = get_turf(trans)
					crinos_form.color = "#000000"
					crinos_form.forceMove(current_loc)
					animate(crinos_form, color = "#FFFFFF", time = 10)
					crinos_form.key = trans.key
					forceMove(crinos_form)
					crinos_form.bloodpool = trans.bloodpool
					crinos_form.masquerade = trans.masquerade
					crinos_form.nutrition = trans.nutrition
					crinos_form.mind = trans.mind
					crinos_form.update_blood_hud()
					transfer_damage(trans, crinos_form)
					crinos_form.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
					trans.forceMove(src)
					transformating = FALSE
					animate(trans, transform = null, color = "#FFFFFF", time = 1)
					crinos_form.update_icons()
//					if(crinos_form.auspice.base_breed != "Crinos")
//						adjust_rage(-1, crinos_form)
			if("Homid")
				if(trans == human_form)
					transformating = FALSE
					return
				animate(trans, transform = ntransform, color = "#000000", time = 30)
				playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
				for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
					if(B)
						qdel(B)
				spawn(30)
					if(trans.stat == DEAD || !trans.client) // [ChillRaccoon] - preventing non-player transform issues
						animate(trans, transform = null, color = "#FFFFFF")
						return
					var/items = trans.get_contents()
					for(var/obj/item/item_worn in items)
						if(item_worn)
							if(!ismob(item_worn.loc))
								continue
							trans.dropItemToGround(item_worn, TRUE)
					var/current_loc = get_turf(trans)
					human_form.color = "#000000"
					human_form.forceMove(current_loc)
					animate(human_form, color = "#FFFFFF", time = 10)
					human_form.key = trans.key
					forceMove(human_form)
					human_form.bloodpool = trans.bloodpool
					human_form.masquerade = trans.masquerade
					human_form.nutrition = trans.nutrition
					human_form.mind = trans.mind
					human_form.update_blood_hud()
					transfer_damage(trans, human_form)
					human_form.remove_movespeed_modifier(/datum/movespeed_modifier/crinosform)
					human_form.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
					trans.forceMove(src)
					transformating = FALSE
					animate(trans, transform = null, color = "#FFFFFF", time = 1)
//					if(human_form.auspice.base_breed != "Homid")
//						adjust_rage(-1, human_form)

/obj/werewolf_holder/transformation/proc/fast_trans_gender(mob/trans, form)
	switch(form)
		if("Lupus")
			if(trans == lupus_form)
				return
			var/current_loc = get_turf(trans)
			lupus_form.forceMove(current_loc)
			lupus_form.key = trans.key
			lupus_form.mind.language_holder = trans.mind.language_holder
			forceMove(lupus_form)
			trans.forceMove(src)
		if("Crinos")
			if(trans == crinos_form)
				return
			var/current_loc = get_turf(trans)
			crinos_form.forceMove(current_loc)
			crinos_form.key = trans.key
			crinos_form.mind.language_holder = trans.mind.language_holder
			forceMove(crinos_form)
			trans.forceMove(src)
		if("Homid")
			if(trans == human_form)
				return
			var/current_loc = get_turf(trans)
			human_form.forceMove(current_loc)
			human_form.key = trans.key
			forceMove(human_form)
			trans.forceMove(src)

/mob/living/carbon/human
	var/datum/warform/warform

/mob/living/simple_animal/hostile
	var/datum/warform/warform

/datum/warform
	var/mob/living/carbon/human/humanform
	var/mob/living/simple_animal/hostile/warform

/mob/living/simple_animal/hostile/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	if(warform)
		return warform.humanform.adjustBruteLoss(amount, updating_health, forced)
	else
		..()

/mob/living/simple_animal/hostile/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(warform)
		return warform.humanform.adjustFireLoss(amount, updating_health, forced)
	else
		..()

/mob/living/simple_animal/hostile/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(warform)
		return warform.humanform.adjustOxyLoss(amount, updating_health, forced)
	else
		..()

/mob/living/simple_animal/hostile/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(warform)
		return warform.humanform.adjustToxLoss(amount, updating_health, forced)
	else
		..()

/mob/living/simple_animal/hostile/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(warform)
		return warform.humanform.adjustCloneLoss(amount, updating_health, forced)
	else
		..()

/mob/living/simple_animal/hostile/adjustStaminaLoss(amount, updating_health = FALSE, forced = FALSE)
	if(warform)
		return warform.humanform.adjustStaminaLoss(amount, updating_health, forced)
	else
		..()

/datum/warform/proc/transform(var/animal_atom, var/mob/living/carbon/human/owner, var/masquerady = TRUE)
	humanform = owner
	owner.invisibility = INVISIBILITY_MAXIMUM
	warform = new animal_atom(get_turf(owner))
	warform.attributes = owner.attributes
	warform.stop_automated_movement = TRUE
	warform.wander = FALSE
	humanform.dna.species.brutemod = initial(humanform.dna.species.brutemod)*(initial(humanform.maxHealth)/initial(warform.maxHealth))
	humanform.dna.species.burnmod = initial(humanform.dna.species.burnmod)*(initial(humanform.maxHealth)/initial(warform.maxHealth))
	warform.warform = src
	warform.anchored = TRUE
	warform.AIStatus = AI_OFF
	if(masquerady)
		warform.my_creator = owner
	owner.warform = src
	var/datum/action/end_warform/R = new
	R.Grant(owner)
	owner.forceMove(warform)

/datum/warform/proc/end()
	humanform.forceMove(get_turf(warform))
	qdel(warform)
	humanform.dna.species.brutemod = initial(humanform.dna.species.brutemod)
	humanform.dna.species.burnmod = initial(humanform.dna.species.burnmod)
	humanform.invisibility = initial(humanform.invisibility)
	humanform.warform = null
	for(var/datum/action/end_warform/W in humanform.actions)
		if(W)
			W.Remove(humanform)
	qdel(src)

/datum/action/end_warform
	name = "Exit Warform"
	desc = "Exit your current warform."
	button_icon_state = "bloodcrawler"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/end_warform/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		H.warform.end()
