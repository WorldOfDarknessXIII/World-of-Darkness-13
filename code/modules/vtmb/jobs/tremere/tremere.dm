/datum/job/vamp/tremere
	supervisors = "the Pyramid"
	total_positions = 1
	spawn_positions = 1

/datum/timelock/tremere
	name = "Tremere Roles"

/datum/timelock/tremere/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_TREMERE_ROLES_LIST


/datum/timelock/living
	name = "Living Roles"

/datum/timelock/living/can_play(client/C)
	return C.get_time_living() >= time_required

/datum/timelock/living/get_role_requirement(client/C)
	return time_required - C.get_time_living()
