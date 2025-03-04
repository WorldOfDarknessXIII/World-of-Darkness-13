/**
 * transport_controller landmarks. used to map specific destinations on the map.
 */
/obj/effect/landmark/transport/nav_beacon/tram
	name = "tram destination" //the tram buttons will mention this.
	icon_state = "tram"

	/// The ID of the tram we're linked to
	var/specific_transport_id = TRAMSTATION_LINE_1
	/// The ID of that particular destination
	var/platform_code = null
	/// Icons for the tgui console to list out for what is at this location
	var/list/tgui_icons = list()

/obj/effect/landmark/transport/nav_beacon/tram/Initialize(mapload)
	. = ..()
	LAZYADDASSOCLIST(SStransport.nav_beacons, specific_transport_id, src)

/obj/effect/landmark/transport/nav_beacon/tram/Destroy()
	LAZYREMOVEASSOC(SStransport.nav_beacons, specific_transport_id, src)
	return ..()

/obj/effect/landmark/transport/nav_beacon/tram/nav
	name = "tram nav beacon"
	invisibility = INVISIBILITY_MAXIMUM // nav aids can't be abstract since they stay with the tram

/**
 * transport_controller landmarks. used to map in specific_transport_id to trams and elevators. when the transport_controller encounters one on a tile
 * it sets its specific_transport_id to that landmark. allows you to have multiple trams and multiple objects linking to their specific tram
 */
/obj/effect/landmark/transport/transport_id
	name = "transport init landmark"
	icon_state = "lift_id"
	///what specific id we give to the tram we're placed on, should explicitely set this if its a subtype, or weird things might happen
	var/specific_transport_id

//map-agnostic landmarks

/obj/effect/landmark/transport/nav_beacon/tram/nav/immovable_rod
	name = "DESTINATION/NOT/FOUND"
	specific_transport_id = IMMOVABLE_ROD_DESTINATIONS
