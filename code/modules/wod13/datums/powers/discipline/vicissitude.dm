/datum/discipline/vicissitude
	name = "Vicissitude"
	desc = "It is widely known as Tzimisce art of flesh and bone shaping. Violates Masquerade."
	icon_state = "vicissitude"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/vicissitude

/datum/discipline/vicissitude/post_gain()
	. = ..()
	owner.faction |= "Tzimisce"

/datum/discipline_power/vicissitude
	name = "Vicissitude power name"
	desc = "Vicissitude power description"

	activate_sound = 'code/modules/wod13/sounds/vicissitude.ogg'

//MALLEABLE VISAGE
/datum/discipline_power/vicissitude/malleable_visage
	name = "Malleable Visage"
	desc = "Change your features to mimic those of a victim."

	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND | DISC_CHECK_SEE | DISC_CHECK_LYING

	violates_masquerade = TRUE

	cooldown_length = 10 SECONDS

	//why is this necessary why isn't transfer_identity working please fix this
	var/datum/dna/original_dna
	var/original_name
	var/original_skintone
	var/original_hairstyle
	var/original_facialhair
	var/original_haircolor
	var/original_facialhaircolor
	var/original_eyecolor
	var/original_body_mod
	var/original_alt_sprite
	var/original_alt_sprite_greyscale

	var/datum/dna/impersonating_dna
	var/impersonating_name
	var/impersonating_skintone
	var/impersonating_hairstyle
	var/impersonating_facialhair
	var/impersonating_haircolor
	var/impersonating_facialhaircolor
	var/impersonating_eyecolor
	var/impersonating_body_mod
	var/impersonating_alt_sprite
	var/impersonating_alt_sprite_greyscale

	var/is_shapeshifted = FALSE

/datum/discipline_power/vicissitude/malleable_visage/activate()
	. = ..()

	if (is_shapeshifted)
		var/choice = alert(owner, "What form do you wish to take?", name, "Yours", "Someone Else's")
		if (choice == "Yours")
			deactivate()
			return

	choose_impersonating()
	shapeshift()

/datum/discipline_power/vicissitude/malleable_visage/deactivate()
	. = ..()
	shapeshift(to_original = TRUE)

/datum/discipline_power/vicissitude/malleable_visage/proc/choose_impersonating()
	initialize_original()

	var/list/mob/living/carbon/human/potential_victims = list()
	for (var/mob/living/carbon/human/adding_victim in oviewers(3, owner))
		potential_victims += adding_victim
	if (!length(potential_victims))
		to_chat(owner, span_warning("No one is close enough for you to examine..."))
		return
	var/mob/living/carbon/human/victim = input(owner, "Who do you wish to impersonate?", name) as null|mob in potential_victims
	if (!victim)
		return

	impersonating_dna = new
	victim.dna.copy_dna(impersonating_dna)
	impersonating_name = victim.real_name
	impersonating_skintone = victim.skin_tone
	impersonating_hairstyle = victim.hairstyle
	impersonating_facialhair = victim.facial_hairstyle
	impersonating_haircolor = victim.hair_color
	impersonating_facialhaircolor = victim.facial_hair_color
	impersonating_eyecolor = victim.eye_color
	impersonating_body_mod = victim.base_body_mod
	if (victim.clane)
		impersonating_alt_sprite = victim.clane.alt_sprite
		impersonating_alt_sprite_greyscale = victim.clane.alt_sprite_greyscale

/datum/discipline_power/vicissitude/malleable_visage/proc/initialize_original()
	if (is_shapeshifted)
		return
	if (original_dna && original_body_mod)
		return

	original_dna = new
	owner.dna.copy_dna(original_dna)
	original_name = owner.real_name
	original_skintone = owner.skin_tone
	original_hairstyle = owner.hairstyle
	original_facialhair = owner.facial_hairstyle
	original_haircolor = owner.hair_color
	original_facialhaircolor = owner.facial_hair_color
	original_eyecolor = owner.eye_color
	original_body_mod = owner.base_body_mod
	original_alt_sprite = owner.clane?.alt_sprite
	original_alt_sprite_greyscale = owner.clane?.alt_sprite_greyscale

/datum/discipline_power/vicissitude/malleable_visage/proc/shapeshift(to_original = FALSE, instant = FALSE)
	if (!impersonating_dna)
		return
	if (!instant)
		var/time_delay = 10 SECONDS
		if (original_body_mod != impersonating_body_mod)
			time_delay += 5 SECONDS
		if (original_alt_sprite != impersonating_alt_sprite)
			time_delay += 10 SECONDS
		to_chat(owner, span_notice("You begin molding your appearance... This will take [DisplayTimeText(time_delay)]."))
		if (!do_after(owner, time_delay))
			return

	owner.Stun(1 SECONDS)
	owner.do_jitter_animation(10)
	playsound(get_turf(owner), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)

	if (to_original)
		original_dna.transfer_identity(destination = owner, transfer_SE = TRUE, superficial = TRUE)
		owner.real_name = original_name
		owner.skin_tone = original_skintone
		owner.hairstyle = original_hairstyle
		owner.facial_hairstyle = original_facialhair
		owner.hair_color = original_haircolor
		owner.facial_hair_color = original_facialhaircolor
		owner.eye_color = original_eyecolor
		owner.base_body_mod = original_body_mod
		owner.clane?.alt_sprite = original_alt_sprite
		owner.clane?.alt_sprite_greyscale = original_alt_sprite_greyscale
		is_shapeshifted = FALSE
		QDEL_NULL(impersonating_dna)
	else
		//Nosferatu, Cappadocians, Gargoyles, Kiasyd, etc. will revert instead of being indefinitely without their curse
		if (original_alt_sprite)
			addtimer(CALLBACK(src, PROC_REF(revert_to_cursed_form)), 5 MINUTES)
		impersonating_dna.transfer_identity(destination = owner, superficial = TRUE)
		owner.real_name = impersonating_name
		owner.skin_tone = impersonating_skintone
		owner.hairstyle = impersonating_hairstyle
		owner.facial_hairstyle = impersonating_facialhair
		owner.hair_color = impersonating_haircolor
		owner.facial_hair_color = impersonating_facialhaircolor
		owner.eye_color = impersonating_eyecolor
		owner.base_body_mod = impersonating_body_mod
		owner.clane?.alt_sprite = impersonating_alt_sprite
		owner.clane?.alt_sprite_greyscale = impersonating_alt_sprite_greyscale
		is_shapeshifted = TRUE

	owner.update_body()

/datum/discipline_power/vicissitude/malleable_visage/proc/revert_to_cursed_form()
	if (!original_alt_sprite)
		return
	if (!is_shapeshifted)
		return
	if (!owner.clane)
		return

	owner.base_body_mod = original_body_mod
	owner.clane.alt_sprite = original_alt_sprite
	owner.clane.alt_sprite_greyscale = original_alt_sprite_greyscale

	to_chat(owner, span_warning("Your cursed appearance reasserts itself!"))

//FLESHCRAFTING
/datum/discipline_power/vicissitude/fleshcrafting
	name = "Fleshcrafting"
	desc = "Mold your victim's flesh and soft tissue to your desire."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND
	target_type = TARGET_MOB
	range = 1

	effect_sound = 'code/modules/wod13/sounds/vicissitude.ogg'
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(/datum/discipline_power/vicissitude/bonecrafting)

/datum/discipline_power/vicissitude/fleshcrafting/activate(mob/living/target)
	. = ..()
	if(target.stat >= HARD_CRIT)
		if(target.stat != DEAD)
			target.death()
		new /obj/item/stack/human_flesh/ten(target.loc)
		new /obj/item/guts(target.loc)
		qdel(target)
	else
		target.emote("scream")
		target.apply_damage(30, BRUTE, BODY_ZONE_CHEST)

/datum/discipline_power/vicissitude/fleshcrafting/post_gain()
	. = ..()
	var/obj/item/organ/cyberimp/arm/surgery/surgery_implant = new()
	surgery_implant.Insert(owner)

	if (!owner.mind)
		return
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_wall)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_stool)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_floor)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_eyes)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_implant)

//BONECRAFTING
/datum/discipline_power/vicissitude/bonecrafting
	name = "Bonecrafting"
	desc = "Mold your victim's flesh and soft tissue to your desire."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND
	target_type = TARGET_MOB
	range = 1

	effect_sound = 'code/modules/wod13/sounds/vicissitude.ogg'
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(/datum/discipline_power/vicissitude/fleshcrafting)

/datum/discipline_power/vicissitude/bonecrafting/activate(mob/living/target)
	. = ..()
	if (target.stat >= HARD_CRIT)
		if(target.stat != DEAD)
			target.death()
		var/obj/item/bodypart/r_arm/r_arm = target.get_bodypart(BODY_ZONE_R_ARM)
		var/obj/item/bodypart/l_arm/l_arm = target.get_bodypart(BODY_ZONE_L_ARM)
		var/obj/item/bodypart/r_leg/r_leg = target.get_bodypart(BODY_ZONE_R_LEG)
		var/obj/item/bodypart/l_leg/l_leg = target.get_bodypart(BODY_ZONE_L_LEG)
		if(r_arm)
			r_arm.drop_limb()
		if(l_arm)
			l_arm.drop_limb()
		if(r_leg)
			r_leg.drop_limb()
		if(l_leg)
			l_leg.drop_limb()
		new /obj/item/stack/human_flesh/ten(target.loc)
		new /obj/item/guts(target.loc)
		new /obj/item/spine(target.loc)
		qdel(target)
	else
		target.emote("scream")
		target.apply_damage(60, BRUTE, BODY_ZONE_CHEST)

/datum/discipline_power/vicissitude/bonecrafting/post_gain()
	. = ..()
	var/datum/action/basic_vicissitude/vicissitude_upgrade = new()
	vicissitude_upgrade.Grant(owner)

	if (!owner.mind)
		return
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_trench)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_biter)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_fister)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_tanker)

/datum/action/basic_vicissitude
	name = "Vicissitude Upgrade"
	desc = "Upgrade your body..."
	button_icon_state = "basic"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/selected_upgrade
	var/mutable_appearance/upgrade_overlay
	var/original_skin_tone
	var/original_hairstyle
	var/original_body_mod

/datum/action/basic_vicissitude/Trigger()
	. = ..()
	if (selected_upgrade)
		remove_upgrade()
	else
		give_upgrade()

	owner.update_body()

/datum/action/basic_vicissitude/proc/give_upgrade()
	var/mob/living/carbon/human/user = owner
	var/upgrade = input(owner, "Choose basic upgrade:", "Vicissitude Upgrades") as null|anything in list("Skin armor", "Centipede legs", "Second pair of arms", "Leather wings")
	if(!upgrade)
		return
	to_chat(user, span_notice("You begin molding your flesh and bone into a stronger form..."))
	if (!do_after(user, 10 SECONDS))
		return
	if(selected_upgrade)
		return
	selected_upgrade = upgrade
	ADD_TRAIT(user, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
	switch (upgrade)
		if ("Skin armor")
			user.unique_body_sprite = "tziarmor"
			original_skin_tone = user.skin_tone
			user.skin_tone = "albino"
			original_hairstyle = user.hairstyle
			user.hairstyle = "Bald"
			original_body_mod = user.base_body_mod
			user.base_body_mod = ""
			user.physiology.armor.melee += 20
			user.physiology.armor.bullet += 20
		if ("Centipede legs")
			user.remove_overlay(PROTEAN_LAYER)
			upgrade_overlay = mutable_appearance('code/modules/wod13/64x64.dmi', "centipede", -PROTEAN_LAYER)
			upgrade_overlay.pixel_z = -16
			upgrade_overlay.pixel_w = -16
			user.overlays_standing[PROTEAN_LAYER] = upgrade_overlay
			user.apply_overlay(PROTEAN_LAYER)
			user.add_movespeed_modifier(/datum/movespeed_modifier/centipede)
		if ("Second pair of arms")
			var/limbs = user.held_items.len
			user.change_number_of_hands(limbs + 2)
			user.remove_overlay(PROTEAN_LAYER)
			upgrade_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "2hands", -PROTEAN_LAYER)
			upgrade_overlay.color = "#[skintone2hex(user.skin_tone)]"
			user.overlays_standing[PROTEAN_LAYER] = upgrade_overlay
			user.apply_overlay(PROTEAN_LAYER)
		if ("Leather wings")
			user.dna.species.GiveSpeciesFlight(user)

	user.do_jitter_animation(10)
	playsound(get_turf(user), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)

/datum/action/basic_vicissitude/proc/remove_upgrade()
	var/mob/living/carbon/human/user = owner
	if (!selected_upgrade)
		return
	to_chat(user, span_notice("You begin surgically removing your enhancements..."))
	if (!do_after(user, 10 SECONDS))
		return
	REMOVE_TRAIT(user, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
	switch (selected_upgrade)
		if ("Skin armor")
			user.unique_body_sprite = null
			user.skin_tone = original_skin_tone
			user.hairstyle = original_hairstyle
			user.base_body_mod = original_body_mod
			user.physiology.armor.melee -= 20
			user.physiology.armor.bullet -= 20
		if ("Centipede legs")
			user.remove_overlay(PROTEAN_LAYER)
			QDEL_NULL(upgrade_overlay)
			user.remove_movespeed_modifier(/datum/movespeed_modifier/centipede)
		if ("Second pair of arms")
			var/limbs = user.held_items.len
			user.change_number_of_hands(limbs - 2)
			user.remove_overlay(PROTEAN_LAYER)
			QDEL_NULL(upgrade_overlay)
		if ("Leather wings")
			user.dna.species.RemoveSpeciesFlight(user)

	user.do_jitter_animation(10)
	playsound(get_turf(user), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)

	selected_upgrade = null

//HORRID FORM
/datum/discipline_power/vicissitude/horrid_form
	name = "Horrid Form"
	desc = "Shift your flesh and bone into that of a hideous monster."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 2

	violates_masquerade = TRUE

	duration_length = 20 SECONDS
	cooldown_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shapeshift/tzimisce/horrid_form_shapeshift

/datum/discipline_power/vicissitude/horrid_form/activate()
	. = ..()
	if (!horrid_form_shapeshift)
		horrid_form_shapeshift = new(owner)

	horrid_form_shapeshift.Shapeshift(owner)

/datum/discipline_power/vicissitude/horrid_form/deactivate()
	. = ..()
	horrid_form_shapeshift.Restore(horrid_form_shapeshift.myshape)
	owner.Stun(2 SECONDS)
	owner.do_jitter_animation(50)

/datum/discipline_power/vicissitude/horrid_form/post_gain()
	. = ..()
	if (!owner.mind)
		return
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_heart)

//BLOODFORM
/datum/discipline_power/vicissitude/bloodform
	name = "Bloodform"
	desc = "Liquefy into a shifting mass of sentient Vitae."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE

	duration_length = 20 SECONDS
	cooldown_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler/bloodform_shapeshift

/datum/discipline_power/vicissitude/bloodform/activate()
	. = ..()
	if (!bloodform_shapeshift)
		bloodform_shapeshift = new(owner)

	bloodform_shapeshift.Shapeshift(owner)

/datum/discipline_power/vicissitude/bloodform/deactivate()
	. = ..()
	var/mob/living/simple_animal/hostile/bloodcrawler/bloodform = bloodform_shapeshift.myshape
	owner.bloodpool = min(owner.bloodpool + round(bloodform.collected_blood / 2), owner.maxbloodpool)
	bloodform_shapeshift.Restore(bloodform_shapeshift.myshape)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(30)
