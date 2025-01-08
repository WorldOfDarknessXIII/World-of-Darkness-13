/datum/action/chi_discipline
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi' //This is the file for the BACKGROUND icon
	background_icon_state = "discipline" //And this is the state for the background icon

	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi' //This is the file for the ACTION icon
	button_icon_state = "discipline" //And this is the state for the action icon
	vampiric = TRUE
	var/level_icon_state = "1" //And this is the state for the action icon
	var/datum/chi_discipline/discipline
	var/active_check = FALSE

/datum/action/chi_discipline/Trigger()
	if(discipline && isliving(owner))
		var/mob/living/owning = owner
		if(discipline.ranged)
			if(!active_check)
				active_check = TRUE
				if(owning.chi_ranged)
					owning.chi_ranged.Trigger()
				owning.chi_ranged = src
				if(button)
					button.color = "#970000"
			else
				active_check = FALSE
				owning.chi_ranged = null
				button.color = "#ffffff"
		else
			if(discipline)
				if(discipline.check_activated(owner, owner))
					discipline.activate(owner, owner)
	. = ..()

/datum/action/chi_discipline/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays(TRUE)
		if(discipline)
			current_button.name = discipline.name
			current_button.desc = discipline.desc
			current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.icon_state]"))
			current_button.button_icon_state = "[discipline.icon_state]"
			current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.level_casting]"))
		else
			current_button.add_overlay(mutable_appearance(icon_icon, button_icon_state))
			current_button.button_icon_state = button_icon_state

/datum/action/chi_discipline/proc/switch_level()
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
		if(L.chi_ranged)
			L.chi_ranged.active_check = FALSE
			if(L.chi_ranged.button)
				animate(L.chi_ranged.button, color = "#ffffff", time = 10, loop = 1)
			if(L.chi_ranged.discipline.check_activated(src, usr))
				L.chi_ranged.discipline.activate(src, usr)
			L.chi_ranged = null
	. = ..()

//			if(DISCP)
//				if(DISCP.active)
//					DISCP.range_activate(src, SH)
//					SH.face_atom(src)
//					return

/atom/movable/screen/movable/action_button/Click(location,control,params)
	if(istype(linked_action, /datum/action/chi_discipline))
		var/list/modifiers = params2list(params)
		if(LAZYACCESS(modifiers, "right"))
			var/datum/action/chi_discipline/D = linked_action
			D.switch_level()
			return
	. = ..()

/datum/chi_discipline
	///Name of this Discipline.
	var/name = "Chi Discipline"
	///Text description of this Discipline.
	var/desc = "Discipline with powers such as..."
	///Icon for this Discipline as in disciplines.dmi
	var/icon_state
	///Cost in yin points of activating this Discipline.
	var/cost_yin = 0
	///Cost in yang points of activating this Discipline.
	var/cost_yang = 0
	///Cost in demon points of activating this Discipline.
	var/cost_demon = 0
	//Is ranged?
	var/ranged = FALSE
	///Duration of the Discipline.
	var/delay = 5
	var/next_fire_after
	///Whether this Discipline causes a Masquerade breach when used in front of mortals.
	var/violates_masquerade = FALSE
	///What rank, or how many dots the caster has in this Discipline.
	var/level = 1
	///The sound that plays when any power of this Discipline is activated.
	var/activate_sound = 'code/modules/wod13/sounds/chi_use.ogg'

	var/dead_restricted
	///What rank of this Discipline is currently being casted.
	var/level_casting = 1

	var/discipline_type = "Shintai"		//Either "Shintai", "Chi" or "Demon" arts

/datum/chi_discipline/proc/post_gain(var/mob/living/carbon/human/H)
	return

/datum/chi_discipline/proc/check_activated(var/mob/living/target, var/mob/living/carbon/human/caster)
	if(caster.stat >= HARD_CRIT || caster.IsSleeping() || caster.IsUnconscious() || caster.IsParalyzed() || caster.IsStun() || HAS_TRAIT(caster, TRAIT_RESTRAINED) || !isturf(caster.loc))
		return FALSE
	if(world.time < next_fire_after)
		to_chat(caster, "<span class='warning'>It's too soon to use this discipline again!</span>")
		return FALSE
	if(caster.yin_chi < cost_yin)
		SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(caster, "<span class='warning'>You don't have enough <b>Yin Chi</b> to use this discipline.</span>")
		return FALSE
	if(caster.yang_chi < cost_yang)
		SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(caster, "<span class='warning'>You don't have enough <b>Yang Chi</b> to use this discipline.</span>")
		return FALSE
	if(caster.demon_chi < cost_demon)
		SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(caster, "<span class='warning'>You don't have enough <b>Demon Chi</b> to use this discipline.</span>")
		return FALSE
	if(HAS_TRAIT(caster, TRAIT_PACIFISM))
		return FALSE
	if(target.stat == DEAD && dead_restricted)
		return FALSE
	if(target.resistant_to_disciplines || target.spell_immunity)
		to_chat(caster, "<span class='danger'>[target] resists your powers!</span>")
		return FALSE
	caster.yin_chi = max(0, caster.yin_chi-cost_yin)
	caster.yang_chi = max(0, caster.yang_chi-cost_yang)
	caster.demon_chi = max(0, caster.demon_chi-cost_demon)
	caster.update_chi_hud()
	if(ranged)
		to_chat(caster, "<span class='notice'>You activate [name] on [target].</span>")
	else
		to_chat(caster, "<span class='notice'>You activate [name].</span>")
	if(ranged)
		if(isnpc(target))
			var/mob/living/carbon/human/npc/NPC = target
			NPC.Aggro(caster, TRUE)
	if(activate_sound)
		caster.playsound_local(caster, activate_sound, 50, FALSE)
	if(violates_masquerade)
		if(caster.CheckEyewitness(target, caster, 7, TRUE))
			caster.AdjustMasquerade(-1)
	return TRUE

/datum/chi_discipline/proc/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	if(!target)
		return
	if(!caster)
		return
	next_fire_after = world.time+delay

	log_attack("[key_name(caster)] casted level [src.level_casting] of the Discipline [src.name][target == caster ? "." : " on [key_name(target)]"]")

/datum/chi_discipline/blood_shintai
	name = "Blood Shintai"
	desc = "Manipulate the liquid flow inside."
	icon_state = "blood"
	ranged = FALSE
	delay = 10 SECONDS
	cost_yin = 1
	activate_sound = 'code/modules/wod13/sounds/bloodshintai_activate.ogg'
	var/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler/kuei_jin/BC

/datum/movespeed_modifier/blood_fat
	multiplicative_slowdown = 1

/datum/movespeed_modifier/necroing
	multiplicative_slowdown = 2

/datum/movespeed_modifier/wall_passing
	multiplicative_slowdown = 5

/datum/movespeed_modifier/blood_slim
	multiplicative_slowdown = -0.5

/obj/item/reagent_containers/spray/pepper/kuei_jin
	stream_mode = 1
	stream_range = 5
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/consumable/condensedcapsaicin = 50, /datum/reagent/blood = 20)

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin
	name = "blood splatter"
	desc = "Just a moving blood splatter on the floor..."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	icon_living = "floor1"
	speed = 5
	maxHealth = 100
	health = 100
	melee_damage_lower = 1
	melee_damage_upper = 1
	a_intent = INTENT_HELP
	attack_verb_continuous = "splashes"
	attack_verb_simple = "splash"

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin/Initialize()
	. = ..()
	icon_state = "floor[rand(1, 7)]"
	icon_living = "floor[rand(1, 7)]"

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin/Crossed(atom/movable/O)
	. = ..()
	if(ishuman(O))
		var/mob/living/carbon/C = O
		to_chat(C, "<span class='notice'>You slipped[ O ? " on the [O.name]" : ""]!</span>")
		playsound(C.loc, 'sound/misc/slip.ogg', 50, TRUE)

		SEND_SIGNAL(C, COMSIG_ON_CARBON_SLIP)
		for(var/obj/item/I in C.held_items)
			C.accident(I)

//		var/olddir = C.dir
		C.moving_diagonally = 0 //If this was part of diagonal move slipping will stop it.
		C.Knockdown(20)

/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler/kuei_jin
	shapeshift_type = /mob/living/simple_animal/hostile/bloodcrawler/kuei_jin

/obj/item/gun/magic/blood_shintai
	name = "blood spit"
	desc = "Spit blood on your targets."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "leaper"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/blood_shintai
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/blood_shintai
	name = "blood spit"
	desc = "A spit."
	projectile_type = /obj/projectile/blood_wave
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/blood_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/projectile/blood_wave
	name = "blood wave"
	icon_state = "leaper"
	speed = 20
	animate_movement = SLIDE_STEPS
	ricochets_max = 5
	ricochet_chance = 100
	ricochet_decay_chance =1
	ricochet_decay_damage = 1

	damage = 75
	damage_type = BRUTE
	armour_penetration = 50
	range = 50
	stun = 20
	eyeblur = 20
	dismemberment = 20

	impact_effect_type = /obj/effect/temp_visual/impact_effect

	hit_stunned_targets = TRUE

/datum/chi_discipline/blood_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			var/result = alert(caster, "How do you manage your shape?",,"Shrink","Inflate")
			if(result == "Inflate")
				var/matrix/M = matrix()
				M.Scale(1.2, 1)
				var/matrix/initial = caster.transform
				animate(caster, transform = M, 1 SECONDS)
				caster.physiology.armor.melee += 20
				caster.physiology.armor.bullet += 20
				caster.add_movespeed_modifier(/datum/movespeed_modifier/blood_fat)
				spawn(delay+caster.discipline_time_plus)
					if(caster)
						animate(caster, transform = initial, 1 SECONDS)
						caster.physiology.armor.melee -= 20
						caster.physiology.armor.bullet -= 20
						caster.remove_movespeed_modifier(/datum/movespeed_modifier/blood_fat)
			else if(result == "Shrink")
				var/matrix/M = matrix()
				M.Scale(0.8, 1)
				var/matrix/initial = caster.transform
				animate(caster, transform = M, 1 SECONDS)
				caster.add_movespeed_modifier(/datum/movespeed_modifier/blood_slim)
				spawn(delay+caster.discipline_time_plus)
					if(caster)
						animate(caster, transform = initial, 1 SECONDS)
						caster.remove_movespeed_modifier(/datum/movespeed_modifier/blood_slim)
		if(2)
			playsound(get_turf(caster), 'code/modules/wod13/sounds/spit.ogg', 50, FALSE)
			spawn(1 SECONDS)
				var/obj/item/reagent_containers/spray/pepper/kuei_jin/K = new (get_turf(caster))
				K.spray(get_step(get_step(get_step(get_turf(caster), caster.dir), caster.dir), caster.dir), caster)
				qdel(K)
		if(3)
			if(!BC)
				BC = new (caster)
			BC.Shapeshift(caster)
			var/mob/living/simple_animal/hostile/host = BC.myshape
			host.my_creator = null
			spawn(delay+caster.discipline_time_plus)
				if(BC)
					var/mob/living/simple_animal/hostile/bloodcrawler/BD = BC.myshape
					if(BD.collected_blood > 1)
						H.adjustBruteLoss(-5*round(BD.collected_blood/2), TRUE)
						H.adjustFireLoss(-5*round(BD.collected_blood/2), TRUE)
					BC.Restore(BC.myshape)
					caster.Stun(15)
					caster.do_jitter_animation(30)
		if(4)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/gun/magic/blood_shintai(caster))
		if(5)
			var/obj/item/melee/vampirearms/katana/blood/F = new (caster)
			caster.drop_all_held_items()
			caster.put_in_active_hand(F)
			spawn(delay+caster.discipline_time_plus)
				if(F)
					qdel(F)

/datum/chi_discipline/jade_shintai
	name = "Jade Shintai"
	desc = "Manipulate own weight and capabilities."
	icon_state = "jade"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/jadeshintai_activate.ogg'

/obj/item/melee/powerfist/stone
	name = "stone-fist"
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "stonefist"
	desc = "A stone gauntlet to punch someone."
	item_flags = DROPDEL

/obj/item/tank/internals/oxygen/stone_shintai
	item_flags = DROPDEL
	alpha = 0

/obj/item/melee/powerfist/stone/Initialize()
	. = ..()
	tank = new /obj/item/tank/internals/oxygen/stone_shintai()

/obj/item/melee/powerfist/stone/updateTank(obj/item/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	return FALSE

/datum/chi_discipline/jade_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			var/obj/structure/bury_pit/B = new (get_turf(caster))
			B.icon_state = "pit0"
			caster.forceMove(B)
		if(2)
			caster.pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
			caster.jade_shintai_override = 11
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.pass_flags = initial(caster.pass_flags)
					caster.jade_shintai_override = 0
		if(3)
			caster.gargoyle_pass = TRUE
			caster.alpha = 128
			caster.obfuscate_level = 3
			caster.add_movespeed_modifier(/datum/movespeed_modifier/wall_passing)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.obfuscate_level = 0
					caster.alpha = 255
					caster.gargoyle_pass = FALSE
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/wall_passing)
		if(4)
			caster.dna.species.ToggleFlight(caster)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.dna.species.ToggleFlight(caster)
		if(5)
			caster.remove_overlay(POTENCE_LAYER)
			var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "[caster.base_body_mod]rock", -POTENCE_LAYER)
			caster.overlays_standing[POTENCE_LAYER] = fortitude_overlay
			caster.apply_overlay(POTENCE_LAYER)
			caster.physiology.armor.melee += 50
			caster.physiology.armor.bullet += 50
			caster.drop_all_held_items()
			var/obj/item/melee/powerfist/stone/S1 = new (caster)
			var/obj/item/melee/powerfist/stone/S2 = new (caster)
			caster.put_in_r_hand(S1)
			caster.put_in_l_hand(S2)
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.physiology.armor.melee -= 50
					caster.physiology.armor.bullet -= 50
					caster.remove_overlay(POTENCE_LAYER)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					if(S1)
						qdel(S1)
					if(S2)
						qdel(S2)

/datum/chi_discipline/bone_shintai
	name = "Bone Shintai"
	desc = "Manipulate the matter static around."
	icon_state = "bone"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yin = 1
	activate_sound = 'code/modules/wod13/sounds/boneshintai_activate.ogg'

/obj/effect/particle_effect/smoke/bad/green/bone_shintai
	name = "green dangerous smoke"

/datum/effect_system/smoke_spread/bad/green/bone_shintai
	effect_type = /obj/effect/particle_effect/smoke/bad/green/bone_shintai

/obj/effect/particle_effect/smoke/bad/green/bone_shintai/smoke_mob(mob/living/carbon/M)
	. = ..()
	if(.)
		M.adjustToxLoss(15, TRUE)
		M.emote("cough")
		return TRUE

/obj/item/melee/vampirearms/knife/bone_shintai
	name = "claws"
	icon_state = "claws"
	w_class = WEIGHT_CLASS_BULKY
	force = 35
	armour_penetration = 100	//It's magical damage
	block_chance = 20
	item_flags = DROPDEL
	masquerade_violating = TRUE
	is_iron = FALSE

/datum/chi_discipline/bone_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			ADD_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
			ADD_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
			caster.physiology.armor.melee += 25
			caster.physiology.armor.bullet += 25
			caster.add_movespeed_modifier(/datum/movespeed_modifier/necroing)
			var/initial_limbs_id = caster.dna.species.limbs_id
			caster.dna.species.limbs_id = "rotten1"
			caster.update_body()
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
					caster.physiology.armor.melee -= 25
					caster.physiology.armor.bullet -= 25
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/necroing)
					caster.dna.species.limbs_id = initial_limbs_id
					caster.update_body()
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
		if(2)
			var/initial_hair = caster.hairstyle
			var/initial_facial = caster.facial_hairstyle
			caster.unique_body_sprite = "nothing"
			caster.hairstyle = "Bald"
			caster.facial_hairstyle = "Shaved"
			caster.update_body()
			caster.freezing_aura = TRUE
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.unique_body_sprite = null
					caster.hairstyle = initial_hair
					caster.facial_hairstyle = initial_facial
					caster.update_body()
					caster.freezing_aura = FALSE
		if(3)
			var/obj/item/melee/vampirearms/knife/bone_shintai/S1 = new (caster)
			var/obj/item/melee/vampirearms/knife/bone_shintai/S2 = new (caster)
			caster.put_in_r_hand(S1)
			caster.put_in_l_hand(S2)
			spawn(delay+caster.discipline_time_plus)
				if(S1)
					qdel(S1)
				if(S2)
					qdel(S2)
		if(4)
			playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE)
			var/datum/effect_system/smoke_spread/bad/green/bone_shintai/smoke = new
			smoke.set_up(4, caster)
			smoke.start()
			qdel(smoke)
		if(5)
			ADD_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
			ADD_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
			caster.physiology.armor.melee += 25
			caster.physiology.armor.bullet += 25
			caster.unique_body_sprite = "rotten1"
			caster.update_body()
			caster.set_light(1.4,5,"#34D352")
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
					caster.physiology.armor.melee -= 25
					caster.physiology.armor.bullet -= 25
					caster.unique_body_sprite = null
					caster.update_body()
					caster.set_light(0)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)

/datum/chi_discipline/ghost_flame_shintai
	name = "Ghost Flame Shintai"
	desc = "Manipulate fire and temperature."
	icon_state = "ghostfire"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/ghostflameshintai_activate.ogg'

/mob/living/simple_animal/hostile/beastmaster/fireball
	name = "fireball"
	desc = "FIREBALL!!"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fireball"
	icon_living = "fireball"
	del_on_death = TRUE
	attack_verb_continuous = "burns"
	attack_verb_simple = "burn"
	attack_sound = 'sound/effects/extinguish.ogg'
	speak_chance = 0
	turns_per_move = 3
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_UNDEAD
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	bloodpool = 0
	maxbloodpool = 0
	maxHealth = 30
	health = 30
	yang_chi = 1
	max_yang_chi = 1
	yin_chi = 0
	max_yin_chi = 0
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 30
	melee_damage_type = BURN
	speed = 2
	dodging = TRUE

/obj/item/gun/magic/ghostflame_shintai
	name = "fire spit"
	desc = "Spit fire on your targets."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fireball"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/ghostflame_shintai
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/ghostflame_shintai
	name = "fire spit"
	desc = "A spit."
	projectile_type = /obj/projectile/magic/aoe/fireball/firebreath
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/ghostflame_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)

/datum/chi_discipline/ghost_flame_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/limit = min(2, level) + caster.social + caster.more_companions - 1
	if(length(caster.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(caster.beastmaster)
		B.death()
	switch(level_casting)
		if(1)
			target.overlay_fullscreen("ghostflame", /atom/movable/screen/fullscreen/see_through_darkness)
			caster.set_light(1.4,5,"#ff8c00")
			caster.burning_aura = TRUE
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					target.clear_fullscreen("ghostflame", 5)
					caster.burning_aura = FALSE
					caster.set_light(0)
		if(2)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/fireball/C = new(get_turf(caster))
			C.my_creator = caster
			caster.beastmaster |= C
			C.beastmaster = caster
		if(3)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/gun/magic/ghostflame_shintai(caster))
		if(4)
			caster.drop_all_held_items()
			var/obj/item/melee/vampirearms/katana/fire/F = new (caster)
			caster.put_in_active_hand(F)
			spawn(delay+caster.discipline_time_plus)
				if(F)
					qdel(F)
		if(5)
			caster.dna.species.burnmod = 0
			ADD_TRAIT(caster, TRAIT_PERMANENTLY_ONFIRE, MAGIC_TRAIT)
			ADD_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
			caster.set_fire_stacks(7)
			caster.IgniteMob()
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_PERMANENTLY_ONFIRE, MAGIC_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
					caster.extinguish_mob()
					if(caster.mind.dharma)
						switch(caster.mind.dharma.animated)
							if("Yang")
								caster.dna.species.burnmod = 0.5
							if("Yin")
								caster.dna.species.burnmod = initial(caster.dna.species.burnmod)
					else
						caster.dna.species.burnmod = initial(caster.dna.species.burnmod)
					caster.bodytemperature = BODYTEMP_NORMAL
					caster.coretemperature = BODYTEMP_NORMAL

/datum/chi_discipline/flesh_shintai
	name = "Flesh Shintai"
	desc = "Manipulate own flesh and flexibility."
	icon_state = "flesh"
	ranged = FALSE
	cost_yin = 1
	delay = 12 SECONDS
	activate_sound = 'code/modules/wod13/sounds/fleshshintai_activate.ogg'
	var/datum/component/tackler

/obj/item/chameleon/temp
	name = "Appearance Projector"
	item_flags = DROPDEL

//obj/item/chameleon/temp/Initialize()
//	. = ..()
//	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)

//Meat Hook
/obj/item/gun/magic/hook/flesh_shintai
	name = "obviously long arm"
	ammo_type = /obj/item/ammo_casing/magic/hook/flesh_shintai
	icon_state = "hook_hand"
	icon = 'code/modules/wod13/weapons.dmi'
	inhand_icon_state = "hook_hand"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	fire_sound = 'code/modules/wod13/sounds/vicissitude.ogg'
	max_charges = 1
	item_flags = DROPDEL | NOBLUDGEON
	force = 18

/obj/item/ammo_casing/magic/hook/flesh_shintai
	name = "hand"
	desc = "A hand."
	projectile_type = /obj/projectile/flesh_shintai
	caliber = CALIBER_HOOK
	icon_state = "hook"

/obj/projectile/flesh_shintai
	name = "hand"
	icon_state = "hand"
	icon = 'code/modules/wod13/icons.dmi'
	pass_flags = PASSTABLE
	damage = 0
	stamina = 20
	hitsound = 'sound/effects/splat.ogg'
	var/chain
	var/knockdown_time = (0.5 SECONDS)

/obj/projectile/flesh_shintai/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "arm")
		if(iscathayan(firer))
			var/mob/living/carbon/human/H = firer
			if(H.CheckEyewitness(H, H, 7, FALSE))
				H.AdjustMasquerade(-1)
	..()

/obj/projectile/flesh_shintai/on_hit(atom/target)
	. = ..()
	if(ismovable(target))
		var/atom/movable/A = target
		if(A.anchored)
			return
		A.visible_message("<span class='danger'>[A] is snagged by [firer]'s hand!</span>")
		A.forceMove(get_turf(get_step_towards(firer, A)))
		if (isliving(target))
			var/mob/living/fresh_meat = target
			fresh_meat.grabbedby(firer, supress_message = FALSE)
			fresh_meat.Knockdown(knockdown_time)
			return
		//TODO: keep the chain beamed to A
		//TODO: needs a callback to delete the chain

/obj/projectile/flesh_shintai/Destroy()
	qdel(chain)
	return ..()

/obj/structure/flesh_grip
	name = "flesh grip"
	desc = "A huge flesh meat structure."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "flesh_grip"
	can_buckle = TRUE
	anchored = TRUE
	density = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/flesh_grip/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message("<span class='notice'>[user] tries to pull [M] free of [src]!</span>",\
				"<span class='notice'>[user] is trying to pull you off [src], opening up fresh wounds!</span>",\
				"<span class='hear'>You hear a squishy wet noise.</span>")
			if(!do_after(user, 300, target = src))
				if(M?.buckled)
					M.visible_message("<span class='notice'>[user] fails to free [M]!</span>",\
					"<span class='notice'>[user] fails to pull you off of [src].</span>")
				return

		else
			M.visible_message("<span class='warning'>[M] struggles to break free from [src]!</span>",\
			"<span class='notice'>You struggle to break free from [src], exacerbating your wounds! (Stay still for two minutes.)</span>",\
			"<span class='hear'>You hear a wet squishing noise..</span>")
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M?.buckled)
					to_chat(M, "<span class='warning'>You fail to free yourself!</span>")
				return
		if(!M.buckled)
			return
		release_mob(M)

/obj/structure/flesh_grip/proc/release_mob(mob/living/M)
	var/matrix/m180 = matrix(M.transform)
	m180.Turn(180)
	animate(M, transform = m180, time = 3)
	M.pixel_y = M.base_pixel_y + PIXEL_Y_OFFSET_LYING
	M.adjustBruteLoss(30)
	src.visible_message(text("<span class='danger'>[M] falls free of [src]!</span>"))
	unbuckle_mob(M,force=1)
	M.emote("scream")
	M.AdjustParalyzed(20)
	qdel(src)

/datum/chi_discipline/flesh_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			var/obj/item/gun/magic/hook/flesh_shintai/F = new (caster)
			caster.drop_all_held_items()
			caster.put_in_active_hand(F)
			spawn(delay+caster.discipline_time_plus)
				qdel(F)
		if(2)
			caster.remove_overlay(PROTEAN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "flesh_arms", -PROTEAN_LAYER)
			caster.overlays_standing[PROTEAN_LAYER] = potence_overlay
			caster.apply_overlay(PROTEAN_LAYER)
			caster.dna.species.punchdamagelow += 20
			caster.dna.species.punchdamagehigh += 20
			caster.dna.species.meleemod += 1
			caster.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
			tackler = caster.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 2+level_casting, speed = 1, skill_mod = 0, min_distance = 0)
			caster.potential = 4
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(PROTEAN_LAYER)
					caster.potential = 0
					caster.dna.species.punchdamagelow -= 20
					caster.dna.species.punchdamagehigh -= 20
					caster.dna.species.meleemod -= 1
					caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
					qdel(tackler)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
		if(3)
			ADD_TRAIT(caster, TRAIT_HANDS_BLOCK_PROJECTILES, "flesh shintai 3")
			to_chat(caster, "<span class='notice'>Your muscles relax and start moving unintentionally. You feel perfect at projectile evasion skills...</span>")
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_HANDS_BLOCK_PROJECTILES, "flesh shintai 3")
					to_chat(caster, "<span class='warning'>Your muscles feel natural again..</span>")
		if(4)
			var/obj/structure/flesh_grip/F = new (get_turf(caster))
			if(caster.pulling)
				if(isliving(caster.pulling))
					F.buckle_mob(caster.pulling, TRUE, FALSE)
			else
				for(var/mob/living/L in range(2, caster))
					if(L != caster)
						if(L.stat != DEAD)
							F.buckle_mob(L, TRUE, FALSE)
		if(5)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/chameleon/temp(caster))

/datum/chi_discipline/black_wind
	name = "Black Wind"
	desc = "Gain control over speed of reaction."
	icon_state = "blackwind"
	ranged = FALSE
	activate_sound = 'code/modules/wod13/sounds/blackwind_activate.ogg'
	delay = 12 SECONDS
	cost_demon = 1
	discipline_type = "Demon"

/datum/chi_discipline/black_wind/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/blackwind_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity)
					caster.celerity_visual = FALSE
		if(2)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity2)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/blackwind_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity2)
					caster.celerity_visual = FALSE
		if(3)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity3)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/blackwind_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity3)
					caster.celerity_visual = FALSE
		if(4)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity4)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/blackwind_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity4)
					caster.celerity_visual = FALSE
		if(5)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity5)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/blackwind_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity5)
					caster.celerity_visual = FALSE

/datum/chi_discipline/demon_shintai
	name = "Demon Shintai"
	desc = "Transform into the P'o."
	icon_state = "demon"
	ranged = FALSE
	delay = 12 SECONDS
	cost_demon = 1
	discipline_type = "Demon"
	activate_sound = 'code/modules/wod13/sounds/demonshintai_activate.ogg'
	var/current_form = "Samurai"

/datum/chi_discipline/demon_shintai/post_gain(var/mob/living/carbon/human/H)
	var/datum/action/choose_demon_form/C = new()
	C.Grant(H)

/datum/action/choose_demon_form
	name = "Choose Demon Form"
	desc = "Choose your form of a Demon."
	button_icon_state = "demon_form"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/choose_demon_form/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/BD = usr
		var/sett = input(BD, "Choose your Demon Form", "Demon Form") as null|anything in list("Samurai", "Tentacles", "Demon", "Giant", "Foul")
		if(sett)
			to_chat(BD, "Your new form is [sett].")
			for(var/datum/action/chi_discipline/C in BD.actions)
				if(C)
					if(istype(C.discipline, /datum/chi_discipline/demon_shintai))
						var/datum/chi_discipline/demon_shintai/D = C.discipline
						D.current_form = sett
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/datum/movespeed_modifier/tentacles1
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/demonform1
	multiplicative_slowdown = -0.5
/datum/movespeed_modifier/demonform2
	multiplicative_slowdown = -1
/datum/movespeed_modifier/demonform3
	multiplicative_slowdown = -2
/datum/movespeed_modifier/demonform4
	multiplicative_slowdown = -3
/datum/movespeed_modifier/demonform5
	multiplicative_slowdown = -5

/datum/chi_discipline/demon_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(current_form)
		if("Samurai")
			var/mod = 10*level_casting
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "samurai", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			caster.physiology.armor.melee += mod
			caster.physiology.armor.bullet += mod
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.physiology.armor.melee -= mod
					caster.physiology.armor.bullet -= mod
					caster.remove_overlay(UNICORN_LAYER)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/demonshintai_deactivate.ogg', 50, FALSE)
		if("Tentacles")
			var/mod = level_casting
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "tentacles", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			ADD_TRAIT(caster, TRAIT_SHOCKIMMUNE, SPECIES_TRAIT)
			ADD_TRAIT(caster, TRAIT_PASSTABLE, SPECIES_TRAIT)
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			if(mod > 1)
				caster.add_movespeed_modifier(/datum/movespeed_modifier/tentacles1)
				ADD_TRAIT(caster, TRAIT_PUSHIMMUNE, SPECIES_TRAIT)
				ADD_TRAIT(caster, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
			if(mod > 2)
				ADD_TRAIT(caster, TRAIT_IGNOREDAMAGESLOWDOWN, SPECIES_TRAIT)
				ADD_TRAIT(caster, TRAIT_SLEEPIMMUNE, SPECIES_TRAIT)
			if(mod > 4)
				ADD_TRAIT(caster, TRAIT_STUNIMMUNE, SPECIES_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					REMOVE_TRAIT(caster, TRAIT_SHOCKIMMUNE, SPECIES_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_PASSTABLE, SPECIES_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					if(mod > 1)
						caster.remove_movespeed_modifier(/datum/movespeed_modifier/tentacles1)
						REMOVE_TRAIT(caster, TRAIT_PUSHIMMUNE, SPECIES_TRAIT)
						REMOVE_TRAIT(caster, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
					if(mod > 2)
						REMOVE_TRAIT(caster, TRAIT_IGNOREDAMAGESLOWDOWN, SPECIES_TRAIT)
						REMOVE_TRAIT(caster, TRAIT_SLEEPIMMUNE, SPECIES_TRAIT)
					if(mod > 4)
						REMOVE_TRAIT(caster, TRAIT_STUNIMMUNE, SPECIES_TRAIT)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/demonshintai_deactivate.ogg', 50, FALSE)
		if("Demon")
			var/mod = level_casting
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "demon", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			switch(mod)
				if(1)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform1)
				if(2)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform2)
				if(3)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform3)
				if(4)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform4)
				if(5)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform5)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					switch(mod)
						if(1)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform1)
						if(2)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform2)
						if(3)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform3)
						if(4)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform4)
						if(5)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform5)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/demonshintai_deactivate.ogg', 50, FALSE)
		if("Giant")
			var/mod = level_casting*10
			var/meleemod = level_casting*0.5
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "giant", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			caster.dna.species.punchdamagelow += mod
			caster.dna.species.punchdamagehigh += mod
			caster.dna.species.meleemod += meleemod
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					caster.dna.species.punchdamagelow -= mod
					caster.dna.species.punchdamagehigh -= mod
					caster.dna.species.meleemod -= meleemod
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/demonshintai_deactivate.ogg', 50, FALSE)
		if("Foul")
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "foul", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			caster.foul_aura = level_casting*5
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					caster.foul_aura = 0
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/demonshintai_deactivate.ogg', 50, FALSE)

/datum/chi_discipline/hellweaving
	name = "Hellweaving"
	desc = "Translate the view of Hell to someone."
	icon_state = "hellweaving"
	ranged = TRUE
	delay = 12 SECONDS
	cost_demon = 1
	activate_sound = 'code/modules/wod13/sounds/hellweaving_activate.ogg'
	discipline_type = "Demon"

/atom/movable/screen/fullscreen/yomi_world
	icon = 'icons/hud/fullscreen.dmi'
	icon_state = "hall"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/yomi_world/Initialize()
	. = ..()
	dir = pick(NORTH, EAST, WEST, SOUTH, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/effect/particle_effect/smoke/bad/yomi
	name = "dark red smoke"
	color = "#6f0000"
	opaque = FALSE

/datum/effect_system/smoke_spread/bad/yomi
	effect_type = /obj/effect/particle_effect/smoke/bad/yomi

/obj/effect/particle_effect/smoke/bad/yomi/smoke_mob(mob/living/carbon/M)
	. = ..()
	if(.)
		M.adjustCloneLoss(10, TRUE)
		M.emote(pick("scream", "groan", "cry"))
		return TRUE

/datum/movespeed_modifier/yomi_flashback
	multiplicative_slowdown = 6

/datum/chi_discipline/hellweaving/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/mypower = caster.social + caster.additional_social
	var/theirpower = target.mentality + target.additional_mentality
	if(theirpower >= mypower)
		to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to flashback!</span>")
		return
	switch(level_casting)
		if(1)
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)
		if(2)
			playsound(get_turf(target), 'code/modules/wod13/sounds/portal.ogg', 100, TRUE)
			var/datum/effect_system/smoke_spread/bad/yomi/smoke = new
			smoke.set_up(2, target)
			smoke.start()
		if(3)
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)
			target.add_movespeed_modifier(/datum/movespeed_modifier/yomi_flashback)
			target.emote("cry")
			spawn(30)
				if(target)
					target.remove_movespeed_modifier(/datum/movespeed_modifier/yomi_flashback)
		if(4)
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/attack_myself_command)
				for(var/i in 1 to 20)
					addtimer(cb, (i - 1)*15)
				target.emote("scream")
				target.do_jitter_animation(30)
		if(5)
			target.emote(pick("cry", "scream", "groan"))
			target.point_at(caster)
			target.resist_fire()
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)


/datum/chi_discipline/iron_mountain
	name = "Iron Mountain"
	desc = "Gain the stoicism and endurability of your P'o."
	icon_state = "ironmountain"
	ranged = FALSE
	activate_sound = 'code/modules/wod13/sounds/ironmountain_activate.ogg'
	delay = 12 SECONDS
	cost_demon = 1
	discipline_type = "Demon"

/datum/chi_discipline/iron_mountain/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/mod = level_casting
	var/armah = 15*mod
//	caster.remove_overlay(FORTITUDE_LAYER)
//	var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "mountain", -FORTITUDE_LAYER)
//	caster.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
//	caster.apply_overlay(FORTITUDE_LAYER)
	caster.physiology.armor.melee += armah
	caster.physiology.armor.bullet += armah
	spawn(delay+caster.discipline_time_plus)
		if(caster)
			caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/ironmountain_deactivate.ogg', 50, FALSE)
			caster.physiology.armor.melee -= armah
			caster.physiology.armor.bullet -= armah
//			caster.remove_overlay(FORTITUDE_LAYER)

/datum/chi_discipline/kiai
	name = "Kiai"
	desc = "Manipulate reality by voice."
	icon_state = "kiai"
	ranged = TRUE
	delay = 12 SECONDS
	cost_demon = 1
	activate_sound = 'code/modules/wod13/sounds/kiai_activate.ogg'
	discipline_type = "Demon"

/mob/living/carbon/human/proc/combat_to_caster()
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_to(src,caster,0)
		face_atom(caster)
		a_intent = INTENT_HARM
		drop_all_held_items()
		UnarmedAttack(caster)

/datum/chi_discipline/kiai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
	switch(caster.gender)
		if(MALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
		if(FEMALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_female.ogg'
	caster.emote("scream")
	playsound(caster.loc, sound_gender, 100, FALSE)
	var/mypower = caster.social + caster.additional_social
	var/theirpower = target.mentality + target.additional_mentality
	if(theirpower >= mypower)
		to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to affect!</span>")
		return
	switch(level_casting)
		if(1)
			target.emote(pick("shiver", "pale"))
			target.Stun(2 SECONDS)
		if(2)
			target.emote("stare")
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/combat_to_caster)
				for(var/i in 1 to 20)
					addtimer(cb, (i - 1)*15)
		if(3)
			target.emote("scream")
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/step_away_caster)
				for(var/i in 1 to 20)
					addtimer(cb, (i - 1)*15)
		if(4)
			if(prob(25))
				target.resist_fire()
			new /datum/hallucination/fire(target, TRUE)
		if(5)
			if(prob(25))
				target.resist_fire()
			new /datum/hallucination/fire(target, TRUE)
			for(var/mob/living/L in viewers(5, target))
				if(L != caster && L != target)
					if(prob(20))
						L.resist_fire()
					new /datum/hallucination/fire(L, TRUE)

/datum/chi_discipline/beast_shintai
	name = "Beast Shintai"
	desc = "Use the chi energy flow to control animals or become one."
	icon_state = "beast"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/beastshintai_activate.ogg'
	var/obj/effect/proc_holder/spell/targeted/shapeshift/werewolf_like/WL

/obj/effect/proc_holder/spell/targeted/shapeshift/werewolf_like
	name = "Crinos Form"
	desc = "Take on the shape a Crinos."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/crinos_beast

/mob/living/simple_animal/hostile/crinos_beast
	name = "Wolf-like Beast"
	desc = "The peak of abominations damage. Unbelievably deadly..."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "beast_crinos"
	icon_living = "beast_crinos"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	speed = 1
	maxHealth = 575
	health = 575
	butcher_results = list(/obj/item/stack/human_flesh = 10)
	harm_intent_damage = 5
	melee_damage_lower = 35
	melee_damage_upper = 70
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 10
	maxbloodpool = 10
	dodging = TRUE

/datum/chi_discipline/beast_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	if(!WL)
		WL = new(caster)
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
//			R.my_creator = caster
			caster.beastmaster |= R
			R.beastmaster = caster
		if(2)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/cat/C = new(get_turf(caster))
//			C.my_creator = caster
			caster.beastmaster |= C
			C.beastmaster = caster
		if(3)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/D = new(get_turf(caster))
//			D.my_creator = caster
			caster.beastmaster |= D
			D.beastmaster = caster
		if(4)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/rat/flying/F = new(get_turf(caster))
//			F.my_creator = caster
			caster.beastmaster |= F
			F.beastmaster = caster
		if(5)
			WL.Shapeshift(caster)
			spawn(30 SECONDS + caster.discipline_time_plus)
				if(caster && caster.stat != DEAD)
					WL.Restore(WL.myshape)
					caster.Stun(1.5 SECONDS)

/datum/chi_discipline/smoke_shintai
	name = "Smoke Shintai"
	desc = "Use the chi energy flow to control fumes and smokes."
	icon_state = "smoke"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/smokeshintai_activate.ogg'
	var/obj/effect/proc_holder/spell/targeted/shapeshift/smoke_form/SF
	var/obj/effect/proc_holder/spell/targeted/shapeshift/hidden_smoke_form/HS

/obj/effect/proc_holder/spell/targeted/shapeshift/smoke_form
	name = "Smoke Form"
	desc = "Take on the shape a Smoke."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/smokecrawler

/obj/effect/proc_holder/spell/targeted/shapeshift/hidden_smoke_form
	name = "Smoke Form"
	desc = "Take on the shape a Smoke."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/smokecrawler/hidden

/mob/living/simple_animal/hostile/smokecrawler
	name = "Smoke Form"
	desc = "Levitating fumes."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	icon_living = "smoke"
	mob_biotypes = MOB_ORGANIC
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	speak_chance = 0
	speed = 3
	maxHealth = 100
	health = 100
	butcher_results = list(/obj/item/stack/human_flesh = 1)
	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 0
	maxbloodpool = 0

/mob/living/simple_animal/hostile/smokecrawler/hidden
	alpha = 10
	speed = 5

/datum/chi_discipline/smoke_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	if(!SF)
		SF = new(caster)
	if(!HS)
		HS = new(caster)
	switch(level_casting)
		if(1)
			var/datum/effect_system/smoke_spread/bad/smoke = new
			smoke.set_up(4, caster)
			smoke.start()
			playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE)
		if(2)
			var/list/available_turfs = list()
			for(var/turf/open/O in view(7, caster))
				if(O)
					available_turfs += O
			if(length(available_turfs))
				var/turf/to_move = pick(available_turfs)
				var/atom/movable/visual1 = new (get_turf(caster))
				visual1.density = FALSE
				visual1.anchored = TRUE
				visual1.layer = ABOVE_ALL_MOB_LAYER
				visual1.icon = 'code/modules/wod13/icons.dmi'
				visual1.icon_state = "puff"
				playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE)
				caster.forceMove(to_move)
				var/atom/movable/visual2 = new (to_move)
				visual2.density = FALSE
				visual1.anchored = TRUE
				visual2.layer = ABOVE_ALL_MOB_LAYER
				visual2.icon = 'code/modules/wod13/icons.dmi'
				visual2.icon_state = "puff"
				spawn(2 SECONDS)
					qdel(visual1)
					qdel(visual2)
		if(3)
			var/atom/movable/visual1 = new (get_step(caster, caster.dir))
			visual1.density = TRUE
			visual1.anchored = TRUE
			visual1.layer = ABOVE_ALL_MOB_LAYER
			visual1.icon = 'icons/effects/effects.dmi'
			visual1.icon_state = "smoke"
			var/atom/movable/visual2 = new (get_step(get_step(caster, caster.dir), turn(caster.dir, 90)))
			visual2.density = TRUE
			visual2.anchored = TRUE
			visual2.layer = ABOVE_ALL_MOB_LAYER
			visual2.icon = 'icons/effects/effects.dmi'
			visual2.icon_state = "smoke"
			var/atom/movable/visual3 = new (get_step(get_step(caster, caster.dir), turn(caster.dir, -90)))
			visual3.density = TRUE
			visual3.anchored = TRUE
			visual3.layer = ABOVE_ALL_MOB_LAYER
			visual3.icon = 'icons/effects/effects.dmi'
			visual3.icon_state = "smoke"
			playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE)
			spawn(delay+caster.discipline_time_plus)
				qdel(visual1)
				qdel(visual2)
				qdel(visual3)
		if(4)
			SF.Shapeshift(caster)
			var/mob/living/simple_animal/hostile/host = SF.myshape
			host.my_creator = null
			playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE)
			spawn(delay+caster.discipline_time_plus)
				if(caster && caster.stat != DEAD)
					SF.Restore(SF.myshape)
					caster.Stun(1.5 SECONDS)
		if(5)
			HS.Shapeshift(caster)
			var/mob/living/simple_animal/hostile/host = HS.myshape
			host.my_creator = null
			playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE)
			spawn(30 SECONDS + caster.discipline_time_plus)
				if(caster && caster.stat != DEAD)
					HS.Restore(HS.myshape)
					caster.Stun(1.5 SECONDS)

/datum/chi_discipline/storm_shintai
	name = "Storm Shintai"
	desc = "Use the chi energy flow to control lightnings and weather."
	icon_state = "storm"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/stormshintai_activate.ogg'

/obj/item/melee/touch_attack/storm_shintai
	name = "Storm touch"
	desc = "ELECTROCUTE YOURSELF!"
	catchphrase = null
	on_use_sound = 'code/modules/wod13/sounds/lightning.ogg'
	icon_state = "zapper"
	inhand_icon_state = "zapper"

/obj/item/melee/touch_attack/storm_shintai/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user)) //getting hard after touching yourself would also be bad
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>You can't reach out!</span>")
		return
	var/mob/living/M = target
	if(M.anti_magic_check())
		to_chat(user, "<span class='warning'>The spell can't seem to affect [M]!</span>")
		to_chat(M, "<span class='warning'>You feel your flesh turn to stone for a moment, then revert back!</span>")
		..()
		return
	M.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)
	return ..()

/obj/item/gun/magic/hook/storm_shintai
	name = "electric hand"
	ammo_type = /obj/item/ammo_casing/magic/hook/storm_shintai
	icon_state = "zapper"
	inhand_icon_state = "zapper"
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	fire_sound = 'code/modules/wod13/sounds/lightning.ogg'
	max_charges = 1
	item_flags = DROPDEL | NOBLUDGEON
	force = 18

/obj/item/ammo_casing/magic/hook/storm_shintai
	name = "lightning"
	desc = "Electricity."
	projectile_type = /obj/projectile/storm_shintai
	caliber = CALIBER_HOOK
	icon_state = "hook"

/obj/item/gun/magic/hook/storm_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/projectile/storm_shintai
	name = "lightning"
	icon_state = "spell"
	pass_flags = PASSTABLE
	damage = 0
	stamina = 20
	hitsound = 'code/modules/wod13/sounds/lightning.ogg'
	var/chain
	var/knockdown_time = (0.5 SECONDS)

/obj/projectile/storm_shintai/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state="lightning[rand(1,12)]")
		if(iscathayan(firer))
			var/mob/living/carbon/human/H = firer
			if(H.CheckEyewitness(H, H, 7, FALSE))
				H.AdjustMasquerade(-1)
	..()

/obj/projectile/storm_shintai/on_hit(atom/target)
	. = ..()
	if(ismovable(target))
		var/atom/movable/A = target
		if(A.anchored)
			return
		A.visible_message("<span class='danger'>[A] is snagged by lightning!</span>")
		playsound(get_turf(target), 'code/modules/wod13/sounds/lightning.ogg', 100, FALSE)
		if (isliving(target))
			var/mob/living/L = target
			L.Stun(5)
			L.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)
			return

/obj/projectile/storm_shintai/Destroy()
	qdel(chain)
	return ..()

/datum/chi_discipline/storm_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			caster.remove_overlay(FORTITUDE_LAYER)
			var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "tornado", -FORTITUDE_LAYER)
			fortitude_overlay.alpha = 128
			caster.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
			caster.apply_overlay(FORTITUDE_LAYER)
			caster.wind_aura = TRUE
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(FORTITUDE_LAYER)
					caster.wind_aura = FALSE
		if(2)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/melee/touch_attack/storm_shintai(caster))
		if(3)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/gun/magic/hook/storm_shintai(caster))
		if(4)
			caster.dna.species.ToggleFlight(caster)
			caster.remove_overlay(FORTITUDE_LAYER)
			var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "tornado", -FORTITUDE_LAYER)
			fortitude_overlay.pixel_y = -16
			caster.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
			caster.apply_overlay(FORTITUDE_LAYER)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.dna.species.ToggleFlight(caster)
					caster.remove_overlay(FORTITUDE_LAYER)
		if(5)
			caster.storm_aura = TRUE
			caster.remove_overlay(FORTITUDE_LAYER)
			var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "puff_const", -FORTITUDE_LAYER)
			fortitude_overlay.alpha = 128
			caster.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
			caster.apply_overlay(FORTITUDE_LAYER)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.storm_aura = FALSE
					caster.remove_overlay(FORTITUDE_LAYER)

/datum/chi_discipline/equilibrium
	name = "Equilibrium"
	desc = "Equilibrium can be used to create grotesque Chi imbalances in individuals who displease the user."
	icon_state = "equilibrium"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	cost_yin = 1
	discipline_type = "Chi"
	activate_sound = 'code/modules/wod13/sounds/equilibrium.ogg'

/datum/chi_discipline/equilibrium/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+5
			caster.physiology.armor.melee = caster.physiology.armor.melee+15
			caster.physiology.armor.bullet = caster.physiology.armor.bullet+15
			caster.dexterity = caster.dexterity+2
			caster.athletics = caster.athletics+2
			caster.lockpicking = caster.lockpicking+2
			ADD_TRAIT(caster, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
			caster.do_jitter_animation(10)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-5
					caster.physiology.armor.melee = caster.physiology.armor.melee-15
					caster.physiology.armor.bullet = caster.physiology.armor.bullet-15
					caster.dexterity = caster.dexterity-2
					caster.athletics = caster.athletics-2
					caster.lockpicking = caster.lockpicking-2
					REMOVE_TRAIT(caster, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
		if(2)
			caster.yin_chi += 1
			caster.yang_chi += 1		//Redeeming for the shift
			var/next = input(caster, "Where do you want to shift your Yang Chi?", "Chi Shift") as null|anything in list("Yin Pool", "Demon Pool", "Nowhere")
			if(next == "Yin Pool")
				var/init_yin = caster.yin_chi
				var/actually_shifted = min(min(caster.max_yin_chi, caster.yin_chi+caster.yang_chi)-init_yin, caster.yang_chi)
				caster.yang_chi -= actually_shifted
				caster.yin_chi += actually_shifted
				to_chat(caster, "<span class='warning'>You put your Yang into your Yin.</span>")
			if(next == "Demon Pool")
				var/init_demon = caster.demon_chi
				var/actually_shifted = min(min(caster.max_demon_chi, caster.demon_chi+caster.yang_chi)-init_demon, caster.yang_chi)
				caster.yang_chi -= actually_shifted
				caster.demon_chi += actually_shifted
				to_chat(caster, "<span class='warning'>You put your Yang into your Demon.</span>")
			var/next2 = input(caster, "Where do you want to shift your Yin Chi?", "Chi Shift") as null|anything in list("Yang Pool", "Demon Pool", "Nowhere")
			if(next2 == "Yang Pool")
				var/init_yang = caster.yang_chi
				var/actually_shifted = min(min(caster.max_yang_chi, caster.yang_chi+caster.yin_chi)-init_yang, caster.yin_chi)
				caster.yin_chi -= actually_shifted
				caster.yang_chi += actually_shifted
				to_chat(caster, "<span class='warning'>You put your Yin into your Yang.</span>")
			if(next2 == "Demon Pool")
				var/init_demon = caster.demon_chi
				var/actually_shifted = min(min(caster.max_demon_chi, caster.demon_chi+caster.yin_chi)-init_demon, caster.yin_chi)
				caster.yin_chi -= actually_shifted
				caster.demon_chi += actually_shifted
				to_chat(caster, "<span class='warning'>You put your Yin into your Demon.</span>")
			var/next3 = input(caster, "Where do you want to shift your Demon Chi?", "Chi Shift") as null|anything in list("Yin Pool", "Yang Pool", "Nowhere")
			if(next3 == "Yin Pool")
				var/init_yin = caster.yin_chi
				var/actually_shifted = min(min(caster.max_yin_chi, caster.yin_chi+caster.demon_chi)-init_yin, caster.demon_chi)
				caster.demon_chi -= actually_shifted
				caster.yin_chi += actually_shifted
				to_chat(caster, "<span class='warning'>You put your Demon into your Yin.</span>")
			if(next3 == "Yang Pool")
				var/init_yang = caster.yang_chi
				var/actually_shifted = min(min(caster.max_yang_chi, caster.yang_chi+caster.demon_chi)-init_yang, caster.demon_chi)
				caster.demon_chi -= actually_shifted
				caster.yang_chi += actually_shifted
				to_chat(caster, "<span class='warning'>You put your Demon into your Yang.</span>")
		if(3)
			for(var/mob/living/carbon/human/H in viewers(5, caster))
				if(H != caster)
					H.dna.species.punchdamagehigh = H.dna.species.punchdamagehigh+5
					H.physiology.armor.melee = H.physiology.armor.melee+15
					H.physiology.armor.bullet = H.physiology.armor.bullet+15
					H.dexterity = H.dexterity+2
					H.athletics = H.athletics+2
					H.lockpicking = H.lockpicking+2
					ADD_TRAIT(H, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
					var/obj/effect/celerity/C = new(get_turf(H))
					C.appearance = H.appearance
					C.dir = H.dir
					var/matrix/ntransform = matrix(H.transform)
					ntransform.Scale(2, 2)
					animate(C, transform = ntransform, alpha = 0, time = 1 SECONDS)
					spawn(delay+caster.discipline_time_plus)
						qdel(C)
						if(H)
							H.dna.species.punchdamagehigh = H.dna.species.punchdamagehigh-5
							H.physiology.armor.melee = H.physiology.armor.melee-15
							H.physiology.armor.bullet = H.physiology.armor.bullet-15
							H.dexterity = H.dexterity-2
							H.athletics = H.athletics-2
							H.lockpicking = H.lockpicking-2
							REMOVE_TRAIT(H, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
		if(4)
			for(var/mob/living/H in viewers(5, caster))
				if(H != caster)
					H.AdjustKnockdown(2 SECONDS, TRUE)
					H.emote("scream")
					playsound(get_turf(H), 'code/modules/wod13/sounds/vicissitude.ogg', 75, FALSE)
					step_away(H, caster)
		if(5)
			caster.yin_chi += 1
			caster.yang_chi += 1
			var/area/A = get_area(caster)
			if(A.yang_chi)
				caster.yang_chi = min(caster.yang_chi+A.yang_chi+1, caster.max_yang_chi)
				to_chat(caster, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
			if(A.yin_chi)
				caster.yin_chi = min(caster.yin_chi+A.yin_chi+1, caster.max_yin_chi)
				to_chat(caster, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")

/datum/chi_discipline/feng_shui
	name = "Feng Shui"
	desc = "By manipulating special talismans, the fang shih can direct energies to control and corrupt."
	icon_state = "fengshui"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	cost_yin = 1
	discipline_type = "Chi"
	activate_sound = 'code/modules/wod13/sounds/feng_shui.ogg'

/datum/movespeed_modifier/pacifisting
	multiplicative_slowdown = 3

/datum/chi_discipline/feng_shui/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			var/sound/auspexbeat = sound('code/modules/wod13/sounds/auspex.ogg', repeat = TRUE)
			caster.playsound_local(caster, auspexbeat, 75, 0, channel = CHANNEL_DISCIPLINES, use_reverb = FALSE)
			var/loh = FALSE
			if(!HAS_TRAIT(caster, TRAIT_NIGHT_VISION))
				ADD_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
				loh = TRUE
			caster.update_sight()
			caster.add_client_colour(/datum/client_colour/glass_colour/lightblue)
			var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
			abductor_hud.add_hud_to(caster)
			caster.auspex_examine = TRUE
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.auspex_examine = FALSE
					caster.see_invisible = initial(caster.see_invisible)
					abductor_hud.remove_hud_from(caster)
					caster.stop_sound_channel(CHANNEL_DISCIPLINES)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/auspex_deactivate.ogg', 50, FALSE)
					if(loh)
						REMOVE_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
					caster.remove_client_colour(/datum/client_colour/glass_colour/lightblue)
					caster.update_sight()
		if(2)
			var/sound/auspexbeat = sound('code/modules/wod13/sounds/auspex.ogg', repeat = TRUE)
			caster.playsound_local(caster, auspexbeat, 75, 0, channel = CHANNEL_DISCIPLINES, use_reverb = FALSE)
			ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
			var/loh = FALSE
			if(!HAS_TRAIT(caster, TRAIT_NIGHT_VISION))
				ADD_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
				loh = TRUE
			caster.update_sight()
			var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
			health_hud.add_hud_to(caster)
			caster.auspex_examine = TRUE
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.auspex_examine = FALSE
					caster.see_invisible = initial(caster.see_invisible)
					health_hud.remove_hud_from(caster)
					caster.stop_sound_channel(CHANNEL_DISCIPLINES)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/auspex_deactivate.ogg', 50, FALSE)
					REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
					if(loh)
						REMOVE_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
					caster.update_sight()
		if(3)
			if(caster.lastattacked)
				if(isliving(caster.lastattacked))
					var/mob/living/L = caster.lastattacked
					to_chat(L, "<span class='warning'>You feel bigger hunger than usual.</span>")
					if(iskindred(L))
						L.bloodpool = max(0, L.bloodpool-3)
					else if(iscathayan(L))
						L.yang_chi = max(0, L.yang_chi-2)
						L.yin_chi = max(0, L.yin_chi-2)
					else
						L.adjust_nutrition(-100)
					playsound(get_turf(L), 'code/modules/wod13/sounds/hunger.ogg', 100, FALSE)
					to_chat(caster, "You send your curse on [L], the last creature you attacked.")
				else
					to_chat(caster, "You don't seem to have last attacked soul earlier...")
					return
			else
				to_chat(caster, "You don't seem to have last attacked soul earlier...")
				return
		if(4)
			for(var/mob/living/L in viewers(5, caster))
				if(L != caster)
					ADD_TRAIT(L, TRAIT_PACIFISM, MAGIC_TRAIT)
					L.add_movespeed_modifier(/datum/movespeed_modifier/pacifisting)
					L.emote("stare")
					spawn(delay+caster.discipline_time_plus)
						if(L)
							REMOVE_TRAIT(L, TRAIT_PACIFISM, MAGIC_TRAIT)
							L.remove_movespeed_modifier(/datum/movespeed_modifier/pacifisting)
		if(5)
			var/atom/movable/visual1 = new (get_step(caster, caster.dir))
			visual1.density = TRUE
			visual1.anchored = TRUE
			visual1.layer = ABOVE_ALL_MOB_LAYER
			visual1.icon = 'icons/effects/effects.dmi'
			visual1.icon_state = "static_base"
			visual1.alpha = 128
			var/atom/movable/visual2 = new (get_step(caster, turn(caster.dir, 90)))
			visual2.density = TRUE
			visual2.anchored = TRUE
			visual2.layer = ABOVE_ALL_MOB_LAYER
			visual2.icon = 'icons/effects/effects.dmi'
			visual2.icon_state = "static_base"
			visual2.alpha = 128
			var/atom/movable/visual3 = new (get_step(caster, turn(caster.dir, -90)))
			visual3.density = TRUE
			visual3.anchored = TRUE
			visual3.layer = ABOVE_ALL_MOB_LAYER
			visual3.icon = 'icons/effects/effects.dmi'
			visual3.icon_state = "static_base"
			visual3.alpha = 128
			var/atom/movable/visual4 = new (get_step(caster, turn(caster.dir, 180)))
			visual4.density = TRUE
			visual4.anchored = TRUE
			visual4.layer = ABOVE_ALL_MOB_LAYER
			visual4.icon = 'icons/effects/effects.dmi'
			visual4.icon_state = "static_base"
			visual4.alpha = 128
			playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE)
			spawn(delay+caster.discipline_time_plus)
				qdel(visual1)
				qdel(visual2)
				qdel(visual3)
				qdel(visual4)

/datum/chi_discipline/tapestry
	name = "Tapestry"
	desc = "Kuei-jin can manipulate the dragon lines that flow beneath the Middle Kingdom."
	icon_state = "tapestry"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1
	cost_yin = 1
	discipline_type = "Chi"
	activate_sound = 'code/modules/wod13/sounds/tapestry.ogg'
	var/prev_z

/atom/movable/penumbra_ghost
	var/last_ghost_moved = 0

/atom/movable/penumbra_ghost/relaymove(mob/living/user, direction)
	if(last_ghost_moved+5 <= world.time)
		last_ghost_moved = world.time
		dir = direction
		forceMove(get_step(src, direction))

/obj/effect/anomaly/grav_kuei
	name = "gravitational anomaly"
	icon_state = "shield2"
	density = FALSE
	var/boing = 0
	aSignal = /obj/item/assembly/signaler/anomaly/grav
	drops_core = FALSE
	var/mob/owner

/obj/effect/anomaly/grav_kuei/process(delta_time)
	anomalyEffect()		//so it's kinda more faster?
	if(death_time < world.time)
		if(loc)
			detonate()
		qdel(src)

/obj/effect/anomaly/grav_kuei/anomalyEffect()
	..()
	boing = 1
	for(var/obj/O in orange(4, src))
		if(!O.anchored)
			step_towards(O,src)
	for(var/mob/living/M in range(0, src))
		if(M != owner)
			gravShock(M)
	for(var/mob/living/M in orange(4, src))
		if(!M.mob_negates_gravity() && M != owner)
			step_towards(M,src)
	for(var/obj/O in range(0,src))
		if(!O.anchored)
			if(isturf(O.loc))
				var/turf/T = O.loc
				if(T.intact && HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
					continue
			var/mob/living/target = locate() in view(4,src)
			if(target && !target.stat && target != owner)
				O.throw_at(target, 5, 10)

/obj/effect/anomaly/grav_kuei/Crossed(atom/movable/AM)
	. = ..()
	gravShock(AM)

/obj/effect/anomaly/grav_kuei/Bump(atom/A)
	gravShock(A)

/obj/effect/anomaly/grav_kuei/Bumped(atom/movable/AM)
	gravShock(AM)

/obj/effect/anomaly/grav_kuei/proc/gravShock(mob/living/A)
	if(boing && isliving(A) && !A.stat)
		A.Paralyze(40)
		var/atom/target = get_edge_target_turf(A, get_dir(src, get_step_away(A, src)))
		A.throw_at(target, 5, 1)
		boing = 0

/datum/chi_discipline/tapestry/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			caster.client.prefs.chat_toggles ^= CHAT_DEAD
			caster.see_invisible = SEE_INVISIBLE_OBSERVER
			for(var/mob/dead/observer/G in GLOB.player_list)
				if(G.key)
					to_chat(G, "<span class='ghostalert'>[FOLLOW_LINK(G, caster)][caster] is calling you!</span>")
			spawn(30 SECONDS)
				if(caster)
					caster.client?.prefs.chat_toggles &= ~CHAT_DEAD
					caster.see_invisible = initial(caster.see_invisible)
		if(2)
			var/chosen_z
			var/umbra_z
			var/atom/movable/penumbra_ghost/GH
			if(istype(caster.loc, /atom/movable/penumbra_ghost))
				GH = caster.loc
			for(var/area/vtm/interior/penumbra/U in world)
				if(U)
					chosen_z = U.z
					umbra_z = U.z
			if(caster.z != chosen_z)
				prev_z = caster.z
			else
				chosen_z = prev_z
				var/turf/mine = get_turf(caster)
				var/turf/to_wall = locate(mine.x, mine.y, chosen_z)
				var/area/A = get_area(to_wall)
				if(A)
					if(A.wall_rating > 1)
						to_chat(caster, "<span class='warning'><b>GAUNTLET</b> rating there is too high! You can't cross <b>PENUMBRA</b> like this...</span>")
						caster.yin_chi += 1
						caster.yang_chi += 1
						return
			if(do_mob(caster, caster, delay))
				if(chosen_z != umbra_z)
					var/atom/myloc = caster.loc
					caster.forceMove(locate(myloc.x, myloc.y, chosen_z))
					if(GH)
						qdel(GH)
				else
					caster.z = chosen_z
					GH = new (get_turf(caster))
					GH.appearance = caster.appearance
					GH.name = caster.name
					GH.alpha = 128
					caster.forceMove(GH)
				playsound(get_turf(caster), 'code/modules/wod13/sounds/portal.ogg', 100, TRUE)
		if(3)
			ADD_TRAIT(caster, TRAIT_SUPERNATURAL_LUCK, "tapestry 3")
			to_chat(caster, "<b>You feel insanely lucky!</b>")
			spawn(30 SECONDS)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_SUPERNATURAL_LUCK, "tapestry 3")
					to_chat(caster, "<span class='warning'>Your luck wanes...</span>")
		if(4)
			var/A
			A = input(caster, "Area to jump to", "BOOYEA", A) as null|anything in GLOB.teleportlocs
			if(A)
				if(do_mob(caster, caster, delay))
					var/area/thearea = GLOB.teleportlocs[A]

					var/datum/effect_system/smoke_spread/smoke = new
					smoke.set_up(2, caster.loc)
					smoke.attach(caster)
					smoke.start()
					var/list/L = list()
					for(var/turf/T in get_area_turfs(thearea.type))
						if(!T.is_blocked_turf())
							L += T

					if(!L.len)
						to_chat(caster, "<span class='warning'>The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.</span>")
						return

					if(do_teleport(caster, pick(L), forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
						smoke.start()
					else
						to_chat(caster, "<span class='warning'>The spell matrix was disrupted by something near the destination.</span>")
		if(5)
			var/obj/effect/anomaly/grav_kuei/G = new (get_turf(caster))
			G.owner = caster
			spawn(30 SECONDS)
				qdel(G)

/datum/chi_discipline/yin_prana
	name = "Yin Prana"
	desc = "Allows to tap into and manipulate Kuei-Jin internal Yin energy"
	icon_state = "yin_prana"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yin = 2
	discipline_type = "Chi"
	activate_sound = 'code/modules/wod13/sounds/yin_prana.ogg'

/obj/item/melee/touch_attack/yin_touch
	name = "\improper shadow touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'code/modules/wod13/weapons.dmi'
	catchphrase = null
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "quietus"
	color = "#343434"
	inhand_icon_state = "mansus"

/obj/item/melee/touch_attack/yin_touch/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/structure/vampdoor))
		var/obj/structure/vampdoor/V = target
		playsound(get_turf(target), 'code/modules/wod13/sounds/get_bent.ogg', 100, FALSE)
		var/obj/item/shield/door/D = new(get_turf(target))
		D.icon_state = V.baseicon
		var/atom/throw_target = get_edge_target_turf(target, user.dir)
		D.throw_at(throw_target, rand(2, 4), 4, src)
		qdel(target)
	if(isliving(target))
		var/mob/living/L = target
		L.adjustCloneLoss(20)
		L.AdjustKnockdown(2 SECONDS)
	return ..()

/datum/chi_discipline/yin_prana/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			animate(caster, alpha = 10, time = 1 SECONDS)
			caster.obfuscate_level = 3
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.obfuscate_level = 0
					if(caster.alpha != 255)
						caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/obfuscate_deactivate.ogg', 50, FALSE)
						caster.alpha = 255
		if(2)
			var/atom/movable/AM = new(target)
			AM.set_light(5, -7)
			spawn(delay+caster.discipline_time_plus)
				AM.set_light(0)
		if(3)
			for(var/mob/living/L in viewers(5, caster))
				if(L != caster)
					L.AdjustKnockdown(2 SECONDS)
					L.adjustStaminaLoss(50, TRUE)
			var/matrix/M = matrix()
			M.Scale(2, 2)
			var/obj/effect/celerity/C1 = new(get_turf(caster))
			var/obj/effect/celerity/C2 = new(get_turf(caster))
			var/obj/effect/celerity/C3 = new(get_turf(caster))
			C1.appearance = caster.appearance
			C1.dir = caster.dir
			C1.color = "#000000"
			C2.appearance = caster.appearance
			C2.dir = caster.dir
			C2.color = "#000000"
			C3.appearance = caster.appearance
			C3.dir = caster.dir
			C3.color = "#000000"
			animate(C1, pixel_x = pick(-16, 0, 16), pixel_y = pick(-16, 0, 16), alpha = 0, transform = M, time = 2 SECONDS)
			animate(C2, pixel_x = pick(-16, 0, 16), pixel_y = pick(-16, 0, 16), alpha = 0, transform = M, time = 2 SECONDS)
			animate(C3, pixel_x = pick(-16, 0, 16), pixel_y = pick(-16, 0, 16), alpha = 0, transform = M, time = 2 SECONDS)
		if(4)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/melee/touch_attack/yin_touch(caster))
		if(5)
			for(var/mob/living/L in viewers(7, caster))
				if(L != caster)
					new /datum/hallucination/dangerflash(L, TRUE)
					new /datum/hallucination/dangerflash(L, TRUE)
					new /datum/hallucination/dangerflash(L, TRUE)
					new /datum/hallucination/dangerflash(L, TRUE)
					new /datum/hallucination/dangerflash(L, TRUE)
			do_sparks(5, FALSE, caster)

/datum/chi_discipline/yang_prana
	name = "Yang Prana"
	desc = "Allows to tap into and manipulate Kuei-Jin internal Yang energy"
	icon_state = "yang_prana"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 2
	discipline_type = "Chi"
	activate_sound = 'code/modules/wod13/sounds/yang_prana.ogg'
	var/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/E

/datum/chi_discipline/yang_prana/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	if(!E)
		E = new(caster)
	switch(level_casting)
		if(1)
			var/new_say = input(caster, "What are you trying to say?", "Say") as null|text
			new_say = sanitize_text(new_say)
			if(new_say)
				caster.say(new_say)
				var/list/list_of_victims = list()
				for(var/mob/living/carbon/human/L in viewers(7, caster))
					if(L != caster)
						list_of_victims |= L
				for(var/mob/living/carbon/human/H in list_of_victims)
					if(H)
						H.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_MAGIC)
						H.gain_trauma(new /datum/brain_trauma/hypnosis(new_say), TRAUMA_RESILIENCE_MAGIC)
				spawn(30 SECONDS)
					for(var/mob/living/carbon/human/H in list_of_victims)
						if(H)
							H.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_MAGIC)
		if(2)
			caster.remove_overlay(HALO_LAYER)
			var/mutable_appearance/fortitude_overlay = mutable_appearance('icons/effects/96x96.dmi', "boh_tear", -HALO_LAYER)
			fortitude_overlay.pixel_x = -32
			fortitude_overlay.pixel_y = -32
			fortitude_overlay.alpha = 128
			caster.overlays_standing[HALO_LAYER] = fortitude_overlay
			caster.apply_overlay(HALO_LAYER)
			caster.set_light(2, 5, "#ffffff")
			spawn()
				yang_mantle_loop(caster, delay + caster.discipline_time_plus)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(HALO_LAYER)
					caster.set_light(0)
		if(3)
			ADD_TRAIT(caster, TRAIT_ENHANCED_MELEE_DODGE, "yang prana 3")
			to_chat(caster, "<span class='notice'>Your muscles relax and start moving unintentionally. You feel perfect at close range evasion skills...</span>")
			if(prob(50))
				dancefirst(caster)
			else
				dancesecond(caster)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_ENHANCED_MELEE_DODGE, "yang prana 3")
					to_chat(caster, "<span class='warning'>Your muscles feel natural again..</span>")
		if(4)
			ADD_TRAIT(caster, TRAIT_HANDS_BLOCK_PROJECTILES, "yang prana 4")
			to_chat(caster, "<span class='notice'>Your muscles relax and start moving on their own. You feel like you could deflect bullets...</span>")
			if(prob(50))
				dancefirst(caster)
			else
				dancesecond(caster)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_HANDS_BLOCK_PROJECTILES, "yang prana 4")
					to_chat(caster, "<span class='warning'>Your muscles feel normal again.</span>")
		if(5)
			E.cast(list(caster), caster)

/datum/chi_discipline/yang_prana/proc/yang_mantle_loop(mob/living/carbon/human/caster, duration)
	var/loop_started_time = world.time
	while (world.time <= (loop_started_time + duration))
		for(var/mob/living/viewing_mantle in oviewers(3, src))
			if(prob(20))
				viewing_mantle.flash_act(affect_silicon = 1)

		sleep(2 SECONDS)
