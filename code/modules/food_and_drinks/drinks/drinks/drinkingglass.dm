/obj/item/reagent_containers/food/drinks/drinkingglass
	name = "Collins glass"
	desc = "Your standard drinking glass."
	icon = 'icons/obj/cocktails_1.dmi'
	icon_state = "collins_glass"
	fill_icon_thresholds = list(5, 15, 30, 40, 50)
	fill_icon_state = "collinsglass"
	amount_per_transfer_from_this = 10
	volume = 50
	custom_materials = list(/datum/material/glass=500)
	max_integrity = 20
	spillable = TRUE
	resistance_flags = ACID_PROOF
	obj_flags = UNIQUE_RENAME
	drop_sound = 'sound/items/handling/drinkglass_drop.ogg'
	pickup_sound =  'sound/items/handling/drinkglass_pickup.ogg'
	custom_price = PAYCHECK_PRISONER

/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change(datum/reagents/holder, ...)
	. = ..()
	if(!length(reagents.reagent_list))
		renamedByPlayer = FALSE //so new drinks can rename the glass
		return

	if(renamedByPlayer)
		return

	var/datum/reagent/largest_reagent = reagents.get_master_reagent()
	name = largest_reagent.glass_name || initial(name)
	desc = largest_reagent.glass_desc || initial(desc)

/obj/item/reagent_containers/food/drinks/drinkingglass/update_icon_state()
	. = ..()
	if(!length(reagents.reagent_list))
		fill_icon_state = initial(fill_icon_state)
		icon_state = initial(icon_state)
		desc = initial(desc)
		name = initial(name)
		return

	var/datum/reagent/largest_reagent = reagents.get_master_reagent()
	if(largest_reagent.glass_icon_state)
		var/list/icon_states = icon_states(icon)
		if((largest_reagent.empty_glass_icon_state in icon_states) && (largest_reagent.empty_glass_icon_state == initial(icon_state))) //temporary check, waiting for new cocktail sprites
			fill_icon_state = null
			icon_state = largest_reagent.glass_icon_state
	return NONE

/obj/item/reagent_containers/food/drinks/drinkingglass/update_overlays()
	. = ..()
	if(icon_state != initial(icon_state))
		return

	var/mutable_appearance/reagent_overlay = mutable_appearance(icon, "glassoverlay")
	reagent_overlay.color = mix_color_from_reagents(reagents.reagent_list)
	. += reagent_overlay

//Shot glasses!//
//  This lets us add shots in here instead of lumping them in with drinks because >logic  //
//  The format for shots is the exact same as iconstates for the drinking glass, except you use a shot glass instead.  //
//  If it's a new drink, remember to add it to Chemistry-Reagents.dm  and Chemistry-Recipes.dm as well.  //
//  You can only mix the ported-over drinks in shot glasses for now (they'll mix in a shaker, but the sprite won't change for glasses). //
//  This is on a case-by-case basis, and you can even make a separate sprite for shot glasses if you want. //

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	name = "Shot glass"
	desc = "A shot glass - the universal symbol for bad decisions."
	fill_icon_thresholds = list(5, 10, 15)
	fill_icon_state = "vodkashot"
	icon_state = "vodka_shot"
	gulp_size = 15
	amount_per_transfer_from_this = 15
	volume = 15
	custom_materials = list(/datum/material/glass=100)
	custom_price = PAYCHECK_ASSISTANT * 0.4

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/on_reagent_change(datum/reagents/holder, ...)
	. = ..()
	if(!length(reagents.reagent_list))
		name = "Shot glass"
		desc = "A shot glass - the universal symbol for bad decisions."
		return

	name = "filled shot glass"
	desc = "The challenge is not taking as many as you can, but guessing what it is before you pass out."

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/update_icon_state()
	. = ..()
	if(!length(reagents.reagent_list))
		icon_state = "vodka_shot"
		name = "Shot glass"
		desc = "A shot glass - the universal symbol for bad decisions."
		return

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/update_overlays()
	. = ..()
	if(icon_state != "shotglassclear")
		return

	var/mutable_appearance/shot_overlay = mutable_appearance(icon, "shotglassoverlay")
	shot_overlay.color = mix_color_from_reagents(reagents.reagent_list)
	. += shot_overlay

/obj/item/reagent_containers/food/drinks/drinkingglass/martini_glass
	name = "Martini glass"
	desc = ""
	fill_icon_thresholds = list(5, 10, 15)
	fill_icon_state = "martiniglass"
	icon_state = "martini_glass"
	amount_per_transfer_from_this = 15
	volume = 15
	custom_materials = list(/datum/material/glass=70)
	custom_price = PAYCHECK_ASSISTANT * 0.3

/obj/item/reagent_containers/food/drinks/drinkingglass/whiskey_shot
	name = "Whiskey shot"
	desc = ""
	fill_icon_thresholds = list(10, 20, 30)
	fill_icon_state = "whiskeyshot"
	icon_state = "whiskey_shot"
	volume = 30
	custom_materials = list(/datum/material/glass=100)
	custom_price = PAYCHECK_ASSISTANT * 0.5

/obj/item/reagent_containers/food/drinks/drinkingglass/wine_glass
	name = "Wine glass"
	desc = ""
	fill_icon_thresholds = list(5, 15, 30, 40, 50)
	fill_icon_state = "wineglass"
	icon_state = "wine_glass"
	volume = 50
	custom_materials = list(/datum/material/glass=500)
	custom_price = PAYCHECK_ASSISTANT * 0.6

/obj/item/reagent_containers/food/drinks/drinkingglass/pint
	name = "Pint glass"
	desc = ""
	fill_icon_thresholds = list(5, 15, 30, 50, 75, 90)
	fill_icon_state = "pint"
	icon_state = "pint"
	volume = 90
	custom_materials = list(/datum/material/glass=1000)
	custom_price = PAYCHECK_MINIMAL

/obj/item/reagent_containers/food/drinks/drinkingglass/filled/soda
	name = "Soda Water"
	list_reagents = list(/datum/reagent/consumable/sodawater = 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/filled/cola
	name = "Space Cola"
	list_reagents = list(/datum/reagent/consumable/space_cola = 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/food/egg)) //breaking eggs
		var/obj/item/food/egg/E = I
		if(reagents)
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[src] is full.</span>")
			else
				to_chat(user, "<span class='notice'>You break [E] in [src].</span>")
				reagents.add_reagent(/datum/reagent/consumable/eggyolk, 5)
				qdel(E)
			return
	else
		..()

/obj/item/reagent_containers/food/drinks/drinkingglass/attack(obj/target, mob/user)
	if(user.a_intent == INTENT_HARM && ismob(target) && target.reagents && reagents.total_volume)
		target.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [target]!</span>", \
						"<span class='userdanger'>[user] splashes the contents of [src] onto you!</span>")
		log_combat(user, target, "splashed", src)
		reagents.expose(target, TOUCH)
		reagents.clear_reagents()
		return
	..()

/obj/item/reagent_containers/food/drinks/drinkingglass/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if((!proximity) || !check_allowed_items(target,target_self=1))
		return

	else if(reagents.total_volume && user.a_intent == INTENT_HARM)
		user.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [target]!</span>", \
							"<span class='notice'>You splash the contents of [src] onto [target].</span>")
		reagents.expose(target, TOUCH)
		reagents.clear_reagents()
		return
