/datum/job/vamp/camarilla
	supervisors = "the Camarilla and the Traditions"
	total_positions = 1
	spawn_positions = 1

/datum/timelock/camarilla_authorities
	name = "Camarilla Authorities Roles"

/datum/timelock/camarilla_authorities/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_CAMARILLA_AUTHORITIES_ROLES_LIST

/datum/timelock/camarilla_council
	name = "Camarilla Council Roles"

/datum/timelock/camarilla_council/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_CAMARILLA_COUNCIL_ROLES_LIST


/datum/timelock/living
	name = "Living Roles"

/datum/timelock/living/can_play(client/C)
	return C.get_time_living() >= time_required

/datum/timelock/living/get_role_requirement(client/C)
	return time_required - C.get_time_living()
