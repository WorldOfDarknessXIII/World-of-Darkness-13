//SABBAT = +90 threat
//HUNT = +60 threat
//CAITIFF = +30 threat

SUBSYSTEM_DEF(bad_guys_party)
	name = "Bad Guys Party"
	init_order = INIT_ORDER_DEFAULT
	wait = 4000
	priority = FIRE_PRIORITY_DEFAULT

	var/threat = 0	//Bigger number - less chance

	var/setting

	var/list/candidates = list()
	var/max_candidates = 0
	var/datum/outfit/job/Next = null
	var/go_on_next_fire = FALSE

	var/setted_up = FALSE
	var/list/datum/job/jobs = list()

/datum/controller/subsystem/bad_guys_party/proc/setup_occupations()
	var/list/all_jobs = subtypesof(/datum/job)

	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job)
			continue
		jobs[job.title] = job

/datum/controller/subsystem/bad_guys_party/proc/GetAntagJob(var/rank)
	return jobs[rank]

/datum/controller/subsystem/bad_guys_party/proc/set_badguys(var/new_setting)
	if(new_setting in list("caitiff", "sabbat", "hunter"))
		SSbad_guys_party.setting = new_setting
	else
		setting = null



/datum/controller/subsystem/bad_guys_party/proc/get_badguys(var/level)
	if(setting)
		switch(setting)
			if("caitiff")
				if(Next)
					qdel(Next)
				threat = min(100, threat+60)
				max_candidates = 1
				go_on_next_fire = TRUE
				Next = new /datum/outfit/job/caitiff()
				setting = null
			if("sabbat")
				if(Next)
					qdel(Next)
				threat = min(100, threat+30)
				max_candidates = 2
				go_on_next_fire = TRUE
				Next = new /datum/outfit/job/sabbatist()
				setting = null
			if("hunter")
				if(Next)
					qdel(Next)
				threat = min(100, threat+60)
				max_candidates = 5
				go_on_next_fire = TRUE
				Next = new /datum/outfit/job/hunter()
				setting = null
	else if(setting == null)
		switch(level)
			if(1)
				if(prob(20))
					//caitiff
					if(Next)
						qdel(Next)
					threat = min(100, threat+60)
					max_candidates = 1
					go_on_next_fire = TRUE
					Next = new /datum/outfit/job/caitiff()
				else
					//sabbat
					if(Next)
						qdel(Next)
					threat = min(100, threat+30)
					max_candidates = 2
					go_on_next_fire = TRUE
					Next = new /datum/outfit/job/sabbatist()
			if(2)
				if(prob(30))
					//sabbat
					if(Next)
						qdel(Next)
					threat = min(100, threat+90)
					max_candidates = 4
					go_on_next_fire = TRUE
					Next = new /datum/outfit/job/sabbatist()
				else
					//hunt
					if(Next)
						qdel(Next)
					threat = min(100, threat+60)
					max_candidates = 2
					go_on_next_fire = TRUE
					Next = new /datum/outfit/job/hunter()
			/*if(3)
				if(prob(50))
					//hunt
					if(Next)
						qdel(Next)
					threat = min(100, threat+60)
					max_candidates = 2
					go_on_next_fire = TRUE
					Next = new /datum/outfit/job/hunter()
				else
					//sabbat
					if(Next)
						qdel(Next)
					threat = min(100, threat+90)
					max_candidates = 3
					go_on_next_fire = TRUE
					Next = new /datum/outfit/job/sabbatist()*/

/mob/dead/new_player/proc/ForceLateSpawn()
	if(SSticker.late_join_disabled)
		alert(src, "An administrator has disabled late join spawning.")
		return FALSE

	//Remove the player from the join queue if he was in one and reset the timer
	SSticker.queued_players -= src
	SSticker.queue_delay = 4

	SSjob.AssignRole(src, "Citizen", 1)

	var/mob/living/character = create_character(TRUE)	//creates the human and transfers vars and mind
	SSbad_guys_party.Next.equip(H = character, visualsOnly = FALSE)
	var/atom/movable/screen/splash/Spl = new(character.client, TRUE)
	Spl.Fade(TRUE)
	character.update_parallax_teleport()

	SSticker.minds += character.mind
	character.client.init_verbs() // init verbs for the late join

/datum/controller/subsystem/bad_guys_party/fire()
	switch(SSmasquerade.total_level)
		if(0 to 250)
			wait = 3000
		if(251 to 500)
			wait = 6000
		if(501 to 1000)
			wait = 12000
	if(!setted_up)
		setup_occupations()
		setted_up = TRUE

	if(SSticker.current_state == GAME_STATE_PLAYING)
		threat = max(0, threat-10)

		if(go_on_next_fire)
			if(length(candidates))
				var/list/actual_candidates = candidates.Copy()
				if(length(candidates) > max_candidates)
					for(var/i in 1 to length(candidates)-max_candidates)
						actual_candidates -= pick(candidates)
				for(var/mob/dead/new_player/NP in actual_candidates)
					candidates -= NP
					NP.late_ready = FALSE
					NP.ForceLateSpawn()
				go_on_next_fire = FALSE
			return
		else
			if(SSmasquerade.total_level <= 500)
				get_badguys(2)
			else
				switch(threat)
					if(0 to 10)
						//ANYONE
						if(prob(100-threat))
							get_badguys(rand(1, 3))
					if(11 to 40)
						//HUNT OR CAITIFF
						if(prob(100-threat))
							get_badguys(rand(1, 2))
					if(41 to 70)
						//CAITIFF ONLY
						if(prob(100-threat))
							get_badguys(1)
