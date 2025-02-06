/datum/job/vamp/giovanni_family
	supervisors = "the Family and the Traditions"
	total_positions = 1
	spawn_positions = 1

/datum/timelock/giovanni_family
	name = "Giovanni Family Roles"

/datum/timelock/giovanni_family/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_GIOVANNI_ROLES_LIST


/datum/timelock/living
	name = "Living Roles"

/datum/timelock/living/can_play(client/C)
	return C.get_time_living() >= time_required

/datum/timelock/living/get_role_requirement(client/C)
	return time_required - C.get_time_living()
