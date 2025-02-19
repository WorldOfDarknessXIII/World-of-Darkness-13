/datum/discipline
	/* CUSTOMIZABLE */
	///Name of this Discipline.
	var/name = "Discipline name"
	///Text description of this Discipline.
	var/desc = "Discipline description"
	///Icon for this Discipline as in disciplines.dmi
	var/icon_state
	///If this Discipline is unique to a certain Clan.
	var/clan_restricted = FALSE
	///The root type of the powers this Discipline uses.
	var/power_type = /datum/discipline_power
	///If this Discipline can be selected at all, or has special handling.
	var/selectable = TRUE

	/* BACKEND */
	///What rank, or how many dots the caster has in this Discipline.
	var/level = 1
	///What rank of this Discipline is currently being casted.
	var/level_casting = 1
	///The power that is currently in use.
	var/datum/discipline_power/current_power
	///All Discipline powers under this Discipline that the owner knows. Derived from all_powers.
	var/list/datum/discipline_power/known_powers = list()
	///The typepaths of possible powers for every rank in this Discipline.
	var/all_powers = list()
	///The mob that owns and is using this Discipline.
	var/mob/living/carbon/human/owner
	///If this Discipline has been assigned before and post_gain effects have already been applied.
	var/initialized

//TODO: rework this and set_level to use proper loadouts instead of a default set every time
/datum/discipline/New(level)
	all_powers = subtypesof(power_type)

	if (!level)
		return

	src.level = level
	for (var/i in 1 to level)
		var/type_to_create = all_powers[i]
		var/datum/discipline_power/new_power = new type_to_create(src)
		known_powers += new_power
	current_power = known_powers[1]

/datum/discipline/proc/set_level(level)
	if (level == src.level)
		return

	var/list/datum/discipline_power/new_known_powers = list()
	for (var/i in 1 to level)
		if (length(known_powers) >= level)
			new_known_powers.Add(known_powers[i])
		else
			var/adding_power_type = all_powers[i]
			var/datum/discipline_power/new_power = new adding_power_type(src)
			new_known_powers.Add(new_power)
			new_power.post_gain()

	//delete orphaned powers
	var/list/datum/discipline_power/leftover_powers = known_powers - new_known_powers
	if (length(leftover_powers))
		QDEL_LIST(leftover_powers)

	known_powers = new_known_powers
	src.level = level

/datum/discipline/proc/assign(mob/owner)
	src.owner = owner
	for (var/datum/discipline_power/power in known_powers)
		power.owner = owner

	if (!initialized)
		post_gain()
	initialized = TRUE

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

/datum/discipline/proc/pre_activation(atom/target)
	current_power.pre_activation(target)

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
	SHOULD_CALL_PARENT(TRUE)

	for (var/datum/discipline_power/power in known_powers)
		power.post_gain()
