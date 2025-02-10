SUBSYSTEM_DEF(bouncer_barriers)
	name = "Bouncer Barrier"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_BARRIER
	var/barriers_enabled = TRUE

	///List of vip barriers
	var/list/datum/vip_barrier_perm/vip_barrier_perms = list()


/datum/controller/subsystem/bouncer_barriers/Initialize()
	for(var/barrier in subtypesof(/obj/effect/vip_barrier))
		var/obj/effect/vip_barrier/test_barrier = new barrier
		if(!vip_barrier_perms?[test_barrier.protected_zone_id])
			vip_barrier_perms[test_barrier.protected_zone_id] = new /datum/vip_barrier_perm(test_barrier.protected_zone_id)
		qdel(test_barrier)
	return ..()
