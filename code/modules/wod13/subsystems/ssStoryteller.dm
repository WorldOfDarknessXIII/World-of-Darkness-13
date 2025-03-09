SUBSYSTEM_DEF(storyteller)
	name = "storyteller"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_STORYTELLER
	var/list/attribute_types = list(
		"physical",
		"social",
		"mental",
	)
	var/list/physical_attributes = list(
		"strength",
		"dexterity",
		"stamina",
	)
	var/list/social_attributes = list(
		"charisma",
		"manipulation",
		"appearance",
	)
	var/list/mental_attributes = list(
		"perception",
		"intelligence",
		"wits",
	)
	var/list/ability_types = list(
		"talents",
		"skills",
		"knowledges",
	)
	var/list/talent_types = list(
		"alertness",
		"athletics",
		"awareness",
		"brawl",
		"empathy",
		"expression",
		"intimidation",
		"leadership",
		"streetwise",
		"subterfuge",
	)
	var/list/skill_types = list(
		"animal_ken",
		"crafts",
		"drive",
		"etiquette",
		"firearms",
		"larceny",
		"melee",
		"performance",
		"stealth",
		"survival",
	)
	var/list/knowledge_types = list(
		"academics",
		"computer",
		"finance",
		"investigation",
		"law",
		"medicine",
		"occult",
		"politics",
		"science",
		"technology",
	)

/datum/controller/subsystem/storyteller/Initialize()

/datum/controller/subsystem/storyteller/proc/roll(roll_type, mob/living/roller, atom/contesting = null)
	#warn "implement this"
	return TRUE
