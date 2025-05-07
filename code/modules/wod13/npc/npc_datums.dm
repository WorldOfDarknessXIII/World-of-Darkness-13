/datum/icon_generator/

	var/mob/owner

	var/hair_style
	var/beard_style
	var/hair_color

	var/gender_suffix
	var/body_type_prefix
	var/skin_tone
	var/race = "human"

	var/list/gear_icons = list(
		"clothes" = list("emo","black","red","gothic","rich","janitor","graveyard"),
		"shoes" = list("shoes","jackboots","sneakers"),
		"hands" = list("leather","work","latex"),
		"belt" = list(),
		"jacket" = list("fancy_red_jacket","fancy_gray_jacket","coat1","coat2","jacket1","jacket2","trench1","trench2"),
		"eyes" = list("yellow","sun"),
		"face" = list(), //Facial covers covers facial hair, but not eyes/eye cover
		"mask" = list(), //Masks cover facial hair and eyes/eye cover
		"hat" = list(), //hats don't cover hair. This is just to make things simpler and not additonally run lists against lists to exclude hair coverage.
		"helmet" = list(), //helmets cover hair. This is an abstact to determine icon layering, not actual armor, that is decided later.
		)

	var/hair_covered = 0
	var/beard_covered = 0
	var/eyes_covered = 0
	var/eye_cover_covered = 0

/datum/icon_generator/New(mob/new_owner)
	. = ..()
	if(!new_owner) return

	owner = new_owner

/datum/icon_generator/proc/check_coverage()

	var/list/list_to_check = list()
	list_to_check = gear_icons["eyes"]
	if(list_to_check.len != 0)
		eyes_covered = 1
	list_to_check = gear_icons["face"]
	if(list_to_check.len != 0)
		beard_covered = 1
	list_to_check = gear_icons["mask"]
	if(list_to_check.len != 0)
		eye_cover_covered = 1
		eyes_covered = 1
		beard_covered = 1
	list_to_check = gear_icons["helmet"]
	if(list_to_check.len != 0)
		hair_covered = 1


/datum/icon_generator/proc/generate_icon()
	owner.overlays.Cut()
	check_coverage()
	var/datum/sprite_accessory/S
	var/mutable_appearance/finished_icon = new(src)
	var/mutable_appearance/body_icon = new(src)
	if(!skin_tone)
		skin_tone = random_skin_tone()
	if(race == "vampire")
		skin_tone = get_vamp_skin_color(skin_tone)
	var/skin_tone_hex = "#[skintone2hex(skin_tone)]"

	if(!body_type_prefix)
		body_type_prefix = pick(prob(70);"",
		prob(15);"f",
		prob(15);"s"
		)

	if(!gender_suffix)
		gender_suffix = pick("_m","_f")

	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_head[gender_suffix]"))
	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_chest[gender_suffix]"))
	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_r_hand"))
	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_r_arm"))
	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_l_hand"))
	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_l_arm"))
	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_r_leg"))
	body_icon.overlays += (icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_l_leg"))
	body_icon.color = skin_tone_hex
	body_icon.layer = 4

	finished_icon.overlays += body_icon

	if(!eyes_covered)
		var/mutable_appearance/eyes = new(src)
		eyes.overlays += (icon(icon = 'icons/mob/human_face.dmi', icon_state = "eyes"))
		eyes.color = pick("#191099","#0d6b05","#7a3802")
		eyes.layer = 4.1
		finished_icon.overlays += eyes

	if(!hair_style && !beard_style)
		if(gender_suffix == "_m")
			if(hair_covered == 0) hair_style = pick(GLOB.hairstyles_male_list)
			if(beard_covered == 0) beard_style = pick(GLOB.facial_hairstyles_male_list)
		if(gender_suffix == "_f")
			if(hair_covered == 0) hair_style = pick(GLOB.hairstyles_female_list)
	if(!hair_color)
		hair_color = "#[random_color()]"
	if(hair_style && !hair_covered)
		S = GLOB.hairstyles_list[hair_style]
		if(S)
			var/mutable_appearance/hair = new(src)
			hair.overlays += icon(icon = S.icon,icon_state = S.icon_state)
			hair.color = hair_color
			hair.layer = 4.1
			finished_icon.overlays += hair
	if(beard_style && !beard_covered)
		S = GLOB.facial_hairstyles_list[beard_style]
		if(S)
			var/mutable_appearance/beard = new()
			beard.overlays += icon(icon = S.icon,icon_state = S.icon_state)
			beard.color = hair_color
			beard.layer = 4.1
			finished_icon.overlays += beard

	var/list/list_to_check = list()
	var/icon_file
	if(body_type_prefix == "s")
		if(gender_suffix == "_m")
			icon_file = 'code/modules/wod13/worn_slim_m.dmi'
		if(gender_suffix == "_f")
			icon_file = 'code/modules/wod13/worn_slim_f.dmi'
	if(body_type_prefix == "f")
		icon_file = 'code/modules/wod13/worn_fat.dmi'
	if(!icon_file) icon_file = 'code/modules/wod13/worn.dmi'

	list_to_check = gear_icons["clothes"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.2
		finished_icon.overlays += clothing
	list_to_check = gear_icons["shoes"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.21
		finished_icon.overlays += clothing
	list_to_check = gear_icons["hands"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.21
		finished_icon.overlays += clothing
	list_to_check = gear_icons["belt"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.21
		finished_icon.overlays += clothing
	list_to_check = gear_icons["jacket"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.22
		finished_icon.overlays += clothing
	list_to_check = gear_icons["eyes"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.22
		finished_icon.overlays += clothing
	list_to_check = gear_icons["face"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.22
		finished_icon.overlays += clothing
	list_to_check = gear_icons["mask"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.23
		finished_icon.overlays += clothing
	list_to_check = gear_icons["hat"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.23
		finished_icon.overlays += clothing
	list_to_check = gear_icons["helmet"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += (icon(icon = icon_file, icon_state = picked_state))
		clothing.layer = 4.24
		finished_icon.overlays += clothing



	owner.overlays += finished_icon

/datum/combat_ai/

	var/mob/living/owner
	var/loop_terminator = 0

	var/movement_delay = 10

	var/armor = 0
	var/poise = 10
	var/health = 10

	var/turf/anchor_turf
	var/mob/living/target_player
	var/last_attack = 0
	var/attack_delay = 17

	var/return_override
	var/return_distance = 14

/datum/combat_ai/New(mob/owner_mob)
	. = ..()
	if(!owner_mob) return
	owner = owner_mob
	anchor_turf = get_turf(owner)
	INVOKE_ASYNC(src,PROC_REF(ai_loop))

/datum/combat_ai/proc/combat_stun()
	loop_terminator = 1
	sleep(25)
	if(health > 0) INVOKE_ASYNC(src, PROC_REF(damage_animation),"poise_restore")
	sleep(5)
	if(health > 0)
		loop_terminator = 0
		poise = (floor(initial(poise) / 3))
		INVOKE_ASYNC(src, PROC_REF(ai_loop))

/datum/combat_ai/proc/attack_animation(type,time)
	if(!type || !time) return
	switch(type)
		if("single_target")
			var/starting_x = owner.pixel_x
			var/starting_y = owner.pixel_y
			var/pull_x = owner.pixel_x
			var/pull_y = owner.pixel_y
			var/push_x = 0
			var/push_y = 0
			var/turf/current_turf = get_turf(owner)
			var/turf/target_turf = get_turf(target_player)
			var/wind_up = ceil(time / 2)
			var/attack = floor(time / 2)
			switch(get_dir(current_turf,target_turf))
				if(NORTH)
					owner.dir = NORTH
					pull_y -= 16
					push_y = 16
				if(NORTHEAST)
					owner.dir = EAST
					pull_y -= 8
					push_y = 8
					pull_x -= 8
					push_x = 8
				if(EAST)
					owner.dir = EAST
					pull_x -= 16
					push_x = 16
				if(SOUTHEAST)
					owner.dir = EAST
					pull_x -= 8
					push_x = 8
					pull_y += 8
					push_y = -8
				if(SOUTH)
					owner.dir = SOUTH
					pull_y += 16
					push_y = -16
				if(SOUTHWEST)
					owner.dir = WEST
					pull_y += 8
					push_y = -8
					pull_x += 8
					push_x = -8
				if(WEST)
					owner.dir = WEST
					pull_x += 16
					push_x = -16
				if(NORTHWEST)
					owner.dir = WEST
					pull_x += 8
					push_x = -8
					pull_y -= 8
					push_y = 8
			animate(owner,time = wind_up, pixel_x = pull_x, pixel_y = pull_y)
			animate(time = attack, pixel_x = push_x, pixel_y = push_y)
			animate(time = attack, pixel_x = starting_x, pixel_y = starting_y)

/datum/combat_ai/proc/damage_animation(type)
	switch(type)
		if(null)
			return
		if("poise_restore")
			var/obj/icon_obj = new()
			icon_obj.mouse_opacity = 1
			icon_obj.appearance = owner.appearance
			icon_obj.dir = owner.dir
			icon_obj.layer = EFFECTS_LAYER
			icon_obj.alpha = 0
			var/matrix/M = new
			M.Scale(2)
			icon_obj.transform = M
			var/matrix/N = new
			N.Scale(1)
			animate(icon_obj, time = 5, alpha = 255, transform = N)
			owner.vis_contents += icon_obj
			sleep(6)
			owner.vis_contents -= icon_obj
		if("poise_break")
			var/obj/icon_obj = new()
			icon_obj.mouse_opacity = 1
			icon_obj.appearance = owner.appearance
			icon_obj.layer = EFFECTS_LAYER
			icon_obj.dir = owner.dir
			var/matrix/M = new
			M.Scale(2)
			animate(icon_obj, time = 5, alpha = 0, transform = M)
			owner.vis_contents += icon_obj
			sleep(6)
			owner.vis_contents -= icon_obj
		if("poise_hit")
			var/obj/icon_obj = new()
			icon_obj.mouse_opacity = 1
			icon_obj.appearance = owner.appearance
			icon_obj.layer = EFFECTS_LAYER
			var/matrix/M = new
			M.Scale(1.2 + (0.02 * ((initial(poise) + 1) - poise)))
			animate(icon_obj, time = 3, alpha = 0, transform = M)
			owner.vis_contents += icon_obj
			sleep(4)
			owner.vis_contents -= icon_obj
		if("dam_hit")
			var/starting_x = owner.pixel_x
			var/starting_y = owner.pixel_y
			var/displacement_x = starting_x + rand(-3,3)
			var/displacement_y = starting_y + rand(-3,3)
			animate(owner, time = 1, pixel_x = displacement_x, pixel_y = displacement_y)
			animate(time = 1, pixel_x = starting_x, pixel_y = starting_y)

/datum/combat_ai/proc/die()
	loop_terminator = 1
	var/matrix/M = new
	M.Turn(pick(-90,90))
	var/displacement_x = owner.pixel_x + rand(-10,10)
	var/displacement_y = owner.pixel_y + rand(-10,10)
	animate(owner, time = 4, pixel_x = displacement_x, pixel_y = displacement_y, transform = M, easing = QUAD_EASING|EASE_IN)

/datum/combat_ai/proc/process_damage(damage_number,damage_type)
	if(!damage_number) return
	if(health == 0) return
	var/damage_to_deal = damage_number - armor
	if(damage_type == "poise")
		if(poise >= 0)
			poise -= damage_to_deal
			if(poise <= 0)
				poise = 0
				INVOKE_ASYNC(src,PROC_REF(damage_animation),"poise_break")
				INVOKE_ASYNC(src,PROC_REF(combat_stun))
				return
			else
				INVOKE_ASYNC(src,PROC_REF(damage_animation),"poise_hit")
		return
	if(damage_type == "health")
		if(health > 0)
			var/new_health = health - damage_number
			if(new_health <= 0)
				health = 0
				die()
				return
			else
				health -= damage_number
				INVOKE_ASYNC(src,PROC_REF(damage_animation),"dam_hit")
				return
	if(damage_type == BURN)
		INVOKE_ASYNC(src, PROC_REF(process_damage),(damage_number),"health")
		return
	INVOKE_ASYNC(src, PROC_REF(process_damage),(damage_number * 2),"poise")
	INVOKE_ASYNC(src, PROC_REF(process_damage),(damage_number),"health")


/datum/combat_ai/proc/attack_turf(turf/turf_target,attack_time)
	var/mob/living/carbon/human/human_mob_target = target_player
	INVOKE_ASYNC(src, PROC_REF(attack_animation),"single_target",attack_time)
	sleep(attack_time)
	if(get_turf(target_player) == turf_target)
		if(world.time > target_player.blocking_timestamp + 5)
			target_player.apply_damage(rand(owner.melee_damage_lower,owner.melee_damage_upper))
		else
			process_damage(2,"poise")
		if(human_mob_target && human_mob_target.blocking)
			human_mob_target.SwitchBlocking()
		if(target_player.blocking == TRUE) target_player.blocking = FALSE // This is a failsafe in case the above is not trigerred on player mobs.

/datum/combat_ai/proc/ai_loop()
	while(loop_terminator == 0)
		if(return_override == 1)
			if((get_turf(owner)) != anchor_turf)
				step_towards(owner, anchor_turf)
				sleep(movement_delay)
				continue
			else
				return_override = 0
		if(!target_player)
			for(var/mob/living/mob_in_range in range(7,owner))
				if (mob_in_range.client)
					target_player = mob_in_range
		if(!target_player)
			sleep(movement_delay)
			continue
		else
			var/turf/own_turf = get_turf(owner)
			var/turf/target_turf = get_turf(target_player)
			if(get_dist(own_turf,anchor_turf) > return_distance)
				return_override = 1
				continue
			if(get_dist(own_turf,target_turf) > 1)
				step_towards(owner,target_player)
				sleep(movement_delay)
				continue
			else
				INVOKE_ASYNC(src,PROC_REF(attack_turf),target_turf,6)
				sleep(attack_delay)
				continue
