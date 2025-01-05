SUBSYSTEM_DEF(job_scaling)
	name = "Job Scaling"
	init_order = INIT_ORDER_JOBS + 1
	wait = 10 SECONDS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/scaling_rules = list()
	var/last_player_count = 0  // track last count to avoid spam

/datum/controller/subsystem/job_scaling/Initialize(timeofday)
	setup_scaling_rules()
	apply_initial_scaling()
	return ..()

/datum/controller/subsystem/job_scaling/fire()
	var/total_players = length(GLOB.player_list)

	if(total_players == last_player_count)  // skip if player count hasn't changed
		return

	last_player_count = total_players

	for(var/job_title in scaling_rules)
		var/datum/job/J = SSjob.GetJob(job_title)
		if(!J)
			continue

		var/list/rule = scaling_rules[job_title]
		var/players_per_slot = rule[1]
		var/base_pop = rule[2]
		var/max_additional = rule[3]

		if(total_players <= base_pop)
			continue

		var/slots_needed = min(round((total_players - base_pop) / players_per_slot), max_additional)
		var/slots_to_add = slots_needed - (J.total_positions - initial(J.total_positions))

		if(slots_to_add > 0)
			var/old_total = J.total_positions
			J.total_positions += slots_to_add
			message_admins("Job Scaling: Added [slots_to_add] [job_title] slot(s), Total_Positions increased from [old_total] to [J.total_positions]")

/datum/controller/subsystem/job_scaling/proc/setup_scaling_rules()
//police jobs
	scaling_rules["Police Officer"] = list(10, 30, 10)  // 1 slot per 10 players over 30 players, up to 10 extra slots (15 max since 5 is the base)
	scaling_rules["Police Sergeant"] = list(20, 30, 3) // 1 slot per 20 players over 30 players, up to 3 extra slots (5 max since 2 is the base)

//civilian/human jobs
	scaling_rules["Doctor"] = list(10, 30, 5)  // 1 slot per 10 players over 30 players, up to 5 extra slots (9 max since 4 is the base)
	scaling_rules["Priest"] = list(10, 30, 3) // 1 slot per 10 players over 30 players, up to 3 extra slots (5 max since 2 is the base)
	scaling_rules["Stripper"] = list(10, 30, 6) // 1 slot per 10 players over 30 players, up to 6 extra slots (10 max since 6 is the base)
	scaling_rules["Street Janitor"] = list(10, 30, 4) // 1 slot per 10 players over 30 players, up to 4 extra slots (10 max since 6 is the base)

//vampire jobs
	scaling_rules["Scourge"] = list(10, 30, 3) // 1 slot per 10 players over 30 players, up to 3 extra slots (10 max since 7 is the base)
	scaling_rules["Bruiser"] = list(10, 30, 3) // 1 slot per 10 players over 30 players, up to 3 extra slots (10 max since 7 is the base)

	message_admins("Job Scaling: Rules initialized")

/datum/controller/subsystem/job_scaling/proc/apply_initial_scaling()
	fire()
