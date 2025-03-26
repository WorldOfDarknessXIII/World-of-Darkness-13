/obj/item/vtm/dwelling_loot
	name = "Dwelling Loot Master Item"
	desc = "If you can see this with the base description, someone did a funny. Please report this as a bug."
	icon = 'icons/obj/clothing/accessories.dmi'
	icon_state = "bronze"
	var/loot_value = 0 // From 1 to 3 assings value and changes description. This should be replaced by a full proc at some point, but will do for a first implementation.

/obj/item/vtm/dwelling_loot/Initialize()
	. = ..()
	switch(loot_value)
		if(1)
			AddComponent(/datum/component/selling, 50, "loot_small", TRUE, -1, 5)
		if(2)
			AddComponent(/datum/component/selling, 150, "loot_medium", TRUE, -1, 5)
		if(3)
			AddComponent(/datum/component/selling, 350, "loot_large", TRUE, -1, 5)

/obj/item/vtm/dwelling_loot/minor
	name = "minor valuable"
	desc = "A small trinket of low value. Can be fenced for some money."
	icon_state = "bronze"
	loot_value = 1

/obj/item/vtm/dwelling_loot/moderate
	name = "moderate valuable"
	desc = "A small trinket of decent value. Can be fenced for money."
	icon_state = "silver"
	loot_value = 2

/obj/item/vtm/dwelling_loot/major
	name = "major valuable"
	desc = "A small trinket of excellent value. Can be fenced for good money."
	icon_state = "gold"
	loot_value = 3

/obj/structure/vtm/dwelling_container
	name = "Dwelling Container Master Item"
	desc = "This is a Container that should not be seen by the player. Oopsie!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "dresser"
	anchored = 1
	var/area/vtm/dwelling/area_reference
	var/search_tries = 0
	var/search_hits_left = 0 // These should be automated by the system, btu tries typically are double the hits.
	var/currently_searched = 0 // Terminator for when in use

/obj/structure/vtm/dwelling_container/Initialize()
	var/area/vtm/dwelling/current_area = get_area(src)
	if(current_area)
		current_area.loot_containers.Add(src)
	. = ..()


/obj/structure/vtm/dwelling_container/proc/roll_for_loot() // This assumes that there are still tries left and outputs loot value to be turned into loot. Also does some self-repairing should it detect an impossible value.
	if(search_hits_left > search_tries) // Self-maitnenance. Ammount of tries can't be lower than ammount of assigned sucesses, so they are equalized in case this state is detected. This should not happen unless vars where changed by hand.
		search_tries = search_hits_left
	if(search_hits_left == search_tries)
		search_tries -= 1
		search_hits_left -= 1
		return(area_reference.return_loot_value())
	if(search_hits_left < search_tries)
		if(rand(1,2) == 1)
			search_tries -= 1
			return "fail"
		else
			search_tries -= 1
			search_hits_left -= 1
			return(area_reference.return_loot_value())

/obj/structure/vtm/dwelling_container/proc/dispense_loot(loot_type) // This proc creates the actual loot item. Pulling it out like this allows to individualize loot tables per specific item.
	switch(loot_type)
		if(null)
			return
		if("minor")
			new /obj/item/vtm/dwelling_loot/minor(src)
		if("moderate")
			new /obj/item/vtm/dwelling_loot/moderate(src)
		if("major")
			new /obj/item/vtm/dwelling_loot/major(src)

/obj/structure/vtm/dwelling_container/attack_hand(mob/living/user)
	add_fingerprint(user) // For frorencics, adds user fingerprints
	if(!area_reference) // Terminators
		to_chat(user, span_warning("Error: No area reference detected. This is a bug."))
		return
	if(search_tries == 0)
		to_chat(user, span_warning("This container does not seem to have anything of note inside."))
		return
	if(currently_searched == 1)
		to_chat(user, span_warning("Someone is currently using this object."))
		return
	currently_searched = 1 // Starts searching
	area_reference.add_heat(5)
	var/search_time = search_tries * 30
	if(do_mob(user, src, search_time))
		var/loot_roll = roll_for_loot()
		switch(loot_roll)
			if(0)
				search_hits_left = 0
				to_chat(user, span_warning("You search through the container, but don't find anything of value. You doubt you will be able to find much else here."))
			if("fail")
				to_chat(user, span_warning("You search through the container, but don't find anything of value."))
			if("minor","moderate","major")
				to_chat(user, span_notice("You find an item of [loot_roll] value!"))
				dispense_loot(loot_roll)
	currently_searched = 0
