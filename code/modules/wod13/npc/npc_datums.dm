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



	owner.appearance = finished_icon
