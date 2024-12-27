/datum/ritual
	name = "Base Ritual"
	description = "An arcane rite shrouded in mystery."
	duration = 60 SECONDS				//Ritual effects duration
	requires = list()					//Required item list
	cost = 1 							//Blood cost
	effects = null
	failure_effects = null

/datum/ritual/proc/start(user)
	if(!can_perform(user))
		to_chat(user, "<span class='warning'>You lack the required items or conditions to perform this ritual.</span>")
		return
	else
		perform_ritual(user)

/datum/ritual/proc/can_perform(user)
	for(var/obj/item/req in requires)
		if(!locate(req) in user.contents)
			return FALSE
	if(user.bloodpool < cost)
		return FALSE
	else
		return TRUE

/datum/ritual/proc/perform_ritual(user)
	if(success_check(user))
		call(effects)(user)
	else
		call(failure_effects)(user)

/datum/ritual/proc/success_check(user)
	if(storyteller_roll(user.mentality, base_difficulty + difficulty_malus) == ROLL_SUCCESS)
		return TRUE
	else
		return FALSE
