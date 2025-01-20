/mob/living
	var/datum/action/discipline/discipline_ranged

/datum/action/discipline
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	button_icon = 'code/modules/wod13/UI/actions.dmi' //This is the file for the BACKGROUND icon
	background_icon_state = "discipline" //And this is the state for the background icon

	icon_icon = 'code/modules/wod13/UI/actions.dmi' //This is the file for the ACTION icon
	button_icon_state = "discipline" //And this is the state for the action icon
	vampiric = TRUE
	var/level_icon_state = "1" //And this is the state for the action icon
	var/datum/discipline/discipline
	var/active_check = FALSE

/datum/action/discipline/Trigger()
	if(discipline && isliving(owner))
		var/mob/living/owning = owner
		if(discipline.ranged)
			if(!active_check)
				active_check = TRUE
				if(owning.discipline_ranged)
					owning.discipline_ranged.Trigger()
				owning.discipline_ranged = src
				if(button)
					button.color = "#970000"
			else
				active_check = FALSE
				owning.discipline_ranged = null
				button.color = "#ffffff"
		else
			if(discipline)
				if(discipline.check_activated(owner, owner))
					discipline.activate(owner, owner)
	. = ..()

/datum/action/discipline/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(owner)
		if(owner.client)
			if(owner.client.prefs)
				if(owner.client.prefs.old_discipline)
					button_icon = 'code/modules/wod13/disciplines.dmi'
					icon_icon = 'code/modules/wod13/disciplines.dmi'
				else
					button_icon = 'code/modules/wod13/UI/actions.dmi'
					icon_icon = 'code/modules/wod13/UI/actions.dmi'
	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays(TRUE)
		if(discipline)
			current_button.name = discipline.name
			current_button.desc = discipline.desc
			current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.icon_state]"))
			current_button.button_icon_state = "[discipline.icon_state]"
			if(discipline.leveled)
				current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.level_casting]"))
		else
			current_button.add_overlay(mutable_appearance(icon_icon, button_icon_state))
			current_button.button_icon_state = button_icon_state

/datum/action/discipline/proc/switch_level()
	SEND_SOUND(owner, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))
	if(discipline)
		if(discipline.level_casting < discipline.level)
			discipline.level_casting = discipline.level_casting+1
			if(button)
				ApplyIcon(button, TRUE)
			return
		else
			discipline.level_casting = 1
			if(button)
				ApplyIcon(button, TRUE)
			return

/mob/living/Click()
	if(isliving(usr) && usr != src)
		var/mob/living/L = usr
		if(L.discipline_ranged)
			L.discipline_ranged.active_check = FALSE
			if(L.discipline_ranged.button)
				animate(L.discipline_ranged.button, color = "#ffffff", time = 10, loop = 1)
			if(L.discipline_ranged.discipline.check_activated(src, usr))
				L.discipline_ranged.discipline.activate(src, usr)
			L.discipline_ranged = null
	. = ..()

//			if(DISCP)
//				if(DISCP.active)
//					DISCP.range_activate(src, SH)
//					SH.face_atom(src)
//					return

/atom/movable/screen/movable/action_button/Click(location,control,params)
	if(istype(linked_action, /datum/action/discipline))
		var/list/modifiers = params2list(params)
		if(LAZYACCESS(modifiers, "right"))
			var/datum/action/discipline/D = linked_action
			D.switch_level()
			return
	. = ..()

/datum/discipline
	///Name of this Discipline.
	var/name = "Vampiric Discipline"
	///Text description of this Discipline.
	var/desc = "Discipline with powers such as..."
	///Icon for this Discipline as in disciplines.dmi
	var/icon_state
	///Cost in blood points of activating this Discipline.
	var/cost = 2
	///Whether this Discipline is ranged.
	var/ranged = FALSE
	///The range from which this Discipline can be used on a target.
	var/range_sh = 8
	///Duration of the Discipline.
	var/delay = 5
	///Whether this Discipline causes a Masquerade breach when used in front of mortals.
	var/violates_masquerade = FALSE
	///What rank, or how many dots the caster has in this Discipline.
	var/level = 1
	var/leveled = TRUE
	///The sound that plays when any power of this Discipline is activated.
	var/activate_sound = 'code/modules/wod13/sounds/bloodhealing.ogg'
	///Whether this Discipline's cooldowns are multipled by the level it's being casted at.
	var/leveldelay = FALSE
	///Whether this Discipline aggroes NPC targets.
	var/fearless = FALSE

	///What rank of this Discipline is currently being casted.
	var/level_casting = 1
	///Whether this Discipline is exclusive to one Clan.
	var/clane_restricted = FALSE
	///Whether this Discipline is restricted from affecting dead people.
	var/dead_restricted = TRUE

	var/next_fire_after = 0

/datum/discipline/proc/post_gain(var/mob/living/carbon/human/H)
	return

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

/datum/discipline/proc/check_activated(var/mob/living/target, var/mob/living/carbon/human/caster)
	if(caster.stat >= HARD_CRIT || caster.IsSleeping() || caster.IsUnconscious() || caster.IsParalyzed() || caster.IsStun() || HAS_TRAIT(caster, TRAIT_RESTRAINED) || !isturf(caster.loc))
		return FALSE
	var/plus = 0
	if(HAS_TRAIT(caster, TRAIT_HUNGRY))
		plus = 1
	if(caster.bloodpool < cost+plus)
		SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(caster, "<span class='warning'>You don't have enough <b>BLOOD</b> to use this discipline.</span>")
		return FALSE
	if(world.time < next_fire_after)
		to_chat(caster, "<span class='warning'>It's too soon to use this discipline again!</span>")
		return FALSE
	if(target.stat == DEAD && dead_restricted)
		return FALSE
	if(ranged)
		if(get_dist(caster, target) > range_sh)
			return FALSE
	if(HAS_TRAIT(caster, TRAIT_PACIFISM))
		return FALSE
	if(target.resistant_to_disciplines || target.spell_immunity)
		to_chat(caster, "<span class='danger'>[target] resists your powers!</span>")
		return FALSE
	caster.bloodpool = max(0, caster.bloodpool-(cost+plus))
	caster.update_blood_hud()
	if(ranged)
		to_chat(caster, "<span class='notice'>You activate [name] on [target].</span>")
	else
		to_chat(caster, "<span class='notice'>You activate [name].</span>")
	if(ranged)
		if(isnpc(target) && !fearless)
			var/mob/living/carbon/human/npc/NPC = target
			NPC.Aggro(caster, TRUE)
	if(activate_sound)
		caster.playsound_local(caster, activate_sound, 50, FALSE)
//	if(caster.key)
//		var/datum/preferences/P = GLOB.preferences_datums[ckey(caster.key)]
//		if(P)
//			if(!HAS_TRAIT(caster, TRAIT_NON_INT))
//				P.exper = min(calculate_mob_max_exper(caster), P.exper+10+caster.experience_plus)
//			P.save_preferences()
//			P.save_character()
	if(violates_masquerade)
		if(caster.CheckEyewitness(target, caster, 7, TRUE))
			caster.AdjustMasquerade(-1)
	return TRUE

/datum/discipline/proc/activate(mob/living/target, mob/living/carbon/human/caster)
	if(!target)
		return
	if(!caster)
		return

	if(leveldelay)
		next_fire_after = world.time+delay*level_casting
	else
		next_fire_after = world.time+delay

	log_attack("[key_name(caster)] casted level [src.level_casting] of the Discipline [src.name][target == caster ? "." : " on [key_name(target)]"]")

/datum/discipline/animalism
	name = "Animalism"
	desc = "Summons Spectral Animals over your targets. Violates Masquerade."
	icon_state = "animalism"
	cost = 1
	delay = 8 SECONDS
	ranged = FALSE
	violates_masquerade = TRUE
	activate_sound = 'code/modules/wod13/sounds/wolves.ogg'
	dead_restricted = FALSE
	var/obj/effect/proc_holder/spell/targeted/shapeshift/animalism/AN

/obj/effect/spectral_wolf
	name = "Spectral Wolf"
	desc = "Bites enemies in other dimensions."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "wolf"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/proc_holder/spell/targeted/shapeshift/animalism
	name = "Animalism Form"
	desc = "Take on the shape a rat."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/pet/rat

/datum/discipline/animalism/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	if(!AN)
		AN = new(caster)
	var/limit = min(2, level) + caster.social + caster.more_companions - 1
	if(length(caster.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(caster.beastmaster)
		B.death()
	switch(level_casting)
		if(1)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/rat/R = new(get_turf(caster))
			R.my_creator = caster
			caster.beastmaster |= R
			R.beastmaster = caster
		if(2)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/cat/C = new(get_turf(caster))
			C.my_creator = caster
			caster.beastmaster |= C
			C.beastmaster = caster
		if(3)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/D = new(get_turf(caster))
			D.my_creator = caster
			caster.beastmaster |= D
			D.beastmaster = caster
		if(4)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/rat/flying/F = new(get_turf(caster))
			F.my_creator = caster
			caster.beastmaster |= F
			F.beastmaster = caster
		if(5)
			AN.Shapeshift(caster)
//			caster.dna.species.attack_verb = "slash"
//			caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//			caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+20
//			caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+20
//			caster.add_movespeed_modifier(/datum/movespeed_modifier/protean3)
//			caster.remove_overlay(PROTEAN_LAYER)
//			caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//			caster.apply_overlay(PROTEAN_LAYER)
			spawn(20 SECONDS + caster.discipline_time_plus)
				if(caster && caster.stat != DEAD)
					AN.Restore(AN.myshape)
					caster.Stun(1.5 SECONDS)

/datum/discipline/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	cost = 1
	ranged = FALSE
	delay = 5 SECONDS
	leveldelay = TRUE

/datum/discipline/auspex/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	var/sound/auspexbeat = sound('code/modules/wod13/sounds/auspex.ogg', repeat = TRUE)
	caster.playsound_local(caster, auspexbeat, 75, 0, channel = CHANNEL_DISCIPLINES, use_reverb = FALSE)
	ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	var/loh = FALSE
	if(!HAS_TRAIT(caster, TRAIT_NIGHT_VISION))
		ADD_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
		loh = TRUE
	caster.update_sight()
	caster.add_client_colour(/datum/client_colour/glass_colour/lightblue)
	var/shitcasted = FALSE
	if(level_casting >= 2)
		var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
		abductor_hud.add_hud_to(caster)
	if(level_casting >= 3)
		var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		health_hud.add_hud_to(caster)
	if(level_casting >= 4)
		caster.auspex_examine = TRUE
	if(level_casting >= 5)
		caster.ghostize(TRUE, FALSE, TRUE)
		caster.soul_state = SOUL_PROJECTING

	spawn((delay*level_casting)+caster.discipline_time_plus)
		if(caster)
			if(shitcasted)
				GLOB.auspex_list -= caster
			caster.auspex_examine = FALSE
			caster.see_invisible = initial(caster.see_invisible)
			var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
			abductor_hud.remove_hud_from(caster)
			var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
			health_hud.remove_hud_from(caster)
			caster.stop_sound_channel(CHANNEL_DISCIPLINES)
			caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/auspex_deactivate.ogg', 50, FALSE)
			REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
			if(loh)
				REMOVE_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
			caster.remove_client_colour(/datum/client_colour/glass_colour/lightblue)
			caster.update_sight()

/datum/discipline/celerity
	name = "Celerity"
	desc = "Boosts your speed. Violates Masquerade."
	icon_state = "celerity"
	cost = 1
	ranged = FALSE
	delay = 7.5 SECONDS
	violates_masquerade = FALSE
	activate_sound = 'code/modules/wod13/sounds/celerity_activate.ogg'
	leveldelay = TRUE

/obj/effect/celerity
	name = "Damn"
	desc = "..."
	anchored = 1

/obj/effect/celerity/Initialize()
	. = ..()
	spawn(0.5 SECONDS)
		qdel(src)

/mob/living/carbon/human/Move(atom/newloc, direct, glide_size_override)
	..()
	if(celerity_visual)
		var/obj/effect/celerity/C = new(loc)
		C.name = name
		C.appearance = appearance
		C.dir = dir
		animate(C, pixel_x = rand(-16, 16), pixel_y = rand(-16, 16), alpha = 0, time = 5)
		if(CheckEyewitness(src, src, 7, FALSE))
			AdjustMasquerade(-1)

/datum/movespeed_modifier/celerity
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/celerity2
	multiplicative_slowdown = -0.75

/datum/movespeed_modifier/celerity3
	multiplicative_slowdown = -1

/datum/movespeed_modifier/celerity4
	multiplicative_slowdown = -1.25

/datum/movespeed_modifier/celerity5
	multiplicative_slowdown = -1.5

/datum/movespeed_modifier/temporis5
	multiplicative_slowdown = -2.5

/datum/movespeed_modifier/wing
	multiplicative_slowdown = -0.25

/datum/movespeed_modifier/dominate
	multiplicative_slowdown = 5

/datum/movespeed_modifier/temporis
	multiplicative_slowdown = 7.5

/datum/discipline/celerity/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	if (caster.temporis_visual || caster.temporis_blur) //sorry guys, no using two time powers at once
		to_chat(caster, "<span class='userdanger'>Your active Temporis causes Celerity to wrench your body's temporal field apart!</span>")
		caster.emote("scream")
		spawn(3 SECONDS)
			caster.gib()
		return
	switch(level_casting)
		if(1)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity)
			caster.celerity_visual = TRUE
			spawn((delay*level_casting)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity)
					caster.celerity_visual = FALSE
		if(2)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity2)
			caster.celerity_visual = TRUE
			spawn((delay*level_casting)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity2)
					caster.celerity_visual = FALSE
		if(3)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity3)
			caster.celerity_visual = TRUE
			spawn((delay*level_casting)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity3)
					caster.celerity_visual = FALSE
		if(4)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity4)
			caster.celerity_visual = TRUE
			spawn((delay*level_casting)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity4)
					caster.celerity_visual = FALSE
		if(5)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity5)
			caster.celerity_visual = TRUE
			spawn((delay*level_casting)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity5)
					caster.celerity_visual = FALSE

/datum/discipline/dominate
	name = "Dominate"
	desc = "Supresses will of your targets and forces them to obey you, if their will is not more powerful than yours."
	icon_state = "dominate"
	cost = 1
	ranged = TRUE
	delay = 15 SECONDS
	activate_sound = 'code/modules/wod13/sounds/dominate.ogg'
	fearless = TRUE

/datum/discipline/dominate/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	if(target.spell_immunity)
		return
	var/mypower = caster.get_total_social()
	var/theirpower = target.get_total_mentality()
	var/dominate_me = FALSE
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.clane)
			if(H.clane.name == "Gargoyle")
				dominate_me = TRUE
	if(((theirpower >= mypower) || (caster.generation > target.generation)) && !dominate_me)
		to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to dominate!</span>")
		return
	if(HAS_TRAIT(caster, TRAIT_MUTE))
		to_chat(caster, "<span class='warning'>You find yourself unable to speak!</span>")
		return
	var/mob/living/carbon/human/TRGT
	if(ishuman(target))
		TRGT = target
		TRGT.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/dominate_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dominate", -MUTATIONS_LAYER)
		dominate_overlay.pixel_z = 2
		TRGT.overlays_standing[MUTATIONS_LAYER] = dominate_overlay
		TRGT.apply_overlay(MUTATIONS_LAYER)
	switch(level_casting)
		if(1)
			to_chat(target, "<span class='userdanger'><b>FORGET ABOUT IT</b></span>")
			caster.say("FORGET ABOUT IT!!")
			ADD_TRAIT(target, TRAIT_BLIND, "dominate")
			spawn(30)
				if(target)
					REMOVE_TRAIT(target, TRAIT_BLIND, "dominate")
		if(2)
			target.Immobilize(5)
			if(target.body_position == STANDING_UP)
				to_chat(target, "<span class='userdanger'><b>GET DOWN</b></span>")
				target.toggle_resting()
				caster.say("GET DOWN!!")
			else
				to_chat(target, "<span class='userdanger'><b>STAY DOWN</b></span>")
				caster.say("STAY DOWN!!")
		if(3)
			to_chat(target, "<span class='userdanger'><b>THINK TWICE</b></span>")
			caster.say("THINK TWICE!!")
			target.add_movespeed_modifier(/datum/movespeed_modifier/dominate)
			spawn(30)
				if(target)
					target.remove_movespeed_modifier(/datum/movespeed_modifier/dominate)
		if(4)
			to_chat(target, "<span class='userdanger'><b>THINK TWICE</b></span>")
			caster.say("THINK TWICE!!")
			target.add_movespeed_modifier(/datum/movespeed_modifier/dominate)
			spawn(60)
				if(target)
					target.remove_movespeed_modifier(/datum/movespeed_modifier/dominate)
		if(5)
			if(!target.spell_immunity)
				to_chat(target, "<span class='userdanger'><b>YOU SHOULD HARM YOURSELF NOW</b></span>")
				caster.say("YOU SHOULD HARM YOURSELF NOW!!")
				var/datum/cb = CALLBACK(TRGT,/mob/living/carbon/human/proc/attack_myself_command)
				for(var/i in 1 to 20)
					addtimer(cb, (i - 1)*15)
	spawn(2 SECONDS)
		if(TRGT)
			TRGT.remove_overlay(MUTATIONS_LAYER)

/datum/discipline/dementation
	name = "Dementation"
	desc = "Makes all humans in radius mentally ill for a moment, supressing their defending ability."
	icon_state = "dementation"
	cost = 2
	ranged = TRUE
	delay = 10 SECONDS
	activate_sound = 'code/modules/wod13/sounds/insanity.ogg'
	clane_restricted = TRUE

/proc/dancefirst(mob/living/M)
	if(M.dancing)
		return
	M.dancing = TRUE
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 75)
		if (!M)
			return
		switch(i)
			if (1 to 15)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (16 to 30)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (31 to 45)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (46 to 60)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (61 to 75)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(0.1 SECONDS)
	M.lying_fix()
	M.dancing = FALSE

/proc/dancesecond(mob/living/M)
	if(M.dancing)
		return
	M.dancing = TRUE
	animate(M, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 60)
		if (!M)
			return
		if (i<31)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		if (i>30)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,-1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(0.1 SECONDS)
	M.lying_fix()
	M.dancing = FALSE

/datum/discipline/dementation/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	//1 - instant laugh
	//2 - hallucinations and less damage
	//3 - victim dances
	//4 - victim fake dies
	//5 - victim starts to attack themself
	if(target.spell_immunity)
		return
	var/mypower = caster.get_total_social()
	var/theirpower = target.get_total_mentality()
	if(theirpower >= mypower)
		to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to corrupt!</span>")
		return
	if(!ishuman(target))
		to_chat(caster, "<span class='warning'>[target] doesn't have enough mind to get affected by this discipline!</span>")
		return
	var/mob/living/carbon/human/H = target
	H.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
	dementation_overlay.pixel_z = 1
	H.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
	H.apply_overlay(MUTATIONS_LAYER)
	switch(level_casting)
		if(1)
			H.Stun(5)
			H.emote("laugh")
			to_chat(target, "<span class='userdanger'><b>HAHAHAHAHAHAHAHAHAHAHAHA!!</b></span>")
			caster.playsound_local(get_turf(H), pick('sound/items/SitcomLaugh1.ogg', 'sound/items/SitcomLaugh2.ogg', 'sound/items/SitcomLaugh3.ogg'), 100, FALSE)
			if(target.body_position == STANDING_UP)
				target.toggle_resting()
		if(2)
//			H.Immobilize(10)
			H.hallucination += 50
			new /datum/hallucination/oh_yeah(H, TRUE)
		if(3)
			H.Immobilize(20)
			if(H.stat <= HARD_CRIT && !H.IsSleeping() && !H.IsUnconscious() && !H.IsParalyzed() && !H.IsKnockdown() && !HAS_TRAIT(H, TRAIT_RESTRAINED))
				if(prob(50))
					dancefirst(H)
				else
					dancesecond(H)
		if(4)
//			H.Immobilize(20)
			new /datum/hallucination/death(H, TRUE)
		if(5)
			var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/attack_myself_command)
			for(var/i in 1 to 20)
				addtimer(cb, (i - 1)*15)
	spawn(delay+caster.discipline_time_plus)
		if(H)
			H.remove_overlay(MUTATIONS_LAYER)

/datum/discipline/potence
	name = "Potence"
	desc = "Boosts melee and unarmed damage."
	icon_state = "potence"
	cost = 1
	ranged = FALSE
	delay = 10 SECONDS
	activate_sound = 'code/modules/wod13/sounds/potence_activate.ogg'
	var/datum/component/tackler

/datum/discipline/potence/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	var/mod = 8*level_casting
	var/armah = 0.4*level_casting
	caster.remove_overlay(POTENCE_LAYER)
	var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "potence", -POTENCE_LAYER)
	caster.overlays_standing[POTENCE_LAYER] = potence_overlay
	caster.apply_overlay(POTENCE_LAYER)
	caster.dna.species.punchdamagelow += mod
	caster.dna.species.punchdamagehigh += mod
	caster.dna.species.meleemod += armah
	caster.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
	tackler = caster.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 2+level_casting, speed = 1, skill_mod = 0, min_distance = 0)
	caster.potential = level_casting
	spawn(delay+caster.discipline_time_plus)
		if(caster)
			if(caster.dna)
				if(caster.dna.species)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/potence_deactivate.ogg', 50, FALSE)
					caster.dna.species.punchdamagelow -= mod
					caster.dna.species.punchdamagehigh -= mod
					caster.dna.species.meleemod -= armah
					caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
					caster.remove_overlay(POTENCE_LAYER)
					caster.potential = 0
					qdel(tackler)

/datum/discipline/fortitude
	name = "Fortitude"
	desc = "Boosts armor."
	icon_state = "fortitude"
	cost = 1
	ranged = FALSE
	delay = 7.5 SECONDS
	activate_sound = 'code/modules/wod13/sounds/fortitude_activate.ogg'

/datum/discipline/fortitude/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	var/mod = min(3, level_casting)
	var/armah = 15*mod
//	caster.remove_overlay(FORTITUDE_LAYER)
//	var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "fortitude", -FORTITUDE_LAYER)
//	caster.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
//	caster.apply_overlay(FORTITUDE_LAYER)
	caster.physiology.armor.melee += armah
	caster.physiology.armor.bullet += armah
	spawn(delay+caster.discipline_time_plus)
		if(caster)
			caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/fortitude_deactivate.ogg', 50, FALSE)
			caster.physiology.armor.melee -= armah
			caster.physiology.armor.bullet -= armah
//			caster.remove_overlay(FORTITUDE_LAYER)

/datum/discipline/obfuscate
	name = "Obfuscate"
	desc = "Makes you less noticable for living and un-living beings."
	icon_state = "obfuscate"
	cost = 1
	ranged = FALSE
	delay = 10 SECONDS
	activate_sound = 'code/modules/wod13/sounds/obfuscate_activate.ogg'
	leveldelay = TRUE
	// if the caster acts overtly, the ability is deactivated
	COOLDOWN_DECLARE(obfuscate_combat_cooldown)
	var/static/list/aggressive_signals = list(
		COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_MOB_ATTACK_RANGED,
	)
	var/deactivation_timer = null	//separate from the combat cooldown; this is the timer for the ability itself
	var/active = FALSE // this is used to determine if the ability is active or not

/datum/discipline/obfuscate/check_activated(mob/living/target, mob/living/carbon/human/caster)
	// check if the caster has acted overtly recently before we go assigning or calculating anything
	if(!COOLDOWN_FINISHED(src, obfuscate_combat_cooldown))
		to_chat(caster, span_warning("You have acted overtly too recently to pull the cloak of obfuscation upon yourself; your attempt fails!"))
		return FALSE
	. = ..()

/datum/discipline/obfuscate/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	var/duration = delay*level_casting+caster.discipline_time_plus
	if(active)	// if they're popping it again while it's already active, extend the duration
		if(deactivation_timer)	// BYOND is mysterious and the timer may be null, so we check before we try deleting it
			deltimer(deactivation_timer)
			deactivation_timer = null
		deactivation_timer = addtimer(CALLBACK(src, PROC_REF(reveal), caster), duration, TIMER_STOPPABLE)
		return
	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)	// ... this iterates over every NPC in the game?
		if(NPC)
			if(NPC.danger_source == caster)
				NPC.danger_source = null
	caster.alpha = 10
	caster.obfuscate_level = level_casting
	deactivation_timer = addtimer(CALLBACK(src, PROC_REF(reveal), caster), duration, TIMER_STOPPABLE)
	handle_signals(TRUE, caster)
	active = TRUE

/datum/discipline/obfuscate/proc/reveal(mob/living/carbon/human/caster)

	to_chat(caster, "<span class='warning'>Your cloak of obfuscation fades away.</span>")
	caster.alpha = 255
	caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/obfuscate_deactivate.ogg', 50, FALSE)
	handle_signals(FALSE, caster)
	if(deactivation_timer)
		deltimer(deactivation_timer)
		deactivation_timer = null	// just in case
	active = FALSE

/datum/discipline/obfuscate/proc/on_hostile_action(datum/source, mob/living/carbon/human/caster)
	SIGNAL_HANDLER

	var/cooldown_length = (60-min(30, level_casting*5)) SECONDS
	COOLDOWN_START(src, obfuscate_combat_cooldown, cooldown_length)
	to_chat(source, span_warning("You feel your cloak of obfuscation fly away from you as you act conspicuously."))
	reveal(source)

/datum/discipline/obfuscate/proc/handle_signals(bool, mob/living/carbon/human/caster) // the bool in this instance indicates if the ability is activating
	if(bool)
		for(var/signal in aggressive_signals)
			RegisterSignal(caster, signal, PROC_REF(on_hostile_action))
		return
	for(var/signal in aggressive_signals)
		UnregisterSignal(caster, signal)

/datum/discipline/presence
	name = "Presence"
	desc = "Makes targets in radius more vulnerable to damages."
	icon_state = "presence"
	cost = 1
	ranged = TRUE
	delay = 5 SECONDS
	activate_sound = 'code/modules/wod13/sounds/presence_activate.ogg'
	leveldelay = FALSE
	fearless = TRUE

/mob/living/carbon/human/proc/walk_to_caster()
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_to(src,caster,0)
		face_atom(caster)

/mob/living/carbon/human/proc/step_away_caster()
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_away(src,caster,99)
		face_atom(caster)

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

/datum/discipline/presence/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	var/mypower = caster.get_total_social()
	var/theirpower = target.get_total_mentality()
	if((theirpower >= mypower) || ((caster.generation - 3) >= target.generation))
		to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to sway!</span>")
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		H.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		H.apply_overlay(MUTATIONS_LAYER)
		H.caster = caster
		switch(level_casting)
			if(1)
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/walk_to_caster)
				for(var/i in 1 to 30)
					addtimer(cb, (i - 1)*H.total_multiplicative_slowdown())
				to_chat(target, "<span class='userlove'><b>COME HERE</b></span>")
				caster.say("COME HERE!!")
			if(2)
				target.Stun(10)
				to_chat(target, "<span class='userlove'><b>REST</b></span>")
				caster.say("REST!!")
				if(target.body_position == STANDING_UP)
					target.toggle_resting()
			if(3)
				var/obj/item/I1 = H.get_active_held_item()
				var/obj/item/I2 = H.get_inactive_held_item()
				to_chat(target, "<span class='userlove'><b>PLEASE ME</b></span>")
				caster.say("PLEASE ME!!")
				target.face_atom(caster)
				target.do_jitter_animation(30)
				target.Immobilize(10)
				target.drop_all_held_items()
				if(I1)
					I1.throw_at(get_turf(caster), 3, 1, target)
				if(I2)
					I2.throw_at(get_turf(caster), 3, 1, target)
			if(4)
				to_chat(target, "<span class='userlove'><b>FEAR ME</b></span>")
				caster.say("FEAR ME!!")
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/step_away_caster)
				for(var/i in 1 to 30)
					addtimer(cb, (i - 1)*H.total_multiplicative_slowdown())
				target.emote("scream")
				target.do_jitter_animation(30)
			if(5)
				to_chat(target, "<span class='userlove'><b>UNDRESS YOURSELF</b></span>")
				caster.say("UNDRESS YOURSELF!!")
				target.Immobilize(10)
				for(var/obj/item/clothing/W in H.contents)
					if(W)
						H.dropItemToGround(W, TRUE)
		spawn(delay + caster.discipline_time_plus)
			if(H)
				H.remove_overlay(MUTATIONS_LAYER)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/presence_deactivate.ogg', 50, FALSE)

/datum/discipline/protean
	name = "Protean"
	desc = "Lets your beast out, making you stronger and faster. Violates Masquerade."
	icon_state = "protean"
	cost = 1
	ranged = FALSE
	delay = 20 SECONDS
	violates_masquerade = TRUE
	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	clane_restricted = TRUE
	var/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/GA

/datum/movespeed_modifier/protean2
	multiplicative_slowdown = -0.15

/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel
	name = "Gangrel Form"
	desc = "Take on the shape a wolf."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/gangrel

/datum/discipline/protean/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	var/mod = min(4, level_casting)
//	var/mutable_appearance/protean_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "protean[mod]", -PROTEAN_LAYER)
	if(!GA)
		GA = new(caster)
	switch(mod)
		if(1)
			caster.drop_all_held_items()
			caster.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
			caster.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
			caster.add_client_colour(/datum/client_colour/glass_colour/red)
//			caster.dna.species.attack_verb = "slash"
//			caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//			caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+10
//			caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+10
//			caster.remove_overlay(PROTEAN_LAYER)
//			caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//			caster.apply_overlay(PROTEAN_LAYER)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					for(var/obj/item/melee/vampirearms/knife/gangrel/G in caster.contents)
						if(G)
							qdel(G)
					caster.remove_client_colour(/datum/client_colour/glass_colour/red)
//					if(caster.dna)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//						caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//						caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//						caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-10
//						caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-10
//						caster.remove_overlay(PROTEAN_LAYER)
		if(2)
			caster.drop_all_held_items()
			caster.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
			caster.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
			caster.add_client_colour(/datum/client_colour/glass_colour/red)
//			caster.dna.species.attack_verb = "slash"
//			caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//			caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+15
//			caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+15
			caster.add_movespeed_modifier(/datum/movespeed_modifier/protean2)
//			caster.remove_overlay(PROTEAN_LAYER)
//			caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//			caster.apply_overlay(PROTEAN_LAYER)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					for(var/obj/item/melee/vampirearms/knife/gangrel/G in caster.contents)
						if(G)
							qdel(G)
					caster.remove_client_colour(/datum/client_colour/glass_colour/red)
//					if(caster.dna)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//						caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//						caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//						caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-15
//						caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-15
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean2)
//						caster.remove_overlay(PROTEAN_LAYER)
		if(3)
			caster.drop_all_held_items()
			GA.Shapeshift(caster)
//			caster.dna.species.attack_verb = "slash"
//			caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//			caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+20
//			caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+20
//			caster.add_movespeed_modifier(/datum/movespeed_modifier/protean3)
//			caster.remove_overlay(PROTEAN_LAYER)
//			caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//			caster.apply_overlay(PROTEAN_LAYER)
			spawn(delay+caster.discipline_time_plus)
				if(caster && caster.stat != DEAD)
					GA.Restore(GA.myshape)
					caster.Stun(15)
					caster.do_jitter_animation(30)
//					if(caster.dna)
					caster.playsound_local(caster, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//						caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//						caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//						caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-20
//						caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-20
//						caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean3)
//						caster.remove_overlay(PROTEAN_LAYER)
		if(4 to 5)
			caster.drop_all_held_items()
			if(level_casting == 4)
				GA.shapeshift_type = /mob/living/simple_animal/hostile/gangrel/better
			if(level_casting == 5)
				GA.shapeshift_type = /mob/living/simple_animal/hostile/gangrel/best
			GA.Shapeshift(caster)
//			caster.dna.species.attack_verb = "slash"
//			caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//			caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+25
//			caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagelow+25
//			if(level_casting == 5)
//				caster.add_movespeed_modifier(/datum/movespeed_modifier/protean5)
//			else
//				caster.add_movespeed_modifier(/datum/movespeed_modifier/protean4)
//			caster.remove_overlay(PROTEAN_LAYER)
//			caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//			caster.apply_overlay(PROTEAN_LAYER)
			spawn(delay+caster.discipline_time_plus)
				if(caster && caster.stat != DEAD)
					GA.Restore(GA.myshape)
					caster.Stun(1 SECONDS)
					caster.do_jitter_animation(1.5 SECONDS)
//					if(caster.dna)
					caster.playsound_local(caster, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//						caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//						caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//						caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-25
//						caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-25
//						if(level_casting == 5)
//							caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean5)
//						else
//							caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean4)
//						caster.remove_overlay(PROTEAN_LAYER)

/mob/living/proc/tremere_gib()
	Stun(5 SECONDS)
	new /obj/effect/temp_visual/tremere(loc, "gib")
	animate(src, pixel_y = 16, color = "#ff0000", time = 50, loop = 1)

	spawn(5 SECONDS)
		if(stat != DEAD)
			death()
		var/list/items = list()
		items |= get_equipped_items(TRUE)
		for(var/obj/item/I in items)
			dropItemToGround(I)
		drop_all_held_items()
		spawn_gibs()
		spawn_gibs()
		spawn_gibs()
		qdel(src)

/obj/effect/projectile/tracer/thaumaturgy
	name = "blood beam"
	icon_state = "cult"

/obj/effect/projectile/muzzle/thaumaturgy
	name = "blood beam"
	icon_state = "muzzle_cult"

/obj/effect/projectile/impact/thaumaturgy
	name = "blood beam"
	icon_state = "impact_cult"

/obj/projectile/thaumaturgy
	name = "blood beam"
	icon_state = "thaumaturgy"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 5
	damage_type = BURN
	hitsound = 'code/modules/wod13/sounds/drinkblood1.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = LASER
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 1
	light_color = COLOR_SOFT_RED
	ricochets_max = 0
	ricochet_chance = 0
	tracer_type = /obj/effect/projectile/tracer/thaumaturgy
	muzzle_type = /obj/effect/projectile/muzzle/thaumaturgy
	impact_type = /obj/effect/projectile/impact/thaumaturgy
	var/level = 1

/obj/projectile/thaumaturgy/on_hit(atom/target, blocked = FALSE, pierce_hit)
	if(ishuman(firer))
		var/mob/living/carbon/human/VH = firer
		if(isliving(target))
			var/mob/living/VL = target
			if(isgarou(VL))
				if(VL.bloodpool >= 1 && VL.stat != DEAD)
					var/sucked = min(VL.bloodpool, 2)
					VL.bloodpool = VL.bloodpool-sucked
					VL.blood_volume = max(VL.blood_volume-50, 0) // average blood_volume of most carbons seems to be 560
					VL.apply_damage(45, BURN)
					VL.visible_message("<span class='danger'>[target]'s wounds spray boiling hot blood!</span>", "<span class='userdanger'>Your blood boils!</span>")
					VL.add_splatter_floor(get_turf(target))
					VL.add_splatter_floor(get_turf(get_step(target, target.dir)))
				if(!iskindred(target))
					if(VL.bloodpool >= 1 && VL.stat != DEAD)
						var/sucked = min(VL.bloodpool, 2)
						VL.bloodpool = VL.bloodpool-sucked
						VL.blood_volume = max(VL.blood_volume-50, 0)
					if(ishuman(VL))
						if(VL.bloodpool >= 1 && VL.stat != DEAD)
							var/mob/living/carbon/human/VHL = VL
							VHL.blood_volume = max(VHL.blood_volume-25, 0)
							if(VL.bloodpool == 0)
								VHL.blood_volume = 0
								VL.death()
//							if(isnpc(VL))
//								AdjustHumanity(VH, -1, 3)
					else
						if(VL.bloodpool == 0)
							VL.death()
					//VH.bloodpool = VH.bloodpool+(sucked*max(1, VL.bloodquality-1))
					//VH.bloodpool = min(VH.maxbloodpool, VH.bloodpool)
			else
				if(VL.bloodpool >= 1)
					var/sucked = min(VL.bloodpool, 1*level)
					VL.bloodpool = VL.bloodpool-sucked
					VH.bloodpool = VH.bloodpool+sucked
					VH.bloodpool = min(VH.maxbloodpool, VH.bloodpool)

/datum/discipline/thaumaturgy
	name = "Thaumaturgy"
	desc = "Opens the secrets of blood magic and how you use it, allows to steal other's blood. Violates Masquerade."
	icon_state = "thaumaturgy"
	cost = 1
	ranged = TRUE
	delay = 5 SECONDS
	violates_masquerade = TRUE
	activate_sound = 'code/modules/wod13/sounds/thaum.ogg'
	clane_restricted = TRUE
	dead_restricted = FALSE

/datum/discipline/thaumaturgy/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	switch(level_casting)
		if(1)
			var/turf/start = get_turf(caster)
			var/obj/projectile/thaumaturgy/H = new(start)
			H.firer = caster
			H.preparePixelProjectile(target, start)
			H.fire(direct_target = target)
		if(2)
			var/turf/start = get_turf(caster)
			var/obj/projectile/thaumaturgy/H = new(start)
			H.firer = caster
			H.damage = 10+caster.thaum_damage_plus
			H.preparePixelProjectile(target, start)
			H.level = 2
			H.fire(direct_target = target)
		if(3)
			var/turf/start = get_turf(caster)
			var/obj/projectile/thaumaturgy/H = new(start)
			H.firer = caster
			H.damage = 15+caster.thaum_damage_plus
			H.preparePixelProjectile(target, start)
			H.level = 2
			H.fire(direct_target = target)
		else
			if(iscarbon(target))
				target.Stun(2.5 SECONDS)
				target.visible_message("<span class='danger'>[target] throws up!</span>", "<span class='userdanger'>You throw up!</span>")
				playsound(get_turf(target), 'code/modules/wod13/sounds/vomit.ogg', 75, TRUE)
				target.add_splatter_floor(get_turf(target))
				target.add_splatter_floor(get_turf(get_step(target, target.dir)))
			else
				caster.bloodpool = min(caster.maxbloodpool, caster.bloodpool + target.bloodpool)
				if(!istype(target, /mob/living/simple_animal/hostile/megafauna))
//				if(isnpc(target))
//					AdjustHumanity(caster, -1, 0)
					target.tremere_gib()
/*
/datum/discipline/bloodshield
	name = "Blood shield"
	desc = "Boosts armor."
	icon_state = "bloodshield"
	cost = 2
	ranged = FALSE
	delay = 150
	activate_sound = 'code/modules/wod13/sounds/thaum.ogg'

/datum/discipline/bloodshield/activate(mob/living/target, mob/living/carbon/human/caster)
	..()
	var/mod = level_casting
	caster.physiology.armor.melee = caster.physiology.armor.melee+(15*mod)
	caster.physiology.armor.bullet = caster.physiology.armor.bullet+(15*mod)
	animate(caster, color = "#ff0000", time = 10, loop = 1)
//	caster.color = "#ff0000"
	spawn(delay+caster.discipline_time_plus)
		if(caster)
			playsound(caster.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			caster.physiology.armor.melee = caster.physiology.armor.melee-(15*mod)
			caster.physiology.armor.bullet = caster.physiology.armor.bullet-(15*mod)
			caster.color = initial(caster.color)
*/

/datum/discipline/serpentis
	name = "Serpentis"
	desc = "Act like a cobra, get the powers to stun targets with your gaze and your tongue, praise the mummy traditions and spread them to your childe. Violates Masquerade."
	icon_state = "serpentis"
	cost = 1
	ranged = TRUE
	delay = 5
//	range_sh = 2
	violates_masquerade = TRUE
	clane_restricted = TRUE
	dead_restricted = FALSE

/datum/discipline/serpentis/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	if(level_casting == 1)
		var/antidir = NORTH
		switch(caster.dir)
			if(NORTH)
				antidir = SOUTH
			if(SOUTH)
				antidir = NORTH
			if(WEST)
				antidir = EAST
			if(EAST)
				antidir = WEST
		if(target.dir == antidir)
			target.Immobilize(10)
			target.visible_message("<span class='warning'><b>[caster] hypnotizes [target] with his eyes!</b></span>", "<span class='warning'><b>[caster] hypnotizes you like a cobra!</b></span>")
			caster.playsound_local(target.loc, 'code/modules/wod13/sounds/serpentis.ogg', 50, TRUE)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.remove_overlay(MUTATIONS_LAYER)
				var/mutable_appearance/serpentis_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "serpentis", -MUTATIONS_LAYER)
				H.overlays_standing[MUTATIONS_LAYER] = serpentis_overlay
				H.apply_overlay(MUTATIONS_LAYER)
				spawn(5)
					H.remove_overlay(MUTATIONS_LAYER)
	if(level_casting >= 2)
//		var/turf/start = get_turf(caster)
//		var/obj/projectile/tentacle/H = new(start)
//		H.hitsound = 'code/modules/wod13/sounds/tongue.ogg'
		var/bloodpoints_to_suck = max(0, min(target.bloodpool, level_casting-1))
		if(bloodpoints_to_suck)
			caster.bloodpool = min(caster.maxbloodpool, caster.bloodpool+bloodpoints_to_suck)
			target.bloodpool = max(0, target.bloodpool-bloodpoints_to_suck)
		var/obj/item/ammo_casing/magic/tentacle/casing = new (caster.loc)
		playsound(caster.loc, 'code/modules/wod13/sounds/tongue.ogg', 100, TRUE)
		casing.fire_casing(target, caster, null, null, null, ran_zone(), 0,  caster)
		caster.playsound_local(target.loc, 'code/modules/wod13/sounds/serpentis.ogg', 50, TRUE)
		qdel(casing)

/datum/discipline/vicissitude
	name = "Vicissitude"
	desc = "It is widely known as Tzimisce art of flesh and bone shaping. Violates Masquerade."
	icon_state = "vicissitude"
	cost = 1
	ranged = TRUE
	delay = 100
	range_sh = 2
	violates_masquerade = TRUE
	clane_restricted = TRUE
	dead_restricted = FALSE

/datum/discipline/vicissitude/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 50, TRUE)
		//caster.adjustFireLoss(35)		//abusers suffer no more
		caster.Stun(20)
		caster.emote("scream")
		target.apply_damage(10*level_casting, BRUTE)
		target.apply_damage(5*level_casting, CLONE)
		target.visible_message("<span class='danger'>[target]'s skin writhes like worms, twisting and contorting!</span>", "<span class='userdanger'>Your flesh twists unnaturally!</span>")
		target.Stun(30)
		target.emote("scream")
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		caster.playsound_local(target.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 50, TRUE)
		if(target.stat >= HARD_CRIT)
			if(istype(target, /mob/living/carbon/human/npc))
				var/mob/living/carbon/human/npc/NPC = target
				NPC.last_attacker = null
			if(!iskindred(target) || !isgarou(target))
				if(H.stat != DEAD)
					H.death()
				switch(level_casting)
					if(1)
						new /obj/item/stack/human_flesh(target.loc)
						new /obj/item/guts(target.loc)
						qdel(target)
					if(2)
						new /obj/item/stack/human_flesh/five(target.loc)
						new /obj/item/guts(target.loc)
						new /obj/item/spine(target.loc)
						var/obj/item/bodypart/B = H.get_bodypart(pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
						if(B)
							B.drop_limb()
						qdel(target)
					if(3)
						var/obj/item/bodypart/B1 = H.get_bodypart(BODY_ZONE_R_ARM)
						var/obj/item/bodypart/B2 = H.get_bodypart(BODY_ZONE_L_ARM)
						var/obj/item/bodypart/B3 = H.get_bodypart(BODY_ZONE_R_LEG)
						var/obj/item/bodypart/B4 = H.get_bodypart(BODY_ZONE_L_LEG)
						if(B1)
							B1.drop_limb()
						if(B2)
							B2.drop_limb()
						if(B3)
							B3.drop_limb()
						if(B4)
							B4.drop_limb()
						new /obj/item/stack/human_flesh/ten(target.loc)
						new /obj/item/guts(target.loc)
						new /obj/item/spine(target.loc)
						qdel(target)
					if(4)
						var/obj/item/bodypart/B1 = H.get_bodypart(BODY_ZONE_R_ARM)
						var/obj/item/bodypart/B2 = H.get_bodypart(BODY_ZONE_L_ARM)
						var/obj/item/bodypart/B3 = H.get_bodypart(BODY_ZONE_R_LEG)
						var/obj/item/bodypart/B4 = H.get_bodypart(BODY_ZONE_L_LEG)
						var/obj/item/bodypart/CH = H.get_bodypart(BODY_ZONE_CHEST)
						if(B1)
							B1.drop_limb()
						if(B2)
							B2.drop_limb()
						if(B3)
							B3.drop_limb()
						if(B4)
							B4.drop_limb()
						if(CH)
							CH.dismember()
						new /obj/item/stack/human_flesh/twenty(target.loc)
						qdel(target)
					if(5)
						var/obj/item/bodypart/B1 = H.get_bodypart(BODY_ZONE_R_ARM)
						var/obj/item/bodypart/B2 = H.get_bodypart(BODY_ZONE_L_ARM)
						var/obj/item/bodypart/B3 = H.get_bodypart(BODY_ZONE_R_LEG)
						var/obj/item/bodypart/B4 = H.get_bodypart(BODY_ZONE_L_LEG)
						var/obj/item/bodypart/CH = H.get_bodypart(BODY_ZONE_CHEST)
						var/obj/item/bodypart/HE = H.get_bodypart(BODY_ZONE_HEAD)
						if(B1)
							B1.drop_limb()
						if(B2)
							B2.drop_limb()
						if(B3)
							B3.drop_limb()
						if(B4)
							B4.drop_limb()
						if(CH)
							CH.dismember()
						if(HE)
							HE.dismember()
						new /obj/item/stack/human_flesh/fifty(target.loc)
						new /obj/item/guts(target.loc)
						new /obj/item/spine(target.loc)
						qdel(target)
		else
			target.emote("scream")
			target.apply_damage(20*level_casting, BRUTE, BODY_ZONE_CHEST)
			if(prob(5*level_casting))
				var/obj/item/bodypart/B = H.get_bodypart(pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				if(B)
					B.drop_limb()
	//else
		//target.death() - Removed until a better solution is found to not have insta-kills on player mobs, unsure of side effects for normal vicissitude use but call death above already so should be fine?

/turf
	var/silented = FALSE

/obj/projectile/quietus
	name = "acid spit"
	icon_state = "har4ok"
	pass_flags = PASSTABLE
	damage = 80
	damage_type = BURN
	hitsound = 'sound/weapons/effects/searwall.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	ricochets_max = 0
	ricochet_chance = 0

/datum/discipline/quietus
	name = "Quietus"
	desc = "Make a poison out of nowhere and forces all beings in range to mute, poison your touch, poison your weapon, poison your spit and make it acid. Violates Masquerade."
	icon_state = "quietus"
	cost = 1
	ranged = FALSE
	delay = 50
//	range = 2
	violates_masquerade = TRUE
	clane_restricted = TRUE

/datum/discipline/quietus/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	caster.playsound_local(target.loc, 'code/modules/wod13/sounds/quietus.ogg', 50, TRUE)
	switch(level_casting)
		if(1)
			for(var/mob/living/carbon/human/H in oviewers(7, caster))
				ADD_TRAIT(H, TRAIT_DEAF, "quietus")
				if(H.get_confusion() < 15)
					var/diff = 15 - H.get_confusion()
					H.add_confusion(min(15, diff))
				spawn(50)
					if(H)
						REMOVE_TRAIT(H, TRAIT_DEAF, "quietus")
		if(2)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/melee/touch_attack/quietus(caster))
		if(3)
			if(caster.lastattacked)
				if(isliving(caster.lastattacked))
					var/mob/living/L = caster.lastattacked
					L.adjustStaminaLoss(80)
					L.adjustFireLoss(10)
					to_chat(caster, "You send your curse on [L], the last creature you attacked.")
				else
					to_chat(caster, "You don't seem to have last attacked soul earlier...")
					return
			else
				to_chat(caster, "You don't seem to have last attacked soul earlier...")
				return
		if(4)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/quietus_upgrade(caster))
		if(5)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/gun/magic/quietus(caster))

/obj/item/gun/magic/quietus
	name = "acid spit"
	desc = "Spit poison on your targets."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "har4ok"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/quietus
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/quietus
	name = "acid spit"
	desc = "A spit."
	projectile_type = /obj/projectile/quietus
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/quietus/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)
/*
	playsound(target.loc, 'code/modules/wod13/sounds/quietus.ogg', 50, TRUE)
	target.Stun(5*level_casting)
	if(level_casting >= 3)
		if(target.bloodpool > 1)
			var/transfered = max(1, target.bloodpool-3)
			caster.bloodpool = min(caster.maxbloodpool, caster.bloodpool+transfered)
			target.bloodpool = transfered
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/quietus_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "quietus", -MUTATIONS_LAYER)
		H.overlays_standing[MUTATIONS_LAYER] = quietus_overlay
		H.apply_overlay(MUTATIONS_LAYER)
		spawn(5*level_casting)
			H.remove_overlay(MUTATIONS_LAYER)
*/
/datum/discipline/necromancy
	name = "Necromancy"
	desc = "Offers control over another, undead reality."
	icon_state = "necromancy"
	cost = 1
	ranged = TRUE
	range_sh = 2
	delay = 50
	violates_masquerade = TRUE
	clane_restricted = TRUE
	dead_restricted = FALSE

/datum/discipline/necromancy/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	caster.playsound_local(target.loc, 'code/modules/wod13/sounds/necromancy.ogg', 50, TRUE)
	var/limit = min(3, level)+caster.social-1+caster.more_companions
	if(length(caster.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(caster.beastmaster)
		B.death()
	if(target.stat == DEAD)
		switch(level_casting)
			if(1)
				if(!length(caster.beastmaster))
					var/datum/action/beastmaster_stay/E1 = new()
					E1.Grant(caster)
					var/datum/action/beastmaster_deaggro/E2 = new()
					E2.Grant(caster)
				var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/M = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level1(caster.loc)
				M.my_creator = caster
				caster.beastmaster |= M
				M.beastmaster = caster
//				if(target.key)
//					M.key = target.key
//				else
//					M.give_player()
				target.gib()
			if(2)
				if(!length(caster.beastmaster))
					var/datum/action/beastmaster_stay/E1 = new()
					E1.Grant(caster)
					var/datum/action/beastmaster_deaggro/E2 = new()
					E2.Grant(caster)
				var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/M = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level2(caster.loc)
				M.my_creator = caster
				caster.beastmaster |= M
				M.beastmaster = caster
				target.gib()
			if(3)
				if(!length(caster.beastmaster))
					var/datum/action/beastmaster_stay/E1 = new()
					E1.Grant(caster)
					var/datum/action/beastmaster_deaggro/E2 = new()
					E2.Grant(caster)
				var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/M = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level3(caster.loc)
				M.my_creator = caster
				caster.beastmaster |= M
				M.beastmaster = caster
				target.gib()
			if(4)
				if(!length(caster.beastmaster))
					var/datum/action/beastmaster_stay/E1 = new()
					E1.Grant(caster)
					var/datum/action/beastmaster_deaggro/E2 = new()
					E2.Grant(caster)
				var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/M = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level4(caster.loc)
				M.my_creator = caster
				caster.beastmaster |= M
				M.beastmaster = caster
				target.gib()
			if(5)
				if(!length(caster.beastmaster))
					var/datum/action/beastmaster_stay/E1 = new()
					E1.Grant(caster)
					var/datum/action/beastmaster_deaggro/E2 = new()
					E2.Grant(caster)
				var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/M = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level5(caster.loc)
				M.my_creator = caster
				caster.beastmaster |= M
				M.beastmaster = caster
				target.gib()
	else
		target.apply_damage(5 * level_casting, BRUTE, caster.zone_selected)
		target.apply_damage(6 * level_casting, CLONE, caster.zone_selected)
		target.emote("scream")

/datum/discipline/obtenebration
	name = "Obtenebration"
	desc = "Controls the darkness around you."
	icon_state = "obtenebration"
	cost = 1
	ranged = TRUE
	delay = 100
	violates_masquerade = TRUE
	clane_restricted = TRUE
	activate_sound = 'sound/magic/voidblink.ogg'

/datum/discipline/obtenebration/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	if(level_casting == 1)
		var/atom/movable/AM = new(target)
		AM.set_light(3, -7)
		spawn(delay+caster.discipline_time_plus)
			AM.set_light(0)
	else
		target.Stun(10*(level_casting-1))
		var/obj/item/ammo_casing/magic/tentacle/lasombra/casing = new (caster.loc)
		casing.fire_casing(target, caster, null, null, null, ran_zone(), 0,  caster)

/datum/discipline/daimonion
	name = "Daimonion"
	desc = "Get a help from the Hell creatures, resist THE FIRE, transform into an imp. Violates Masquerade."
	icon_state = "daimonion"
	cost = 1
	ranged = FALSE
	delay = 150
	violates_masquerade = TRUE
	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	clane_restricted = TRUE
	var/obj/effect/proc_holder/spell/targeted/shapeshift/bat/BAT

/datum/discipline/daimonion/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	var/mod = min(4, level_casting)
//	var/mutable_appearance/protean_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "protean[mod]", -PROTEAN_LAYER)
	if(!BAT)
		BAT = new(caster)
	switch(mod)
		if(1)
			caster.physiology.burn_mod *= 1/100
			caster.color = "#884200"
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.color = initial(caster.color)
					caster.physiology.burn_mod *= 100
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
		if(2)
			caster.dna.species.GiveSpeciesFlight(caster)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.dna.species.RemoveSpeciesFlight(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
		if(3)
			caster.drop_all_held_items()
			caster.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
			caster.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					for(var/obj/item/melee/vampirearms/knife/gangrel/G in caster)
						if(G)
							qdel(G)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
		if(4 to 5)
			caster.drop_all_held_items()
			BAT.Shapeshift(caster)
			spawn(delay+caster.discipline_time_plus)
				if(caster && caster.stat != DEAD)
					BAT.Restore(BAT.myshape)
					caster.Stun(15)
					caster.do_jitter_animation(30)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)

/datum/discipline/valeren
	name = "Valeren"
	desc = "Use your third eye in healing or protecting needs."
	icon_state = "valeren"
	cost = 1
	ranged = TRUE
	delay = 50
	violates_masquerade = FALSE
	activate_sound = 'code/modules/wod13/sounds/valeren.ogg'
	clane_restricted = TRUE
	dead_restricted = FALSE
	var/datum/beam/current_beam
	var/humanity_restored = 0

/datum/discipline/valeren/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	switch(level_casting)
		if(1)
			healthscan(caster, target, 1, FALSE)
			chemscan(caster, target)
//			woundscan(caster, target, src)
			to_chat(caster, "<b>[target]</b> has <b>[target.bloodpool]/[target.maxbloodpool]</b> blood points.")
			to_chat(caster, "<b>[target]</b> has a rating of <b>[target.humanity]</b> on their path.")
		if(2)
			if(get_dist(caster, target) <= 2)
				if(isgarou(target))
					return
				if(iskindred(target))
					target.add_confusion(5)
					target.drowsyness += 4
				else if(ishuman(target))
					target.SetSleeping(300)
			else
				to_chat(caster, "You need to be close to use this power.")
				return
		if(3)
			if(current_beam)
				qdel(current_beam)
			caster.Beam(target, icon_state="sm_arc", time = 50, maxdistance = 9, beam_type = /obj/effect/ebeam/medical)
			target.adjustBruteLoss(-50, TRUE)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(length(H.all_wounds))
					var/datum/wound/W = pick(H.all_wounds)
					W.remove_wound()
			target.adjustFireLoss(-50, TRUE)
			target.update_damage_overlays()
			target.update_health_hud()
		if(4)
			if(current_beam)
				qdel(current_beam)
			caster.Beam(target, icon_state="sm_arc", time = 50, maxdistance = 9, beam_type = /obj/effect/ebeam/medical)
			target.adjustBruteLoss(-60, TRUE)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				if(length(H.all_wounds))
					var/datum/wound/W = pick(H.all_wounds)
					W.remove_wound()
			target.adjustFireLoss(-60, TRUE)
			target.update_damage_overlays()
			target.update_health_hud()
		if(5)
			if(caster.grab_state > GRAB_PASSIVE)
				if(ishuman(caster.pulling))
					var/mob/living/carbon/human/PB = caster.pulling
					if(do_after(caster, 10 SECONDS) && iskindred(PB) && humanity_restored < 3)
						to_chat(caster, "<span class='notice'>You healed [PB]'s soul slightly.</span>")
						PB.AdjustHumanity(1, 10)
						humanity_restored += 1
					else if(humanity_restored >=3)
						to_chat(caster, "<span class='warning'>You can't heal anymore souls this night.</span>")
					else
						to_chat(caster, "<span class='warning'>You need to grab a kindred and stay still to use this power.</span>")
						return
			else
				to_chat(caster, "<span class='warning'>You need to hold your patient properly to heal their soul.</span>")
				return

/datum/discipline/melpominee
	name = "Melpominee"
	desc = "Named for the Greek Muse of Tragedy, Melpominee is a unique discipline of the Daughters of Cacophony. It explores the power of the voice, shaking the very soul of those nearby and allowing the vampire to perform sonic feats otherwise impossible."
	icon_state = "melpominee"
	cost = 1
	ranged = TRUE
	delay = 75
	violates_masquerade = FALSE
	activate_sound = 'code/modules/wod13/sounds/melpominee.ogg'
	clane_restricted = TRUE
	dead_restricted = FALSE

/mob/living/carbon/human/proc/create_walk_to(var/max)
	var/datum/cb = CALLBACK(src,/mob/living/carbon/human/proc/walk_to_caster)
	for(var/i in 1 to max)
		addtimer(cb, (i - 1)*total_multiplicative_slowdown())

/datum/discipline/melpominee/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	switch(level_casting)
		if(1)
			if (target.stat == DEAD)
				//why? because of laziness, it sends messages to deadchat if you do that
				to_chat(caster, "<span class='notice'>You can't use this on corpses.</span>")
				return
			var/new_say = input(caster, "What will your target say?") as null|text
			if(new_say)
				//prevent forceful emoting and whatnot
				new_say = trim(copytext_char(sanitize(new_say), 1, MAX_MESSAGE_LEN))
				if (findtext(new_say, "*"))
					to_chat(caster, "<span class='danger'>You can't force others to perform emotes!</span>")
					return

				if(CHAT_FILTER_CHECK(new_say))
					to_chat(caster, "<span class='warning'>That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[new_say]\"</span></span>")
					SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
					return
				target.say("[new_say]", forced = "melpominee 1")

				var/base_difficulty = 5
				var/difficulty_malus = 0
				var/masked = FALSE
				if (ishuman(target)) //apply a malus and different text if victim's mouth isn't visible, and a malus if they're already typing
					var/mob/living/carbon/human/victim = target
					if ((victim.wear_mask?.flags_inv & HIDEFACE) || (victim.head?.flags_inv & HIDEFACE))
						masked = TRUE
						base_difficulty += 2
					if (victim.overlays_standing[SAY_LAYER]) //ugly way to check for if the victim is currently typing
						base_difficulty += 2

				for (var/mob/living/hearer in (view(7, target) - caster - target))
					if (!hearer.client)
						continue
					difficulty_malus = 0
					if (get_dist(hearer, target) > 3)
						difficulty_malus += 1
					if (storyteller_roll(hearer.get_total_mentality(), base_difficulty + difficulty_malus) == ROLL_SUCCESS)
						if (masked)
							to_chat(hearer, "<span class='warning'>[target.name]'s jaw isn't moving to match [target.p_their()] words.</span>")
						else
							to_chat(hearer, "<span class='warning'>[target.name]'s lips aren't moving to match [target.p_their()] words.</span>")
		if(2)
			target = input(caster, "Who will you project your voice to?") as null|mob in (GLOB.player_list - caster)
			if(target)
				var/input_message = input(caster, "What message will you project to them?") as null|text
				if (input_message)
					//sanitisation!
					input_message = trim(copytext_char(sanitize(input_message), 1, MAX_MESSAGE_LEN))
					if(CHAT_FILTER_CHECK(input_message))
						to_chat(caster, "<span class='warning'>That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[input_message]\"</span></span>")
						SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
						return

					var/language = caster.get_selected_language()
					var/message = caster.compose_message(caster, language, input_message, , list())
					to_chat(target, "<span class='purple'><i>You hear someone's voice in your head...</i></span>")
					target.Hear(message, target, language, input_message, , , )
					to_chat(caster, "<span class='notice'>You project your voice to [target]'s ears.</span>")
		if(3)
			for(var/mob/living/carbon/human/HU in oviewers(7, caster))
				if(HU)
					HU.caster = caster
					HU.create_walk_to(2 SECONDS)
					HU.remove_overlay(MUTATIONS_LAYER)
					var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
					HU.overlays_standing[MUTATIONS_LAYER] = song_overlay
					HU.apply_overlay(MUTATIONS_LAYER)
					spawn(2 SECONDS)
						if(HU)
							HU.remove_overlay(MUTATIONS_LAYER)
		if(4)
			playsound(caster.loc, 'code/modules/wod13/sounds/killscream.ogg', 100, FALSE)
			for(var/mob/living/carbon/human/HU in oviewers(7, caster))
				if(HU)
					HU.Stun(2 SECONDS)
					HU.remove_overlay(MUTATIONS_LAYER)
					var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
					HU.overlays_standing[MUTATIONS_LAYER] = song_overlay
					HU.apply_overlay(MUTATIONS_LAYER)
					spawn(2 SECONDS)
						if(HU)
							HU.remove_overlay(MUTATIONS_LAYER)
		if(5)
			playsound(caster.loc, 'code/modules/wod13/sounds/killscream.ogg', 100, FALSE)
			for(var/mob/living/carbon/human/HU in oviewers(7, caster))
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



/datum/discipline/temporis
	name = "Temporis"
	desc = "Temporis is a Discipline unique to the True Brujah. Supposedly a refinement of Celerity, Temporis grants the Cainite the ability to manipulate the flow of time itself."
	icon_state = "temporis"
	cost = 1
	ranged = TRUE
	delay = 50
	violates_masquerade = FALSE
	activate_sound = 'code/modules/wod13/sounds/temporis.ogg'
	clane_restricted = TRUE
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

/datum/discipline/temporis/activate(mob/living/target, mob/living/carbon/human/caster)
	. = ..()
	if (caster.celerity_visual) //no using two time powers at once
		to_chat(caster, "<span class='userdanger'>You try to manipulate your temporal field, but Celerity causes it to slip out of your grasp!</span>")
		caster.emote("scream")
		spawn(3 SECONDS)
			caster.gib()
		return
	switch(level_casting)
		if(1)
			to_chat(caster, "<b>[SScity_time.timeofnight]</b>")
			caster.bloodpool = caster.bloodpool+1
		if(2)
			target.AddComponent(/datum/component/dejavu, rewinds = 4, interval = 2 SECONDS)
		if(3)
			to_chat(target, "<span class='userdanger'><b>Slow down.</b></span>")
			target.add_movespeed_modifier(/datum/movespeed_modifier/temporis)
			spawn(10 SECONDS)
				if(target)
					target.remove_movespeed_modifier(/datum/movespeed_modifier/temporis)
		if(4)
			to_chat(caster, "<b>Use the second Temporis button at the bottom of the screen to cast this level of Temporis.</b>")
			caster.bloodpool = caster.bloodpool+1
		if(5)
			to_chat(caster, "<b>Use the third Temporis button at the bottom of the screen to cast this level of Temporis.</b>")
			caster.bloodpool = caster.bloodpool+1
