/obj/item/bong
	name = "bong"
	desc = "Technically known as a water pipe."
	icon = 'icons/wod13/items.dmi'
	icon_state = "bulbulator"
	inhand_icon_state = "bulbulator"
	onflooricon = 'icons/wod13/onfloor.dmi'

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
	to_chat(hit_mob, "<span class='notice'>You finish taking a hit from [src].</span>")
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
