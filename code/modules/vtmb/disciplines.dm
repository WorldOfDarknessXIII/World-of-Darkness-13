/atom/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/Z = user
		if(Z.auspex_examine)
			if(!isturf(src) && !isobj(src) && !ismob(src))
				return
			var/list/fingerprints = list()
			var/list/blood = return_blood_DNA()
			var/list/fibers = return_fibers()
			var/list/reagents = list()

			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				if(!H.gloves)
					fingerprints += md5(H.dna.uni_identity)

			else if(!ismob(src))
				fingerprints = return_fingerprints()


				if(isturf(src))
					var/turf/T = src
					// Only get reagents from non-mobs.
					if(T.reagents && T.reagents.reagent_list.len)

						for(var/datum/reagent/R in T.reagents.reagent_list)
							T.reagents[R.name] = R.volume

							// Get blood data from the blood reagent.
							if(istype(R, /datum/reagent/blood))

								if(R.data["blood_DNA"] && R.data["blood_type"])
									var/blood_DNA = R.data["blood_DNA"]
									var/blood_type = R.data["blood_type"]
									LAZYINITLIST(blood)
									blood[blood_DNA] = blood_type
				if(isobj(src))
					var/obj/T = src
					// Only get reagents from non-mobs.
					if(T.reagents && T.reagents.reagent_list.len)

						for(var/datum/reagent/R in T.reagents.reagent_list)
							T.reagents[R.name] = R.volume

							// Get blood data from the blood reagent.
							if(istype(R, /datum/reagent/blood))

								if(R.data["blood_DNA"] && R.data["blood_type"])
									var/blood_DNA = R.data["blood_DNA"]
									var/blood_type = R.data["blood_type"]
									LAZYINITLIST(blood)
									blood[blood_DNA] = blood_type

			// We gathered everything. Create a fork and slowly display the results to the holder of the scanner.

			var/found_something = FALSE

			// Fingerprints
			if(length(fingerprints))
				to_chat(user, "<span class='info'><B>Prints:</B></span>")
				for(var/finger in fingerprints)
					to_chat(user, "[finger]")
				found_something = TRUE

			// Blood
			if (length(blood))
				to_chat(user, "<span class='info'><B>Blood:</B></span>")
				found_something = TRUE
				for(var/B in blood)
					to_chat(user, "Type: <font color='red'>[blood[B]]</font> DNA (UE): <font color='red'>[B]</font>")

			//Fibers
			if(length(fibers))
				to_chat(user, "<span class='info'><B>Fibers:</B></span>")
				for(var/fiber in fibers)
					to_chat(user, "[fiber]")
				found_something = TRUE

			//Reagents
			if(length(reagents))
				to_chat(user, "<span class='info'><B>Reagents:</B></span>")
				for(var/R in reagents)
					to_chat(user, "Reagent: <font color='red'>[R]</font> Volume: <font color='red'>[reagents[R]]</font>")
				found_something = TRUE

			if(!found_something)
				to_chat(user, "<I># No forensic traces found #</I>") // Don't display this to the holder user
			return

/datum/movespeed_modifier/temporis5
	multiplicative_slowdown = -2.5

/datum/movespeed_modifier/wing
	multiplicative_slowdown = -0.25

/datum/movespeed_modifier/temporis
	multiplicative_slowdown = 7.5

/mob/living/carbon/human/proc/walk_to_caster(mob/living/step_to)
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_to(src, step_to, 0)
		face_atom(step_to)

/mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_away(src, step_from, 99)
		face_atom(step_from)

/mob/living/carbon/human/proc/attack_myself_command()
	if(!CheckFrenzyMove())
		a_intent = INTENT_HARM
		var/obj/item/I = get_active_held_item()
		if(I)
			if(I.force)
				ClickOn(src)
			else
				drop_all_held_items()
				ClickOn(src)
		else
			ClickOn(src)

/datum/discipline/melpominee
	name = "Melpominee"
	desc = "Named for the Greek Muse of Tragedy, Melpominee is a unique discipline of the Daughters of Cacophony. It explores the power of the voice, shaking the very soul of those nearby and allowing the vampire to perform sonic feats otherwise impossible."
	icon_state = "melpominee"
	/*
	cost = 1
	ranged = TRUE
	delay = 75
	violates_masquerade = FALSE
	activate_sound = 'code/modules/wod13/sounds/melpominee.ogg'
	clan_restricted = TRUE
	dead_restricted = FALSE
	*/

/*

/datum/discipline/melpominee/activate(mob/living/target, mob/living/carbon/human/owner)
	. = ..()
	switch(level_casting)
		if(5)
			playsound(owner.loc, 'code/modules/wod13/sounds/killscream.ogg', 100, FALSE)
			for(var/mob/living/carbon/human/HU in oviewers(7, owner))
				if(HU)
					HU.Stun(20)
					HU.apply_damage(50, BRUTE, BODY_ZONE_HEAD)
					HU.remove_overlay(MUTATIONS_LAYER)
					var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
					HU.overlays_standing[MUTATIONS_LAYER] = song_overlay
					HU.apply_overlay(MUTATIONS_LAYER)
					spawn(20)
						if(HU)
							HU.remove_overlay(MUTATIONS_LAYER)
	*/


/datum/discipline/temporis
	name = "Temporis"
	desc = "Temporis is a Discipline unique to the True Brujah. Supposedly a refinement of Celerity, Temporis grants the Cainite the ability to manipulate the flow of time itself."
	icon_state = "temporis"
	/*
	cost = 1
	ranged = TRUE
	delay = 50
	violates_masquerade = FALSE
	activate_sound = 'code/modules/wod13/sounds/temporis.ogg'
	clan_restricted = TRUE
	dead_restricted = FALSE
	var/current_cycle = 0
	var/datum/component/temporis_target


#define TEMPORIS_ATTACK_SPEED_MODIFIER 0.25

/obj/effect/temporis
	name = "Za Warudo"
	desc = "..."
	anchored = 1

/obj/effect/temporis/Initialize()
	. = ..()
	spawn(5)
		qdel(src)

/mob/living/carbon/human/Move(atom/newloc, direct, glide_size_override)
	..()
	if(temporis_visual)
		var/obj/effect/temporis/T = new(loc)
		T.name = name
		T.appearance = appearance
		T.dir = dir
		animate(T, pixel_x = rand(-32,32), pixel_y = rand(-32,32), alpha = 255, time = 10)
		if(CheckEyewitness(src, src, 7, FALSE))
			AdjustMasquerade(-1)
	else if(temporis_blur)
		var/obj/effect/temporis/T = new(loc)
		T.name = name
		T.appearance = appearance
		T.dir = dir
		animate(T, pixel_x = rand(-32,32), pixel_y = rand(-32,32), alpha = 155, time = 5)
		if(CheckEyewitness(src, src, 7, FALSE))
			AdjustMasquerade(-1)

/datum/discipline/temporis/activate(mob/living/target, mob/living/carbon/human/owner)
	. = ..()
	if (owner.celerity_visual) //no using two time powers at once
		to_chat(owner, "<span class='userdanger'>You try to manipulate your temporal field, but Celerity causes it to slip out of your grasp!</span>")
		owner.emote("scream")
		spawn(3 SECONDS)
			owner.gib()
		return
	switch(level_casting)
		if(1)
			to_chat(owner, "<b>[SScity_time.timeofnight]</b>")
			owner.adjust_blood_points(1)
		if(2)
			target.AddComponent(/datum/component/dejavu, rewinds = 4, interval = 2 SECONDS)
		if(3)
			to_chat(target, "<span class='userdanger'><b>Slow down.</b></span>")
			target.add_movespeed_modifier(/datum/movespeed_modifier/temporis)
			spawn(10 SECONDS)
				if(target)
					target.remove_movespeed_modifier(/datum/movespeed_modifier/temporis)
		if(4)
			to_chat(owner, "<b>Use the second Temporis button at the bottom of the screen to cast this level of Temporis.</b>")
			owner.adjust_blood_points(1)
		if(5)
			to_chat(owner, "<b>Use the third Temporis button at the bottom of the screen to cast this level of Temporis.</b>")
			owner.adjust_blood_points(1)
	*/
