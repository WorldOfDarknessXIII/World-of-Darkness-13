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
	src.auspice = GLOB.auspices[auspice]
	src.tribe = GLOB.tribes[tribe]
	src.breed = GLOB.breeds[breed]

	max_resources[RESOURCE_GNOSIS] = src.breed.starting_gnosis
	resources[RESOURCE_GNOSIS] = max_resources[RESOURCE_GNOSIS]

	resources[RESOURCE_RAGE] = src.auspice.starting_rage

/datum/splat/werewolf/garou/on_gain()
	. = ..()

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
