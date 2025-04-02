/datum/splat/werewolf/garou

	max_resources = list(
		RESOURCE_RAGE = 10,
		RESOURCE_GNOSIS = 10
	)
	resources = list(
		RESOURCE_RAGE = 10,
		RESOURCE_GNOSIS = 10
	)

	selectable = TRUE
	whitelisted = TRUE

	var/datum/auspice/auspice
	var/obj/werewolf_holder/transformation/transformator

	COOLDOWN_DECLARE(rage_from_attack)
	COOLDOWN_DECLARE(look_at_moon)
