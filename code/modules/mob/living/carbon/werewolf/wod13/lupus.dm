/mob/living/carbon/werewolf/lupus
	name = "wolf"
	icon_state = "black"
	icon = 'icons/wod13/werewolf_lupus.dmi'
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	butcher_results = list(/obj/item/food/meat/slab = 5)
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	hud_type = /datum/hud/werewolf
	limb_destroyer = 1
	has_limbs = 0
//	dextrous = FALSE
//	speed = -1.5     doesn't work on carbons
//	var/move_delay_add = -1.5 // movement delay to add    also didn't work
	melee_damage_lower = 15
	melee_damage_upper = 35
	health = 150
	maxHealth = 150
	werewolf_armor = 10
//	bodyparts = list(
//		/obj/item/bodypart/chest,
//		/obj/item/bodypart/head,
//		/obj/item/bodypart/r_arm,
//		/obj/item/bodypart/l_arm,
//		/obj/item/bodypart/r_leg,
//		/obj/item/bodypart/l_leg,
//		)
	var/hispo = FALSE

/datum/movespeed_modifier/lupusform
	multiplicative_slowdown = -0.80

/mob/living/carbon/werewolf/lupus/update_icons()
	cut_overlays()

	var/laid_down = FALSE

	if(stat == UNCONSCIOUS || IsSleeping() || stat == HARD_CRIT || stat == SOFT_CRIT || IsParalyzed() || stat == DEAD || body_position == LYING_DOWN)
		icon_state = "[sprite_color]_rest"
		laid_down = TRUE
	else
		icon_state = "[sprite_color]"

	switch(getFireLoss()+getBruteLoss())
		if(25 to 75)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage1[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)
		if(75 to 150)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage2[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)
		if(150 to INFINITY)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage3[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)

	var/mutable_appearance/eye_overlay = mutable_appearance(icon, "eyes[laid_down ? "_rest" : ""]")
	eye_overlay.color = sprite_eye_color
	eye_overlay.plane = ABOVE_LIGHTING_PLANE
	eye_overlay.layer = ABOVE_LIGHTING_LAYER
	add_overlay(eye_overlay)

/mob/living/carbon/werewolf/lupus/regenerate_icons()
	if(!..())
	//	update_icons() //Handled in update_transform(), leaving this here as a reminder
		update_transform()

/mob/living/carbon/werewolf/lupus/update_transform() //The old method of updating lying/standing was update_icons(). Aliens still expect that.
	. = ..()
	update_icons()

/mob/living/carbon/werewolf/lupus/Life()
	if(hispo)
		CheckEyewitness(src, src, 7, FALSE)
	..()
