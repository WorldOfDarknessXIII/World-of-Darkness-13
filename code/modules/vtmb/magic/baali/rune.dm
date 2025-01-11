/obj/effect/decal/baalirune
	name = "satanic rune"
	pixel_w = -16
	pixel_z = -16
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "baali"
	var/total_corpses = 111
	var/test_data
	var/list/rune_rituals = list()

/obj/effect/decal/baalirune/Initialize()
	. = ..()
	for(var/type in subtypesof(/datum/rune_ritual))
		var/datum/rune_ritual/rune_type = type
		var/datum/rune_ritual/rune_ref = new rune_type
		if(!rune_ref.Initialize())
			return null
		rune_rituals[rune_ref.category] += list(rune_ref)

/obj/effect/decal/baalirune/attack_hand(mob/living/user)
	. = ..()
	ui_interact(user)

/obj/effect/decal/baalirune/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("sacrifice")
			var/mob/living/carbon/human/corpse = locate() in get_turf(src)
			if(corpse && corpse.stat == DEAD)
				corpse.gib()
				total_corpses++
			else
				to_chat(usr, "<span class='baali'>You need to sacrifice CORPSE</span>")
			return TRUE
		if("ritual")
			if(params["category"] && params["name"])
				for(var/datum/rune_ritual/ritual in rune_rituals[params["category"]])
					if(ritual.name == params["name"])
						if(total_corpses >= ritual.cost)
							if(ritual.Execute(usr, src))
								total_corpses -= ritual.cost
							else
								to_chat(usr, "<span class='baali'>You failed to make this ritual!</span>")
						else
							to_chat(usr, "<span class='baali'>You need to sacrifice MORE humans!!!</span>")
						return TRUE
			to_chat(usr, "<span class='baali'>You don't have knowledge about this ritual!</span>")
			return TRUE

/obj/effect/decal/baalirune/ui_interact(mob/user, datum/tgui/ui)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/player = user
		if(!player.clane || !istype(player.clane, /datum/vampireclane/baali))
			to_chat(user, "You have no clues about this rune!")
			//return
		ui = SStgui.try_update_ui(user, src, ui)
		if(!ui)
			ui = new(user, src, "BaaliRune", "Satanic Rune")
			ui.open()

/obj/effect/decal/baalirune/ui_data(mob/user)
	. = ..()
	var/list/data = list()
	data["corpses"] = total_corpses
	var/categories = list()
	for(var/category in rune_rituals)
		categories += category
	data["categories"] = categories
	var/list/rituals = list()
	for(var/category in rune_rituals)
		for(var/datum/rune_ritual/ritual in rune_rituals[category])
			rituals += list(list("name" = ritual.name, "description" = ritual.description,  "cost" = ritual.cost, "category" = ritual.category))
	data["rituals"] = rituals
	test_data = data
	return data
