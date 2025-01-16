SUBSYSTEM_DEF(blackout)
	name = "Blackout"
	init_order = INIT_ORDER_DEFAULT
	wait = 10 MINUTES
	priority = FIRE_PRIORITY_VERYLOW

/datum/controller/subsystem/blackout/fire()
	for(var/obj/generator/G in GLOB.generators)
		if(G.on)
			if(prob(50))
				G.brek()
			G.fuel_remain = max(0, G.fuel_remain-10)
			if(G.fuel_remain == 0)
				G.brek()

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
			if(istype(get_area(src), /area/vtm/church))
				if(prob(50))
					to_chat(H, "<span class='warning'>You don't belong here!</span>")
					adjustFireLoss(20)
					adjust_fire_stacks(6)
					IgniteMob()
		if(!antifrenzy && !HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
			var/fearstack = 0
			for(var/obj/effect/fire/F in GLOB.fires_list)
				if(F)
					if(get_dist(F, src) < 8 && F.z == z)
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

	else if(iscathayan(src))


		if(key && (stat <= HARD_CRIT) && mind?.dharma)
			update_chi_hud()
			if(!in_frenzy)
				mind.dharma.Po_combat = FALSE
			if(demon_chi == max_demon_chi && max_demon_chi != 0 && !in_frenzy)
				rollfrenzy()

			if(mind.dharma.Po == "Monkey")
				if(COOLDOWN_FINISHED(mind.dharma, po_call))
					var/atom/trigger1
					var/atom/trigger2
					var/atom/trigger3
					for(var/obj/structure/pole/pole in view(5, src))
						if(pole)
							trigger1 = pole
					if(trigger1)
						mind.dharma.roll_po(trigger1, src)
					for(var/obj/item/toy/toy in view(5, src))
						if(toy && toy.loc != src)
							trigger2 = toy
					if(trigger2)
						mind.dharma.roll_po(trigger2, src)
					for(var/obj/machinery/computer/slot_machine/slot in view(5, src))
						if(slot)
							trigger3 = slot
					if(trigger3)
						mind.dharma.roll_po(trigger3, src)

			if(mind.dharma.Po == "Fool")
				var/datum/species/kuei_jin/K = dna.species
				if(K.fool_turf != get_turf(src))
					K.fool_fails = 0
					K.fool_turf = get_turf(src)
				else
					if(client)
						K.fool_fails = K.fool_fails+1
						if(K.fool_fails >= 10)
							mind.dharma.roll_po(src, src)
							K.fool_fails = 0

			if(mind.dharma.Po == "Demon")
				if(COOLDOWN_FINISHED(H.mind.dharma, po_call))
					var/atom/trigger
					for(var/mob/living/carbon/human/hum in viewers(5, src))
						if(hum != src)
							if(hum.stat > CONSCIOUS && hum.stat < DEAD)
								trigger = hum
					if(trigger)
						mind.dharma.roll_po(trigger, src)
		nutrition = NUTRITION_LEVEL_START_MAX
		if((last_bloodpool_restore + 60 SECONDS) <= world.time)
			last_bloodpool_restore = world.time
			bloodpool = min(maxbloodpool, bloodpool+1)

	else

		if((last_bloodpool_restore + 60 SECONDS) <= world.time)
			last_bloodpool_restore = world.time
			bloodpool = min(maxbloodpool, bloodpool+1)
