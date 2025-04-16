/datum/splat/werewolf

/datum/splat/werewolf/proc/get_gnosis()
	return get_resource(RESOURCE_GNOSIS)

/datum/splat/werewolf/proc/add_gnosis(amount = 1, sound = TRUE)
	if (!add_resource(RESOURCE_GNOSIS, amount))
		return

	to_chat(owner, span_boldnotice("GNOSIS INCREASES"))

	if (sound)
		SEND_SOUND(owner, 'code/modules/wod13/sounds/humanity_gain.ogg')

	owner.update_rage_hud()

/datum/splat/werewolf/proc/remove_gnosis(amount = 1, sound = TRUE)
	if (!remove_resource(RESOURCE_GNOSIS, amount))
		return

	to_chat(owner, span_boldnotice("GNOSIS DECREASES"))

	if (sound)
		SEND_SOUND(owner, 'code/modules/wod13/sounds/rage_decrease.ogg')

	owner.update_rage_hud()

/datum/splat/werewolf/proc/get_rage()
	return get_resource(RESOURCE_RAGE)

/datum/splat/werewolf/proc/add_rage(amount = 1, sound = TRUE)
	if (!add_resource(RESOURCE_RAGE, amount))
		return

	to_chat(owner, span_userdanger("RAGE INCREASES"))

	if (sound)
		SEND_SOUND(owner, 'code/modules/wod13/sounds/rage_increase.ogg')

	owner.update_rage_hud()

/datum/splat/werewolf/proc/remove_rage(amount = 1, sound = TRUE)
	if (!remove_resource(RESOURCE_RAGE, amount))
		return

	to_chat(owner, span_userdanger("RAGE DECREASES"))

	if (sound)
		SEND_SOUND(owner, 'code/modules/wod13/sounds/rage_decrease.ogg')

	owner.update_rage_hud()


