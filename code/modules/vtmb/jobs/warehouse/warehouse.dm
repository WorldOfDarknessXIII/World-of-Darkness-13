/datum/job/vamp/warehouse
	supervisors = "None. You are beholden only to yourself."
	total_positions = 1
	spawn_positions = 1

/datum/timelock/warehouse
	name = "Warehouse Roles"

/datum/timelock/warehouse/New(name, time_required, list/roles)
	. = ..()
	src.roles = JOB_WAREHOUSE_ROLES_LIST


/datum/timelock/living
	name = "Living Roles"

/datum/timelock/living/can_play(client/C)
	return C.get_time_living() >= time_required

/datum/timelock/living/get_role_requirement(client/C)
	return time_required - C.get_time_living()
