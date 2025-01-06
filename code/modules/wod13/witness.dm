/obj/item/police_radio
	name = "dispatch frequency radio"
	desc = "911, I'm stuck in my dishwasher and stepbrother is coming in my room..."
	icon_state = "radio"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/last_shooting = 0
	var/last_shooting_victims = 0

/obj/item/police_radio/examine(mob/user)
	. = ..()
	var/turf/T = get_turf(user)
	if(T)
		. += "<b>Location:</b> [T.x]:[T.y] ([get_cardinal_direction(T.x, T.y)])"

/proc/get_cardinal_direction(x, y)
	var/direction = ""
	var/center_x = (x >= 98 && x <= 158)
	var/center_y = (y >= 98 && y <= 158)
	if(center_x && center_y)
		return "Central"
	if(center_x)
		direction = ""
	else if(x >= 128)
		direction += "East"
	else
		direction += "West"
	if(center_y)
		direction = "Central [direction]"
	else if(y >= 128)
		direction = "North [direction]"
	else
		direction = "South [direction]"
	direction += " San Francisco"
	return direction

/obj/item/police_radio/proc/announce_crime(var/crime, var/atom/location)
	switch(crime)
		if("shooting")
			if(last_shooting+50 < world.time)
				last_shooting = world.time
				var/area/A = get_area(location)
				say("Citizens report hearing gunshots at [A.name], to the [get_cardinal_direction(location.x, location.y)]...")
		if("victim")
			if(last_shooting_victims+50 < world.time)
				last_shooting_victims = world.time
				var/area/A = get_area(location)
				say("Active firefight in progress at [A.name], wounded civilians, to the [get_cardinal_direction(location.x, location.y)]...")
		if("murder")
			var/area/A = get_area(location)
			say("Murder at [A.name], to the [get_cardinal_direction(location.x, location.y)]...")

/obj/item/police_radio/Initialize()
	. = ..()
	GLOB.police_radios += src

/obj/item/police_radio/Destroy()
	. = ..()
	GLOB.police_radios -= src

/mob/living/carbon/Initialize()
	. = ..()
	var/datum/atom_hud/abductor/hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	hud.add_to_hud(src)

/mob/living/carbon/proc/update_auspex_hud()
	var/image/holder = hud_list[GLAND_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "aura"

	if (client)
		if(a_intent == INTENT_HARM)
			holder.color = "#ff0000"
		else
			holder.color = "#0000ff"
	else if (isnpc(src))
		var/mob/living/carbon/human/npc/N = src
		if (N.danger_source)
			holder.color = "#ff0000"
		else
			holder.color = "#0000ff"

	if (iskindred(src))
		//pale aura for vampires
		holder.color = "#ffffff"
		//only Baali can get antifrenzy through selling their soul, so this gives them the unholy halo (MAKE THIS BETTER)
		if (antifrenzy)
			holder.icon = 'icons/effects/32x64.dmi'
		//black aura for diablerists
		if (diablerist)
			holder.icon_state = "diablerie_aura"

	if (isgarou(src) || iswerewolf(src))
		//garou have bright auras due to their spiritual potence
		holder.icon_state = "aura_bright"

	if (isghoul(src))
		//Pale spots in the aura, had to be done manually since holder.color will show only a type of color
		holder.overlays = null
		holder.color = null
		holder.icon_state = "aura_ghoul"

	if(mind?.holy_role >= HOLY_ROLE_PRIEST)
		holder.color = "#ffe12f"
		holder.icon_state = "aura"
