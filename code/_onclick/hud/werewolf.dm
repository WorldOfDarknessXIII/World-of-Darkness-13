/atom/movable/screen/werewolf
	icon = 'icons/hud/screen_midnight.dmi'

/datum/hud/werewolf
	ui_style = 'icons/hud/screen_midnight.dmi'

/atom/movable/screen/rage
	name = "Rage"
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "rage0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_homid
	name = "Homid"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "homid"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_homid/Click()
	var/mob/living/carbon/werewolf = usr
	if (!iscarbon(werewolf))
		return
	if (werewolf.stat >= SOFT_CRIT || werewolf.IsSleeping() || werewolf.IsUnconscious() || werewolf.IsParalyzed() || werewolf.IsKnockdown() || werewolf.IsStun())
		return

	var/datum/splat/werewolf/garou/lycanthropy = is_garou(werewolf)
	if (!lycanthropy?.transformator)
		return

	lycanthropy.transformator.trans_gender(werewolf, "Homid")

/atom/movable/screen/transform_crinos
	name = "Crinos"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "crinos"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_crinos/Click()
	var/mob/living/carbon/werewolf = usr
	if (!iscarbon(werewolf))
		return
	if (werewolf.stat >= SOFT_CRIT || werewolf.IsSleeping() || werewolf.IsUnconscious() || werewolf.IsParalyzed() || werewolf.IsKnockdown() || werewolf.IsStun())
		return

	var/datum/splat/werewolf/garou/lycanthropy = is_garou(werewolf)
	if (!lycanthropy?.transformator)
		return

	lycanthropy.transformator.trans_gender(werewolf, "Crinos")

/atom/movable/screen/transform_lupus
	name = "Lupus"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "lupus"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_lupus/Click()
	var/mob/living/carbon/werewolf = usr
	if (!iscarbon(werewolf))
		return
	if (werewolf.stat >= SOFT_CRIT || werewolf.IsSleeping() || werewolf.IsUnconscious() || werewolf.IsParalyzed() || werewolf.IsKnockdown() || werewolf.IsStun())
		return

	var/datum/splat/werewolf/garou/lycanthropy = is_garou(werewolf)
	if (!lycanthropy?.transformator)
		return

	lycanthropy.transformator.trans_gender(werewolf, "Lupus")

/atom/movable/screen/auspice
	name = "Auspice"
	icon = 'code/modules/wod13/werewolf_ui.dmi'
	icon_state = "auspice_bar"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/auspice/Click()
	if(!GLOB.moon_state)
		GLOB.moon_state = pick("Full", "Gibbous", "Half", "Crescent", "New")

	var/mob/living/carbon/werewolf = usr
	if(werewolf.stat >= SOFT_CRIT || werewolf.IsSleeping() || werewolf.IsUnconscious() || werewolf.IsParalyzed() || werewolf.IsKnockdown() || werewolf.IsStun())
		return

	var/datum/splat/werewolf/garou/lycanthropy = is_garou(werewolf)
	if (!lycanthropy)
		return

	var/area/vtm/area = get_area(werewolf)
	if (!istype(area, /area/vtm))
		return
	if(!area.upper)
		to_chat(werewolf, span_warning("You need to be outside to look at the moon!"))
		return

	if(COOLDOWN_FINISHED(lycanthropy, look_at_moon))
		COOLDOWN_START(lycanthropy, look_at_moon, 2 MINUTES)

		to_chat(werewolf, "<span class='notice'>The Moon is [GLOB.moon_state].</span>")
		werewolf.emote("howl")
		playsound(get_turf(werewolf), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
		icon_state = "[GLOB.moon_state]"

		lycanthropy.add_rage(1)

/datum/hud
	var/atom/movable/screen/auspice_icon

/datum/hud/werewolf/New(mob/living/carbon/werewolf/owner)
	..()

	var/atom/movable/screen/using
	var/atom/movable/screen/transform_werewolf

//equippable shit

//hands
	if(iscrinos(owner))
		build_hand_slots()

//begin buttons

	using = new /atom/movable/screen/fullscreen_hud()
	using.screen_loc = ui_full_inventory
	using.hud = src
	static_inventory += using

	transform_werewolf = new /atom/movable/screen/transform_lupus()
	transform_werewolf.screen_loc = ui_werewolf_lupus
	transform_werewolf.hud = src
	static_inventory += transform_werewolf

	transform_werewolf = new /atom/movable/screen/transform_crinos()
	transform_werewolf.screen_loc = ui_werewolf_crinos
	transform_werewolf.hud = src
	static_inventory += transform_werewolf

	transform_werewolf = new /atom/movable/screen/transform_homid()
	transform_werewolf.screen_loc = ui_werewolf_homid
	transform_werewolf.hud = src
	static_inventory += transform_werewolf

	auspice_icon = new /atom/movable/screen/auspice()
	auspice_icon.screen_loc = ui_werewolf_auspice
	auspice_icon.hud = src
	static_inventory += auspice_icon

	rage_icon = new /atom/movable/screen/rage()
	rage_icon.screen_loc = ui_werewolf_rage
	rage_icon.hud = src
	infodisplay += rage_icon

	if(iscrinos(owner))
		using = new /atom/movable/screen/swap_hand()
		using.icon = 'code/modules/wod13/UI/buttons32.dmi'
		using.icon_state = "swap_1"
		using.screen_loc = ui_swaphand_position(owner,1)
		using.hud = src
		static_inventory += using

		using = new /atom/movable/screen/swap_hand()
		using.icon = 'code/modules/wod13/UI/buttons32.dmi'
		using.icon_state = "swap_2"
		using.screen_loc = ui_swaphand_position(owner,2)
		using.hud = src
		static_inventory += using

	using = new /atom/movable/screen/act_intent()
	using.icon_state = mymob.a_intent
	using.icon = 'code/modules/wod13/UI/buttons32.dmi'
	using.hud = src
	static_inventory += using
	action_intent = using

	using = new/atom/movable/screen/language_menu
	using.screen_loc = ui_language_menu
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/drop()
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.screen_loc = ui_drop
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/resist()
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.screen_loc = ui_resist
	using.hud = src
	hotkeybuttons += using

	throw_icon = new /atom/movable/screen/throw_catch()
	throw_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	throw_icon.screen_loc = ui_throw
	throw_icon.hud = src
	hotkeybuttons += throw_icon

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_pull
	pull_icon.hud = src
	static_inventory += pull_icon

//begin indicators

	healths = new /atom/movable/screen/healths()
	healths.icon = 'code/modules/wod13/UI/buttons32.dmi'
	healths.hud = src
	infodisplay += healths
	blood_icon = new /atom/movable/screen/blood()
	blood_icon.screen_loc = ui_bloodpool
	blood_icon.hud = src
	infodisplay += blood_icon

	zone_select = new /atom/movable/screen/zone_sel()
	zone_select.icon = 'code/modules/wod13/UI/buttons64.dmi'
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_icon()

/datum/hud/werewolf/persistent_inventory_update()
	if(!mymob)
		return
	if(!iscrinos(mymob))
		return
	var/mob/living/carbon/werewolf/H = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I))
			H.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			H.client.screen -= I
