SUBSYSTEM_DEF(factionwar)
	name = "Faction War"
	init_order = INIT_ORDER_DEFAULT
	wait = 6 SECONDS
	priority = FIRE_PRIORITY_VERYLOW

	var/list/marks_camarilla = list()
	var/list/marks_anarch = list()
	var/list/marks_sabbat = list()
	var/list/marks_contested = list()

	var/camarilla_power = 500
	var/list/camarilla_members = list()
	var/anarch_power = 500
	var/list/anarch_members = list()

	var/last_check_time = 0

/mob/living/carbon/human/Destroy()
	if(vampire_faction == FACTION_CAMARILLA)
		SSfactionwar.camarilla_members -= src
	..()

/datum/controller/subsystem/factionwar/proc/adjust_members()
	camarilla_members = list()
	anarch_members = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H)
			if(H.vampire_faction == FACTION_CAMARILLA)
				camarilla_members += H
			if(H.vampire_faction == FACTION_ANARCHS)
				anarch_members += H

/datum/controller/subsystem/factionwar/fire()
	//Sanity check
	var/time = world.time - SSticker.round_start_time
	var/mark_expiration = FALSE
	if(time - last_check_time >= 10 MINUTES)
		last_check_time = time
		mark_expiration = TRUE
	camarilla_members = list()
	anarch_members = list()
	var/how_much_cam = length(marks_camarilla)
	var/how_much_an = length(marks_anarch)
//	var/how_much_sab = length(marks_sabbat)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H)
//			var/datum/preferences/P = GLOB.preferences_datums[ckey(H.key)]
//			var/mode = 1
//			if(HAS_TRAIT(H, TRAIT_NON_INT))
//				mode = 2
//			if(P)
			if(H.vampire_faction == FACTION_CAMARILLA)
				camarilla_members += H
//					P.exper = min(calculate_mob_max_exper(H), P.exper+((4/mode)*how_much_cam))
			if(H.vampire_faction == FACTION_ANARCHS)
				anarch_members += H
//					P.exper = min(calculate_mob_max_exper(H), P.exper+((4/mode)*how_much_an))
//				if(H.vampire_faction == FACTION_SABBAT)
//					P.exper = min(calculate_mob_max_exper(H), P.exper+((4/mode)*how_much_sab))
	camarilla_power = max(0, camarilla_power-(how_much_cam*5))
	if(camarilla_power == 0 && mark_expiration)
		var/list/shit = list()
		for(var/obj/graffiti/G in marks_camarilla)
			if(G)
				if(!G.permanent)
					shit += G
		if(length(shit))
			var/obj/graffiti/R = pick(shit)
			marks_camarilla -= R
			R.icon_state = "Unknown"
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(H.vampire_faction == FACTION_CAMARILLA || H.vampire_faction == FACTION_ANARCHS || H.vampire_faction == FACTION_SABBAT)
					var/area/A = get_area(R)
					to_chat(H, "<b><span class='warning'>Camarilla</span> don't have resources to sustain [A.name] [R.x]:[R.y], so it belongs to no one now.</b>")
	anarch_power = max(0, anarch_power-(how_much_an*5))
	if(anarch_power == 0 && mark_expiration)
		var/list/shit = list()
		for(var/obj/graffiti/G in marks_anarch)
			if(G)
				if(!G.permanent)
					shit += G
		if(length(shit))
			var/obj/graffiti/R = pick(shit)
			marks_anarch -= R
			R.icon_state = "Unknown"
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(H.vampire_faction == FACTION_CAMARILLA || H.vampire_faction == FACTION_ANARCHS || H.vampire_faction == FACTION_SABBAT)
					var/area/A = get_area(R)
					to_chat(H, "<b><span class='warning'>Anarch</span> don't have recources to sustain [A.name] [R.x]:[R.y], so it belongs to no one now.</b>")
	if(length(marks_contested))
		for(var/obj/graffiti/G in marks_contested)
			for(var/mob/living/carbon/human/mob in range(7, G))
				if(mob?.vampire_faction == G.last_contender.vampire_faction && mob.stat != DEAD)
					G.progress += 6
				else if(mob?.vampire_faction != G.last_contender.vampire_faction && mob.stat != DEAD && (mob?.vampire_faction == "Camarilla" || mob?.vampire_faction == "Anarch" || mob?.vampire_faction == "Sabbat"))
					G.progress -= 6
			G.progress -= 2
			if(G.progress <= 0)
				G.repainting = FALSE
				G.progress = 0
				marks_contested -= G
				var/area/vtm/A = get_area(G)
				message_all_factions("<b>[A.name] [G.x]:[G.y] mark was not captured by <span class='warning'>[G.last_contender.vampire_faction]</span></b>")
			if(G.progress >= 100)
				G.icon_state = G.last_contender.vampire_faction
				if(ishuman(G.last_contender))
					var/mob/living/carbon/human/H = G.last_contender
					H.last_repainted_mark = G.last_contender.vampire_faction
				if(G.last_contender.vampire_faction == "Camarilla")
					camarilla_power = max(0, camarilla_power-length(marks_camarilla)*5)
				if(G.last_contender.vampire_faction == "Anarch")
					anarch_power = max(0, anarch_power-length(marks_anarch)*5)
				move_mark(G, G.last_contender.vampire_faction)
				var/area/vtm/A = get_area(G)
				message_all_factions("<b>[A.name] [G.x]:[G.y] mark now belongs to <span class='warning'>[G.last_contender.vampire_faction]</span></b>")
				if(A.zone_owner)
					A.zone_owner = G.last_contender.vampire_faction
				G.repainting = FALSE
				G.progress = 0
				marks_contested -= G

/datum/controller/subsystem/factionwar/proc/message_faction(var/vampire_faction, var/message)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.vampire_faction == vampire_faction)
			for(var/obj/item/vamp/phone/phn in GLOB.phones_list)
				if(phn.number == H.Myself.phone_number)
					phn.say("[message]", range = 1)

/datum/controller/subsystem/factionwar/proc/message_all_factions(var/message)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.vampire_faction == "Camarilla" || H.vampire_faction == "Anarch" || H.vampire_faction == "Sabbat")
			for(var/obj/item/vamp/phone/phn in GLOB.phones_list)
				if(phn.number == H.Myself.phone_number)
					phn.say("[message]", range = 1)

/datum/controller/subsystem/factionwar/proc/switch_member(var/mob/living/member, var/vampire_faction)
	switch(vampire_faction)
		if(FACTION_CAMARILLA)
			anarch_members -= member
			camarilla_members += member
		if(FACTION_ANARCHS)
			camarilla_members -= member
			anarch_members += member
		if(FACTION_SABBAT)
			camarilla_members -= member
			anarch_members -= member

/datum/controller/subsystem/factionwar/proc/check_faction_ability(var/vampire_faction)
	switch(vampire_faction)
		if(FACTION_SABBAT)
			return TRUE
		if(FACTION_CAMARILLA)
			if(round(length(marks_camarilla)/3) > length(camarilla_members))
				return FALSE
			if(camarilla_power < length(marks_camarilla)*5)
				return FALSE
			return TRUE
		if(FACTION_ANARCHS)
			if(round(length(marks_anarch)/3) > length(anarch_members))
				return FALSE
			if(anarch_power < length(marks_anarch)*5)
				return FALSE
			return TRUE

/datum/controller/subsystem/factionwar/proc/move_mark(var/obj/graffiti/G, var/vampire_faction)
	switch(vampire_faction)
		if(FACTION_CAMARILLA)
			marks_anarch -= G
			marks_sabbat -= G
			marks_camarilla |= G
		if(FACTION_ANARCHS)
			marks_camarilla -= G
			marks_sabbat -= G
			marks_anarch |= G
		if(FACTION_SABBAT)
			marks_camarilla -= G
			marks_anarch -= G
			marks_sabbat |= G

/obj/graffiti
	name = "faction mark"
	desc = "Reminds anyone who sees it which faction it belongs to..."
	icon = 'code/modules/wod13/48x48.dmi'
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	pixel_w = -8
	pixel_z = -8
	alpha = 128
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/repainting = FALSE
	var/permanent = FALSE
	var/mob/living/carbon/human/last_contender
	var/progress = 0

/obj/graffiti/Initialize()
	. = ..()
	if(icon_state)
		SSfactionwar.move_mark(src, icon_state)

/obj/graffiti/camarilla
	icon_state = "Camarilla"

/obj/graffiti/anarch
	icon_state = "Anarchs"

/obj/graffiti/sabbat
	icon_state = "Sabbat"

/obj/graffiti/examine(mob/user)
	. = ..()
	if(repainting)
		. += "<b>Progress:</b> [progress] %"

/datum/controller/subsystem/factionwar/proc/start_capture(mob/living/carbon/human/user, obj/graffiti/G)
	marks_contested |= G
	G.last_contender = user
	var/area/vtm/A = get_area(G)
	message_all_factions("<b>[A.name] [G.x]:[G.y] mark is contended by <span class='warning'>[G.last_contender.vampire_faction]</span></b>")

/obj/graffiti/AltClick(mob/user)
	..()
	if(isliving(user))
		var/mob/living/L = user
		if(!L.vampire_faction)
			to_chat(user, "You don't belong to any faction, so you can't repaint it.")
			return
		if(L.vampire_faction == FACTION_CAMARILLA || L.vampire_faction == FACTION_ANARCHS || L.vampire_faction == FACTION_SABBAT)
			if(L.vampire_faction != icon_state)
				if(SSfactionwar.check_faction_ability(L.vampire_faction))
					if(!repainting)
						if(do_mob(user, src, 7 SECONDS))
							if(ishuman(user))
								var/mob/living/carbon/human/H = user
								repainting = TRUE
								SSfactionwar.start_capture(H, src)
				else
					if(L.vampire_faction == FACTION_CAMARILLA)
						to_chat(user, "Your faction needs <span class='warning'>[round(length(SSfactionwar.marks_camarilla)/3)]</span> members and <span class='warning'>[length(SSfactionwar.marks_camarilla)*5]</span> influence to gain this mark.")
					if(L.vampire_faction == FACTION_ANARCHS)
						to_chat(user, "Your faction needs <span class='warning'>[round(length(SSfactionwar.marks_anarch)/3)]</span> members and <span class='warning'>[length(SSfactionwar.marks_anarch)*5]</span> influence to gain this mark.")
			else
				to_chat(user, "Your faction already own this.")

/obj/structure/faction_map
	name = "faction marks map"
	desc = "Exact map of all marks. <b>Insert dollars to gain influence and bloodbond kindred to gain faction members</b>."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "faction_map"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/faction

/obj/structure/faction_map/examine(mob/user)
	. = ..()
	switch(faction)
		if(FACTION_CAMARILLA)
			. += "<b>Total Influence:</b> [SSfactionwar.camarilla_power]"
			if(length(SSfactionwar.camarilla_members))
				. += "<b>Total Members:</b> [length(SSfactionwar.camarilla_members)]"
			if(length(SSfactionwar.marks_camarilla))
				. += "<b>Total Marks:</b> [length(SSfactionwar.marks_camarilla)]"
			. += "<b>Next Mark Cost:</b> [round(length(SSfactionwar.marks_camarilla)/3)] members and [length(SSfactionwar.marks_camarilla)*5] influence"
		if(FACTION_ANARCHS)
			. += "<b>Total Influence:</b> [SSfactionwar.anarch_power]"
			if(length(SSfactionwar.anarch_members))
				. += "<b>Total Members:</b> [length(SSfactionwar.anarch_members)]"
			if(length(SSfactionwar.marks_anarch))
				. += "<b>Total Marks:</b> [length(SSfactionwar.marks_anarch)]"
			. += "<b>Next Mark Cost:</b> [round(length(SSfactionwar.marks_anarch)/3)] members and [length(SSfactionwar.marks_anarch)*5] influence"

/obj/structure/faction_map/camarilla
	icon_state = "camarilla_map"
	faction = FACTION_CAMARILLA

/obj/structure/faction_map/anarch
	icon_state = "anarch_map"
	faction = FACTION_ANARCHS

/obj/structure/faction_map/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/D = I
		if(faction == FACTION_CAMARILLA)
			SSfactionwar.camarilla_power += D.amount
			qdel(I)
		if(faction == FACTION_ANARCHS)
			SSfactionwar.anarch_power += D.amount
			qdel(I)
