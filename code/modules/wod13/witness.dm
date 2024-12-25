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
		. += "<b>Location:</b> [T.x]:[T.y]"

/obj/item/police_radio/proc/announce_crime(var/crime, var/atom/location)
	switch(crime)
		if("shooting")
			if(last_shooting+50 < world.time)
				last_shooting = world.time
				var/area/A = get_area(location)
				say("Gun shots at [A.name], [location.x]:[location.y]...")
		if("victim")
			if(last_shooting_victims+50 < world.time)
				last_shooting_victims = world.time
				var/area/A = get_area(location)
				say("Engaged combat at [A.name], wounded civillian, [location.x]:[location.y]...")
		if("murder")
			var/area/A = get_area(location)
			say("Murder at [A.name], [location.x]:[location.y]...")

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
	if(iskindred(src))
		if(antifrenzy)
			holder.icon = 'icons/effects/32x64.dmi'
		holder.color = "#ffffff"
		if(diablerist)
			holder.icon_state = "diablerie_aura"
		else
			holder.icon_state = "aura"
	else
		holder.icon_state = "aura"
		if(isgarou(src) || iswerewolf(src))
			holder.icon_state = "aura_bright"
		var/ghoul = FALSE
		if(isghoul(src))
			//Pale spots in the aura, had to be done manually since holder.color will show only a type of color
			holder.icon_state = "aura_ghoul"
			ghoul = TRUE

		if(isnpc(src))
			var/mob/living/carbon/human/npc/N = src
			if(N.danger_source)
				holder.color = "#ff0000"
			else
				holder.color = "#0000ff"
		else if(!ghoul)
		//Ghoul got a mix of two different colors on the dmi, so it can't recieve any holder.color 
			if(a_intent == INTENT_HARM)
				holder.color = "#ff0000"
			else
				holder.color = "#0000ff"

		if(mind)
			if(mind.holy_role == HOLY_ROLE_PRIEST)
				holder.color = "#ffe12f"
