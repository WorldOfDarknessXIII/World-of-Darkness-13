/area
	var/fire_controled = FALSE
	var/fire_controling = FALSE

/area/vtm
	name = "San Francisco"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sewer"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	var/music
	var/upper = TRUE
	var/zone_type = "masquerade"
	var/zone_owner

/area/vtm/powered(chan)
	if(!requires_power)
		return TRUE
	return FALSE

/area/vtm/proc/break_elysium()
	if(zone_type == "masquerade")
		zone_type = "battle"
		spawn(1800)
			zone_type = "masquerade"

/area/vtm/interior
	name = "Interior"
	icon_state = "interior"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE

/area/vtm/interior/shop
	name = "Shop"
	icon_state = "shop"
	upper = FALSE
	fire_controled = TRUE

/area/vtm/interior/laundromat
	name = "Laundromat"
	icon_state = "shop"
	upper = FALSE
	fire_controled = TRUE

/area/vtm/interior/giovanni
	name = "Giovanni Mansion"
	icon_state = "giovanni"
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_GIOVANNI
	fire_controled = TRUE

/area/vtm/interior/techshop
	name = "Nightwolf Techshop"
	icon_state = "shop"
	upper = FALSE
	fire_controled = TRUE

/area/vtm/interior/bianchiBank
	name = "Bianchi Bank"
	icon_state = "giovanni"
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_GIOVANNI
	fire_controled = TRUE

/area/vtm/interior/police
	name = "Police Station"
	icon_state = "police"
	upper = FALSE
	fire_controled = TRUE

/area/vtm/interior/vjanitor
	name = "Cleaners"
	icon_state = "janitor"
	upper = FALSE
	fire_controled = TRUE

/area/vtm/interior/strip
	name = "Strip Club"
	icon_state = "strip"
	upper = FALSE
	fire_controled = TRUE

/area/vtm/interior/mansion
	name = "Abandoned Mansion"
	icon_state = "mansion"
	upper = FALSE
	zone_type = "battle"

/area/vtm/financialdistrict
	name = "Financial District"
	icon_state = "financialdistrict"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/downtown
	upper = TRUE

/area/vtm/ghetto
	name = "Ghetto"
	icon_state = "ghetto"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/downtown
	upper = TRUE

/area/vtm/pacificheights
	name = "Pacific Heights"
	icon_state = "pacificheights"
	ambience_index = AMBIENCE_NATURE
	music = /datum/vampiremusic/hollywood
	upper = TRUE

/area/vtm/chinatown
	name = "Chinatown"
	icon_state = "chinatown"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/chinatown
	upper = TRUE

/area/vtm/fishermanswharf
	name = "Fisherman's Wharf"
	icon_state = "fishermanswharf"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/santamonica
	upper = TRUE

/area/vtm/northbeach
	name = "North Beach"
	icon_state = "northbeach"
	ambience_index = AMBIENCE_BEACH
	music = /datum/vampiremusic/santamonica
	upper = TRUE

/area/vtm/unionsquare
	name = "Union Square"
	icon_state = "unionsquare"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/downtown
	upper = TRUE

/area/vtm/prince_elevator
	name = "Millenium Elevator"
	icon_state = "prince"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_CAMARILLA
	fire_controled = TRUE

/area/vtm/city_elevator
	name = "City Elevator"
	icon_state = "prince"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_CAMARILLA
	fire_controled = TRUE

/area/vtm/prince
	name = "Millenium Tower"
	icon_state = "prince"
	ambience_index = AMBIENCE_PRINCE
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_CAMARILLA
	fire_controled = TRUE

/area/vtm/camarilla
	name = "Millenium Appartements"
	icon_state = "camarilla"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_CAMARILLA
	fire_controled = TRUE

/area/vtm/jazzclub
	name = "Jazz Club"
	icon_state = "camarilla"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_CAMARILLA
	fire_controled = TRUE

/area/vtm/cabaret
	name = "Siren's Cabaret"
	icon_state = "melpominee"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE

/area/vtm/cabinet
	name = "Millenium Upper Level"
	icon_state = "prince"
	ambience_index = AMBIENCE_INTERIOR
	music = /datum/vampiremusic/prince
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_CAMARILLA
	fire_controled = TRUE

/area/vtm/clinic
	name = "Clinic"
	icon_state = "clinic"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE

/area/vtm/supply
	name = "Supply"
	icon_state = "supply"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE

/area/vtm/anarch
	name = "Bar"
	icon_state = "anarch"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	music = /datum/vampiremusic/bar
	zone_type = "elysium"
	zone_owner = FACTION_ANARCHS
	fire_controled = TRUE

/area/vtm/hotel
	name = "Hotel"
	icon_state = "hotel"
//	music = /datum/vampiremusic/bar
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE

/area/vtm/church
	name = "Church"
	icon_state = "church"
	music = /datum/vampiremusic/church
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE

/area/vtm/graveyard
	name = "Graveyard"
	icon_state = "graveyard"
	ambience_index = AMBIENCE_INTERIOR
	music = /datum/vampiremusic/hollywood
	upper = TRUE
	zone_type = "battle"

/area/vtm/graveyard/interior
	name = "Graveyard Interior"
	icon_state = "interior"
	upper = FALSE
	zone_type = "battle"

/area/vtm/park
	name = "Park"
	icon_state = "park"
	ambience_index = AMBIENCE_NATURE
	music = /datum/vampiremusic/downtown
	upper = TRUE

/area/vtm/theatre
	name = "Theatre"
	icon_state = "theatre"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	music = /datum/vampiremusic/theatre
	zone_type = "elysium"
	zone_owner = FACTION_TREMERE
	fire_controled = TRUE

/area/vtm/sewer
	name = "Sewer"
	icon_state = "sewer"
	ambience_index = AMBIENCE_SEWER
	music = /datum/vampiremusic/sewer
	upper = FALSE
	zone_type = "battle"

/area/vtm/sewer/nosferatu_town
	name = "Underground Town"
	icon_state = "hotel"
	upper = FALSE
	music = /datum/vampiremusic/nosferatu
	zone_type = "elysium"
	zone_owner = FACTION_NOSFERATU

/area/vtm/elevator
	name = "Elevator"
	icon_state = "prince"
	music = /datum/vampiremusic/elevator
	upper = FALSE
	zone_type = "elysium"
	zone_owner = FACTION_CAMARILLA
	fire_controled = TRUE

/area/vtm/forest
	name = "Forest"
	icon_state = "park"
	upper = TRUE
	zone_type = "battle"
	music = /datum/vampiremusic/forest

/area/vtm/interior/glasswalker
	name = "Glasswalker's Lab"
	icon_state = "supply"
	upper = FALSE
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	fire_controled = TRUE

/area/vtm/interior/wyrm_corrupted
	name = "Corrupted by Wyrm"
	icon_state = "graveyard"
	upper = FALSE
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	fire_controled = FALSE

/area/vtm/interior/penumbra
	name = "Penumbra"
	icon_state = "church"
	ambience_index = AMBIENCE_NATURE
	upper = FALSE
	zone_type = "battle"
	music = /datum/vampiremusic/penumbra
	fire_controled = FALSE

/area/vtm/interior/backrooms
	name = "Backrooms"
	icon_state = "church"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	zone_type = "battle"
	fire_controled = FALSE

//MUSIC

/datum/vampiremusic
	var/length = 30 SECONDS
	var/sound
	var/forced = FALSE

/datum/vampiremusic/forest
	length = 389 SECONDS
	sound = 'code/modules/wod13/sounds/night_ambience.ogg'

/datum/vampiremusic/penumbra
	length = 336 SECONDS
	sound = 'code/modules/wod13/sounds/penumbra.ogg'

/datum/vampiremusic/santamonica
	length = 304 SECONDS
	sound = 'code/modules/wod13/sounds/santamonica.ogg'

/datum/vampiremusic/downtown
	length = 259 SECONDS
	sound = 'code/modules/wod13/sounds/downtown.ogg'

/datum/vampiremusic/sewer
	length = 134 SECONDS
	sound = 'code/modules/wod13/sounds/enterlair.ogg'
	forced = TRUE

/datum/vampiremusic/hollywood
	length = 337 SECONDS
	sound = 'code/modules/wod13/sounds/hollywood.ogg'

/datum/vampiremusic/chinatown
	length = 369 SECONDS
	sound = 'code/modules/wod13/sounds/chinatown.ogg'

/datum/vampiremusic/prince
	length = 132 SECONDS
	sound = 'code/modules/wod13/sounds/prince.ogg'
	forced = TRUE

/datum/vampiremusic/church
	length = 91 SECONDS
	sound = 'code/modules/wod13/sounds/hahihaho.ogg'
	forced = TRUE

/datum/vampiremusic/bar
	length = 497 SECONDS
	sound = 'code/modules/wod13/sounds/naive.ogg'
	forced = TRUE

/datum/vampiremusic/theatre
	length = 93 SECONDS
	sound = 'code/modules/wod13/sounds/theatre.ogg'
	forced = TRUE

/datum/vampiremusic/nosferatu
	length = 181 SECONDS
	sound = 'code/modules/wod13/sounds/nosferatu.ogg'
	forced = TRUE

/datum/vampiremusic/elevator
	length = 157 SECONDS
	sound = 'code/modules/wod13/sounds/lift.ogg'
	forced = TRUE

/mob/living/proc/handle_vampire_music()
	if(!client)
		return
	if(stat == DEAD)
		return

	var/turf/T

	if(!isturf(loc))
		var/atom/A = loc
		if(!isturf(A.loc))
			return
		T = A.loc
	else
		T = loc

	if(istype(get_area(T), /area/vtm))
		var/area/vtm/VTM = get_area(T)
		if(VTM)
			/*
			if(VTM.upper)
				if(SScityweather.raining)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/rain.ogg', 0, 0, CHANNEL_RAIN, 25))
					wash(CLEAN_WASH)
			*/

			var/cacophony = FALSE

			if(iskindred(src))
				var/mob/living/carbon/human/H = src
				if(H.clane)
					if(H.clane.name == "Daughters of Cacophony")
						cacophony = FALSE //This Variable was TRUE, which makes the DoC music loop play.

			if(!cacophony)
				if(!(client && (client.prefs.toggles & SOUND_AMBIENCE)))
					return

				if(!VTM.music)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					return
				var/datum/vampiremusic/VMPMSC = new VTM.music()
				if(VMPMSC.forced && wait_for_music != VMPMSC.length)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					wasforced = TRUE

				else if(wasforced && wait_for_music != VMPMSC.length)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					wasforced = FALSE

				if(last_vampire_ambience+wait_for_music+10 < world.time)
					wait_for_music = VMPMSC.length
					client << sound(VMPMSC.sound, 0, 0, CHANNEL_LOBBYMUSIC, 10)
					last_vampire_ambience = world.time
				qdel(VMPMSC)
			else
				if(last_vampire_ambience+wait_for_music+10 < world.time)
					wait_for_music = 1740
					client << sound('code/modules/wod13/sounds/daughters.ogg', 0, 0, CHANNEL_LOBBYMUSIC, 5)
					last_vampire_ambience = world.time
