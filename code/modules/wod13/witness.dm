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
	var/area/crime_location = get_area(location)
	var/direction = get_cardinal_direction(location.x, location.y)
	var/message = ""

	switch(crime)
		if("shooting")
			if(last_shooting + 15 SECONDS < world.time)
				last_shooting = world.time
				message = "Citizens report hearing gunshots at [crime_location.name], to the [direction], [location.x]:[location.y]..."
		if("victim")
			if(last_shooting_victims + 15 SECONDS < world.time)
				last_shooting_victims = world.time
				message = "Active firefight in progress at [crime_location.name], wounded civilians, the [direction], [location.x]:[location.y]..."
		if("murder")
			message = "Murder at [crime_location.name], to the [direction], [location.x]:[location.y]..."

	if(message != "")
		for(var/obj/item/police_radio/radio in GLOB.police_radios)
			radio.say(message)
		for(var/obj/item/p25radio/police/radio in GLOB.p25_radios)
			if(radio.linked_network == "police")
				radio.say(message)

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

SUBSYSTEM_DEF(witness_pool)
	name = "Witness Pool"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_VERYLOW
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 6 SECONDS

	var/list/currentrun = list()

/datum/controller/subsystem/witness_pool/stat_entry(msg)
	var/list/activelist = GLOB.mob_living_list
	msg = "WITNESS:[length(activelist)]"
	return ..()

/datum/controller/subsystem/witness_pool/fire(resumed = FALSE)

	if (!resumed)
		var/list/activelist = GLOB.mob_living_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/LIV = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(LIV))
			GLOB.mob_living_list -= LIV
			log_world("Found a null in car list!")
			continue

		if(MC_TICK_CHECK)
			return
		LIV.handle_witness()

/mob/living/proc/handle_witness()
	return

/mob/living/simple_animal/hostile/handle_witness()
	if(my_creator)
		if(CheckEyewitness(src, src, 5, FALSE))
			SEND_SOUND(src, sound('code/modules/wod13/sounds/masquerade_violation.ogg', 0, 0, 75))
			to_chat(src, "<span class='userdanger'><b>MASQUERADE VIOLATION</b></span>")
			my_creator.AdjustMasquerade(-1)

/mob/living/carbon/werewolf/handle_witness()
	if(stat != DEAD)
		var/gaining_rage = TRUE
		for(var/obj/structure/werewolf_totem/W in GLOB.totems)
			if(W)
				if(W.totem_health)
					if(W.tribe == auspice?.tribe)
						if(get_area(W) == get_area(src) && client)
							gaining_rage = FALSE
							if(last_gnosis_buff+300 < world.time)
								last_gnosis_buff = world.time
								adjust_gnosis(1, src, TRUE)
		if(iscrinos(src))
			if(auspice?.base_breed == "Crinos")
				gaining_rage = FALSE
			if(CheckEyewitness(src, src, 5, FALSE))
				adjust_veil(-1)
		if(islupus(src))
			if(auspice?.base_breed == "Lupus")
				gaining_rage = FALSE
			var/mob/living/carbon/werewolf/lupus/Lupus = src
			if(Lupus.hispo)
				CheckEyewitness(src, src, 7, FALSE)
		if(gaining_rage && client)
			if((last_rage_gain + 1 MINUTES) < world.time)
				last_rage_gain = world.time
				adjust_rage(1, src, TRUE)

		if(masquerade == 0)
			var/special_role_name
			if(mind)
				if(mind.special_role)
					var/datum/antagonist/A = mind.special_role
					special_role_name = A.name
			if(!is_special_character(src) || special_role_name == "Ambitious")
				if(auspice?.gnosis)
					to_chat(src, "<span class='warning'>My Veil is too low to connect with the spirits of Umbra!</span>")
					adjust_gnosis(-1, src, FALSE)

		if(auspice?.rage >= 9)
			if(!in_frenzy)
				if((last_frenzy_check + 18 SECONDS) <= world.time)
					last_frenzy_check = world.time
					rollfrenzy()

		if(istype(get_area(src), /area/vtm/interior/penumbra))
			if((last_veil_restore + 40 SECONDS) < world.time)
				adjust_veil(1, src, TRUE)
				last_veil_restore = world.time

		switch(auspice?.tribe)
			if("Wendigo")
				if(istype(get_area(src), /area/vtm/forest))
					if((last_veil_restore + 60 SECONDS) <= world.time)
						adjust_veil(1, src, TRUE)
						last_veil_restore = world.time

			if("Glasswalkers")
				if(istype(get_area(src), /area/vtm/interior/glasswalker))
					if((last_veil_restore + 60 SECONDS) <= world.time)
						adjust_veil(1, src, TRUE)
						last_veil_restore = world.time

			if("Black Spiral Dancers")
				if(istype(get_area(src), /area/vtm/interior/wyrm_corrupted))
					if((last_veil_restore + 60 SECONDS) <= world.time)
						adjust_veil(1, src, TRUE)
						last_veil_restore = world.time

/mob/living/carbon/human/handle_witness()
	var/mob/living/carbon/human/H = src
	if(istype(get_area(H), /area/vtm))
		var/area/vtm/V = get_area(H)
		if(V.zone_type == "masquerade" && V.upper)
			if(pulling)
				if(ishuman(pulling))
					var/mob/living/carbon/human/pull = pulling
					if(pull.stat == DEAD)
						var/obj/item/card/id/id_card = get_idcard(FALSE)
						if(!istype(id_card, /obj/item/card/id/clinic))
							if(CheckEyewitness(H, H, 7, FALSE))
								if(last_loot_check+50 <= world.time)
									last_loot_check = world.time
									last_nonraid = world.time
									killed_count = killed_count+1
									if(!warrant && !ignores_warrant)
										if(killed_count >= 5)
											warrant = TRUE
											SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
										else
											SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (corpse)</b></span>")
			for(var/obj/item/I in contents)
				if(I)
					if(I.masquerade_violating)
						if(I.loc == H)
							var/obj/item/card/id/id_card = get_idcard(FALSE)
							if(!istype(id_card, /obj/item/card/id/clinic))
								if(CheckEyewitness(H, H, 7, FALSE))
									if(last_loot_check+50 <= world.time)
										last_loot_check = world.time
										last_nonraid = world.time
										killed_count = killed_count+1
										if(!warrant && !ignores_warrant)
											if(killed_count >= 5)
												warrant = TRUE
												SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
												to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
											else
												SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
												to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (equipment)</b></span>")

	if(iskindred(src))


		if(clane?.name == "Baali")
			if(istype(get_area(H), /area/vtm/church))
				if(prob(50))
					to_chat(H, "<span class='warning'>You don't belong here!</span>")
					adjustFireLoss(20)
					adjust_fire_stacks(6)
					IgniteMob()
		if(!antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
			var/fearstack = 0
			for(var/obj/effect/fire/F in GLOB.fires_list)
				if(F)
					if(get_dist(F, H) < 8 && F.z == z)
						fearstack += F.stage
			for(var/mob/living/carbon/human/U in viewers(7, H))
				if(U.on_fire)
					fearstack += 1

			fearstack = min(fearstack, 10)

			if(fearstack)
				if(prob(fearstack*5))
					do_jitter_animation(10)
					if(fearstack > 20)
						if(prob(fearstack))
							if(!in_frenzy)
								rollfrenzy()
				if(!has_status_effect(STATUS_EFFECT_FEAR))
					apply_status_effect(STATUS_EFFECT_FEAR)
			else
				remove_status_effect(STATUS_EFFECT_FEAR)

		//masquerade violations due to unnatural appearances
		if(is_face_visible() && clane?.violating_appearance)
			switch(clane.alt_sprite)
				if ("kiasyd")
					//masquerade breach if eyes are uncovered, short range
					if (!is_eyes_covered())
						if (CheckEyewitness(H, H, 3, FALSE))
							AdjustMasquerade(-1)
				if ("rotten3")
					//slightly less range than if fully decomposed
					if (CheckEyewitness(H, H, 5, FALSE))
						AdjustMasquerade(-1)
				else
					//gargoyles, nosferatu, skeletons, that kind of thing
					if (CheckEyewitness(H, H, 7, FALSE))
						AdjustMasquerade(-1)

		if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
			if(CheckEyewitness(H, H, 7, FALSE))
				AdjustMasquerade(-1)
		if(HAS_TRAIT(H, TRAIT_NONMASQUERADE))
			if(CheckEyewitness(H, H, 7, FALSE))
				AdjustMasquerade(-1)
		if(hearing_ghosts)
			bloodpool = max(0, bloodpool-1)
			to_chat(H, "<span class='warning'>Necromancy Vision reduces your blood points too sustain itself.</span>")

		if(clane?.name == "Tzimisce" || clane?.name == "Old Clan Tzimisce")
			var/datum/vampireclane/tzimisce/TZ = clane
			if(TZ.heirl)
				if(!(TZ.heirl in GetAllContents()))
					if(prob(5))
						to_chat(H, "<span class='warning'>You are missing your home soil...</span>")
						rollfrenzy()
		if(clane?.name == "Kiasyd")
			var/datum/vampireclane/kiasyd/kiasyd = clane
			for(var/obj/item/I in contents)
				if(I?.is_iron)
					if (COOLDOWN_FINISHED(kiasyd, cold_iron_frenzy))
						COOLDOWN_START(kiasyd, cold_iron_frenzy, 10 SECONDS)
						rollfrenzy()
						to_chat(H, "<span class='warning'>[I] is <b>COLD IRON</b>!")

		if(clane && !antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
			if(clane.name == "Banu Haqim")
				if(mind)
					if(mind.enslaved_to)
						if(get_dist(H, mind.enslaved_to) > 10)
							if((last_frenzy_check + 40 SECONDS) <= world.time)
								to_chat(H, "<span class='warning'><b>As you are far from [mind.enslaved_to], you feel the desire to drink more vitae!<b></span>")
								last_frenzy_check = world.time
								rollfrenzy()
						else if(bloodpool > 1 || in_frenzy)
							last_frenzy_check = world.time
			else
				if(bloodpool > 1 || in_frenzy)
					last_frenzy_check = world.time

		if(!antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
			if(bloodpool <= 1 && !in_frenzy)
				if((last_frenzy_check + 40 SECONDS) <= world.time)
					last_frenzy_check = world.time
					rollfrenzy()
					if(clane)
						if(clane.enlightenment)
							if(!CheckFrenzyMove())
								AdjustHumanity(1, 10)

	else if(isgarou(src))

		if(auspice?.base_breed != "Homid")
			if(client)
				if((last_rage_gain + 1 MINUTES) < world.time)
					last_rage_gain = world.time
					adjust_rage(1, src, TRUE)
		if(masquerade == 0)
			var/special_role_name
			if(mind)
				if(mind.special_role)
					var/datum/antagonist/A = mind.special_role
					special_role_name = A.name
			if(!is_special_character(src) || special_role_name == "Ambitious")
				if(auspice?.gnosis)
					to_chat(src, "<span class='warning'>My Veil is too low to connect with the spirits of Umbra!</span>")
					adjust_gnosis(-1, src, FALSE)

		if(auspice?.rage >= 9)
			if(!in_frenzy)
				if((last_frenzy_check + 18 SECONDS) <= world.time)
					last_frenzy_check = world.time
					rollfrenzy()

		if(istype(get_area(src), /area/vtm/interior/penumbra))
			if((last_veil_restore + 40 SECONDS) < world.time)
				adjust_veil(1, src, TRUE)
				last_veil_restore = world.time

		switch(auspice?.tribe)
			if("Wendigo")
				if(istype(get_area(src), /area/vtm/forest))
					if((last_veil_restore + 60 SECONDS) <= world.time)
						adjust_veil(1, src, TRUE)
						last_veil_restore = world.time

			if("Glasswalkers")
				if(istype(get_area(src), /area/vtm/interior/glasswalker))
					if((last_veil_restore + 60 SECONDS) <= world.time)
						adjust_veil(1, src, TRUE)
						last_veil_restore = world.time

			if("Black Spiral Dancers")
				if(istype(get_area(src), /area/vtm/interior/wyrm_corrupted))
					if((last_veil_restore + 60 SECONDS) <= world.time)
						adjust_veil(1, src, TRUE)
						last_veil_restore = world.time

		var/datum/species/garou/Garou = dna?.species
		if(Garou)
			if(Garou.glabro)
				if(CheckEyewitness(H, H, 7, FALSE))
					adjust_veil(-1)

		if((last_bloodpool_restore + 60 SECONDS) <= world.time)
			last_bloodpool_restore = world.time
			bloodpool = min(maxbloodpool, bloodpool+1)

	else if(isghoul(src))


		if(humanity <= 2)
			if(prob(5))
				if(prob(50))
					Stun(20)
					to_chat(H, "<span class='warning'>You stop in fear and remember your crimes against humanity...</span>")
					emote("cry")
				else
					to_chat(H, "<span class='warning'>You feel the rage rising as your last sins come to your head...</span>")
					drop_all_held_items()
					emote("scream")


	else

		if((last_bloodpool_restore + 60 SECONDS) <= world.time)
			last_bloodpool_restore = world.time
			bloodpool = min(maxbloodpool, bloodpool+1)
