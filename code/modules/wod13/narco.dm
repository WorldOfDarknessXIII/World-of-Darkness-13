/obj/structure/weedshit
	name = "hydroponics"
	desc = "Definitely not for the weed."
	icon = 'code/modules/wod13/weed.dmi'
	icon_state = "soil_dry0"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	var/wet = FALSE
	var/growth_stage = 0
	var/health = 3

/obj/structure/weedshit/buyable
	anchored = FALSE


/obj/structure/weedshit/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to secure the [src] to the ground.</span>"
	if(!wet)
		. += "<span class='warning'>[src] is dry!</span>"
	if(growth_stage == 5)
		. += "<span class='warning'>The crop is dead!</span>"
	else
		if(health <= 2)
			. += "<span class='warning'>The crop is looking unhealthy.</span>"

/obj/item/weedseed
	name = "seed"
	desc = "Green and smelly..."
	icon_state = "seed"
	icon = 'code/modules/wod13/items.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/weedpack
	name = "green package"
	desc = "Green and smelly..."
	icon_state = "package_weed"
	icon = 'code/modules/wod13/items.dmi'
	w_class = WEIGHT_CLASS_SMALL
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	illegal = TRUE
	cost = 150

/datum/crafting_recipe/weed_leaf
	name = "Sort Weed"
	time = 10
	reqs = list(/obj/item/food/vampire/weed = 1)
	result = /obj/item/weedpack
	always_available = TRUE
	category = CAT_DRUGS

/datum/crafting_recipe/weed_blunt
	name = "Roll Blunt"
	time = 10
	reqs = list(/obj/item/weedpack = 1, /obj/item/paper = 1)
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis
	always_available = TRUE
	category = CAT_DRUGS

/obj/item/food/vampire/weed
	name = "leaf"
	desc = "Green and smelly..."
	icon_state = "weed"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	bite_consumption = 5
	tastes = list("cat piss" = 4, "weed" = 2)
	foodtypes = VEGETABLES
	food_reagents = list(/datum/reagent/drug/space_drugs = 20, /datum/reagent/toxin/lipolicide = 20)
	eat_time = 10
	illegal = TRUE
	cost = 50

/obj/item/bailer
	name = "bailer"
	desc = "Best for flora!"
	icon_state = "bailer"
	icon = 'code/modules/wod13/items.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/amount_of_water = 10

/obj/item/bailer/examine(mob/user)
	. = ..()
	if(!amount_of_water)
		. += "<span class='warning'>[src] is empty!</span>"

/obj/structure/weedshit/attack_hand(mob/user, params)
	. = ..()
	if(growth_stage == 5)
		growth_stage = 0
		health = 3
		to_chat(user, "<span class='notice'>You rip the rotten weed out of [src].</span>")
	if(growth_stage == 4)
		growth_stage = 1
		to_chat(user, "<span class='notice'>You pull the grown weed out of [src].</span>")
		var/mob/living/carbon/human/H = user
		var/amount
		switch(storyteller_roll(H.get_total_mentality(), 6, TRUE))
			if(3 to INFINITY)
				amount = 4
			if(2)
				amount = 3
			if(1)
				amount = 2
			else
				amount = 1
		for(var/i = 1 to amount)
			new /obj/item/food/vampire/weed(get_turf(user))
	update_weed_icon()

/obj/structure/weedshit/AltClick(mob/user)
	if(do_after(user, 15))
		if(anchored)
			to_chat(user, "<span class='notice'>You unsecure the [src] from the ground.</span>")
			anchored = FALSE
			return
		else
			to_chat(user, "<span class='notice'>You secure the [src] to the ground.</span>")
			anchored = TRUE
			return

/obj/structure/weedshit/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/bailer))
		var/obj/item/bailer/B = W
		if(B.amount_of_water)
			B.amount_of_water = max(0, B.amount_of_water-1)
			wet = TRUE
			to_chat(user, "<span class='notice'>You fill [src] with water.</span>")
			playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
			call_dharma("cleangrow", user)
		else
			to_chat(user, "<span class='warning'>[W] is empty!</span>")
	if(istype(W, /obj/item/weedseed))
		if(growth_stage == 0)
			health = 3
			growth_stage = 1
			qdel(W)
	update_weed_icon()
	return

/obj/structure/weedshit/Initialize()
	. = ..()
	GLOB.weed_list += src

/obj/structure/weedshit/Destroy()
	. = ..()
	GLOB.weed_list -= src

/obj/structure/weedshit/proc/update_weed_icon()
	icon_state = "soil[wet ? "" : "_dry"][growth_stage]"

SUBSYSTEM_DEF(smokeweedeveryday)
	name = "Smoke Weed Every Day"
	init_order = INIT_ORDER_DEFAULT
	wait = 1800
	priority = FIRE_PRIORITY_VERYLOW

/datum/controller/subsystem/smokeweedeveryday/fire()
	for(var/obj/structure/weedshit/W in GLOB.weed_list)
		if(W)
			if(W.growth_stage != 0 && W.growth_stage != 5)
				if(!W.wet)
					if(W.health)
						W.health = max(0, W.health-1)
					else
						W.growth_stage = 5
				else if(W.health)
					if(prob(33))
						W.wet = FALSE
					W.health = min(3, W.health+1)
					W.growth_stage = min(4, W.growth_stage+1)
			W.update_weed_icon()

/obj/item/bong
	name = "bong"
	desc = "Technically known as a water pipe."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "bulbulator"
	inhand_icon_state = "bulbulator"
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	///The icon state when the bong is lit
	var/icon_on = "bulbulator"
	///The icon state when the bong is not lit
	var/icon_off = "bulbulator"
	///Whether the bong is lit or not
	var/lit = FALSE
	///How many hits can the bong be used for?
	var/max_hits = 4
	///How many uses does the bong have remaining?
	var/bong_hits = 0
	///How likely is it we moan instead of cough?
	var/moan_chance = 0

	///Max units able to be stored inside the bong
	var/chem_volume = 30
	///Is it filled?
	var/packed_item = FALSE

	///How many reagents do we transfer each use?
	var/reagent_transfer_per_use = 0
	///How far does the smoke reach per use?
	var/smoke_range = 2

/obj/item/bong/Initialize(mapload)
	. = ..()
	create_reagents(chem_volume, INJECTABLE | NO_REACT)

/obj/item/bong/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/food/grown))
		var/obj/item/food/grown/grown_item = used_item
		if(packed_item)
			to_chat(user, "<span class='warning'>Already packed!</span>")
			return
		if(!HAS_TRAIT(grown_item, TRAIT_DRIED))
			to_chat(user, "<span class='warning'>Needs to be dried!</span>")
			return
		to_chat(user, "<span class='notice'>You stuff [grown_item] into [src].</span>")
		bong_hits = max_hits
		packed_item = TRUE
		if(grown_item.reagents)
			grown_item.reagents.trans_to(src, grown_item.reagents.total_volume)
			reagent_transfer_per_use = reagents.total_volume / max_hits
		qdel(grown_item)
	else if(istype(used_item, /obj/item/weedpack)) //for hash/dabs
		if(packed_item)
			to_chat(user, "<span class='warning'>Already packed!</span>")
			return
		to_chat(user, "<span class='notice'>You stuff [used_item] into [src].</span>")
		bong_hits = max_hits
		packed_item = TRUE
		var/obj/item/food/grown/cannabis/W = new(loc)
		if(W.reagents)
			W.reagents.trans_to(src, W.reagents.total_volume)
			reagent_transfer_per_use = reagents.total_volume / max_hits
		qdel(W)
		qdel(used_item)
	else
		var/lighting_text = used_item.ignition_effect(src, user)
		if(!lighting_text)
			return ..()
		if(bong_hits <= 0)
			to_chat(user, "<span class='warning'>Nothing to smoke!</span>")
			return ..()
		light(lighting_text)
		name = "lit [initial(name)]"

/obj/item/bong/attack_self(mob/user)
	var/turf/location = get_turf(user)
	if(lit)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>", "<span class='notice'>You put out [src].</span>")
		lit = FALSE
		icon_state = icon_off
		inhand_icon_state = icon_off
	else if(!lit && bong_hits > 0)
		to_chat(user, "<span class='notice'>You empty [src] onto [location].</span>")
		new /obj/effect/decal/cleanable/ash(location)
		packed_item = FALSE
		bong_hits = 0
		reagents.clear_reagents()
	return

/obj/item/bong/attack(mob/hit_mob, mob/user, def_zone)
	if(!packed_item || !lit)
		return
	hit_mob.visible_message("<span class='notice'>[user] starts [hit_mob == user ? "taking a hit from [src]." : "forcing [hit_mob] to take a hit from [src]!"]", "[hit_mob == user ? "<span class='notice'>You start taking a hit from [src].</span>" : "<span class='danger'>[user] starts forcing you to take a hit from [src]!</span>"]")
	playsound(src, 'code/modules/wod13/sounds/heatdam.ogg', 50, TRUE)
	if(!do_after(user, 40, src))
		return
	to_chat(hit_mob, "<span class='notice'>You finish taking a hit from the [src].</span>")
	if(reagents.total_volume)
		reagents.trans_to(hit_mob, reagent_transfer_per_use, methods = VAPOR)
		bong_hits--
	var/turf/open/pos = get_turf(src)
	if(istype(pos))
		for(var/i in 1 to smoke_range)
			spawn_cloud(pos, smoke_range)
	if(moan_chance > 0)
		if(prob(moan_chance))
			playsound(hit_mob, pick('code/modules/wod13/sounds/lungbust_moan1.ogg','code/modules/wod13/sounds/lungbust_moan2.ogg', 'code/modules/wod13/sounds/lungbust_moan3.ogg'), 50, TRUE)
			hit_mob.emote("moan")
		else
			playsound(hit_mob, pick('code/modules/wod13/sounds/lungbust_cough1.ogg','code/modules/wod13/sounds/lungbust_cough2.ogg'), 50, TRUE)
			hit_mob.emote("cough")
	if(bong_hits <= 0)
		to_chat(hit_mob, "<span class='warning'>Out of uses!</span>")
		lit = FALSE
		packed_item = FALSE
		icon_state = icon_off
		inhand_icon_state = icon_off
		name = "[initial(name)]"
		reagents.clear_reagents() //just to make sure

/obj/item/bong/proc/light(flavor_text = null)
	if(lit)
		return
	if(!(flags_1 & INITIALIZED_1))
		icon_state = icon_on
		inhand_icon_state = icon_on
		return
	lit = TRUE
	name = "lit [name]"

	if(reagents.get_reagent_amount(/datum/reagent/toxin/plasma)) // the plasma explodes when exposed to fire
		var/datum/effect_system/reagents_explosion/explosion = new()
		explosion.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/plasma) * 0.4, 1), get_turf(src), 0, 0)
		explosion.start()
		qdel(src)
		return
	if(reagents.get_reagent_amount(/datum/reagent/fuel)) // the fuel explodes, too, but much less violently
		var/datum/effect_system/reagents_explosion/explosion = new()
		explosion.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) * 0.2, 1), get_turf(src), 0, 0)
		explosion.start()
		qdel(src)
		return

	// allowing reagents to react after being lit
	reagents.flags &= ~(NO_REACT)
	reagents.handle_reactions()
	icon_state = icon_on
	inhand_icon_state = icon_on
	if(flavor_text)
		var/turf/bong_turf = get_turf(src)
		bong_turf.visible_message(flavor_text)

/obj/item/bong/proc/spawn_cloud(turf/open/location, smoke_range)
	var/list/turfs_affected = list(location)
	var/list/turfs_to_spread = list(location)
	var/spread_stage = smoke_range
	for(var/i in 1 to smoke_range)
		if(!turfs_to_spread.len)
			break
		var/list/new_spread_list = list()
		for(var/turf/open/turf_to_spread as anything in turfs_to_spread)
			if(isspaceturf(turf_to_spread))
				continue
			var/obj/effect/abstract/fake_steam/fake_steam = locate() in turf_to_spread
			var/at_edge = FALSE
			if(!fake_steam)
				at_edge = TRUE
				fake_steam = new(turf_to_spread)
			fake_steam.stage_up(spread_stage)

			if(!at_edge)
				for(var/turf/open/open_turf as anything in turf_to_spread.atmos_adjacent_turfs)
					if(!(open_turf in turfs_affected))
						new_spread_list += open_turf
						turfs_affected += open_turf

		turfs_to_spread = new_spread_list
		spread_stage--

#define MAX_FAKE_STEAM_STAGES 5
#define STAGE_DOWN_TIME (10 SECONDS)

/// Fake steam effect
/obj/effect/abstract/fake_steam
	layer = FLY_LAYER
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "water_vapor"
	blocks_emissive = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/next_stage_down = 0
	var/current_stage = 0

/obj/effect/abstract/fake_steam/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/abstract/fake_steam/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/abstract/fake_steam/process()
	if(next_stage_down > world.time)
		return
	stage_down()

#define FAKE_STEAM_TARGET_ALPHA 204

/obj/effect/abstract/fake_steam/proc/update_alpha()
	alpha = FAKE_STEAM_TARGET_ALPHA * (current_stage / MAX_FAKE_STEAM_STAGES)

#undef FAKE_STEAM_TARGET_ALPHA

/obj/effect/abstract/fake_steam/proc/stage_down()
	if(!current_stage)
		qdel(src)
		return
	current_stage--
	next_stage_down = world.time + STAGE_DOWN_TIME
	update_alpha()

/obj/effect/abstract/fake_steam/proc/stage_up(max_stage = MAX_FAKE_STEAM_STAGES)
	var/target_max_stage = min(MAX_FAKE_STEAM_STAGES, max_stage)
	current_stage = min(current_stage + 1, target_max_stage)
	next_stage_down = world.time + STAGE_DOWN_TIME
	update_alpha()

#undef MAX_FAKE_STEAM_STAGES

/obj/structure/methlab
	name = "chemical laboratory"
	desc = "\"Jesse... It's not about style, it's about science... I forgor in what order... But you should mix gasoline, 2 potassium iodide pills or mix of full coffee cup and vodka bottle... then add 3-4 ephedrine pills and mix it... May your ass not be blown off...\""
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "methlab"
//	plane = GAME_PLANE
//	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	var/troll_explode = FALSE	//HE FAILED THE ORDER (
	var/added_ephed = 0		//we need to add 3 pills each
	var/added_iod = 0		//gonna be 2 iod pills or coffee+vodka
	var/added_gas = FALSE	//fill it up boi

/obj/structure/methlab/movable
	name = "movable chemical lab"
	desc = "Not an RV, but it moves..."
	anchored = FALSE
	var/health = 20

/obj/structure/methlab/movable/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to secure the [src] to the ground.</span>"

	if(health == 20)
		. += "<span class='notice'>[src] is in good condition.</span>"
	else if(health > 16)
		. += "<span class='notice'>[src] is lightly damaged.</span>"
	else if(health > 10)
		. += "<span class='warning'>[src] has sustained some damage.</span>"
	else if(health > 6)

		. += "<span class='warning'>[src] is close to breaking!</span>"
	else
		. += "<span class='warning'>[src] is about to fall apart!</span>"

/obj/structure/methlab/AltClick(mob/user)
	if(do_after(user, 15))
		if(anchored)
			to_chat(user, "<span class='notice'>You unsecure the [src] from the ground.</span>")
			anchored = FALSE
			return
		else
			to_chat(user, "<span class='notice'>You secure the [src] to the ground.</span>")
			anchored = TRUE
			return

/obj/structure/methlab/movable/attackby(obj/item/used_item, mob/user, params)
	if(..(used_item, user, params))
		if(health <= 0)
			to_chat(user, "<span class='warning'>The [src] is too damaged to use!</span>")
			return
		return TRUE

	if(added_ephed == 3 && added_iod == 2 && added_gas == TRUE)
		playsound(src, 'code/modules/wod13/sounds/methcook.ogg', 50, TRUE)
		spawn(3 SECONDS)
			health -= 1
			if(health <= 16)
				var/probability
				if(health >= 10)
					probability = 5
				else if(health >= 6)
					probability = 10
				else if(health > 0)
					probability = 20
				else
					probability = 100
				if(prob(probability))
					explosion(loc,0,1,3,4)
	return

/obj/structure/methlab/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/reagent_containers/pill/ephedrine))
		if(added_ephed != 3)
			added_ephed = min(3, added_ephed+1)
			to_chat(user, "You [pick("insert", "add", "mix")] [added_ephed] [used_item] in [src].")
			qdel(used_item)
	if(istype(used_item, /obj/item/reagent_containers/pill/potassiodide))
		if(added_iod != 2)
			if(!added_ephed)
				troll_explode = TRUE
			added_iod = min(2, added_iod+1)
			to_chat(user, "You [pick("insert", "add", "mix")] [added_iod] [used_item] in [src].")
			if(prob(20))
				to_chat(user, "Reagents start to react strangely...")
			qdel(used_item)
	if(istype(used_item, /obj/item/reagent_containers/food/drinks/coffee/vampire))
		if(!added_iod)
			added_iod = 1
			to_chat(user, "You [pick("throw", "blow", "spit")] [used_item] in [src].")
			if(prob(20))
				to_chat(user, "Reagents start to react strangely...")
			qdel(used_item)
	if(istype(used_item, /obj/item/reagent_containers/food/drinks/bottle/vodka))
		if(added_iod == 1)
			added_iod = 2
			to_chat(user, "You [pick("throw", "blow", "spit")] [used_item] in [src].")
			if(prob(20))
				to_chat(user, "Reagents start to react strangely...")
			qdel(used_item)
	if(istype(used_item, /obj/item/gas_can))
		var/obj/item/gas_can/G = used_item
		if(G.stored_gasoline && !added_gas)
			if(!added_ephed)
				troll_explode = TRUE
			if(!added_iod)
				troll_explode = TRUE
			G.stored_gasoline = max(0, G.stored_gasoline-100)
			playsound(loc, 'code/modules/wod13/sounds/gas_fill.ogg', 25, TRUE)
			to_chat(user, "You [pick("spill", "add", "blender")] [used_item] in [src].")
			added_gas = TRUE
			if(prob(20))
				to_chat(user, "Something may be going wrong, or may not...")
	if(added_ephed == 3 && added_iod == 2 && added_gas == TRUE)
		playsound(src, 'code/modules/wod13/sounds/methcook.ogg', 50, TRUE)
		spawn(3 SECONDS)
			playsound(src, 'code/modules/wod13/sounds/methcook.ogg', 100, TRUE)
			if(troll_explode)
				explosion(loc,0,1,3,4)
			else
				var/amount = 4
				for(var/i = 1 to amount)
					new /obj/item/reagent_containers/food/drinks/meth(get_turf(src))
				added_ephed = 0
				added_iod = 0
				added_gas = FALSE
				troll_explode = FALSE

/obj/item/reagent_containers/food/drinks/meth
	name = "blue package"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "package_meth"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/drug/methamphetamine = 30)
	spillable = FALSE
	resistance_flags = FREEZE_PROOF
	isGlass = FALSE
	foodtype = BREAKFAST
	illegal = TRUE
	cost = 300

/obj/item/reagent_containers/food/drinks/meth/cocaine
	name = "white package"
	icon_state = "package_cocaine"
	list_reagents = list(/datum/reagent/drug/methamphetamine/cocaine = 30)
	cost = 300

/obj/item/reagent_containers/drug/methpack
	name = "\improper elite blood pack (full)"
	desc = "Fast way to feed your inner beast."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "blood4"
	inhand_icon_state = "blood4"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/drug/methamphetamine = 15) //some of the source chemicals are lost in the process
	resistance_flags = FREEZE_PROOF
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	var/empty = FALSE
	var/feeding = FALSE
	var/amount_of_bloodpoints = 4
	var/vitae = FALSE

/obj/item/reagent_containers/drug/methpack/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!iskindred(M))
		if(!vitae)
			return
	if(empty)
		return
	feeding = TRUE
	if(do_mob(user, src, 3 SECONDS))
		var/obj/item/reagent_containers/drug/methpack/H = new(src) //setting up the drugged bag in question (and its contents) as a variable to be called later
		feeding = FALSE
		empty = TRUE
		icon_state = "blood0"
		inhand_icon_state = "blood0"
		name = "\improper drinkable blood pack (empty)"
		M.bloodpool = min(M.maxbloodpool, M.bloodpool+amount_of_bloodpoints)
		M.adjustBruteLoss(-20, TRUE)
		M.adjustFireLoss(-20, TRUE)
		M.update_damage_overlays()
		M.update_health_hud()
		if(iskindred(M))
			M.update_blood_hud()
			H.reagents.trans_to(M, min(10, H.reagents.total_volume), transfered_by = H, methods = VAMPIRE) //calling the earlier variable to transfer to target, M
		playsound(M.loc,'sound/items/drink.ogg', 50, TRUE)
		return
	else
		feeding = FALSE
		return

/obj/item/reagent_containers/drug/morphpack
	name = "\improper elite blood pack (full)"
	desc = "Fast way to feed your inner beast."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "blood4"
	inhand_icon_state = "blood4"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 10, /datum/reagent/medicine/morphine = 10) //some of the source chemicals are lost in the process
	resistance_flags = FREEZE_PROOF
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	var/empty = FALSE
	var/feeding = FALSE
	var/amount_of_bloodpoints = 4
	var/vitae = FALSE

/obj/item/reagent_containers/drug/morphpack/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!iskindred(M))
		if(!vitae)
			return
	if(empty)
		return
	feeding = TRUE
	if(do_mob(user, src, 3 SECONDS))
		var/obj/item/reagent_containers/drug/morphpack/H = new(src) //setting up the drugged bag in question (and its contents) as a variable to be called later
		feeding = FALSE
		empty = TRUE
		icon_state = "blood0"
		inhand_icon_state = "blood0"
		name = "\improper drinkable blood pack (empty)"
		M.bloodpool = min(M.maxbloodpool, M.bloodpool+amount_of_bloodpoints)
		M.adjustBruteLoss(-20, TRUE)
		M.adjustFireLoss(-20, TRUE)
		M.update_damage_overlays()
		M.update_health_hud()
		if(iskindred(M))
			M.update_blood_hud()
			H.reagents.trans_to(M, min(10, H.reagents.total_volume), transfered_by = H, methods = VAMPIRE) //calling the earlier variable to transfer to target, M
		playsound(M.loc,'sound/items/drink.ogg', 50, TRUE)
		return
	else
		feeding = FALSE
		return

/obj/item/reagent_containers/drug/cokepack
	name = "\improper elite blood pack (full)"
	desc = "Fast way to feed your inner beast."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "blood4"
	inhand_icon_state = "blood4"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/drug/methamphetamine/cocaine = 15) //some of the source chemicals are lost in the process
	resistance_flags = FREEZE_PROOF
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	var/empty = FALSE
	var/feeding = FALSE
	var/amount_of_bloodpoints = 4
	var/vitae = FALSE

/obj/item/reagent_containers/drug/cokepack/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!iskindred(M))
		if(!vitae)
			return
	if(empty)
		return
	feeding = TRUE
	if(do_mob(user, src, 3 SECONDS))
		var/obj/item/reagent_containers/drug/cokepack/H = new(src) //setting up the drugged bag in question (and its contents) as a variable to be called later
		feeding = FALSE
		empty = TRUE
		icon_state = "blood0"
		inhand_icon_state = "blood0"
		name = "\improper drinkable blood pack (empty)"
		M.bloodpool = min(M.maxbloodpool, M.bloodpool+amount_of_bloodpoints)
		M.adjustBruteLoss(-20, TRUE)
		M.adjustFireLoss(-20, TRUE)
		M.update_damage_overlays()
		M.update_health_hud()
		if(iskindred(M))
			M.update_blood_hud()
			H.reagents.trans_to(M, min(10, H.reagents.total_volume), transfered_by = H, methods = VAMPIRE) //calling the earlier variable to transfer to target, M
		playsound(M.loc,'sound/items/drink.ogg', 50, TRUE)
		return
	else
		feeding = FALSE
		return
