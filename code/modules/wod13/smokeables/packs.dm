////////////////IN HONOR OF MOJAVE SUN... LIGHT ONE UP..../////////////////

/obj/item/storage/fancy/ms13/cigarettes
	name = "\improper cigarette pack"
	desc = "A unbranded, generic cigarette pack, how the hell did you get this. A label on the packaging reads, \"There is no label, report this to a developer.\""
	icon = 'code/modules/wod13/smokeables/smokeables_world.dmi'
	icon_state = "generic"
	inventory_state = "generic_pack"
	world_state = "generic"
	lefthand_file = 'code/modules/wod13/smokeables/smokeables_lefthand.dmi'
	righthand_file = 'code/modules/wod13/smokeables/smokeables_righthand.dmi'
	inhand_icon_state = "lucky"
	w_class = WEIGHT_CLASS_SMALL
	gender = PLURAL
	spawn_type = /obj/item/ms13/cigarette
	component_type = /datum/component/storage/concrete/ms13/cigarettes
	contents_tag = "cigarette"
	folds = FALSE
	grid_width = 32
	grid_height = 32
	freshsound = 'code/modules/wod13/smokeables/smokesounds/freshpack.ogg'
	drop_sound = 'code/modules/wod13/smokeables/smokesounds/packdrop.ogg'
	pickup_sound = 'code/modules/wod13/smokeables/smokesounds/packgrab.ogg'
	var/amount = 8 //the amount spawned in the pack
	var/max_amount = 8 //the max amount allowed in the pack
	var/othertype = FALSE
	var/pack_overlay = "cig"
	var/is_randomised = FALSE //no idea what this does currently

/obj/item/storage/fancy/ms13/cigarettes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Click in offhand to take one out. Use to open/close.</span>"

/obj/item/storage/fancy/ms13/cigarettes/PopulateContents()
	if(!spawn_type)
		return
	if(!is_randomised)
		for(var/i = 1 to amount)
			new spawn_type(src)
	else
		for(var/i = 0 to rand(0, amount))
			new spawn_type(src)
	if(contents.len == max_amount) //full pack, unopened
		fresh = TRUE

/obj/item/storage/fancy/ms13/cigarettes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = max_amount
	STR.set_holdable(list(/obj/item/ms13/cigarette))
	AddElement(/datum/element/world_icon, null, icon, 'code/modules/wod13/smokeables/smokeables_inventory.dmi', world_state, inventory_state)

/obj/item/storage/fancy/ms13/cigarettes/MouseDrop()
	if(!is_open && (usr.stat != DEAD))
		to_chat(usr, "<span class='danger'>[src] is closed.</span>")
		return COMPONENT_NO_MOUSEDROP
	else
		return . = ..()

/obj/item/storage/fancy/ms13/cigarettes/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ms13/cigarette) && !is_open)
		to_chat(user, "<span class='danger'>[src] is closed.</span>")
		return
	else
		. = ..()

/obj/item/storage/fancy/ms13/cigarettes/update_icon_state()
	if(is_open && !othertype)
		inventory_state = "[initial(inventory_state)]_open"
		. = ..()
	else
		inventory_state = "[initial(inventory_state)]"
		. = ..()

/obj/item/storage/fancy/ms13/cigarettes/Exited(atom/movable/gone, direction)
	. = ..()
	playsound(src, 'code/modules/wod13/smokeables/smokesounds/cigremove.ogg', 200)

/obj/item/storage/fancy/ms13/cigarettes/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	playsound(src, 'code/modules/wod13/smokeables/smokesounds/cigplace.ogg', 200)

/obj/item/storage/fancy/ms13/cigarettes/update_overlays()
	. = ..()
	cut_overlays()
	if(is_open && contents.len && !othertype)
		var/mutable_appearance/inserted_overlay = mutable_appearance('code/modules/wod13/smokeables/smokeables_inventory.dmi')

		inserted_overlay.icon_state = "overlay_[pack_overlay]"

		inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[contents.len]"
		add_overlay(image(icon, icon_state = inserted_overlay.icon_state))
	if(is_open && contents.len && othertype)
		var/mutable_appearance/inserted_overlay = mutable_appearance('code/modules/wod13/smokeables/smokeables_inventory.dmi')

		inserted_overlay.icon_state = "overlay_[pack_overlay]"
		add_overlay(image(icon, icon_state = inserted_overlay.icon_state))

/obj/item/storage/fancy/ms13/cigarettes/attack_self(mob/living/user)
	if(do_after(user, 0.5 SECONDS, src))
		. = ..()
		if(!is_open)
			playsound(user, 'code/modules/wod13/smokeables/smokesounds/packopen.ogg', 100)
		if(is_open)
			playsound(user, 'code/modules/wod13/smokeables/smokesounds/packclose.ogg', 100)

/obj/item/storage/fancy/ms13/cigarettes/attack_hand_secondary(mob/user, list/modifiers)
	attack_hand(user, modifiers)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/fancy/ms13/cigarettes/attackby_secondary(obj/item/weapon, mob/user, params)
	attackby(weapon, user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/fancy/ms13/cigarettes/alt_click_on_secondary(mob/user)
	attack_hand(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/fancy/ms13/cigarettes/AltClick(mob/user)
	attack_hand(user)
	return

/obj/item/storage/fancy/ms13/cigarettes/attack_hand(mob/user, list/modifiers)
	if(!ismob(user))
		return
	if(!user.is_holding(src))
		return . = ..()
	if(!loc == user)
		return . = ..()
	if(!is_open)
		to_chat(user, "<span class='danger'>[src] is closed.</span>")
		return
	var/obj/item/ms13/cigarette/cig = locate(/obj/item/ms13/cigarette) in contents
	if(cig)
		if(user && contents.len > 0)
			var/obj/item/ms13/cigarette/W = cig
			SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
			user.put_in_hands(W)
			contents -= W
			to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
		else
			..()
	else
		to_chat(user, "<span class='notice'>There are no [contents_tag]s left in the pack.</span>")

//Cigarette Packs

/obj/item/storage/fancy/cigarettes/marlboro
	name = "\improper Marlboro pack"
	desc = "A cool red cigarette packet. A label on the packaging reads, \"<b>Marlboro</b>. Where theres a man, theres a Marlboro.\""
	icon_state = "marl"
	inventory_state = "marl_pack"
	world_state = "marl"
	inhand_icon_state = "red"
	spawn_type = /obj/item/cigarette/marlboro

/obj/item/storage/fancy/cigarettes/winston
	name = "\improper Winston pack"
	desc = "A refined red cigarette packet. A label on the packaging reads, \"<b>Winston</b>. Winston tastes good, like a cigarette should!\""
	icon_state = "wins"
	inventory_state = "wins_pack"
	world_state = "wins"
	inhand_icon_state = "red"
	spawn_type = /obj/item/cigarette/winston

/obj/item/storage/fancy/cigarettes/luckystrike
	name = "\improper Lucky Strike pack"
	desc = "A white cigarette packet with a large red circle on it. A label on the packaging reads, \"<b>Lucky Strike</b>. Be Happy - Go Lucky!\""
	icon_state = "lucky"
	inventory_state = "lucky_pack"
	world_state = "lucky"
	inhand_icon_state = "lucky"
	spawn_type = /obj/item/cigarette/lucky
	amount = 7
	max_amount = 7
	pack_overlay = "lucky"
	othertype = TRUE


/obj/item/storage/fancy/cigarettes/salem
	name = "\improper Salem pack"
	desc = "A refined green cigarette packet. A label on the packaging reads, \"<b>Salem</b>. Refreshes your taste.\""
	icon_state = "salem"
	inventory_state = "salem_pack"
	world_state = "salem"
	inhand_icon_state = "green"
	spawn_type = /obj/item/cigarette/salem

/obj/item/storage/fancy/cigarettes/kools
	name = "\improper Kools pack"
	desc = "A kool green cigarette packet. A label on the packaging reads, \"<b>KOOL</b>. So good, it's got to be KOOL!\""
	icon_state = "kool"
	inventory_state = "kool_pack"
	world_state = "kool"
	inhand_icon_state = "green"
	spawn_type = /obj/item/cigarette/kools
	othertype = FALSE

//Rollie Packs

/obj/item/storage/fancy/ms13/cigarettes/rollies //generic craftable pack
	name = "\improper cardboard pack"
	desc = "A simple hand-made cardboard cigarette pack."
	icon_state = "custom"
	inventory_state = "custom_pack"
	world_state = "custom"
	inhand_icon_state = "brown"
	spawn_type = /obj/item/ms13/cigarette/rollie
	othertype = FALSE
	pack_overlay = "rolled"

/obj/item/storage/fancy/ms13/cigarettes/rollies/random
	is_randomised = TRUE

/obj/item/storage/fancy/ms13/cigarettes/rollies/empty
	spawn_type = null
