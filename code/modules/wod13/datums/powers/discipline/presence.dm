/datum/discipline/presence
	name = "Presence"
	desc = "Makes targets in radius more vulnerable to damages."
	icon_state = "presence"
	power_type = /datum/discipline_power/presence

/datum/discipline_power/presence
	name = "Presence power name"
	desc = "Presence power description"

	activate_sound = 'code/modules/wod13/sounds/presence_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/presence_deactivate.ogg'

//AWE
/datum/discipline_power/presence/awe
	name = "Awe"
	desc = "Make those around you admire and want to be closer to you."

	level = 1

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS

/datum/discipline_power/presence/awe/pre_activation_checks(mob/living/target)
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	if((theirpower >= mypower) || ((owner.generation - 3) >= target.generation))
		to_chat(owner, span_warning("[target]'s mind is too powerful to sway!"))
		return FALSE

	return TRUE

/datum/discipline_power/presence/awe/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	var/datum/cb = CALLBACK(target, /mob/living/carbon/human/proc/walk_to_caster, owner)
	for(var/i in 1 to 30)
		addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
	to_chat(target, "<span class='userlove'><b>COME HERE</b></span>")
	owner.say("COME HERE!!")

/datum/discipline_power/presence/awe/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/walk_to_caster(mob/living/step_to)
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_to(src, step_to, 0)
		face_atom(step_to)

//DREAD GAZE
/datum/discipline_power/presence/dread_gaze
	name = "Dread Gaze"
	desc = "Incite fear in others through only your words and gaze."

	level = 2

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS

/datum/discipline_power/presence/dread_gaze/pre_activation_checks(mob/living/target)
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	if((theirpower >= mypower) || ((owner.generation - 3) >= target.generation))
		to_chat(owner, span_warning("[target]'s mind is too powerful to sway!"))
		return FALSE

	return TRUE

/datum/discipline_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	target.Stun(1 SECONDS)
	to_chat(target, "<span class='userlove'><b>REST</b></span>")
	owner.say("REST!!")
	if(target.body_position == STANDING_UP)
		target.toggle_resting()

/datum/discipline_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//ENTRANCEMENT
/datum/discipline_power/presence/entrancement
	name = "Entrancement"
	desc = "Manipulate minds by bending emotions to your will."

	level = 3

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS

/datum/discipline_power/presence/entrancement/pre_activation_checks(mob/living/target)
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	if((theirpower >= mypower) || ((owner.generation - 3) >= target.generation))
		to_chat(owner, span_warning("[target]'s mind is too powerful to sway!"))
		return FALSE

	return TRUE

/datum/discipline_power/presence/entrancement/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	var/obj/item/I1 = target.get_active_held_item()
	var/obj/item/I2 = target.get_inactive_held_item()
	to_chat(target, "<span class='userlove'><b>PLEASE ME</b></span>")
	owner.say("PLEASE ME!!")
	target.face_atom(owner)
	target.do_jitter_animation(3 SECONDS)
	target.Immobilize(1 SECONDS)
	target.drop_all_held_items()
	if(I1)
		I1.throw_at(get_turf(owner), 3, 1, target)
	if(I2)
		I2.throw_at(get_turf(owner), 3, 1, target)

/datum/discipline_power/presence/entrancement/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SUMMON
/datum/discipline_power/presence/summon
	name = "Summon"
	desc = "Call anyone you've ever met to be by your side."

	level = 4

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS

/datum/discipline_power/presence/summon/pre_activation_checks(mob/living/target)
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	if((theirpower >= mypower) || ((owner.generation - 3) >= target.generation))
		to_chat(owner, span_warning("[target]'s mind is too powerful to sway!"))
		return FALSE

	return TRUE

/datum/discipline_power/presence/summon/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	to_chat(target, "<span class='userlove'><b>FEAR ME</b></span>")
	owner.say("FEAR ME!!")
	var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
	for(var/i in 1 to 30)
		addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
	target.emote("scream")
	target.do_jitter_animation(3 SECONDS)

/datum/discipline_power/presence/summon/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_away(src, step_from, 99)

//MAJESTY
/datum/discipline_power/presence/majesty
	name = "Majesty"
	desc = "Become so grand that others find it nearly impossible to disobey or harm you."

	level = 5

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS

/datum/discipline_power/presence/majesty/pre_activation_checks(mob/living/target)
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	if((theirpower >= mypower) || ((owner.generation - 3) >= target.generation))
		to_chat(owner, span_warning("[target]'s mind is too powerful to sway!"))
		return FALSE

	return TRUE

/datum/discipline_power/presence/majesty/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	to_chat(target, "<span class='userlove'><b>UNDRESS YOURSELF</b></span>")
	owner.say("UNDRESS YOURSELF!!")
	target.Immobilize(1 SECONDS)
	for(var/obj/item/clothing/W in target.contents)
		target.dropItemToGround(W, TRUE)

/datum/discipline_power/presence/majesty/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
