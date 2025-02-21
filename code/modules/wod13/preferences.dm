/datum/preferences
	//Generation
	var/generation = 13
	var/generation_bonus = 0

	//Masquerade
	var/masquerade = 5

	var/enlightenment = FALSE
	var/humanity = 7

	//Legacy
	var/exper = 1440
	var/exper_plus = 0

	var/discipline1level = 1
	var/discipline2level = 1
	var/discipline3level = 1
	var/discipline4level = 1

	var/discipline1type
	var/discipline2type
	var/discipline3type
	var/discipline4type

	//Character sheet stats
	var/true_experience = 50
	var/torpor_count = 0

	//linked lists determining known Disciplines and their known ranks
	///Datum types of the Disciplines this character knows.
	var/list/discipline_types = list()
	///Ranks of the Disciplines this character knows, corresponding to discipline_types.
	var/list/discipline_levels = list()

	var/strength = 1
	var/dexterity = 1
	var/social = 1
	var/mentality = 1
	var/blood = 1

	//Skills
	var/lockpicking = 0
	var/athletics = 0

	var/info_known = INFO_KNOWN_UNKNOWN

	var/friend = FALSE
	var/enemy = FALSE
	var/lover = FALSE

	var/flavor_text

	var/friend_text
	var/enemy_text
	var/lover_text

	var/diablerist = 0

	var/reason_of_death = "None"

	var/archetype = /datum/archetype/average

	var/breed = "Homid"
	var/tribe = "Wendigo"
	var/datum/auspice/auspice = new /datum/auspice/ahroun()
	var/werewolf_color = "black"
	var/werewolf_scar = 0
	var/werewolf_hair = 0
	var/werewolf_hair_color = "#000000"
	var/werewolf_eye_color = "#FFFFFF"
	var/werewolf_apparel

	var/werewolf_name
	var/auspice_level = 1

	var/clane_accessory

	var/dharma_type = /datum/dharma
	var/dharma_level = 1
	var/po_type = "Rebel"
	var/po = 5
	var/hun = 5
	var/yang = 5
	var/yin = 5
	var/list/chi_types = list()
	var/list/chi_levels = list()
