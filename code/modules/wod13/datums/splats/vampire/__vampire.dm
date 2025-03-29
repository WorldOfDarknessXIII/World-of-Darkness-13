/datum/splat/vampire

/datum/splat/vampire/proc/get_vitae()
	return get_resource(RESOURCE_VITAE)

/datum/splat/vampire/proc/add_vitae(amount = 1)
	add_resource(RESOURCE_VITAE, amount)

/datum/splat/vampire/proc/remove_vitae(amount = 1)
	remove_resource(RESOURCE_VITAE, amount)
