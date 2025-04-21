// OOPS office defines

/obj/structure/vampdoor/glass/oops_office
	name = "OOPS delivery office"
	lock_id = "oops"
	lockpick_difficulty = 12

/obj/structure/delivery_board/oops_office
	name = "OOPS delivery assigment board"
	delivery_employer_tag = "oops"
	desc = "OOPS provides city-wide delivery services in secure containers and at low, low prices. The latter is mostly guaranteed by the fact that most of the actual transportation seems to not be done by certified truck drivers but rather is outsourced by random hires taken off the street. It is very unclear who exactly is funding this initiative or how did OOPS networks become such a popular supplier in the city. Deliveries from this board do not support any particular group."

/area/vtm/interior/delivery/oops_office
	name = "OOPS delivery office"
	delivery_employer_tag = "oops"

/area/vtm/interior/delivery_garage/oops_office
	name = "OOPS delivery office - Garage"
	delivery_employer_tag = "oops"

/obj/effect/landmark/delivery_truck_beacon/oops_office
	spawn_dir = WEST
	delivery_employer_tag = "oops"

// Camarilla variant

/obj/structure/vampdoor/glass/mt_office
	name = "Millenium Tower delivery garage"
	lock_id = "millenium_delivery"
	lockpick_difficulty = 12

/obj/structure/delivery_board/mt_office
	name = "Millenium Tower delivery assigment board"
	delivery_employer_tag = "millenium_delivery"
	desc = "It did not take long after OOPS showed up in the city that some industrious Ventrue decided to copy and adapt their model for the Tower’s use. Millenium Logistics as the shell company is called, does the same services as OOPS does, with the exception that the company sources and delivers to kindred owned interests in the city. Or so you are told, anyway. Deliveries taken from this board are more likely to directly benefit the Camarilla."

/area/vtm/interior/delivery_garage/mt_office
	name = "Millenium Tower delivery office - Garage"
	delivery_employer_tag = "millenium_delivery"

/obj/effect/landmark/delivery_truck_beacon/mt_office
	spawn_dir = NORTH
	delivery_employer_tag = "millenium_delivery"

//Anarchs

/obj/structure/vampdoor/glass/bar_office
	name = "Bar delivery garage"
	lock_id = "bar_delivery"
	lockpick_difficulty = 12

/obj/structure/delivery_board/bar_office
	name = "Bar delivery assigment board"
	delivery_employer_tag = "bar_delivery"
	desc = "The Anarch response to Camarilla logistics is likewise based on the OOPS model and seems to exist more to encroach on the Camarillas influence than as a tool Anarchs use for themselves. Essentially, as long the Camarilla benefits from this business, Anarchs want to do it better. Or so they say, anyway. Deliveries from this board will benefit the Anarchs."

/area/vtm/interior/delivery_garage/bar_office
	name = "Bar delivery office - Garage"
	delivery_employer_tag = "bar_delivery"

/obj/effect/landmark/delivery_truck_beacon/bar_office
	spawn_dir = SOUTH
	delivery_employer_tag = "bar_delivery"
