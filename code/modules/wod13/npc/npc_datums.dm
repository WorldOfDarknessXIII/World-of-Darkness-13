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
	var/image/finished_image = new(src)
	var/mutable_appearance/body_icon = new(src)
	finished_image.appearance = owner.appearance
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

	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_head[gender_suffix]"),layer = 3.98)
	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_chest[gender_suffix]"),layer = 3.98)
	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_r_hand"),layer = 3.98)
	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_r_arm"),layer = 3.98)
	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_l_hand"),layer = 3.98)
	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_l_arm"),layer = 3.98)
	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_r_leg"),layer = 3.98)
	body_icon.overlays += image(icon = icon(icon = 'icons/mob/human_parts_greyscale.dmi', icon_state = "[body_type_prefix]human_l_leg"),layer = 3.98)
	body_icon.color = skin_tone_hex

	finished_image.overlays += body_icon

	if(!eyes_covered)
		var/mutable_appearance/eyes = new(src)
		eyes.overlays += image(icon = icon(icon = 'icons/mob/human_face.dmi', icon_state = "eyes"), layer = 3.981)
		eyes.color = pick("#191099","#0d6b05","#7a3802")
		finished_image.overlays += eyes

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
			hair.overlays += image(icon = icon(icon = S.icon,icon_state = S.icon_state),layer = 3.981)
			hair.color = hair_color
			finished_image.overlays += hair
	if(beard_style && !beard_covered)
		S = GLOB.facial_hairstyles_list[beard_style]
		if(S)
			var/mutable_appearance/beard = new()
			beard.overlays += image(icon = icon(icon = S.icon,icon_state = S.icon_state),layer = 3.981)
			beard.color = hair_color
			finished_image.overlays += beard

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
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.99)
		finished_image.overlays += clothing
	list_to_check = gear_icons["shoes"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.991)
		finished_image.overlays += clothing
	list_to_check = gear_icons["hands"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.991)
		finished_image.overlays += clothing
	list_to_check = gear_icons["belt"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.991)
		finished_image.overlays += clothing
	list_to_check = gear_icons["jacket"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.992)
		finished_image.overlays += clothing
	list_to_check = gear_icons["eyes"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.992)
		finished_image.overlays += clothing
	list_to_check = gear_icons["face"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.992)
		finished_image.overlays += clothing
	list_to_check = gear_icons["mask"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.992)
		finished_image.overlays += clothing
	list_to_check = gear_icons["hat"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.993)
		finished_image.overlays += clothing
	list_to_check = gear_icons["helmet"]
	if(list_to_check.len != 0)
		var/mutable_appearance/clothing = new(src)
		var/picked_state = pick(list_to_check)
		clothing.overlays += image(icon = icon(icon = icon_file, icon_state = picked_state),layer = 3.994)
		finished_image.overlays += clothing

	owner.appearance = finished_image.appearance

/datum/combat_ai/

	var/mob/living/owner
	var/loop_terminator = 0

	var/movement_time = 5 // 2 for "smooth" movement if using walk_towards. Or animate your own movement, see if I care :P
	var/mob_heartbeat = 5

	var/armor = 0
	var/poise = 10
	var/health = 10

	var/turf/anchor_turf
	var/mob/living/target_player

	/*Attack Cadence Format is: number for animation time, letter for attack type, optional number for some of the attacks
	Attack types:
	n - Normal;
	a - AOE - hits around, number decides radius;
	c - Cone - hits 3 grids in front based on dir, supports diagonals too;
	p - Power - special animation, typically unblockable
	t - Thrust - if unparried, will move mob forward, pushing others in the way. Number decioes how far to move.
	f - Fast - omits windup. Good for combos.
	g - Grab - Unblockable, if hits players immobilizes them and plays a "grab animation" depending on number subtype which includes multiple unblockable hits. Can be interrupted by incoming damage from another player.
	*/
	var/list/attack_cadence = list(list("5n","10n","15n"))

	var/attacking_flag = 0
	var/attack_delay = 10 //This is a pause AFTER all the attacks in a single cadence, ie extra time between attack decisons. Individual attack loops are decided by cadence

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

/datum/combat_ai/proc/attack_animation(type,time,factor)
	if(!type || !time) return
	switch(type)
		if("n")
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

			return attack

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
			M.Scale(3)
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
			M.Scale(3)
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
			M.Scale(1.2 + (0.05 * ((initial(poise) + 1) - poise)))
			animate(icon_obj, time = 3, alpha = 0, transform = M)
			owner.vis_contents += icon_obj
			sleep(4)
			owner.vis_contents -= icon_obj
		if("dam_hit")
			var/starting_x = owner.pixel_x
			var/starting_y = owner.pixel_y
			var/displacement_x = starting_x + pick(-3,3)
			var/displacement_y = starting_y + pick(-3,3)
			animate(owner, time = 1, pixel_x = displacement_x, pixel_y = displacement_y)
			animate(time = 1, pixel_x = starting_x, pixel_y = starting_y)

/datum/combat_ai/proc/die()
	loop_terminator = 1
	var/matrix/M = new
	M.Turn(pick(-90,90))
	var/displacement_x = owner.pixel_x + rand(-10,10)
	var/displacement_y = owner.pixel_y + rand(-10,10)
	animate(owner, time = 4, pixel_x = displacement_x, pixel_y = displacement_y, transform = M, easing = QUAD_EASING|EASE_IN)
	owner.density = 0

/datum/combat_ai/proc/process_damage(damage_number,damage_type)
	if(!damage_number) return
	if(health == 0) return
	var/damage_to_deal = damage_number - armor
	return_override = 0
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
	if(poise > 0) INVOKE_ASYNC(src, PROC_REF(process_damage),(damage_number * 2),"poise")
	INVOKE_ASYNC(src, PROC_REF(process_damage),(damage_number),"health")


/datum/combat_ai/proc/process_attack(turf/turf_target)
	var/list/attack_list = pick(attack_cadence)
	attacking_flag = 1
	var/current_position = 1
	while(current_position <= attack_list.len)
		if(loop_terminator)
			attack_list = list()
			break

		var/current_line = attack_list[current_position]
		var/number_bits = 0
		var/current_bit = 1
		var/bit_to_test = copytext(current_line,current_bit,current_bit+1)
		while(text2num(bit_to_test) != null)
			number_bits += 1
			current_bit += 1
			bit_to_test = copytext(current_line,current_bit,current_bit+1)
		if(number_bits == 0) return "err_no_bits"
		var/attack_time = text2num(copytext(current_line,1,1 + number_bits))
		var/attack_type = copytext(current_line,number_bits+1,number_bits+2)
		var/attack_factor
		if(length(current_line) > number_bits + 1) attack_factor = copytext(current_line,number_bits+2,0)
		INVOKE_ASYNC(src, PROC_REF(attack_animation),attack_type,attack_time,attack_factor)
		sleep(attack_time + (floor(attack_time / 2)))
		if(loop_terminator)
			attack_list = list()
			break

		// Parrying

		for(var/mob/living/attacked_mob in turf_target)
			if(istype(attacked_mob,/mob/living/carbon/))
				var/mob/living/carbon/attacked_carbon_mob = attacked_mob
				if(world.time > attacked_carbon_mob.blocking_timestamp + 5)
					attacked_carbon_mob.apply_damage(rand(owner.melee_damage_lower,owner.melee_damage_upper))
				else
					process_damage(2,"poise")
				if(istype(attacked_mob,/mob/living/carbon/human))
					var/mob/living/carbon/human/attacked_human_mob = attacked_mob
					if(attacked_human_mob.blocking == TRUE) attacked_human_mob.SwitchBlocking()
				if(attacked_carbon_mob.blocking == TRUE) attacked_carbon_mob.blocking = FALSE // This is a failsafe in case the above is not trigerred on player mobs.

		current_position += 1
	attacking_flag = 0

/datum/combat_ai/proc/animate_movement(turf/target_turf)
	var/turf/owner_turf = get_turf(owner)
	var/current_pixel_x = owner.pixel_x
	var/current_pixel_y = owner.pixel_y
	owner.forceMove(target_turf)
	switch(get_dir(owner_turf,target_turf))
		if(NORTH)
			owner.pixel_y -= 32
			owner.dir = NORTH
		if(SOUTH)
			owner.pixel_y += 32
			owner.dir = SOUTH
		if(EAST)
			owner.pixel_x -= 32
			owner.dir = EAST
		if(WEST)
			owner.pixel_x += 32
			owner.dir = WEST
		if(NORTHEAST)
			owner.pixel_y -= 32
			owner.pixel_x -= 32
			owner.dir = EAST
		if(NORTHWEST)
			owner.pixel_y -= 32
			owner.pixel_x += 32
			owner.dir = WEST
		if(SOUTHEAST)
			owner.pixel_y += 32
			owner.pixel_x -= 32
			owner.dir = EAST
		if(SOUTHWEST)
			owner.pixel_y += 32
			owner.pixel_x += 32
			owner.dir = WEST
	animate(owner,time = movement_time, pixel_x = current_pixel_x, pixel_y = current_pixel_y,easing = SINE_EASING)
	sleep(movement_time)
	owner.pixel_x = current_pixel_x
	owner.pixel_y = current_pixel_y
	return

/datum/combat_ai/proc/navigate_around(turf/starting_turf,turf/ending_turf)
	var/turf/new_turf
	switch(get_dir(starting_turf,ending_turf))
		if(NORTH,SOUTH)
			new_turf = locate(ending_turf.x + 1,ending_turf.y,ending_turf.z)
			for(var/atom/atom_to_test in new_turf)
				if(atom_to_test.density == 1)
					new_turf = locate(ending_turf.x - 1,ending_turf.y,ending_turf.z)
					for(var/atom/other_atom_to_test in new_turf)
						if(atom_to_test.density == 1) return
		if(EAST,WEST)
			new_turf = locate(ending_turf.x,ending_turf.y + 1,ending_turf.z)
			for(var/atom/atom_to_test in new_turf)
				if(atom_to_test.density == 1)
					new_turf = locate(ending_turf.x,ending_turf.y - 1,ending_turf.z)
					for(var/atom/other_atom_to_test in new_turf)
						if(atom_to_test.density == 1) return
		if(NORTHEAST)
			new_turf = locate(ending_turf.x,ending_turf.y + 1,ending_turf.z)
			for(var/atom/atom_to_test in new_turf)
				if(atom_to_test.density == 1)
					new_turf = locate(ending_turf.x + 1,ending_turf.y,ending_turf.z)
					for(var/atom/other_atom_to_test in new_turf)
						if(atom_to_test.density == 1) return
		if(NORTHWEST)
			new_turf = locate(ending_turf.x,ending_turf.y + 1,ending_turf.z)
			for(var/atom/atom_to_test in new_turf)
				if(atom_to_test.density == 1)
					new_turf = locate(ending_turf.x - 1,ending_turf.y,ending_turf.z)
					for(var/atom/other_atom_to_test in new_turf)
						if(atom_to_test.density == 1) return
		if(SOUTHEAST)
			new_turf = locate(ending_turf.x, ending_turf.y - 1,ending_turf.z)
			for(var/atom/atom_to_test in new_turf)
				if(atom_to_test.density == 1)
					new_turf = locate(ending_turf.x + 1,ending_turf.y,ending_turf.z)
					for(var/atom/other_atom_to_test in new_turf)
						if(atom_to_test.density == 1) return
		if(SOUTHWEST)
			new_turf = locate(ending_turf.x,ending_turf.y - 1,ending_turf.z)
			for(var/atom/atom_to_test in new_turf)
				if(atom_to_test.density == 1)
					new_turf = locate(ending_turf.x - 1,ending_turf.y,ending_turf.z)
					for(var/atom/other_atom_to_test in new_turf)
						if(atom_to_test.density == 1) return
	animate_movement(new_turf)



/datum/combat_ai/proc/process_movement(turf/starting_turf,turf/ending_turf)

	if(get_dist(starting_turf,ending_turf) > 1)
		var/next_turf = get_step_towards(starting_turf,ending_turf)
		for(var/atom/atom_to_test in next_turf)
			if(atom_to_test.density == 1)
				navigate_around(starting_turf, next_turf)
				break
			else
				animate_movement(next_turf)
		return
	if(get_dist(starting_turf,ending_turf) == 1)
		return 1

/datum/combat_ai/proc/process_target()
	if(!target_player)
		for(var/mob/living/mob_in_range in range(7,owner))
			var/list/anchor_range = range(return_distance, anchor_turf)
			if ((anchor_range.Find(mob_in_range) != 0) && mob_in_range.client)
				target_player = mob_in_range
				return_override = 0
	else if(get_dist(target_player,anchor_turf) > return_distance)
		return_override = 1
		target_player = null

/datum/combat_ai/proc/ai_loop()
	while(loop_terminator == 0)
		if(attacking_flag == 1)
			sleep(mob_heartbeat)
			continue
		var/turf/own_turf = get_turf(owner)
		if(return_override == 1)
			process_movement(own_turf,anchor_turf)
		process_target()
		if(!target_player)
			sleep(mob_heartbeat)
			continue
		var/turf/target_turf = get_turf(target_player)
		if(process_movement(own_turf,target_turf) == 1)
			process_attack(target_turf)
			if(attack_delay != 0) sleep(attack_delay)

