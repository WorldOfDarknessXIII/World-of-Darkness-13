/mob/living/carbon/proc/add_bite_animation()
	remove_overlay(BITE_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "bite", -BITE_LAYER)
	overlays_standing[BITE_LAYER] = bite_overlay
	apply_overlay(BITE_LAYER)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon, remove_overlay), BITE_LAYER), 1.5 SECONDS)

/mob/living/carbon/human/proc/bite(mob/living/victim)
	if (world.time < last_drinkblood_use + 3 SECONDS)
		return

	update_blood_hud()

	// Can't bite people if the mouth is covered
	if (is_mouth_covered())
		SEND_SOUND(src, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(src, span_warning("You can't bite people with your mouth covered!"))
		return

	// People who don't drink blood and ghouls not drinking Vitae are grossed out by this
	if ((!is_vtm(src) && !is_kuei_jin(src)) || (is_ghoul(src) && !is_kindred(victim)))
		SEND_SOUND(src, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(src, span_warning("Eww, drinking blood is <b>GROSS</b>."))
		return

	// Can't drink when there is no blood available, unless trying to Diablerize someone
	if ((victim.bloodpool <= 0) && !(is_kindred(src) && is_kindred(victim)))
		SEND_SOUND(src, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(src, span_warning("There is no <b>BLOOD</b> in [victim]"))
		return

	// Kindred can't drink from corpses unless they have the relevant trait
	if ((victim.stat == DEAD) && is_kindred(src) && !HAS_TRAIT(src, TRAIT_GULLET))
		SEND_SOUND(src, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(src, span_warning("[victim]'s dead blood can't feed you."))
		return

	// Check for consensual feeding
	if (HAS_TRAIT(src, TRAIT_CONSENSUAL_FEEDING_ONLY) && !victim.IsUnconscious())
		if (victim.client)
			to_chat(src, span_notice("You await [victim]'s consent before you drink..."))

			var/response = tgui_alert(victim, "Do you consent to being fed on by [src]?", "Feeding Confirmation", list("Yes", "No"))
			if (response != "Yes")
				to_chat(src, span_warning("[victim] rejects your attempt at feeding on [victim.p_them()]"))
				return
		else
			to_chat(src, span_warning("[victim] does not wish to be fed on. [victim.p_they(TRUE)] need[victim.p_s()] to be unconscious."))
			return

	// Display message for the biting
	if (HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
		playsound(src, 'code/modules/wod13/sounds/kiss.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		victim.visible_message(
			span_italics("<b>[src] kisses [victim]!</b>"),
			span_userlove("[src] kisses your neck!")
		)
	else
		playsound(src, 'code/modules/wod13/sounds/drinkblood1.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)
		victim.visible_message(
			span_danger("<b>[src] bites [src]'s neck!</b>"),
			span_userlove("[src] bites your neck!")
		)

		// Masquerade violation for obviously drinking blood
		if (CheckEyewitness(victim, src, 7, FALSE))
			AdjustMasquerade(-1)

	// Handle emotes depending on the nature of the feeding
	if (HAS_TRAIT(src, TRAIT_PAINFUL_VAMPIRE_KISS))
		victim.emote("scream")
	else if (HAS_TRAIT(src, TRAIT_CONSENSUAL_FEEDING_ONLY))
		victim.emote("moan")
	else
		victim.emote("groan")

	// Bite animation, only works for carbons due to overlay shenanigans
	if (iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		carbon_victim.add_bite_animation()

	// Actually drink blood
	drinksomeblood(victim)

/mob/living/carbon/human/proc/drinksomeblood(mob/living/victim)
	last_drinkblood_use = world.time

	// Store the drinker's splat
	var/datum/splat/vampire/kindred/vampirism = is_kindred(src)
	var/datum/splat/vampire/kindred/ghoul = is_ghoul(src)
	var/datum/splat/hungry_dead/kuei_jin/kuei_jin = is_kuei_jin(src)
	// Store if the victim is Kindred
	var/datum/splat/vampire/kindred/victim_vampirism = is_kindred(victim)
	// Store if the victim is an NPC
	var/mob/living/carbon/human/npc/NPC
	if (isnpc(victim))
		NPC = victim

	// Visual and audio effects for drinking blood
	if (client)
		// Create graphics visualising remaining boodpool of victim
		client.images -= suckbar
		qdel(suckbar)
		suckbar_loc = victim
		suckbar = image('code/modules/wod13/bloodcounter.dmi', suckbar_loc, "[round(14*(victim.bloodpool / victim.maxbloodpool))]", HUD_LAYER)
		suckbar.pixel_z = 40
		suckbar.plane = ABOVE_HUD_PLANE
		suckbar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		client.images += suckbar

		// Heartbeat sound effect while drinking blood
		var/sound/heartbeat = sound('code/modules/wod13/sounds/drinkblood2.ogg', repeat = TRUE)
		playsound_local(src, heartbeat, 75, 0, channel = CHANNEL_BLOOD, use_reverb = FALSE)

	// Initial Diablerie check, notify the drinker of what's about to happen
	if (victim.bloodpool <= 1)
		to_chat(src, span_warning("You feel small amount of <b>BLOOD</b> in your victim."))
		if (vampirism && victim_vampirism)
			to_chat(src, span_userdanger("<b>YOU TRY TO COMMIT DIABLERIE ON [victim].</b>"))

	// Prevent drinker from stopping if they have the relevant trait, or are drinking Vitae and addicted to it/it's especially tasty
	if (HAS_TRAIT(src, TRAIT_BLOODY_SUCKER) || (victim_vampirism && (HAS_TRAIT(src, TRAIT_VITAE_ADDICTION || HAS_TRAIT(victim, TRAIT_IRRESISTIBLE_VITAE)))))
		emote("moan")
		Stun(3 SECONDS, TRUE)

	// Immobilises the victim unless they can resist the effects or the vampire doesn't have a pleasurable Kiss
	var/drained_signal_return = SEND_SIGNAL(victim, COMSIG_MOB_VAMPIRE_SUCKED, src)
	if (!(drained_signal_return & COMPONENT_RESIST_VAMPIRE_KISS) && !HAS_TRAIT(src, TRAIT_PAINFUL_VAMPIRE_KISS))
		victim.Stun(3 SECONDS)

		// Pacify NPCs who fail to resist
		if (NPC)
			NPC.danger_source = null

	// 3 second timer to repeatedly drink blood
	if (!do_mob(src, victim, 3 SECONDS, timed_action_flags = NONE, progress = FALSE))
		last_drinkblood_use = 0

		if (client)
			client.images -= suckbar
		qdel(suckbar)
		stop_sound_channel(CHANNEL_BLOOD)

		var/sucked_signal_return = SEND_SIGNAL(victim, COMSIG_MOB_VAMPIRE_SUCKED, src)
		if (!(sucked_signal_return & COMPONENT_RESIST_VAMPIRE_KISS) && !HAS_TRAIT(src, TRAIT_PAINFUL_VAMPIRE_KISS))
			victim.SetSleeping(5 SECONDS)
		return

	// Do Masquerade violation unless the feeding is subtle
	if (!HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
		if (CheckEyewitness(src, src, 7, FALSE))
			AdjustMasquerade(-1)

	// Transfer a percentage of total reagents equal to percentage of bloodpool drank
	if (victim.reagents && length(victim.reagents.reagent_list) && (victim.bloodpool > 0) && prob(50))
		victim.reagents.trans_to(src, (1 / victim.bloodpool) * victim.reagents.total_volume, transfered_by = victim, methods = VAMPIRE)

	victim.bloodpool = clamp(victim.bloodpool - 1, 0, victim.maxbloodpool)
	victim.blood_volume = clamp(victim.blood_volume - 50, BLOOD_VOLUME_SURVIVE, BLOOD_VOLUME_NORMAL)

	suckbar.icon_state = "[round(14*(victim.bloodpool / victim.maxbloodpool))]"

	// Drain Chi through blood
	if (kuei_jin)
		if (victim.yang_chi > 0 || victim.yin_chi > 0)
			if (victim.yang_chi > victim.yin_chi)
				victim.yang_chi = clamp(victim.yang_chi - 1, 0, victim.max_yang_chi)
				yang_chi = clamp(yang_chi + 1, 0, max_yang_chi)
				to_chat(src, span_engradio("Some <b>Yang</b> Chi energy enters you..."))
			else
				victim.yin_chi = clamp(victim.yin_chi - 1, 0, victim.max_yin_chi)
				yin_chi = clamp(yin_chi + 1, 0, max_yin_chi)
				to_chat(src, span_medradio("Some <b>Yin</b> Chi energy enters you..."))
			COOLDOWN_START(victim, chi_restore, 30 SECONDS)
			update_chi_hud()
		else
			to_chat(src, span_warning("The <b>BLOOD</b> feels tasteless..."))

	// Inflict damage and extreme pain with the appropriate trait
	if (HAS_TRAIT(src, TRAIT_PAINFUL_VAMPIRE_KISS))
		victim.adjustBruteLoss(20, TRUE)
		victim.emote("scream")
		to_chat(victim, span_userdanger("IT HURTS!"))

	// Can't feed from poor people if they have a feeding restriction (to be improved)
	if (HAS_TRAIT(src, TRAIT_FEEDING_RESTRICTION) && victim.bloodquality < BLOOD_QUALITY_NORMAL)
		to_chat(src, span_warning("You are too privileged to drink that awful <b>BLOOD</b>. Go get something better."))
		visible_message(
			span_danger("[src] throws up!"),
			span_userdanger("You throw up!"),
			span_warning("Someone vomits!")
		)
		playsound(get_turf(src), 'code/modules/wod13/sounds/vomit.ogg', 75, TRUE)

		if (isturf(loc))
			add_splatter_floor(loc)
		stop_sound_channel(CHANNEL_BLOOD)
		if (client)
			client.images -= suckbar
		qdel(suckbar)

		return

	// Display flavour for how the blood feels to drink
	if (victim_vampirism)
		to_chat(src, span_userlove("[victim]'s blood tastes HEAVENLY..."))
	else
		to_chat(src, span_userlove("You sip some <b>delicious</b> blood from [victim]."))

	// If the drinker actually gained anything from feeding
	var/overfed = (bloodpool == maxbloodpool)

	// Add blood to the user, depending on quality of drank blood
	bloodpool = clamp(bloodpool + 1 * max(1, victim.bloodquality - 1), 0, maxbloodpool)

	// Drain the victim to death
	if (victim.bloodpool <= 0)
		if (vampirism && victim_vampirism) // Diablerize Kindred
			vampirism.diablerize(victim)
		else if (HAS_TRAIT(victim, TRAIT_CAN_TORPOR)) // Send undead into Torpor
			victim.torpor()
		else // Kill mortals
			// Handle NPC murder, with horrific "police assault" code
			if (NPC)
				NPC.last_attacker = null
				killed_count++
				if (killed_count >= 5)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
					to_chat(src, span_userdanger("<b>POLICE ASSAULT IN PROGRESS</b>"))

			SEND_SOUND(src, sound('code/modules/wod13/sounds/feed_failed.ogg', 0, 0, 75))

			AdjustMasquerade(-1)

			victim.blood_volume = 0
			victim.death()

			if (vampirism)
				// If the victim was someone who loves or trusts the drinker
				var/trusted_by_victim = ((victim.mind?.enslaved_to == src) || (Myself?.Lover?.owner == victim) || (Myself?.Friend?.owner == victim))

				// Different ways in which this could affect a Kindred's morality
				if (bloodpool <= 4) // Accidental violation by starvation
					to_chat(src, span_warning("This act of starvation withers a piece of your soul."))
					AdjustHumanity(-1, 5)
				if (HAS_TRAIT(src, TRAIT_IN_FRENZY)) // Impassioned violation by frenzy
					to_chat(src, span_warning("This accidental act of violation rots a piece of your soul."))
					AdjustHumanity(-1, 3)
				else if (!overfed) // Planned violation by regular feeding
					to_chat(src, span_warning("This sad sacrifice for your own survival rots something deep in your soul."))
					AdjustHumanity(-1, 2)
				else if (!trusted_by_victim)// Casual violation by overfeeding
					to_chat(src, span_danger("This sad sacrifice of a life for your own pleasure feeds the [span_bold("Beast.")]"))
					AdjustHumanity(-1, 1)
				else // Heinous violation of someone who trusted/loved the drinker
					to_chat(src, span_bolddanger("This heinous, needless violation of one who loved you empowers the Beast."))
					AdjustHumanity(-1, 0)

		if (client)
			client.images -= suckbar
		qdel(suckbar)
		stop_sound_channel(CHANNEL_BLOOD)
		return

	// Remove visual and audio effects
	last_drinkblood_use = 0
	if(client)
		client.images -= suckbar
	qdel(suckbar)
	stop_sound_channel(CHANNEL_BLOOD)

	// Continue drinking if they're still holding the victim
	if (grab_state >= GRAB_AGGRESSIVE)
		stop_sound_channel(CHANNEL_BLOOD)
		drinksomeblood(victim)
	else
		to_chat(src, span_warning("You need a better grip on [victim] to keep <b>feeding.</b>"))
