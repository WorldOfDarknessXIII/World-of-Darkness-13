//Here's things for future madness

//add_client_colour(/datum/client_colour/glass_colour/red)
//remove_client_colour(/datum/client_colour/glass_colour/red)
/client/Click(object,location,control,params)
	if(isatom(object))
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			if(H.in_frenzy)
				return
	..()

/mob/living/carbon/proc/rollfrenzy()
	if(client)
		var/mob/living/carbon/human/H
		if(ishuman(src))
			H = src

		if(isgarou(src) || iswerewolf(src))
			to_chat(src, "I'm full of <span class='danger'><b>ANGER</b></span>, and I'm about to flare up in <span class='danger'><b>RAGE</b></span>. Rolling...")
		else if(iskindred(src))
			to_chat(src, "I need <span class='danger'><b>BLOOD</b></span>. The <span class='danger'><b>BEAST</b></span> is calling. Rolling...")
		else if(iscathayan(src))
			to_chat(src, "My <span class='danger'><b>P'o</b></span> is awakening. Rolling...")
		else
			to_chat(src, "I'm too <span class='danger'><b>AFRAID</b></span> to continue doing this. Rolling...")
		SEND_SOUND(src, sound('code/modules/wod13/sounds/bloodneed.ogg', 0, 0, 50))
		var/check
		if(iscathayan(src))
			check = vampireroll(max(1, mind.dharma.Hun), min(10, (mind.dharma.level*2)-max_demon_chi), src)
		else
			check = vampireroll(max(1, round(humanity/2)), min(frenzy_chance_boost, frenzy_hardness), src)
		switch(check)
			if(DICE_FAILURE)
				enter_frenzymod()
				if(iskindred(src))
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 100*H.clane.frenzymod)
				else
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 100)
				frenzy_hardness = 1
			if(DICE_CRIT_FAILURE)
				enter_frenzymod()
				if(iskindred(src))
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 200*H.clane.frenzymod)
				else
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 200)
				frenzy_hardness = 1
			if(DICE_CRIT_WIN)
				frenzy_hardness = max(1, frenzy_hardness-1)
			else
				frenzy_hardness = min(10, frenzy_hardness+1)

/mob/living/carbon/proc/enter_frenzymod()
	SEND_SOUND(src, sound('code/modules/wod13/sounds/frenzy.ogg', 0, 0, 50))
	in_frenzy = TRUE
	add_client_colour(/datum/client_colour/glass_colour/red)
	demon_chi = 0
	GLOB.frenzy_list += src

/mob/living/carbon/proc/exit_frenzymod()
	in_frenzy = FALSE
	mind?.dharma?.Po_combat = FALSE
	remove_client_colour(/datum/client_colour/glass_colour/red)
	GLOB.frenzy_list -= src

/mob/living/carbon/proc/CheckFrenzyMove()
	if(stat >= SOFT_CRIT)
		return TRUE
	if(IsSleeping())
		return TRUE
	if(IsUnconscious())
		return TRUE
	if(IsParalyzed())
		return TRUE
	if(IsKnockdown())
		return TRUE
	if(IsStun())
		return TRUE
	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		return TRUE

/mob/living/carbon/proc/frenzystep()
	if(!isturf(loc) || CheckFrenzyMove())
		return
	if(m_intent == MOVE_INTENT_WALK)
		toggle_move_intent(src)
	set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))

	var/atom/fear
	for(var/obj/effect/fire/F in GLOB.fires_list)
		if(F)
			if(get_dist(src, F) < 7 && F.z == src.z)
				if(get_dist(src, F) < 6)
					fear = F
				if(get_dist(src, F) < 5)
					fear = F
				if(get_dist(src, F) < 4)
					fear = F
				if(get_dist(src, F) < 3)
					fear = F
				if(get_dist(src, F) < 2)
					fear = F
				if(get_dist(src, F) < 1)
					fear = F

//	if(!fear && !frenzy_target)
//		return

	if(iskindred(src))
		if(fear)
			step_away(src,fear,99)
			if(prob(25))
				emote("scream")
		else
			var/mob/living/carbon/human/H = src
			if(get_dist(frenzy_target, src) <= 1)
				if(isliving(frenzy_target))
					var/mob/living/L = frenzy_target
					if(L.bloodpool && L.stat != DEAD && last_drinkblood_use+95 <= world.time)
						L.grabbedby(src)
						if(ishuman(L))
							L.emote("scream")
							var/mob/living/carbon/human/BT = L
							BT.add_bite_animation()
						if(CheckEyewitness(L, src, 7, FALSE))
							H.AdjustMasquerade(-1)
						playsound(src, 'code/modules/wod13/sounds/drinkblood1.ogg', 50, TRUE)
						L.visible_message("<span class='warning'><b>[src] bites [L]'s neck!</b></span>", "<span class='warning'><b>[src] bites your neck!</b></span>")
						face_atom(L)
						H.drinksomeblood(L)
			else
				step_to(src,frenzy_target,0)
				face_atom(frenzy_target)
	else
		if(get_dist(frenzy_target, src) <= 1)
			if(isliving(frenzy_target))
				var/mob/living/L = frenzy_target
				if(L.stat != DEAD)
					a_intent = INTENT_HARM
					if(last_rage_hit+5 < world.time)
						last_rage_hit = world.time
						UnarmedAttack(L)
		else
			step_to(src,frenzy_target,0)
			face_atom(frenzy_target)

/mob/living/carbon/proc/get_frenzy_targets()
	var/list/targets = list()
	if(iskindred(src))
		for(var/mob/living/L in oviewers(7, src))
			if(!iskindred(L) && L.bloodpool && L.stat != DEAD)
				targets += L
				if(L == frenzy_target)
					return L
	else
		for(var/mob/living/L in oviewers(7, src))
			if(L.stat != DEAD)
				targets += L
				if(L == frenzy_target)
					return L
	if(length(targets) > 0)
		return pick(targets)
	else
		return null

/mob/living/carbon/proc/handle_automated_frenzy()
	for(var/mob/living/carbon/human/npc/NPC in viewers(5, src))
		NPC.Aggro(src)
	if(isturf(loc))
		frenzy_target = get_frenzy_targets()
		if(frenzy_target)
			var/datum/cb = CALLBACK(src, PROC_REF(frenzystep))
			var/reqsteps = SSfrenzypool.wait/total_multiplicative_slowdown()
			for(var/i in 1 to reqsteps)
				addtimer(cb, (i - 1)*total_multiplicative_slowdown())
		else
			if(!CheckFrenzyMove())
				if(isturf(loc))
					var/turf/T = get_step(loc, pick(NORTH, SOUTH, WEST, EAST))
					face_atom(T)
					Move(T)

/datum/species/kindred/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(H.clane?.name == "Baali")
		if(istype(get_area(H), /area/vtm/church))
			if(prob(25))
				to_chat(H, "<span class='warning'>You don't belong here!</span>")
				H.adjustFireLoss(20)
				H.adjust_fire_stacks(6)
				H.IgniteMob()
	//FIRE FEAR
	if(!H.antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
		var/fearstack = 0
		for(var/obj/effect/fire/F in GLOB.fires_list)
			if(F)
				if(get_dist(F, H) < 8 && F.z == H.z)
					fearstack += F.stage
		for(var/mob/living/carbon/human/U in viewers(7, H))
			if(U.on_fire)
				fearstack += 1

		fearstack = min(fearstack, 10)

		if(fearstack)
			if(prob(fearstack*5))
				H.do_jitter_animation(10)
				if(fearstack > 20)
					if(prob(fearstack))
						if(!H.in_frenzy)
							H.rollfrenzy()
			if(!H.has_status_effect(STATUS_EFFECT_FEAR))
				H.apply_status_effect(STATUS_EFFECT_FEAR)
		else
			H.remove_status_effect(STATUS_EFFECT_FEAR)

	//masquerade violations due to unnatural appearances
	if(H.is_face_visible() && H.clane?.violating_appearance)
		switch(H.clane.alt_sprite)
			if ("kiasyd")
				//masquerade breach if eyes are uncovered, short range
				if (!H.is_eyes_covered())
					if (H.CheckEyewitness(H, H, 3, FALSE))
						H.AdjustMasquerade(-1)
			if ("rotten3")
				//slightly less range than if fully decomposed
				if (H.CheckEyewitness(H, H, 5, FALSE))
					H.AdjustMasquerade(-1)
			else
				//gargoyles, nosferatu, skeletons, that kind of thing
				if (H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)

	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.AdjustMasquerade(-1)
	if(HAS_TRAIT(H, TRAIT_NONMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.AdjustMasquerade(-1)
	if(istype(get_area(H), /area/vtm))
		var/area/vtm/V = get_area(H)
		if(V.zone_type == "masquerade" && V.upper)
			if(H.pulling)
				if(ishuman(H.pulling))
					var/mob/living/carbon/human/pull = H.pulling
					if(pull.stat == DEAD)
						var/obj/item/card/id/id_card = H.get_idcard(FALSE)
						if(!istype(id_card, /obj/item/card/id/clinic))
							if(H.CheckEyewitness(H, H, 7, FALSE))
								if(H.last_loot_check+50 <= world.time)
									H.last_loot_check = world.time
									H.last_nonraid = world.time
									H.killed_count = H.killed_count+1
									if(!H.warrant && !H.ignores_warrant)
										if(H.killed_count >= 5)
											H.warrant = TRUE
											SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
										else
											SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (corpse)</b></span>")
			for(var/obj/item/I in H.contents)
				if(I)
					if(I.masquerade_violating)
						if(I.loc == H)
							var/obj/item/card/id/id_card = H.get_idcard(FALSE)
							if(!istype(id_card, /obj/item/card/id/clinic))
								if(H.CheckEyewitness(H, H, 7, FALSE))
									if(H.last_loot_check+50 <= world.time)
										H.last_loot_check = world.time
										H.last_nonraid = world.time
										H.killed_count = H.killed_count+1
										if(!H.warrant && !H.ignores_warrant)
											if(H.killed_count >= 5)
												H.warrant = TRUE
												SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
												to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
											else
												SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
												to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (equipment)</b></span>")
	if(H.hearing_ghosts)
		H.bloodpool = max(0, H.bloodpool-1)
		to_chat(H, "<span class='warning'>Necromancy Vision reduces your blood points too sustain itself.</span>")

	if(H.clane?.name == "Tzimisce" || H.clane?.name == "Old Clan Tzimisce")
		var/datum/vampireclane/tzimisce/TZ = H.clane
		if(TZ.heirl)
			if(!(TZ.heirl in H.GetAllContents()))
				if(prob(5))
					to_chat(H, "<span class='warning'>You are missing your home soil...</span>")
					H.bloodpool = max(0, H.bloodpool-1)
	if(H.clane?.name == "Kiasyd")
		var/datum/vampireclane/kiasyd/kiasyd = H.clane
		for(var/obj/item/I in H.contents)
			if(I?.is_iron)
				if (COOLDOWN_FINISHED(kiasyd, cold_iron_frenzy))
					COOLDOWN_START(kiasyd, cold_iron_frenzy, 10 SECONDS)
					H.rollfrenzy()
					to_chat(H, "<span class='warning'>[I] is <b>COLD IRON</b>!")

/*
	if(!H in GLOB.masquerade_breakers_list)
		if(H.masquerade < 4)
			GLOB.masquerade_breakers_list += H
	else if(H in GLOB.masquerade_breakers_list)
		if(H.masquerade > 3)
			GLOB.masquerade_breakers_list -= H
*/

	if(H.key && (H.stat <= HARD_CRIT))
		var/datum/preferences/P = GLOB.preferences_datums[ckey(H.key)]
		if(P)
			if(P.humanity != H.humanity)
				P.humanity = H.humanity
				P.save_preferences()
				P.save_character()
			if(P.masquerade != H.masquerade)
				P.masquerade = H.masquerade
				P.save_preferences()
				P.save_character()
//			if(H.last_experience+600 <= world.time)
//				var/addd = 5
//				if(!H.JOB && H.mind)
//					H.JOB = SSjob.GetJob(H.mind.assigned_role)
//					if(H.JOB)
//						addd = H.JOB.experience_addition
//				P.exper = min(calculate_mob_max_exper(H), P.exper+addd+H.experience_plus)
//				if(P.exper == calculate_mob_max_exper(H))
//					to_chat(H, "You've reached a new level! You can add new points in Character Setup (Lobby screen).")
//				P.save_preferences()
//				P.save_character()
//				H.last_experience = world.time
//			if(H.roundstart_vampire)
//				if(P.generation != H.generation)
//					P.generation = H.generation
//					P.save_preferences()
//					P.save_character()
			if(!H.antifrenzy)
				if(P.humanity < 1)
					H.enter_frenzymod()
					to_chat(H, "<span class='userdanger'>You have lost control of the Beast within you, and it has taken your body. Be more [H.client.prefs.enlightenment ? "Enlightened" : "humane"] next time.</span>")
					H.ghostize(FALSE)
					P.reason_of_death = "Lost control to the Beast ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."

	if(H.clane && !H.antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
		if(H.clane.name == "Banu Haqim")
			if(H.mind)
				if(H.mind.enslaved_to)
					if(get_dist(H, H.mind.enslaved_to) > 10)
						if((H.last_frenzy_check + 40 SECONDS) <= world.time)
							to_chat(H, "<span class='warning'><b>As you are far from [H.mind.enslaved_to], you feel the desire to drink more vitae!<b></span>")
							H.last_frenzy_check = world.time
							H.rollfrenzy()
					else if(H.bloodpool > 1 || H.in_frenzy)
						H.last_frenzy_check = world.time
		else
			if(H.bloodpool > 1 || H.in_frenzy)
				H.last_frenzy_check = world.time

//	var/list/blood_fr = list()
//	for(var/obj/effect/decal/cleanable/blood/B in range(7, src))
//		if(B.bloodiness)
//			blood_fr += B
	if(!H.antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
		if(H.bloodpool <= 1 && !H.in_frenzy)
			if((H.last_frenzy_check + 40 SECONDS) <= world.time)
				H.last_frenzy_check = world.time
				H.rollfrenzy()
				if(H.clane)
					if(H.clane.enlightenment)
						if(!H.CheckFrenzyMove())
							H.AdjustHumanity(1, 10)
//	if(length(blood_fr) >= 10 && !H.in_frenzy)
//		if(H.last_frenzy_check+400 <= world.time)
//			H.last_frenzy_check = world.time
//			H.rollfrenzy()
