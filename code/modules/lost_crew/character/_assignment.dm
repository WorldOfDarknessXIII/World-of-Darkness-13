/// Possible assignments corpses can have, both for flavor and to push them towards contributing to the round
/datum/corpse_assignment
	/// Message we send to the player upon revival concerning their job
	var/job_lore
	/// Gear to give to the crewie in a special locked box
	var/list/job_stuffs
	/// Job datum to apply to the human
	var/datum/job/job_datum

/datum/corpse_assignment/proc/apply_assignment(mob/living/carbon/human/working_dead, list/job_gear, list/datum/callback/on_revive_and_player_occupancy)
	if(!job_gear)
		return

	for(var/item in job_stuffs)
		job_gear += new item ()
	job_gear += job_stuffs

	if(job_datum)
		on_revive_and_player_occupancy += CALLBACK(src, PROC_REF(assign_job), working_dead) //this needs to happen once the body has been successfully occupied and revived


/datum/corpse_assignment/proc/assign_job(mob/living/carbon/human/working_undead)
	working_undead.mind.set_assigned_role_with_greeting(new job_datum (), working_undead.client)

/datum/corpse_assignment/engineer
	job_lore = "I was employed as an engineer"
	job_stuffs = list(/obj/item/clothing/under/rank/engineering/engineer)
	job_datum = /datum/job/recovered_crew/engineer


/datum/corpse_assignment/medical
	job_lore = "I was employed as a doctor"
	job_stuffs = list(/obj/item/clothing/under/rank/medical/doctor)
	job_datum = /datum/job/recovered_crew/doctor

/datum/corpse_assignment/security
	job_lore = "I was employed as security"
	job_stuffs = list(/obj/item/clothing/under/rank/security/officer)
	job_datum = /datum/job/recovered_crew/security

/datum/corpse_assignment/security/apply_assignment(mob/living/carbon/human/working_dead, list/job_gear)
	. = ..()

	var/obj/item/implant/mindshield/shield = new()
	shield.implant(working_dead)


/datum/corpse_assignment/science
	job_lore = "I was employed as a scientist"
	job_stuffs = list(/obj/item/clothing/under/rank/rnd/scientist)
	job_datum = /datum/job/recovered_crew/scientist


/datum/corpse_assignment/cargo
	job_lore = "I was employed as a technician"
	job_stuffs = list(/obj/item/clothing/under/rank/cargo/tech)
	job_datum = /datum/job/recovered_crew/cargo


/datum/corpse_assignment/civillian
	job_lore = "I was employed as a civllian"
	job_stuffs = list(/obj/item/clothing/under/color/grey)
	job_datum = /datum/job/recovered_crew/civillian

