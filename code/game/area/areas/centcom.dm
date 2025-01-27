
// CENTCOM

// Side note, be sure to change the network_root_id of any areas that are not a part of centcom
// and just using the z space as safe harbor.  It shouldn't matter much as centcom z is isolated
// from everything anyway

/area/centcom
	name = "CentCom"
	icon_state = "centcom"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	flags_1 = NONE

/area/centcom/central_command_areas/control
	name = "CentCom Docks"

/area/centcom/evac
	name = "CentCom Recovery Ship"

/area/centcom/central_command_areas/supply
	name = "CentCom Supply Shuttle Dock"

/area/centcom/central_command_areas/ferry
	name = "CentCom Transport Shuttle Dock"

/area/centcom/central_command_areas/prison
	name = "Admin Prison"

/area/centcom/central_command_areas/holding
	name = "Holding Facility"

/area/centcom/central_command_areas/supplypod/supplypod_temp_holding
	name = "Supplypod Shipping lane"
	icon_state = "supplypod_flight"

/area/centcom/central_command_areas/supplypod
	name = "Supplypod Facility"
	icon_state = "supplypod"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/centcom/central_command_areas/supplypod/pod_storage
	name = "Supplypod Storage"
	icon_state = "supplypod_holding"

/area/centcom/central_command_areas/supplypod/loading
	name = "Supplypod Loading Facility"
	icon_state = "supplypod_loading"
	var/loading_id = ""

/area/centcom/central_command_areas/supplypod/loading/Initialize()
	. = ..()
	if(!loading_id)
		CRASH("[type] created without a loading_id")
	if(GLOB.supplypod_loading_bays[loading_id])
		CRASH("Duplicate loading bay area: [type] ([loading_id])")
	GLOB.supplypod_loading_bays[loading_id] = src

/area/centcom/central_command_areas/supplypod/loading/one
	name = "Bay #1"
	loading_id = "1"

/area/centcom/central_command_areas/supplypod/loading/two
	name = "Bay #2"
	loading_id = "2"

/area/centcom/central_command_areas/supplypod/loading/three
	name = "Bay #3"
	loading_id = "3"

/area/centcom/central_command_areas/supplypod/loading/four
	name = "Bay #4"
	loading_id = "4"

/area/centcom/central_command_areas/supplypod/loading/ert
	name = "ERT Bay"
	loading_id = "5"
//THUNDERDOME

/area/centcom/tdome
	name = "Thunderdome"
	icon_state = "yellow"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

/area/centcom/tdome/arena
	name = "Thunderdome Arena"
	icon_state = "thunder"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/centcom/tdome/arena_source
	name = "Thunderdome Arena Template"
	icon_state = "thunder"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/centcom/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/centcom/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "green"

/area/centcom/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/centcom/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"


//ENEMY

//Wizard
/area/centcom/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	flags_1 = NONE
	network_root_id = "MAGIC_NET"

//Abductors
/area/centcom/abductor_ship
	name = "Abductor Ship"
	icon_state = "yellow"
	requires_power = FALSE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	network_root_id = "ALIENS"

//Syndicates
/area/centcom/syndicate_mothership
	name = "Syndicate Mothership"
	icon_state = "syndie-ship"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NOTELEPORT
	flags_1 = NONE
	ambience_index = AMBIENCE_DANGER
	network_root_id = SYNDICATE_NETWORK_ROOT

/area/centcom/syndicate_mothership/control
	name = "Syndicate Control Room"
	icon_state = "syndie-control"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	network_root_id = SYNDICATE_NETWORK_ROOT

/area/centcom/syndicate_mothership/elite_squad
	name = "Syndicate Elite Squad"
	icon_state = "syndie-elite"
	network_root_id = SYNDICATE_NETWORK_ROOT
//CAPTURE THE FLAG

/area/centcom/ctf
	name = "Capture the Flag"
	icon_state = "yellow"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	flags_1 = NONE

/area/centcom/ctf/control_room
	name = "Control Room A"

/area/centcom/ctf/control_room2
	name = "Control Room B"

/area/centcom/ctf/central
	name = "Central"

/area/centcom/ctf/main_hall
	name = "Main Hall A"

/area/centcom/ctf/main_hall2
	name = "Main Hall B"

/area/centcom/ctf/corridor
	name = "Corridor A"

/area/centcom/ctf/corridor2
	name = "Corridor B"

/area/centcom/ctf/flag_room
	name = "Flag Room A"

/area/centcom/ctf/flag_room2
	name = "Flag Room B"
