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

	COOLDOWN_DECLARE(rage_from_attack)
	COOLDOWN_DECLARE(look_at_moon)

/datum/splat/werewolf/garou/New(level = 1, auspice = /datum/auspice/ahroun, tribe = /datum/tribe/wendigo, breed = /datum/breed/homid)
	. = ..()
	src.level = level
	src.auspice = new auspice
	src.tribe = new tribe
	src.breed = new breed

	max_resources[RESOURCE_GNOSIS] = src.breed.starting_gnosis
	resources[RESOURCE_GNOSIS] = max_resources[RESOURCE_GNOSIS]

	resources[RESOURCE_RAGE] = src.auspice.starting_rage

/datum/splat/werewolf/garou/on_gain()
	. = ..()

	owner.update_rage_hud()
	transformator.lupus_form.splats = owner.splats
	transformator.crinos_form.splats = owner.splats

	for (var/gift_type in (auspice.gifts + tribe.gifts))
		var/datum/action/gift/giving_gift = new gift_type
		giving_gift.Grant(owner)

	if (character.transformator.crinos_form && character.transformator.lupus_form)
		character.transformator.crinos_form.sprite_color = werewolf_color
		character.transformator.crinos_form.sprite_scar = werewolf_scar
		character.transformator.crinos_form.sprite_hair = werewolf_hair
		character.transformator.crinos_form.sprite_hair_color = werewolf_hair_color
		character.transformator.crinos_form.sprite_eye_color = werewolf_eye_color
		character.transformator.lupus_form.sprite_color = werewolf_color
		character.transformator.lupus_form.sprite_eye_color = werewolf_eye_color

		if(werewolf_name)
			character.transformator.crinos_form.name = werewolf_name
			character.transformator.lupus_form.name = werewolf_name
		else
			character.transformator.crinos_form.name = real_name
			character.transformator.lupus_form.name = real_name

		character.transformator.crinos_form.physique = physique
		character.transformator.crinos_form.dexterity = dexterity
		character.transformator.crinos_form.mentality = mentality
		character.transformator.crinos_form.social = social
		character.transformator.crinos_form.blood = blood

		character.transformator.lupus_form.physique = physique
		character.transformator.lupus_form.dexterity = dexterity
		character.transformator.lupus_form.mentality = mentality
		character.transformator.lupus_form.social = social
		character.transformator.lupus_form.blood = blood

		character.transformator.lupus_form.maxHealth = character.maxHealth
		character.transformator.lupus_form.health = character.maxHealth
		character.transformator.crinos_form.maxHealth = character.maxHealth
		character.transformator.crinos_form.health = character.maxHealth
