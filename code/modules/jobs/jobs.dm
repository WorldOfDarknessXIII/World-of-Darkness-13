GLOBAL_LIST_INIT(leader_positions, list(
	"Prince",
	"Baron",
	"Chantry Regent",
	"Police Chief",
	"Dealer",
    "Capo"

	))

GLOBAL_LIST_INIT(command_positions, list(
	"Prince",
	"Seneschal",
	"Sheriff",
	"Scourge"))

GLOBAL_LIST_INIT(camarilla_council_positions, list(
    "Primogen Malkavian",
    "Primogen Nosferatu",
    "Primogen Toreador",
    "Primogen Ventrue",
    "Primogen Brujah"
))


GLOBAL_LIST_INIT(anarch_positions, list(
	"Baron",
	"Bouncer"
	))


GLOBAL_LIST_INIT(citizen_positions, list(
	"Citizen",
))

GLOBAL_LIST_INIT(police_positions, list(
    "Police Chief",
    "Police Sergeant",
    "Police Officer"

))

GLOBAL_LIST_INIT(national_security_positions, list(
    "Federal Investigator"
))

GLOBAL_LIST_INIT(services_positions, list(
    "Graveyard Keeper",
    "Stripper",
    "Street Janitor",
    "Doctor",
    "Taxi Driver"
))


GLOBAL_LIST_INIT(neutral_positions, list())

GLOBAL_LIST_INIT(giovanni_positions, list(
    "Capo",
    "La Squadra",
    "La Famiglia"
))

GLOBAL_LIST_INIT(tzimisce_positions, list(
    "Voivode",
    "Bogatyr",
    "Zadruga"
))

GLOBAL_LIST_INIT(warehouse_positions, list(
    "Dealer",
    "Supply Technician"
))


GLOBAL_LIST_INIT(tremere_positions, list(
	"Chantry Regent",
	"Chantry Archivist"
))

GLOBAL_LIST_INIT(church_positions, list(
    "Priest",
))

GLOBAL_LIST_INIT(gang_positions, list(
	"Triad Soldier",
))

GLOBAL_LIST_INIT(ss13, list(
    "SS13",
))

GLOBAL_LIST_INIT(nonhuman_positions, list())

// job categories for rendering the late join menu
GLOBAL_LIST_INIT(position_categories, list(
	EXP_TYPE_CAMARILLIA = list("jobs" = command_positions, "color" = "#9f1111"),
    EXP_TYPE_COUNCIL = list("jobs" = camarilla_council_positions, "color" = "#4f0404"),
    EXP_TYPE_TREMERE = list("jobs" = tremere_positions, "color" = "#b2442c"),
    EXP_TYPE_GIOVANNI = list("jobs" = giovanni_positions, "color" = "#3e0c70"),
    EXP_TYPE_OTHER_CITIZEN = list("jobs" = citizen_positions, "color" = "#7e7e7e"),
    EXP_TYPE_ANARCH = list("jobs" = anarch_positions, "color" = "#313131"),
    EXP_TYPE_WAREHOUSE = list("jobs" = warehouse_positions, "color" = "#edc009"),
    EXP_TYPE_SERVICES = list("jobs" = services_positions, "color" = "#e8e6e6"),
    EXP_TYPE_CHURCH = list("jobs" = church_positions, "color" = " #fff700"),
    EXP_TYPE_POLICE = list("jobs" = police_positions, "color" = "#1d22cc"),
    EXP_TYPE_NATIONAL_SECURITY = list("jobs" = national_security_positions, "color" = " #000491"),
    EXP_TYPE_GANG = list("jobs" = gang_positions, "color" = "#837524"),
    EXP_TYPE_TZIMISCE = list("jobs" = tzimisce_positions, "color" = "#fa0207")
))


GLOBAL_LIST_INIT(exp_jobsmap, list(
	EXP_TYPE_CREW = list("titles" = command_positions | church_positions | camarilla_council_positions | citizen_positions | police_positions | national_security_positions | anarch_positions | services_positions  | giovanni_positions | tzimisce_positions | warehouse_positions | tremere_positions | gang_positions), // crew positions
	EXP_TYPE_CAMARILLIA = list("titles" = command_positions),
	EXP_TYPE_TREMERE = list("titles" = tremere_positions),
	EXP_TYPE_ANARCH = list("titles" = anarch_positions),
	EXP_TYPE_GANG = list("titles" = gang_positions),
    EXP_TYPE_OTHER_CITIZEN = list("titles" = citizen_positions),
    EXP_TYPE_COUNCIL = list("titles" = camarilla_council_positions),
    EXP_TYPE_POLICE = list("titles" = police_positions),
    EXP_TYPE_SERVICES = list("titles" = services_positions),
    EXP_TYPE_GIOVANNI = list("titles" = giovanni_positions),
    EXP_TYPE_TZIMISCE = list("titles" = tzimisce_positions),
    EXP_TYPE_WAREHOUSE = list("titles" = warehouse_positions),
    EXP_TYPE_CHURCH = list("titles" = church_positions),
    EXP_TYPE_NATIONAL_SECURITY = list("titles" = national_security_positions),

))

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_SPECIAL = list("Lifebringer","Ash Walker","Exile","Servant Golem","Free Golem","Hermit","Translocated Vet","Escaped Prisoner","Hotel Staff","SuperFriend","Space Syndicate","Ancient Crew","Space Doctor","Space Bartender","Beach Bum","Skeleton","Zombie","Space Bar Patron","Lavaland Syndicate","Ghost Role"), // Ghost roles
	EXP_TYPE_GHOST = list() // dead people, observers
))
GLOBAL_PROTECT(exp_jobsmap)
GLOBAL_PROTECT(exp_specialmap)

//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/sec_expand = new("(?<!security )officer")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = sec_expand.Replace(job, "security officer")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job
