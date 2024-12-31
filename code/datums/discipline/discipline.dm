/datum/discipline
	///Name of this Discipline.
	var/name = "Discipline name"
	///Text description of this Discipline.
	var/desc = "Discipline description"
	///Icon for this Discipline as in disciplines.dmi
	var/icon_state
	///What rank, or how many dots the caster has in this Discipline.
	var/level = 1
	///What rank of this Discipline is currently being casted.
	var/level_casting = 1
	///If this Discipline is unique to a certain Clan.
	var/clan_restricted = FALSE
	///The power that is currently in use.
	var/datum/discipline_power/current_power
	///The Discipline powers that are currently equipped, with one per index. Sublist of known_powers.
	var/list/datum/discipline_power/equipped_powers = list()
	///All Discipline powers under this Discipline that the owner knows. Derived from all_powers.
	var/list/datum/discipline_power/known_powers = list()
	///The typepaths of possible powers for every rank in this Discipline.
	var/all_powers = list()
	///The mob that owns and is using this Discipline.
	var/mob/living/carbon/human/owner

//TODO: rework this to use proper loadouts instead of a default set every time
/datum/discipline/New(level)
	if (!level)
		return

	src.level = level
	for (var/i in 1 to level)
		var/type_to_create = all_powers[i]
		var/datum/discipline_power/new_power = new type_to_create(src)
		known_powers += new_power
		equipped_powers += new_power
	current_power = equipped_powers[1]

/datum/discipline/proc/assign(mob/owner)
	src.owner = owner
	for (var/datum/discipline_power/power in known_powers)
		power.owner = owner

	post_gain()

/datum/discipline/proc/get_power(power)
	for (var/datum/discipline_power/found_power in known_powers)
		if (istext(power))
			if (found_power.name == power)
				return found_power
		else if (ispath(power))
			if (found_power.type == power)
				return found_power

/datum/discipline/proc/can_activate(atom/target)
	return current_power.can_activate(target)

/datum/discipline/proc/can_activate_untargeted(alert)
	return current_power.can_activate_untargeted(alert)

/datum/discipline/proc/activate(atom/target)
	current_power.activate(target)

/datum/discipline/proc/try_activate(atom/target)
	return current_power.try_activate(target)

/datum/discipline/proc/can_deactivate(atom/target)
	return current_power.can_deactivate(target)

/datum/discipline/proc/can_deactivate_untargeted()
	return current_power.can_deactivate_untargeted()

/datum/discipline/proc/deactivate(atom/target)
	current_power.deactivate(target)

/datum/discipline/proc/post_gain()
	for (var/datum/discipline_power/power in known_powers)
		power.post_gain()
