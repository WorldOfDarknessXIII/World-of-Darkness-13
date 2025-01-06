/datum/map_template/modular
	name = "Generic modular template"
	mappath = "_maps/modularmaps"
	///ID of this map template
	var/modular_id = "none"
	///Number for its height, used for sanity
	var/template_height = 0
	///Number for its width, used for sanity
	var/template_width = 0
	///Bool for whether we want to to be spawning from the middle or to the topright of the spawner (true is centered)
	var/keepcentered = FALSE

/datum/map_template/modular/sanfrancisco
	mappath = "_maps/modularmaps/sanfrancisco"

/datum/map_template/modular/sanfrancisco/sewersdrugden
	name = "Sewers Drug Den"
	mappath = "_maps/modularmaps/sanfrancisco/sewersdrugden.dmm"
	modular_id = "sewersnortheast1"
	template_width = 14
	template_height = 17

/datum/map_template/modular/sanfrancisco/sewersthunderdome
	name = "Sewers Thunderdome"
	mappath = "_maps/modularmaps/sanfrancisco/sewersthunderdome.dmm"
	modular_id = "sewersnortheast1"
	template_width = 14
	template_height = 17
