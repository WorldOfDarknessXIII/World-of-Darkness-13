// OOPS office defines

/obj/structure/vampdoor/glass/oops_office
	name = "OOPS delivery office"
	lock_id = "oops"
	lockpick_difficulty = 12

/obj/structure/delivery_board/oops_office
	name = "OOPS delivery assigment board"
	delivery_employer_tag = "oops"
	desc = "The OOPS Delivery Service is said to be ran by the same forces that established and maintain the San Francisco nightly delivery market and the ones ultimately setting and surprisingly, diligently following their own rules per securing the surplus of each night's crate 'trade'. Contracts taken from this board will aid the OOPS service in maintaining the market for everyone involved, however this will also have the side effect of filling the coffers of the powers running the company for their unknown ends."

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
	desc = "The Millenium Tower Delivery Service was established once the Ventrue caught on and adopted the OOPS model for themselves and serves as a Camarilla-backed member of the delivery market. Camarilla related deliveries focus more on private matters of the cities Kindred and working for this Service will help the Camarilla secure the nightly market surplus for their own means."
	crate_types = list(
		"red" = list(
			"cargo_name" = "Industrial-Grade Cleaning Supplies",
			"color" = "#7c1313",
			"desc" = "Extremely strong cleaning supplies or base chemicals to manufacture them, in high quantities. One could easily sterilize entire rooms with the contents of these crates. Strong septic smell.",
			),
		"blue" = list(
			"cargo_name" = "Books and Correspondence",
			"color" = "#202bca",
			"desc" = "Sets of heavy tomes sealed in special containers preventing damage along with modern paperbacks and archived letters both hand and machine written.",
			),
		"yellow" = list(
			"cargo_name" = "Art Pieces",
			"color" = "#b8ac3f",
			"desc" = "Paintings, Sculptures, Pottery, Artifacts and anything else in between, sealed for safety and sometimes meant for assembly post-delivery. Also any tools required for such assembly.",
			),
		"green" = list(
			"cargo_name" = "Personal Items",
			"color" = "#165f29",
			"desc" = "Private correspondence and deliveries marked as private. It could be cargo belonging to other crates but earmarked for private delivery due to private reselling or personal use. Typically, just mail but shipped in bulk. ",
			),
		)

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
	desc = "The Bar Delivery Service is the Anarch-backed entry onto the deliver market and while initially mostly established to get on the local Camarilla representations nerves, has since grown to its own fully fledged member of the market and serves to provide much needed funds to Anarch aligned partners outside of the city."
	crate_types = list(
		"red" = list(
			"cargo_name" = "Homemade Party Favors",
			"color" = "#7c1313",
			"desc" = "The products of underground fermentation and cultivation, separated into containers appropriate for their form, fully cleared and legal for transport.",
			),
		"blue" = list(
			"cargo_name" = "Teaching Aides",
			"color" = "#202bca",
			"desc" = "Sharp or blunt tools used to discipline the unruly and reward the smart. All in their original, legal wrappings and clear for transport.",
			),
		"yellow" = list(
			"cargo_name" = "Care Package",
			"color" = "#b8ac3f",
			"desc" = "Supplies - mostly hermetically sealed food rations, assorted medical supplies as well as clothes and other basics.",
			),
		"green" = list(
			"cargo_name" = "Personal Items",
			"color" = "#165f29",
			"desc" = "Private correspondence and deliveries marked as private. It could be cargo belonging to other crates but earmarked for private delivery due to private reselling or personal use. Typically, just mail but shipped in bulk. ",
			),
		)

/area/vtm/interior/delivery_garage/bar_office
	name = "Bar delivery office - Garage"
	delivery_employer_tag = "bar_delivery"

/obj/effect/landmark/delivery_truck_beacon/bar_office
	spawn_dir = SOUTH
	delivery_employer_tag = "bar_delivery"
