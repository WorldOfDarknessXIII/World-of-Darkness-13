/datum/job/recovered_crew
	policy_override = "Recovered Crew"
	faction = FACTION_STATION

/datum/job/recovered_crew/doctor
	title = JOB_LOSTCREW_MEDICAL
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/job/recovered_crew/engineer
	title = JOB_LOSTCREW_ENGINEER
	department_head = list(JOB_CHIEF_ENGINEER)

/datum/job/recovered_crew/security
	title = JOB_LOSTCREW_SECURITY
	department_head = list(JOB_HEAD_OF_SECURITY)

/datum/job/recovered_crew/cargo
	title = JOB_LOSTCREW_CARGO
	department_head = list(JOB_QUARTERMASTER)

/datum/job/recovered_crew/scientist
	title = JOB_LOSTCREW_SCIENCE
	department_head = list(JOB_RESEARCH_DIRECTOR)

/datum/job/recovered_crew/civillian
	title = JOB_LOSTCREW_CIVILLIAN
	department_head = list(JOB_HEAD_OF_PERSONNEL)
