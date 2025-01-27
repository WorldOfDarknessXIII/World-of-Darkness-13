/datum/discipline/vicissitude
	name = "Vicissitude"
	desc = "It is widely known as Tzimisce art of flesh and bone shaping. Violates Masquerade."
	icon_state = "vicissitude"
	clan_restricted = TRUE

/datum/discipline/vicissitude/New(level)
	all_powers = subtypesof(/datum/discipline_power/vicissitude)
	..()

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

	//what you see here: mostly sane TG code (dna) then bloat required by our codebase
	var/datum/dna/original_dna
	var/original_body_mod
	var/original_alt_sprite
	var/original_alt_sprite_greyscale

	var/datum/dna/impersonating_dna
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
		to_chat(owner, "<span class='warning'>No one is close enough for you to examine...</span>")
		return
	var/mob/living/carbon/human/victim = input(owner, "Who do you wish to impersonate?", name) as null|mob in potential_victims
	if (!victim)
		return

	impersonating_dna = new
	victim.dna.copy_dna(impersonating_dna)
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
	original_body_mod = owner.base_body_mod
	original_alt_sprite = owner.clane?.alt_sprite
	original_alt_sprite_greyscale = owner.clane?.alt_sprite_greyscale

/datum/discipline_power/vicissitude/malleable_visage/proc/shapeshift(to_original = FALSE, instant = FALSE)
	if (!instant)
		var/time_delay = 10 SECONDS
		if (original_body_mod != impersonating_body_mod)
			time_delay += 5 SECONDS
		if (original_alt_sprite != impersonating_alt_sprite)
			time_delay += 10 SECONDS
		to_chat(owner, "<span class='notice'>You begin molding your appearance... This will take [DisplayTimeText(time_delay)].</span>")
		if (!do_after(owner, time_delay))
			return

	owner.Stun(1 SECONDS)
	owner.do_jitter_animation(10)
	playsound(get_turf(owner), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)

	if (to_original)
		original_dna.transfer_identity(destination = owner, transfer_SE = TRUE, superficial = TRUE)
		owner.base_body_mod = original_body_mod
		owner.clane.alt_sprite = original_alt_sprite
		owner.clane.alt_sprite_greyscale = original_alt_sprite_greyscale
		is_shapeshifted = FALSE
	else
		//Nosferatu, Cappadocians, Gargoyles, Kiasyd, etc. will revert instead of being indefinitely without their curse
		if (original_alt_sprite)
			addtimer(CALLBACK(src, PROC_REF(revert_to_cursed_form)), 3 MINUTES)
		impersonating_dna.transfer_identity(destination = owner, superficial = TRUE)
		owner.base_body_mod = impersonating_body_mod
		owner.clane.alt_sprite = impersonating_alt_sprite
		owner.clane.alt_sprite_greyscale = impersonating_alt_sprite_greyscale
		is_shapeshifted = TRUE

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

	to_chat(owner, "<span class='warning'>Your cursed appearance reasserts itself!</span>")

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

//HORRID FORM
/datum/discipline_power/vicissitude/horrid_form
	name = "Horrid Form"
	desc = "Shift your flesh and bone into that of a hideous monster."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 2
	bypass_spending_limits = TRUE

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
	owner.adjust_blood_points(round(bloodform.collected_blood / 2))
	bloodform_shapeshift.Restore(bloodform_shapeshift.myshape)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(30)

