/datum/job/vamp/city_services
	supervisors = "Your Boss"
	total_positions = 1
	spawn_positions = 1

/datum/timelock/city_services
	name = "City Services Roles"

/datum/timelock/city_services/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_CITY_SERVICES_ROLES_LIST


/datum/timelock/living
	name = "Living Roles"

/datum/timelock/living/can_play(client/C)
	return C.get_time_living() >= time_required

/datum/timelock/living/get_role_requirement(client/C)
	return time_required - C.get_time_living()
