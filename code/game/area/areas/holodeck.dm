/area/station/holodeck
	name = "Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA
	sound_environment = SOUND_ENVIRONMENT_PADDED_CELL

	var/obj/machinery/computer/holodeck/linked
	var/restricted = FALSE // if true, program goes on emag list
	network_root_id = "HOLODECK"
/*
	Power tracking: Use the holodeck computer's power grid
	Asserts are to avoid the inevitable infinite loops
*/

/area/station/holodeck/powered(chan)
	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE
	if(!linked)
		return FALSE
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/station/holodeck))
	return A.powered(chan)

/area/station/holodeck/addStaticPower(value, powerchannel)
	if(!linked)
		return
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/station/holodeck))
	return ..()

/area/station/holodeck/use_power(amount, chan)
	if(!linked)
		return FALSE
	var/area/A = get_area(linked)
	ASSERT(!istype(A, /area/station/holodeck))
	return ..()


/*
	This is the standard holodeck.  It is intended to allow you to
	blow off steam by doing stupid things like laying down, throwing
	spheres at holes, or bludgeoning people.
*/
/area/station/holodeck/rec_center
	name = "\improper Recreational Holodeck"

/area/station/holodeck/rec_center/offstation_one
	name = "\improper Recreational Holodeck"
