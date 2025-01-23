/datum/action/info_action
	var/mob/living/carbon/human/host

/datum/action/info_action/Trigger(dat) // PSEUDO_M rework this horrible shit within the next week (1/19/25)
	return host.mind.memory
