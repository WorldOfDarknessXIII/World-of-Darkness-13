/datum/job/vamp/national_security
	supervisors = "Your Country and respective supervisors"
	total_positions = 1
	spawn_positions = 1

/datum/timelock/national_security
	name = "National Security Roles"

/datum/timelock/national_security/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_NATIONAL_SECURITY_ROLES_LIST


/datum/timelock/living
	name = "Living Roles"

/datum/timelock/living/can_play(client/C)
	return C.get_time_living() >= time_required

/datum/timelock/living/get_role_requirement(client/C)
	return time_required - C.get_time_living()
