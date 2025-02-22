/obj/item/food/fish
	desc = "Marine life."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	eatsound = 'code/modules/wod13/sounds/eat.ogg'
	tastes = list("fish" = 1)
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 3)
	foodtypes = RAW | MEAT

/obj/item/food/fish/shark
	name = "leopard shark"
	icon_state = "fish1"
	cost = 400

/obj/item/food/fish/tune
	name = "tune"
	icon_state = "fish2"
	cost = 125

/obj/item/food/fish/catfish
	name = "catfish"
	icon_state = "fish3"
	cost = 50

/obj/item/food/fish/crab
	name = "crab"
	icon_state = "fish4"
	cost = 200

/obj/item/fishing_rod
	name = "fishing rod"
	icon_state = "fishing"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_BULKY
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	var/catching = FALSE

/obj/item/fishing_rod/attack_self(mob/user)
	. = ..()
	if(isturf(user.loc))
		forceMove(user.loc)
		onflooricon = 'code/modules/wod13/64x64.dmi'
		icon = 'code/modules/wod13/64x64.dmi'
		dir = user.dir
		anchored = TRUE

/obj/item/fishing_rod/MouseDrop(atom/over_object)
	. = ..()
	if(isturf(loc))
		if(istype(over_object, /mob/living))
			if(get_dist(src, over_object) < 2)
				if(anchored)
					anchored = FALSE
					onflooricon = initial(onflooricon)
					icon = onflooricon

/obj/item/fishing_rod/attack_hand(mob/living/user)
	if(anchored)
		if(!istype(get_step(src, dir), /turf/open/floor/plating/vampocean))
			return
		if(user.isfishing)
			return
		if(!catching)
			catching = TRUE
			user.isfishing = TRUE
			playsound(loc, 'code/modules/wod13/sounds/catching.ogg', 50, FALSE)
			if(do_mob(user, src, 15 SECONDS))
				catching = FALSE
				user.isfishing = FALSE
				var/diceroll = rand(1, 20)
				var/IT
				if(diceroll <= 5)
					IT = /obj/item/food/fish/tune
				else if(diceroll <= 10)
					IT = /obj/item/food/fish/catfish
				else if(diceroll <= 15)
					IT = /obj/item/food/fish/crab
				else
					IT = /obj/item/food/fish/shark
				new IT(user.loc)
				playsound(loc, 'code/modules/wod13/sounds/catched.ogg', 50, FALSE)
//					var/IT = pick(/obj/item/food/fish/shark,
//									/obj/item/food/fish/tune,
//									/obj/item/food/fish/catfish,
//									/obj/item/food/fish/crab)
//				var/i = rand(1, 1000)
//				if(i == 1000)
//					IT = /obj/item/vtm_artifact/rand

//					if(user.key)
//						var/datum/preferences/P = GLOB.preferences_datums[ckey(user.key)]
//						if(P)
//							P.exper = min(calculate_mob_max_exper(user), P.exper+10)
			else
				catching = FALSE
				user.isfishing = FALSE
		return
	..()
