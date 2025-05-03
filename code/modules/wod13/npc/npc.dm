/mob/living/npc/
	name = "npc mob subtype master"
	desc = "hi, if you're reading me, someone made a mistake. Most likely the coder. Please report this as a bug."
	icon = 'icons/mob/npc.dmi'
	icon_state = "npc"

	var/hair_style
	var/beard_style
	var/hair_color

	var/gender_suffix
	var/body_type_prefix
	var/skin_tone
	var/race = "human"

	var/obj/item/gear_type_head = /obj/item/
	var/obj/item/gear_type_eyes = /obj/item/
	var/obj/item/gear_type_ears = /obj/item/
	var/obj/item/gear_type_neck = /obj/item/
	var/obj/item/gear_type_mask = /obj/item/
	var/obj/item/gear_type_underlay = /obj/item/
	var/obj/item/gear_type_overlay = /obj/item/
	var/obj/item/gear_type_belt = /obj/item/
	var/obj/item/gear_type_hands = /obj/item/
	var/obj/item/gear_type_shoes = /obj/item/

	var/hair_covered = 0
	var/beard_covered = 0
	var/eyes_covered = 0

/mob/living/npc/proc/check_coverage()

	if(gear_type_head.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_eyes.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_ears.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_neck.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_mask.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_underlay.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_overlay.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_belt.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_hands.flags_inv & HIDEHAIR) hair_covered = 1
	if(gear_type_shoes.flags_inv & HIDEHAIR) hair_covered = 1

	if(gear_type_head.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_eyes.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_ears.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_neck.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_mask.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_underlay.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_overlay.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_belt.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_hands.flags_inv & HIDEFACIALHAIR) beard_covered = 1
	if(gear_type_shoes.flags_inv & HIDEFACIALHAIR) beard_covered = 1

	if(gear_type_head.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_eyes.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_ears.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_neck.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_mask.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_underlay.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_overlay.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_belt.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_hands.flags_inv & HIDEEYES) eyes_covered = 1
	if(gear_type_shoes.flags_inv & HIDEEYES) eyes_covered = 1


/mob/living/npc/proc/generate_icon()
	check_coverage()
	var/datum/sprite_accessory/S
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

	if(!hair_style && !beard_style)
		if(gender_suffix == "_m")
			if(hair_covered == 0) hair_style = pick(GLOB.hairstyles_male_list)
			if(beard_covered == 0) beard_style = pick(GLOB.facial_hairstyles_male_list)
		if(gender_suffix == "_f")
			if(hair_covered == 0) hair_style = pick(GLOB.hairstyles_female_list)
	if(!hair_color)
		hair_color = "#[random_color()]"
	if(hair_style)
		S = GLOB.hairstyles_list[hair_style]
		if(S)
			var/mutable_appearance/hair = new(src)
			hair.overlays += icon(icon = S.icon,icon_state = S.icon_state)
			hair.color = hair_color
			body_icon.overlays += hair
	if(beard_style)
		S = GLOB.facial_hairstyles_list[beard_style]
		if(S)
			var/mutable_appearance/beard = new()
			beard.overlays += icon(icon = S.icon,icon_state = S.icon_state)
			beard.color = hair_color
			body_icon.overlays += beard

	appearance = body_icon


/mob/living/npc/proc/generate_hair_icon()





/mob/living/npc/Initialize()
	. = ..()
	overlays.Cut()
	generate_icon()
