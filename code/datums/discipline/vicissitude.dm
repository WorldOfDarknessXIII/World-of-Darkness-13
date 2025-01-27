/datum/discipline/vicissitude
	name = "Vicissitude"
	desc = "It is widely known as Tzimisce art of flesh and bone shaping. Violates Masquerade."
	icon_state = "vicissitude"

/datum/discipline/vicissitude/New(level)
	all_powers = subtypesof(/datum/discipline_power/vicissitude)
	..()

/datum/discipline/vicissitude/post_gain()
	. = ..()
	H.faction |= "Tzimisce"
	if (level >= 2)
		var/obj/item/organ/cyberimp/arm/surgery/surgery_implant = new()
		surgery_implant.Insert(owner)
	if(level >= 3)
		var/datum/action/basic_vicissitude/vicissitude_upgrade = new()
		vicissitude_upgrade.Grant(owner)
	if(level >= 4)
		var/datum/action/vicissitude_form/zulo_form = new()
		zulo_form.Grant(owner)
	if(level >= 5)
		var/datum/action/vicissitude_blood/bloodform = new()
		bloodform.Grant(owner)
	if(owner.mind)
		if(level >= 2)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_wall)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_stool)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_floor)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_eyes)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_implant)
		if(level >= 3)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_trench)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_biter)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_fister)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_tanker)
		if(level >= 4)
			owner.mind.teach_crafting_recipe(/datum/crafting_recipe/tzi_heart)

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
		original_dna.transfer_identity(destination = owner, superficial = TRUE)
		owner.base_body_mod = original_body_mod
		owner.clane.alt_sprite = original_alt_sprite
		owner.clane.alt_sprite_greyscale = original_alt_sprite_greyscale
		is_shapeshifted = FALSE
	else
		//Nosferatu, Cappadocians, Gargoyles, Kiasyd, etc. will revert instead of living without their curse
		if (original_alt_sprite)
			addtimer(CALLBACK(src, PROC_REF(revert_to_cursed_form)), 3 MINUTES)
		impersonating_dna.copy_dna(owner)
		owner.base_body_mod = impersonating_body_mod
		owner.clane.alt_sprite = impersonating_alt_sprite
		owner.clane.alt_sprite_greyscale = impersonating_alt_sprite_greyscale
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

	to_chat(owner, "<span class='warning'>Your cursed appearance reasserts itself!</span>")
