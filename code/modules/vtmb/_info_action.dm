/datum/action/info_action
	var/mob/living/carbon/human/host

/datum/action/info_action/Trigger(dat) // PSEUDO_M rework this horrible shit
	return host.mind.memory
