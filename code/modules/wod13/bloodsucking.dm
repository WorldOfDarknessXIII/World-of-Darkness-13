/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(BITE_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "bite", -BITE_LAYER)
	overlays_standing[BITE_LAYER] = bite_overlay
	apply_overlay(BITE_LAYER)
	spawn(1.5 SECONDS)
		if(src)
			remove_overlay(BITE_LAYER)

/proc/get_needed_difference_between_numbers(var/number1, var/number2)
	if(number1 > number2)
		return number1 - number2
	else if(number1 < number2)
		return number2 - number1
	else
		return 1

/mob/living/carbon/human/proc/drinksomeblood(var/mob/living/mob)
	last_drinkblood_use = world.time
	if(client)
		client.images -= suckbar
	qdel(suckbar)
	suckbar_loc = mob
	suckbar = image('code/modules/wod13/bloodcounter.dmi', suckbar_loc, "[round(14*(mob.bloodpool/mob.maxbloodpool))]", HUD_LAYER)
	suckbar.pixel_z = 40
	suckbar.plane = ABOVE_HUD_PLANE
	suckbar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	if(client)
		client.images += suckbar
	var/sound/heartbeat = sound('code/modules/wod13/sounds/drinkblood2.ogg', repeat = TRUE)

	playsound_local(src, heartbeat, 75, 0, channel = CHANNEL_BLOOD, use_reverb = FALSE)
	if(isnpc(mob))
		var/mob/living/carbon/human/npc/NPC = mob
		NPC.danger_source = null
		mob.Stun(40) //NPCs don't get to resist

	if(mob.bloodpool <= 1 && mob.maxbloodpool > 1)
		to_chat(src, "<span class='warning'>You feel small amount of <b>BLOOD</b> in your victim.</span>")
		if(iskindred(mob) && iskindred(src))
			if(!mob.client)
				to_chat(src, "<span class='warning'>You need [mob]'s attention to do that...</span>")
				if (client)
					client.images -= suckbar
				qdel(suckbar)
				return
			message_admins("[ADMIN_LOOKUPFLW(src)] is attempting to Diablerize [ADMIN_LOOKUPFLW(mob)]")
			log_attack("[key_name(src)] is attempting to Diablerize [key_name(mob)].")
			if(mob.key)
				var/vse_taki = FALSE
				if(clane)
					var/salubri_allowed = FALSE
					var/mob/living/carbon/human/H = mob
					if(H.clane)
						if(H.clane.name == "Salubri")
							salubri_allowed = TRUE
					if(clane.name != "Banu Haqim" && clane.name != "Caitiff")
						if(!salubri_allowed)
							if(!mind.special_role)
								to_chat(src, "<span class='warning'>You find the idea of drinking your own <b>KIND's</b> blood disgusting!</span>")
								last_drinkblood_use = 0
								if(client)
									client.images -= suckbar
								qdel(suckbar)
								stop_sound_channel(CHANNEL_BLOOD)
								return
							else
								vse_taki = TRUE
						else
							vse_taki = TRUE
					else
						vse_taki = TRUE

				if(!GLOB.canon_event)
					to_chat(src, "<span class='warning'>It's not a canon event!</span>")
					if(client)
						client.images -= suckbar
					qdel(suckbar)
					return

				if(vse_taki)
					to_chat(src, "<span class='userdanger'><b>YOU TRY TO COMMIT DIABLERIE ON [mob].</b></span>")
				else
					to_chat(src, "<span class='warning'>You find the idea of drinking your own <b>KIND</b> disgusting!</span>")
					if(client)
						client.images -= suckbar
					qdel(suckbar)
					return
			else
				to_chat(src, "<span class='warning'>You need [mob]'s attention to do that...</span>")
				if(client)
					client.images -= suckbar
				qdel(suckbar)
				return

	if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
		if(CheckEyewitness(src, src, 7, FALSE))
			AdjustMasquerade(-1)

	//drink blood faster if on harm intent, eg forcefully feeding
	var/suck_delay = 3 SECONDS
	if (a_intent == INTENT_HARM)
		suck_delay = 1 SECONDS

	if(do_after(src, suck_delay, target = mob, timed_action_flags = NONE, progress = FALSE))
		var/sucked_blood = clamp(mob.blood_points_per_units(BLOOD_POINT_NORMAL), 1, mob.bloodpool)
		mob.adjust_blood_points(-sucked_blood)
		suckbar.icon_state = "[round(14*(mob.bloodpool/mob.maxbloodpool))]"

		//displays flavour text and prevents the vampire from cancelling the feeding depending on the blood potency of the victim
		switch(sucked_blood)
			if (1 to 1.5) //normal mobs, humans, and 9th gen vampires and above
				if (iskindred(mob))
					to_chat(src, "<span class='userlove'>You drink some <b>HEAVENLY</b> blood.</span>")
				else
					to_chat(src, "<span class='userlove'>You drink some DELICIOUS blood.</span>")
				if(HAS_TRAIT(src, TRAIT_BLOODY_SUCKER))
					Immobilize(3 SECONDS, TRUE)
			if (1.5 to 2) //8th generation vampires
				to_chat(src, "<span class=userlove'>You drink some <b>ENTHRALLING</b> blood... You can't stop drinking...")
				Immobilize(3 SECONDS, TRUE)
			if (2 to 3) //werewolves and 7th generation vampires
				to_chat(src, "<span class='userlove'><h1>Your mind is washed away by sheer <b>ECSTASY</b> as you drink this blood.</h1></span>")
				Immobilize(3 SECONDS, TRUE)
			if (3 to INFINITY) //6th generation vampires and below
				to_chat(src, "<span class='userlove'><h1><b>Blood.</b></h1></span>")
				Immobilize(3 SECONDS, TRUE)

		//transfer reagents from victim to vampire through their blood
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			drunked_of |= "[H.dna.real_name]"
			if(iscathayan(src))
				if(mob.yang_chi > 0 || mob.yin_chi > 0)
					if(mob.yang_chi > mob.yin_chi)
						mob.yang_chi = mob.yang_chi-1
						yang_chi = min(yang_chi+1, max_yang_chi)
						to_chat(src, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
					else
						mob.yin_chi = mob.yin_chi-1
						yin_chi = min(yin_chi+1, max_yin_chi)
						to_chat(src, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")
					COOLDOWN_START(mob, chi_restore, 30 SECONDS)
					update_chi_hud()
				else
					to_chat(src, "<span class='warning'>The <b>BLOOD</b> feels tasteless...</span>")
			if(H.reagents)
				if(length(H.reagents.reagent_list))
					if(prob(50))
						H.reagents.trans_to(src, min(10, H.reagents.total_volume), transfered_by = mob, methods = VAMPIRE)

		//clan-specific behaviours for feeding
		if(clane)
			if(clane.name == "Giovanni")
				mob.apply_damage(15, BRUTE)
			if((clane.name == "Ventrue") && (mob.bloodquality < BLOOD_QUALITY_NORMAL))	//Ventrue can suck on normal people, but not homeless people and animals. BLOOD_QUALITY_LOV - 1, BLOOD_QUALITY_NORMAL - 2, BLOOD_QUALITY_HIGH - 3. Blue blood gives +1 to suction
				to_chat(src, "<span class='warning'>You are too privileged to drink that awful <b>BLOOD</b>. Go get something better.</span>")
				visible_message("<span class='danger'>[src] throws up!</span>", "<span class='userdanger'>You throw up!</span>")
				playsound(get_turf(src), 'code/modules/wod13/sounds/vomit.ogg', 75, TRUE)
				if(isturf(loc))
					add_splatter_floor(loc)
				stop_sound_channel(CHANNEL_BLOOD)
				if(client)
					client.images -= suckbar
				qdel(suckbar)
				return

		adjust_blood_points(sucked_blood)
		if(mob.bloodpool <= 0)
			if(ishuman(mob))
				var/mob/living/carbon/human/victim = mob

				//feed on a vampire to death, diablerie code here
				if(iskindred(mob) && iskindred(src))
					var/datum/preferences/diablerist_preferences = GLOB.preferences_datums[ckey(key)]
					var/datum/preferences/victim_preferences = GLOB.preferences_datums[ckey(mob.key)]
					AdjustHumanity(-1, 0)
					AdjustMasquerade(-1)

					//automatic success and no change if your generation is not higher than theirs
					if(victim.generation >= generation)
						message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(mob)]")
						log_attack("[key_name(src)] successfully Diablerized [key_name(mob)].")
						if(victim.client)
							var/datum/brain_trauma/special/imaginary_friend/trauma = gain_trauma(/datum/brain_trauma/special/imaginary_friend)
							trauma.friend.key = victim.key
						mob.death()
						if(victim_preferences)
							victim_preferences.reason_of_death =  "Diablerized by [true_real_name ? true_real_name : real_name] ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
						if(key)
							if(diablerist_preferences)
								diablerist_preferences.diablerist = TRUE
							diablerist = TRUE
					//attempting diablerie which may fail
					else
						var/start_prob = 10
						if(HAS_TRAIT(src, TRAIT_DIABLERIE))
							start_prob = 30

						//failed diablerie
						if(prob(min(99, start_prob+((generation-victim.generation)*10))))
							to_chat(src, "<span class='userdanger'><b>[victim]'s SOUL OVERCOMES YOURS AND GAIN CONTROL OF YOUR BODY.</b></span>")
							message_admins("[ADMIN_LOOKUPFLW(src)] tried to Diablerize [ADMIN_LOOKUPFLW(mob)] and was overtaken.")
							log_attack("[key_name(src)] tried to Diablerize [key_name(mob)] and was overtaken.")
							generation = clamp(generation + 1, 1, 13)
							death()
							if(diablerist_preferences)
								diablerist_preferences.generation = generation
								diablerist_preferences.reason_of_death = "Failed the Diablerie ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
						//successful diablerie
						else
							message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(mob)]")
							log_attack("[key_name(src)] successfully Diablerized [key_name(mob)].")
							if(diablerist_preferences)
								generation = clamp(generation - 1, 1, 13)
								diablerist_preferences.generation = generation
								diablerist_preferences.diablerist = TRUE
							diablerist = TRUE
							if(victim.client)
								victim.generation = clamp(victim.generation + 1, 1, 13)
								victim_preferences.generation = victim.generation
								var/datum/brain_trauma/special/imaginary_friend/trauma = gain_trauma(/datum/brain_trauma/special/imaginary_friend)
								trauma.friend.key = victim.key
							mob.death()
							if(victim_preferences)
								victim_preferences.reason_of_death = "Diablerized by [true_real_name ? true_real_name : real_name] ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
					if(client)
						client.images -= suckbar
					qdel(suckbar)
					return

			//feed on a human to death
			if(ishuman(mob) && !iskindred(mob))
				if(mob.stat != DEAD)
					if(isnpc(mob))
						var/mob/living/carbon/human/npc/Npc = mob
						Npc.last_attacker = null
						/*
						killed_count = killed_count + 1
						if(killed_count >= 5)
							GLOB.fuckers |= src
							SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
							to_chat(src, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
						*/
					SEND_SOUND(src, sound('code/modules/wod13/sounds/feed_failed.ogg', 0, 0, 75))
					to_chat(src, "<span class='warning'>This sad sacrifice for your own pleasure affects something deep in your mind.</span>")
					AdjustMasquerade(-1)
					AdjustHumanity(-1, 0)
					mob.death()

			//feed on a mob to death
			if(!ishuman(mob))
				if(mob.stat != DEAD)
					mob.death()

			stop_sound_channel(CHANNEL_BLOOD)
			last_drinkblood_use = 0
			if(client)
				client.images -= suckbar
			qdel(suckbar)
			return

		//repeat bloodsucking
		if(grab_state >= GRAB_PASSIVE)
			stop_sound_channel(CHANNEL_BLOOD)
			drinksomeblood(mob)
	else
		last_drinkblood_use = 0
		if(client)
			client.images -= suckbar
		qdel(suckbar)
		stop_sound_channel(CHANNEL_BLOOD)
		if(!(SEND_SIGNAL(mob, COMSIG_MOB_VAMPIRE_SUCKED, mob) & COMPONENT_RESIST_VAMPIRE_KISS))
			mob.SetSleeping(5 SECONDS)
