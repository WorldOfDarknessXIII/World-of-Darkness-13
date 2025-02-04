#define LOCKDIFFICULTY_1 2
#define LOCKTIMER_1 17
#define LOCKDIFFICULTY_2 4
#define LOCKTIMER_2 20
#define LOCKDIFFICULTY_3 6
#define LOCKTIMER_3 22
#define LOCKDIFFICULTY_4 8
#define LOCKTIMER_4 24
#define LOCKDIFFICULTY_5 10
#define LOCKTIMER_5 26
#define LOCKDIFFICULTY_6 11 //originally should have been 10, but that wouldn't work unless locktimer is explicitly declared beforehand, which it won't be
#define LOCKTIMER_6 28
#define LOCKDIFFICULTY_7 12
#define LOCKTIMER_7 30

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
		"milleniumCommon"
	)
	color = "#bd3327"

/obj/item/vamp/keys/sheriff
	name = "Sheriff's keys"
	accesslocks = list(
		"camarilla",
		"prince",
		"archive",
		"milleniumCommon"
	)
	color = "#bd3327"

/obj/item/vamp/keys/clerk
	name = "Clerk's keys"
	accesslocks = list(
		"camarilla",
		"clerk",
		"archive",
		"milleniumCommon"
	)
	color = "#bd3327"

/obj/item/vamp/keys/camarilla
	name = "Millenium Tower keys"
	accesslocks = list(
		"milleniumCommon",
		"clerk",
		"camarilla"
	)

/obj/item/vamp/keys/graveyard
	name = "Graveyard keys"
	accesslocks = list(
		"graveyard"
	)

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

/obj/item/vamp/keys/archive
	name = "Archive keys"
	accesslocks = list(
		"archive"
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

/obj/item/vamp/keys/supply
	name = "Supply keys"
	accesslocks = list(
		"supply"
	)
	color = "#434343"

/obj/item/vamp/keys/npc
	name = "Some keys"
	accesslocks = list(
		"npc"
	)

/obj/item/vamp/keys/npc/Initialize()
	. = ..()
	accesslocks = list(
		"npc[rand(1, 20)]"
	)

/obj/item/vamp/keys/npc/fix
	roundstart_fix = TRUE

/obj/item/vamp/keys/police
	name = "Police keys"
	accesslocks = list(
		"police"
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
		"police",
		"police_secure",
		"police_chief"
	)


/obj/item/vamp/keys/strip
	name = "Strip keys"
	accesslocks = list(
		"strip"
	)

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

/obj/item/vamp/keys/taxi
	name = "Taxi keys"
	accesslocks = list(
		"taxi"
	)
	color = "#fffb8b"

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
		"malkav"
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
		"toreador"
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
		"nosferatu"
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
		"brujah"
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
		"milleniumCommon"
	)
	color = "#e8ff29"

/obj/item/vamp/keys/triads
	name = "Rusty keys"
	accesslocks = list(
		"triad",
		"laundromat"
	)

/obj/item/vamp/keys/hack
	name = "\improper lockpick"
	desc = "These can open some doors. Illegally..."
	icon_state = "hack"

/obj/structure/vampdoor
	name = "\improper door"
	desc = "It opens and closes."
	icon = 'code/modules/wod13/doors.dmi'
	icon_state = "door-1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	pixel_w = -16
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

	var/baseicon = "door"

	var/closed = TRUE
	var/locked = FALSE
	var/lock_id = "nothing"
	var/glass = FALSE
	var/hacking = FALSE
	var/lockpick_timer = 17 //[Lucifernix] - Never have the lockpick timer lower than 7. At 7 it will unlock instantly!!
	var/lockpick_difficulty = 2

	var/open_sound = 'code/modules/wod13/sounds/door_open.ogg'
	var/close_sound = 'code/modules/wod13/sounds/door_close.ogg'
	var/lock_sound = 'code/modules/wod13/sounds/door_locked.ogg'
	var/burnable = FALSE

/obj/structure/vampdoor/New()
	..()
	switch(lockpick_difficulty) //This is fine because any overlap gets intercepted before
		if(LOCKDIFFICULTY_7 to INFINITY)
			lockpick_timer = LOCKTIMER_7
		if(LOCKDIFFICULTY_6 to LOCKDIFFICULTY_7)
			lockpick_timer = LOCKTIMER_6
		if(LOCKDIFFICULTY_5 to LOCKDIFFICULTY_6)
			lockpick_timer = LOCKTIMER_5
		if(LOCKDIFFICULTY_4 to LOCKDIFFICULTY_5)
			lockpick_timer = LOCKTIMER_4
		if(LOCKDIFFICULTY_3 to LOCKDIFFICULTY_4)
			lockpick_timer = LOCKTIMER_3
		if(LOCKDIFFICULTY_2 to LOCKDIFFICULTY_3)
			lockpick_timer = LOCKTIMER_2
		if(-INFINITY to LOCKDIFFICULTY_2) //LOCKDIFFICULTY_1 is basically the minimum so we can just do LOCKTIMER_1 from -INFINITY
			lockpick_timer = LOCKTIMER_1

/obj/structure/vampdoor/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.is_holding_item_of_type(/obj/item/vamp/keys/hack))
		return
	var/message //So the code isn't flooded with . +=, it's just a visual thing
	var/difference = (H.lockpicking * 2 + H.dexterity) - lockpick_difficulty //Lower number = higher difficulty
	switch(difference) //Because rand(1,20) always adds a minimum of 1 we take that into consideration for our theoretical roll ranges, which really makes it a random range of 19.
		if(-INFINITY to -11) //Roll can never go above 10 (-11 + 20 = 9), impossible to lockpick.
			message = "<span class='warning'>You don't have any chance of lockpicking this with your current skills!</span>"
		if(-10 to -7)
			message = "<span class='warning'>This door looks extremely complicated. You figure you will have to be lucky to break it open."
		if(-6 to -3)
			message = "<span class='notice'>This door looks very complicated. You might need a few tries to lockpick it."
		if(-2 to 0) //Only 3 numbers here instead of 4.
			message = "<span class='notice'>This door looks mildly complicated. It shouldn't be too hard to lockpick it.</span>"
		if(1 to 4) //Impossible to break the lockpick from here on because minimum rand(1,20) will always move the value to 2.
			message = "<span class='nicegreen'>This door is somewhat simple. It should be pretty easy for you to lockpick it.</span>"
		if(5 to INFINITY) //Becomes guaranteed to lockpick at 9.
			message = "<span class='nicegreen'>This door is really simple to you. It should be very easy to lockpick it.</span>"
	. += "[message]"
	if(H.lockpicking >= 5) //The difference between a 1/19 and a 4/19 is about 4x. An expert in lockpicks is more discerning.
		//Converting the difference into a number that can be divided by the max value of the rand() used in lockpicking calculations.
		var/max_rand_value = 20
		var/minimum_lockpickable_difference = -10 //Minimum value, any lower and lockpicking will always fail.
		//Add those together then reduce by 1
		var/number_difference = max_rand_value + minimum_lockpickable_difference - 1
		//max_rand_value and number_difference will output 11 currently.
		var/value = difference + max_rand_value - number_difference
		//I'm sure there has to be a better method for this because it's ugly, but it works.
		//Putting a condition here to avoid dividing 0.
		var/odds = value ? clamp((value/max_rand_value), 0, 1) : 0
		. += "<span class='notice'>As an expert in lockpicking, you estimate that you have a [round(odds*100, 1)]% chance to lockpick this door successfully.</span>"

/obj/structure/vampdoor/attack_hand(mob/user)
	. = ..()
	var/mob/living/N = user
	if(locked)
		if(N.a_intent != INTENT_HARM)
			playsound(src, lock_sound, 75, TRUE)
			to_chat(user, "<span class='warning'>[src] is locked!</span>")
		else
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.potential > 0)
					if((H.potential * 2) >= lockpick_difficulty)
						playsound(get_turf(src), 'code/modules/wod13/sounds/get_bent.ogg', 100, FALSE)
						var/obj/item/shield/door/D = new(get_turf(src))
						D.icon_state = baseicon
						var/atom/throw_target = get_edge_target_turf(src, user.dir)
						D.throw_at(throw_target, rand(2, 4), 4, user)
						qdel(src)
					else
						pixel_z = pixel_z+rand(-1, 1)
						pixel_w = pixel_w+rand(-1, 1)
						playsound(get_turf(src), 'code/modules/wod13/sounds/get_bent.ogg', 50, TRUE)
						to_chat(user, "<span class='warning'>[src] is locked, and you aren't strong enough to break it down!</span>")
						spawn(2)
							pixel_z = initial(pixel_z)
							pixel_w = initial(pixel_w)
				else
					pixel_z = pixel_z+rand(-1, 1)
					pixel_w = pixel_w+rand(-1, 1)
					playsound(src, 'code/modules/wod13/sounds/knock.ogg', 75, TRUE)
					to_chat(user, "<span class='warning'>[src] is locked!</span>")
					spawn(2)
						pixel_z = initial(pixel_z)
						pixel_w = initial(pixel_w)
		return

	if(closed)
		playsound(src, open_sound, 75, TRUE)
		icon_state = "[baseicon]-0"
		density = FALSE
		opacity = FALSE
		layer = OPEN_DOOR_LAYER
		to_chat(user, "<span class='notice'>You open [src].</span>")
		closed = FALSE
	else
		for(var/mob/living/L in src.loc)
			if(L)
				playsound(src, lock_sound, 75, TRUE)
				to_chat(user, "<span class='warning'>[L] is preventing you from closing [src].</span>")
				return
		playsound(src, close_sound, 75, TRUE)
		icon_state = "[baseicon]-1"
		density = TRUE
		if(!glass)
			opacity = TRUE
		layer = ABOVE_ALL_MOB_LAYER
		to_chat(user, "<span class='notice'>You close [src].</span>")
		closed = TRUE

/obj/structure/vampdoor/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/vamp/keys/hack))
		if(locked)
			hacking = TRUE
			playsound(src, 'code/modules/wod13/sounds/hack.ogg', 100, TRUE)
			for(var/mob/living/carbon/human/npc/police/P in oviewers(7, src))
				if(P)
					P.Aggro(user)
			var/total_lockpicking = user.get_total_lockpicking()
			if(do_mob(user, src, (lockpick_timer - total_lockpicking * 2) SECONDS))
				var/roll = rand(1, 20) + (total_lockpicking * 2 + user.get_total_dexterity()) - lockpick_difficulty
				if(roll <=1)
					to_chat(user, "<span class='warning'>Your lockpick broke!</span>")
					qdel(W)
					hacking = FALSE
				if(roll >=10)
					to_chat(user, "<span class='notice'>You pick the lock.</span>")
					locked = FALSE
					hacking = FALSE
					return

				else
					to_chat(user, "<span class='warning'>You failed to pick the lock.</span>")
					hacking = FALSE
					return
			else
				to_chat(user, "<span class='warning'>You failed to pick the lock.</span>")
				hacking = FALSE
				return
		else
			if (closed) //yes, this is a thing you can extremely easily do in real life
				to_chat(user, "<span class='notice'>You re-lock the door with your lockpick.</span>")
				locked = TRUE
				playsound(src, 'code/modules/wod13/sounds/hack.ogg', 100, TRUE)
				return
	else if(istype(W, /obj/item/vamp/keys))
		var/obj/item/vamp/keys/KEY = W
		if(KEY.roundstart_fix)
			lock_id = pick(KEY.accesslocks)
			KEY.roundstart_fix = FALSE
		if(KEY.accesslocks)
			for(var/i in KEY.accesslocks)
				if(i == lock_id)
					if(!locked)
						playsound(src, lock_sound, 75, TRUE)
						to_chat(user, "[src] is now locked.")
						locked = TRUE
					else
						playsound(src, lock_sound, 75, TRUE)
						to_chat(user, "[src] is now unlocked.")
						locked = FALSE


/obj/structure/vampdoor/old
	icon_state = "old-1"
	baseicon = "old"

/obj/structure/vampdoor/simple
	icon_state = "cam-1"
	baseicon = "cam"

/obj/structure/vampdoor/reinf
	icon_state = "reinf-1"
	baseicon = "reinf"

/obj/structure/vampdoor/prison
	icon_state = "prison-1"
	opacity = FALSE
	baseicon = "prison"
	glass = TRUE
	lockpick_difficulty = 12

/obj/structure/vampdoor/wood
	icon_state = "wood-1"
	baseicon = "wood"
	burnable = TRUE

/obj/structure/vampdoor/wood/strip
	lock_id = "strip"
	lockpick_difficulty = 8

/obj/structure/vampdoor/wood/old
	icon_state = "oldwood-1"
	baseicon = "oldwood"

/obj/structure/vampdoor/glass
	icon_state = "glass-1"
	opacity = FALSE
	baseicon = "glass"
	glass = TRUE
	burnable = TRUE

/obj/structure/vampdoor/shop
	icon_state = "shop-1"
	opacity = FALSE
	baseicon = "shop"
	glass = TRUE
	lockpick_difficulty = 10

/obj/structure/vampdoor/camarilla
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "camarilla"
	lockpick_difficulty = 8

/obj/structure/vampdoor/clerk
	icon_state = "shop-1"
	opacity = FALSE
	baseicon = "shop"
	glass = TRUE
	locked = TRUE
	lock_id = "clerk"
	lockpick_difficulty = 10

/obj/structure/vampdoor/prince
	icon_state = "glass-1"
	opacity = FALSE
	baseicon = "glass"
	glass = TRUE
	locked = TRUE
	lock_id = "prince"
	burnable = TRUE
	lockpick_difficulty = 10

/obj/structure/vampdoor/daughters
	icon_state = "wood-1"
	baseicon = "wood"
	locked = TRUE
	lock_id = "daughters"
	burnable = TRUE
	lockpick_difficulty = 10

/obj/structure/vampdoor/graveyard
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "graveyard"
	burnable = TRUE
	lockpick_difficulty = 2

/obj/structure/vampdoor/church
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "church"
	burnable = TRUE
	lockpick_difficulty = 10

/obj/structure/vampdoor/clinic
	icon_state = "shop-1"
	opacity = FALSE
	baseicon = "shop"
	glass = TRUE
	locked = TRUE
	lock_id = "clinic"
	lockpick_difficulty = 4

/obj/structure/vampdoor/cleaning
	icon_state = "reinf-1"
	baseicon = "reinf"
	locked = TRUE
	lock_id = "cleaning"
	lockpick_difficulty = 4

/obj/structure/vampdoor/archive
	icon_state = "old-1"
	baseicon = "old"
	locked = TRUE
	lock_id = "archive"
	lockpick_difficulty = 10

/obj/structure/vampdoor/anarch
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "anarch"
	lockpick_difficulty = 10

/obj/structure/vampdoor/bar
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "bar"
	lockpick_difficulty = 10

/obj/structure/vampdoor/supply
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "supply"
	lockpick_difficulty = 8

/obj/structure/vampdoor/npc
	icon_state = "wood-1"
	baseicon = "wood"
	locked = TRUE
	lock_id = "npc"
	burnable = TRUE
	lockpick_difficulty = 4

/obj/structure/vampdoor/police
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "police"
	lockpick_difficulty = 6

/obj/structure/vampdoor/police/secure
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "police_secure"
	lockpick_difficulty = 21

/obj/structure/vampdoor/police/chief
	icon_state = "shop-1"
	opacity = FALSE
	locked = TRUE
	baseicon = "shop"
	glass = TRUE
	lock_id = "police_chief"
	lockpick_difficulty = 21

/obj/structure/vampdoor/prison
	icon_state = "prison-1"
	baseicon = "prison"
	locked = TRUE
	glass = TRUE
	lock_id = "police"
	lockpick_difficulty = 6

/obj/structure/vampdoor/strip
	icon_state = "cam-1"
	baseicon = "cam"
	locked = TRUE
	lock_id = "strip"
	lockpick_difficulty = 4

/obj/structure/vampdoor/giovanni
	icon_state = "wood-1"
	baseicon = "wood"
	locked = TRUE
	lock_id = "giovanni"
	burnable = TRUE
	lockpick_difficulty = 8

/obj/structure/vampdoor/baali
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "baali"
	burnable = FALSE
	lockpick_difficulty = 8

/obj/structure/vampdoor/salubri
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "salubri"
	burnable = FALSE
	lockpick_difficulty = 8

/obj/structure/vampdoor/old_clan_tzimisce
	icon_state = "oldwood-1"
	baseicon = "oldwood"
	locked = TRUE
	lock_id = "old_clan_tzimisce"
	burnable = FALSE
	lockpick_difficulty = 8

/obj/structure/vampdoor/npc/Initialize()
	. = ..()
	lock_id = "npc[rand(1, 20)]"
