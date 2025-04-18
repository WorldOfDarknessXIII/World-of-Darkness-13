/datum/splat/werewolf/garou
	name = "Garou"
	desc = "Half-spiritual beings designated to be the defenders of the spirit world and Earth herself, on an everlasting war against entropy itself."

	splat_traits = list(
		TRAIT_VIRUSIMMUNE
	)
	splat_species_traits = list()
	splat_actions = list(
		/datum/action/gift/glabro,
		/datum/action/gift/rage_heal
	)

	max_resources = list(
		RESOURCE_RAGE = 10,
		RESOURCE_GNOSIS = 1
	)
	resources = list(
		RESOURCE_RAGE = 10,
		RESOURCE_GNOSIS = 1
	)
	replace_splats = list(
		/datum/splat/werewolf
	)
	incompatible_splats = list(
		/datum/splat/hungry_dead/kuei_jin
	)

	selectable = TRUE
	whitelisted = TRUE

	var/level
	var/datum/tribe/tribe
	var/datum/breed/breed
	var/datum/auspice/auspice
	var/obj/werewolf_holder/transformation/transformator

	var/glabro
	var/hispo

	COOLDOWN_DECLARE(rage_from_attack)
	COOLDOWN_DECLARE(look_at_moon)

/datum/splat/werewolf/garou/New(level, datum/auspice/auspice, datum/tribe/tribe, datum/breed/breed)
	. = ..()
	src.level = level
	src.auspice = auspice
	src.tribe = auspice
	src.breed = auspice

	max_resources[RESOURCE_GNOSIS] = src.breed.starting_gnosis
	resources[RESOURCE_GNOSIS] = max_resources[RESOURCE_GNOSIS]

	resources[RESOURCE_RAGE] = src.auspice.starting_rage

/datum/splat/werewolf/garou/on_gain()
	. = ..()

	RegisterSignal(owner, COMSIG_MOB_DRINK_VITAE, PROC_REF(handle_drinking_vitae))
	RegisterSignal(owner, COMSIG_MOB_EMBRACED, PROC_REF(handle_embrace))

	owner.update_rage_hud()

	transformator = new
	transformator.human_form = owner

	// i need character sheet datums yesterday
	transformator.lupus_form.splats = owner.splats
	transformator.crinos_form.splats = owner.splats

	transformator.crinos_form.physique = owner.physique
	transformator.crinos_form.dexterity = owner.dexterity
	transformator.crinos_form.mentality = owner.mentality
	transformator.crinos_form.social = owner.social
	transformator.crinos_form.blood = owner.blood

	transformator.lupus_form.physique = owner.physique
	transformator.lupus_form.dexterity = owner.dexterity
	transformator.lupus_form.mentality = owner.mentality
	transformator.lupus_form.social = owner.social
	transformator.lupus_form.blood = owner.blood

	transformator.lupus_form.maxHealth = owner.maxHealth
	transformator.lupus_form.health = owner.maxHealth
	transformator.crinos_form.maxHealth = owner.maxHealth
	transformator.crinos_form.health = owner.maxHealth

	for (var/gift_type in (auspice.gifts + tribe.gifts))
		var/datum/action/gift/giving_gift = new gift_type
		giving_gift.Grant(owner)

/datum/splat/werewolf/garou/proc/apply_preferences(werewolf_color, werewolf_scar, werewolf_hair, werewolf_hair_color, werewolf_eye_color, werewolf_color, werewolf_eye_color, werewolf_name)
	transformator.crinos_form.sprite_color = werewolf_color
	transformator.lupus_form.sprite_color = werewolf_color

	transformator.crinos_form.sprite_scar = werewolf_scar
	transformator.crinos_form.sprite_hair = werewolf_hair
	transformator.crinos_form.sprite_hair_color = werewolf_hair_color

	transformator.crinos_form.sprite_eye_color = werewolf_eye_color
	transformator.lupus_form.sprite_eye_color = werewolf_eye_color

	if (werewolf_name)
		transformator.crinos_form.name = werewolf_name
		transformator.lupus_form.name = werewolf_name
	else
		transformator.crinos_form.name = owner.real_name
		transformator.lupus_form.name = owner.real_name

/datum/splat/werewolf/garou/proc/handle_drinking_vitae(mob/living/carbon/source, mob/living/vampire, amount)
	SIGNAL_HANDLER

	// This isn't just drinking Vitae, this Garou is being EMBRACED!! And special handling applies instead
	if (source.stat == DEAD)
		return

	// Has already been handled before, no need to repeat the roll
	if (HAS_TRAIT(source, TRAIT_ALLERGIC_TO_VITAE) || HAS_TRAIT(source, TRAIT_TOLERATES_VITAE))
		return

	// Roll to determine if the Garou tolerates Vitae or not
	switch (storyteller_roll(dice = max_resources[RESOURCE_GNOSIS], difficulty = 3))
		if (ROLL_BOTCH, ROLL_FAILURE)
			ADD_TRAIT(source, TRAIT_TOLERATES_VITAE, WEREWOLF_TRAIT)
		if (ROLL_SUCCESS)
			ADD_TRAIT(source, TRAIT_ALLERGIC_TO_VITAE, WEREWOLF_TRAIT)

/datum/splat/werewolf/garou/proc/handle_embrace(mob/living/carbon/source, mob/living/vampire)
	SIGNAL_HANDLER

	if (HAS_TRAIT(owner, TRAIT_EMBRACE_ALWAYS_SUCCEEDS))
		to_chat(vampire, span_danger("Something terrible is happening."))
		to_chat(owner, span_userdanger("Gaia has forsaken you."))
		message_admins("[ADMIN_LOOKUPFLW(vampire)] has turned [ADMIN_LOOKUPFLW(owner)] into an Abomination through TRAIT_EMBRACE_ALWAYS_SUCEEDS.")
		log_game("[key_name(vampire)] has turned [key_name(owner)] into an Abomination through TRAIT_EMBRACE_ALWAYS_SUCCEEDS.")
		return

	// this should be rolling permanent Gnosis, which we... don't really have.
	switch (storyteller_roll(dice = max_resources[RESOURCE_GNOSIS], difficulty = 6))
		if (ROLL_BOTCH)
			to_chat(vampire, span_danger("Something terrible is happening."))
			to_chat(owner, span_userdanger("Gaia has forsaken you."))
			message_admins("[ADMIN_LOOKUPFLW(vampire)] has turned [ADMIN_LOOKUPFLW(owner)] into an Abomination.")
			log_game("[key_name(vampire)] has turned [key_name(owner)] into an Abomination.")
		if (ROLL_FAILURE)
			owner.visible_message(span_warning("[owner] convulses in sheer agony!"))
			owner.do_jitter_animation(30)
			playsound(owner, 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE)
			ADD_TRAIT(owner, TRAIT_CANNOT_BE_EMBRACED, WEREWOLF_TRAIT)
			return CANCEL_EMBRACE
		if (ROLL_SUCCESS)
			to_chat(vampire, span_notice("[owner] does not respond to your Vitae..."))
			ADD_TRAIT(owner, TRAIT_CANNOT_BE_EMBRACED, WEREWOLF_TRAIT)
			return CANCEL_EMBRACE
