/datum/splat/hungry_dead

/datum/splat/hungry_dead/create_powers(list/power_types, list/levels)
	. = ..()

	if (length(power_types) != length(levels))
		return

	for (var/i in 1 to length(power_types))
		add_power(power_types[i], levels[i])

/datum/splat/hungry_dead/add_power(power_type, level)
	. = ..()

	var/datum/chi_discipline/giving_discipline = new power_type
	giving_discipline.level = level
	powers += giving_discipline

	var/datum/action/chi_discipline/giving_action = new
	giving_action.discipline = giving_discipline
	giving_action.Grant(owner)
	giving_discipline.post_gain(owner)

/datum/splat/hungry_dead/remove_power(power_type)
	. = ..()

	for (var/datum/action/chi_discipline/discipline_action in owner.actions)
		if (!istype(discipline_action.discipline, power_type))
			continue

		powers -= discipline_action.discipline
		qdel(discipline_action.discipline)
		discipline_action.Destroy()

/datum/splat/hungry_dead/proc/get_yin_chi()
	return get_resource(RESOURCE_YIN_CHI)

/datum/splat/hungry_dead/proc/get_yang_chi()
	return get_resource(RESOURCE_YANG_CHI)

/datum/splat/hungry_dead/proc/get_demon_chi()
	return get_resource(RESOURCE_DEMON_CHI)
