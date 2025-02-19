/obj/item/vamp/keys
	name = "\improper keys"
	desc = "Those can open some doors."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "keys"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/list/accesslocks = list(
		"nothing"
	)
	var/roundstart_fix = FALSE

//===========================VAMPIRE KEYS===========================
/obj/item/vamp/keys/camarilla
	name = "Camarilla keys"
	accesslocks = list("camarilla")
	color = "#bd3327"

/obj/item/vamp/keys/prince
	name = "Prince's keys"
	accesslocks = list(
		"camarilla",
		"prince",
		"clerk",
		"archive",
		"milleniumCommon",
		"primogen"
	)
	color = "#bd3327"


/obj/item/vamp/keys/sheriff
	name = "Sheriff's keys"
	accesslocks = list(
		"camarilla",
		"prince",
		"archive",
		"milleniumCommon",
		"primogen",
		"clerk"
	)
	color = "#bd3327"

/obj/item/vamp/keys/clerk
	name = "Clerk's keys"
	accesslocks = list(
		"camarilla",
		"clerk",
		"archive",
		"milleniumCommon",
		"primogen"
	)
	color = "#bd3327"

/obj/item/vamp/keys/camarilla
	name = "Millenium Tower keys"
	accesslocks = list(
		"milleniumCommon",
		"clerk",
		"camarilla"
	)

/obj/item/vamp/keys/archive
	name = "Archive keys"
	accesslocks = list(
		"archive"
	)

/obj/item/vamp/keys/regent
	name = "Very archival keys"
	accesslocks = list(
		"archive",
		"milleniumCommon",
		"primogen",
		"camarilla"
	)

/obj/item/vamp/keys/anarch
	name = "Anarch keys"
	accesslocks = list(
		"anarch"
	)
	color = "#434343"

/obj/item/vamp/keys/bar
	name = "Barkeeper keys"
	accesslocks = list(
		"bar",
		"anarch",
	)
	color = "#434343"

/obj/item/vamp/keys/giovanni
	name = "Mafia keys"
	accesslocks = list(
		"giovanni",
		"bianchiBank"
	)

/obj/item/vamp/keys/capo
	name = "Capo keys"
	accesslocks = list(
		"bankboss",
		"bianchiBank",
		"giovanni"
	)


/obj/item/vamp/keys/baali
	name = "Satanic keys"
	accesslocks = list(
		"baali"
	)

/obj/item/vamp/keys/daughters
	name = "Eclectic keys"
	accesslocks = list(
		"daughters"
	)

/obj/item/vamp/keys/salubri
	name = "Conspiracy keys"
	accesslocks = list(
		"salubri"
	)

/obj/item/vamp/keys/old_clan_tzimisce
	name = "Regal keys"
	accesslocks = list(
		"old_clan_tzimisce"
	)

/obj/item/vamp/keys/malkav
	name = "Insane keys"
	accesslocks = list(
		"malkav"
	)
	color = "#8cc4ff"

/obj/item/vamp/keys/malkav/primogen
	name = "Really insane keys"
	accesslocks = list(
		"primMalkav",
		"malkav",
		"primogen",
		"milleniumCommon",
		"camarilla"
	)
	color = "#2c92ff"

/obj/item/vamp/keys/toreador
	name = "Sexy keys"
	accesslocks = list(
		"toreador",
		"toreador1",
		"toreador2",
		"toreador3",
		"toreador4"
	)
	color = "#ffa7e6"

/obj/item/vamp/keys/banuhaqim
	name = "Just keys"
	accesslocks = list(
		"banuhaqim"
	)
	color = "#06053d"

/obj/item/vamp/keys/toreador/primogen
	name = "Really sexy keys"
	accesslocks = list(
		"primToreador",
		"toreador",
		"primogen",
		"milleniumCommon",
		"camarilla"
	)
	color = "#ff2fc4"

/obj/item/vamp/keys/nosferatu
	name = "Ugly keys"
	accesslocks = list(
		"nosferatu"
	)
	color = "#93bc8e"

/obj/item/vamp/keys/nosferatu/primogen
	name = "Really ugly keys"
	accesslocks = list(
		"primNosferatu",
		"nosferatu",
		"primogen",
		"milleniumCommon",
		"camarilla"
	)
	color = "#367c31"

/obj/item/vamp/keys/brujah
	name = "Punk keys"
	accesslocks = list(
		"brujah"
	)
	color = "#ecb586"

/obj/item/vamp/keys/brujah/primogen
	name = "Really punk keys"
	accesslocks = list(
		"primBrujah",
		"brujah",
		"primogen",
		"milleniumCommon",
		"camarilla"
	)
	color = "#ec8f3e"

/obj/item/vamp/keys/ventrue
	name = "Businessy keys"
	accesslocks = list(
		"ventrue",
		"milleniumCommon"
	)
	color = "#f6ffa7"

/obj/item/vamp/keys/ventrue/primogen
	name = "Really businessy keys"
	accesslocks = list(
		"primVentrue",
		"ventrue",
		"milleniumCommon",
		"primogen",
		"camarilla"
	)
	color = "#e8ff29"

//===========================CLINIC KEYS===========================
/obj/item/vamp/keys/clinic
	name = "Clinic keys"
	accesslocks = list(
		"clinic"
	)

/obj/item/vamp/keys/clinics_director
	name = "Clinic director keys"
	accesslocks = list(
		"clinic",
		"director"
	)

//===========================POLICE KEYS===========================
/obj/item/vamp/keys/police
	name = "Police keys"
	accesslocks = list(
		"police"
	)

/obj/item/vamp/keys/dispatch
	name = "Dispatcher keys"
	accesslocks = list(
		"dispatch"
	)

/obj/item/vamp/keys/police/secure
	name = "Sergeant Police keys"
	accesslocks = list(
		"police",
		"police_secure"
	)

/obj/item/vamp/keys/police/secure/chief
	name = "Chief of Police keys"
	accesslocks = list(
		"dispatch",
		"police",
		"police_secure",
		"police_chief"
	)

//===========================MISC KEYS===========================

/obj/item/vamp/keys/triads
	name = "Rusty keys"
	accesslocks = list(
		"triad",
		"laundromat"
	)

/obj/item/vamp/keys/techstore
	name = "Tech Store keys"
	accesslocks = list(
		"wolftech"
	)
	color = "#466a72"

/obj/item/vamp/keys/pentex
	name = "Facility keys"
	accesslocks = list(
		"pentex"
	)
	color = "#062e03"

/obj/item/vamp/keys/graveyard
	name = "Graveyard keys"
	accesslocks = list(
		"graveyard"
	)

/obj/item/vamp/keys/cleaning
	name = "Cleaning keys"
	accesslocks = list(
		"cleaning"
	)

/obj/item/vamp/keys/church
	name = "Church keys"
	accesslocks = list(
		"church"
	)

/obj/item/vamp/keys/supply
	name = "Supply keys"
	accesslocks = list(
		"supply"
	)
	color = "#434343"

/obj/item/vamp/keys/strip
	name = "Strip keys"
	accesslocks = list(
		"strip"
	)

/obj/item/vamp/keys/taxi
	name = "Taxi keys"
	accesslocks = list(
		"taxi"
	)
	color = "#fffb8b"
