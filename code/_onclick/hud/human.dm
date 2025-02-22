/atom/movable/screen/human
	icon = 'code/modules/wod13/UI/buttons32.dmi'

/atom/movable/screen/fullscreen_hud
	layer = HUD_LAYER
	plane = HUD_PLANE
	icon = 'code/modules/wod13/UI/full.dmi'

/atom/movable/screen/human/toggle
	name = "toggle"
	icon_state = "toggle"

/atom/movable/screen/human/toggle/Click()

	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(usr.hud_used.inventory_shown && targetmob.hud_used)
		usr.hud_used.inventory_shown = FALSE
		usr.client.screen -= targetmob.hud_used.toggleable_inventory
	else
		usr.hud_used.inventory_shown = TRUE
		usr.client.screen += targetmob.hud_used.toggleable_inventory

	targetmob.hud_used.hidden_inventory_update(usr)

/atom/movable/screen/human/equip
	name = "equip"
	icon_state = "act_equip"

/atom/movable/screen/human/equip/Click()
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE
	var/mob/living/carbon/human/H = usr
	H.quick_equip()

/atom/movable/screen/ling
	icon = 'icons/hud/screen_changeling.dmi'
	invisibility = INVISIBILITY_ABSTRACT

/atom/movable/screen/ling/sting
	name = "current sting"
	screen_loc = ui_lingstingdisplay

/atom/movable/screen/ling/sting/Click()
	if(isobserver(usr))
		return
	var/mob/living/carbon/U = usr
	U.unset_sting()

/atom/movable/screen/ling/chems
	name = "chemical storage"
	icon_state = "power_display"
	screen_loc = ui_lingchemdisplay

/datum/hud/human/New(mob/living/carbon/human/owner)
	..()

	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box
//	var/atom/movable/screen/inventory/inv_add
	var/atom/movable/screen/transform_werewolf

	if(isgarou(owner))
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

		transform_werewolf = new /atom/movable/screen/auspice()
		transform_werewolf.screen_loc = ui_werewolf_auspice
		transform_werewolf.hud = src
		static_inventory += transform_werewolf

		rage_icon = new /atom/movable/screen/rage()
		rage_icon.screen_loc = ui_werewolf_rage
		rage_icon.hud = src
		infodisplay += rage_icon

	if(iscathayan(owner))
		chi_icon = new /atom/movable/screen/chi_pool()
		chi_icon.screen_loc = ui_chi_pool
		chi_icon.hud = src
		static_inventory += chi_icon
		yang_chi_icon = new /atom/movable/screen/yang_chi()
		yang_chi_icon.screen_loc = ui_chi_pool
		yang_chi_icon.hud = src
		static_inventory += yang_chi_icon
		yin_chi_icon = new /atom/movable/screen/yin_chi()
		yin_chi_icon.screen_loc = ui_chi_pool
		yin_chi_icon.hud = src
		static_inventory += yin_chi_icon
		imbalance_chi_icon = new /atom/movable/screen/imbalance_chi()
		imbalance_chi_icon.screen_loc = ui_chi_pool
		imbalance_chi_icon.hud = src
		static_inventory += imbalance_chi_icon
		demon_chi_icon = new /atom/movable/screen/demon_chi()
		demon_chi_icon.screen_loc = ui_chi_demon
		demon_chi_icon.hud = src
		static_inventory += demon_chi_icon

	using = new/atom/movable/screen/language_menu
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.hud = src
	static_inventory += using

//	using = new/atom/movable/screen/skills
//	using.icon = ui_style
//	using.hud = src
//	static_inventory += using

//	using = new /atom/movable/screen/area_creator
//	using.icon = ui_style
//	using.hud = src
//	static_inventory += using

	action_intent = new /atom/movable/screen/act_intent/segmented
	action_intent.icon_state = mymob.a_intent
	action_intent.icon = 'code/modules/wod13/UI/buttons32.dmi'
	action_intent.hud = src
	static_inventory += action_intent

	using = new /atom/movable/screen/mov_intent
	using.icon = 'code/modules/wod13/UI/buttons32.dmi'
	using.icon_state = (mymob.m_intent == MOVE_INTENT_RUN ? "running" : "walking")
	using.screen_loc = ui_movi
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/drop()
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.screen_loc = ui_drop
	using.hud = src
	static_inventory += using

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "i_clothing"
	inv_box.icon = 'code/modules/wod13/UI/buttons48.dmi'
	inv_box.slot_id = ITEM_SLOT_ICLOTHING
	inv_box.icon_state = "uniform"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_iclothing
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "o_clothing"
	inv_box.icon = 'code/modules/wod13/UI/buttons48.dmi'
	inv_box.slot_id = ITEM_SLOT_OCLOTHING
	inv_box.icon_state = "suit"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_oclothing
	inv_box.hud = src
	toggleable_inventory += inv_box

	build_hand_slots()

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

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "id"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "id"
	inv_box.icon_full = "template2"
	inv_box.screen_loc = ui_id
	inv_box.slot_id = ITEM_SLOT_ID
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "mask"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "mask"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_mask
	inv_box.slot_id = ITEM_SLOT_MASK
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "neck"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "neck"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_neck
	inv_box.slot_id = ITEM_SLOT_NECK
	inv_box.hud = src
	toggleable_inventory += inv_box

//	inv_add = new /atom/movable/screen/addinv()
//	inv_add.name = "inventory"
//	inv_add.icon = 'code/modules/wod13/32x48.dmi'
//	inv_add.icon_state = "gorg"
//	inv_add.screen_loc = ui_gorg
//	inv_add.hud = src
//	toggleable_inventory += inv_add

//	inv_add = new /atom/movable/screen/addinv()
//	inv_add.name = "inventory"
//	inv_add.icon = 'code/modules/wod13/icons.dmi'
//	inv_add.icon_state = "cross1"
//	inv_add.screen_loc = ui_cross1
//	inv_add.hud = src
//	toggleable_inventory += inv_add

//	inv_add = new /atom/movable/screen/addinv()
//	inv_add.name = "inventory"
//	inv_add.icon = 'code/modules/wod13/icons.dmi'
//	inv_add.icon_state = "cross2"
//	inv_add.screen_loc = ui_cross2
//	inv_add.hud = src
//	toggleable_inventory += inv_add

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "back"
	inv_box.icon = 'code/modules/wod13/UI/buttons48.dmi'
	inv_box.icon_state = "back"
	inv_box.icon_full = "template2"
	inv_box.screen_loc = ui_back
	inv_box.slot_id = ITEM_SLOT_BACK
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "storage1"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "pocket"
	inv_box.icon_full = "template2"
	inv_box.screen_loc = ui_storage1
	inv_box.slot_id = ITEM_SLOT_LPOCKET
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "storage2"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "pocket"
	inv_box.icon_full = "template2"
	inv_box.screen_loc = ui_storage2
	inv_box.slot_id = ITEM_SLOT_RPOCKET
	inv_box.hud = src
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "suit storage"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "suit_storage"
	inv_box.icon_full = "template2"
	inv_box.screen_loc = ui_sstore1
	inv_box.slot_id = ITEM_SLOT_SUITSTORE
	inv_box.hud = src
	static_inventory += inv_box

	using = new /atom/movable/screen/resist()
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.screen_loc = ui_resist
	using.hud = src
	hotkeybuttons += using

	using = new /atom/movable/screen/fullscreen_hud()
	using.screen_loc = ui_full_inventory
	using.hud = src
	static_inventory += using

//	using = new /atom/movable/screen/human/equip()
//	using.icon = ui_style
//	using.screen_loc = ui_equip_position(mymob)
//	using.hud = src
//	static_inventory += using

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "gloves"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "gloves"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_gloves
	inv_box.slot_id = ITEM_SLOT_GLOVES
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "eyes"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "glasses"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_glasses
	inv_box.slot_id = ITEM_SLOT_EYES
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "ears"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "ears"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_ears
	inv_box.slot_id = ITEM_SLOT_EARS
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "head"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "head"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_head
	inv_box.slot_id = ITEM_SLOT_HEAD
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "shoes"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "shoes"
	inv_box.icon_full = "template1"
	inv_box.screen_loc = ui_shoes
	inv_box.slot_id = ITEM_SLOT_FEET
	inv_box.hud = src
	toggleable_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "belt"
	inv_box.icon = 'code/modules/wod13/UI/buttons32.dmi'
	inv_box.icon_state = "belt"
	inv_box.icon_full = "template1"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = ui_belt
	inv_box.slot_id = ITEM_SLOT_BELT
	inv_box.hud = src
	static_inventory += inv_box

	throw_icon = new /atom/movable/screen/throw_catch()
	throw_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	throw_icon.screen_loc = ui_throw
	throw_icon.hud = src
	hotkeybuttons += throw_icon

	rest_icon = new /atom/movable/screen/rest()
	rest_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	rest_icon.screen_loc = ui_rest
	rest_icon.hud = src
	static_inventory += rest_icon

	block_icon = new /atom/movable/screen/block()
	block_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	block_icon.screen_loc = ui_block
	block_icon.hud = src
	static_inventory += block_icon

	jump_icon = new /atom/movable/screen/jump()
	jump_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	jump_icon.screen_loc = ui_jump
	jump_icon.hud = src
	static_inventory += jump_icon

//	internals = new /atom/movable/screen/internals()
//	internals.hud = src
//	infodisplay += internals

	spacesuit = new /atom/movable/screen/spacesuit
	spacesuit.hud = src
	infodisplay += spacesuit

	healths = new /atom/movable/screen/healths()
	healths.icon = 'code/modules/wod13/UI/buttons32.dmi'
	healths.hud = src
	infodisplay += healths

	blood_icon = new /atom/movable/screen/blood()
	blood_icon.screen_loc = ui_bloodpool
	blood_icon.hud = src
	infodisplay += blood_icon

	drinkblood_icon = new /atom/movable/screen/drinkblood()
	drinkblood_icon.icon_state = "act_bite"
	drinkblood_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	drinkblood_icon.screen_loc = ui_drinkblood
	drinkblood_icon.hud = src
	static_inventory += drinkblood_icon

	zone_icon = new /atom/movable/screen/vtm_zone()
	zone_icon.screen_loc = ui_vtm_zone
	zone_icon.hud = src
	static_inventory += zone_icon

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_pull
	pull_icon.hud = src
	static_inventory += pull_icon

	lingchemdisplay = new /atom/movable/screen/ling/chems()
	lingchemdisplay.hud = src
	infodisplay += lingchemdisplay

	lingstingdisplay = new /atom/movable/screen/ling/sting()
	lingstingdisplay.hud = src
	infodisplay += lingstingdisplay

	zone_select =  new /atom/movable/screen/zone_sel()
	zone_select.icon = 'code/modules/wod13/UI/buttons64.dmi'
	zone_select.hud = src
	zone_select.update_icon()
	static_inventory += zone_select

	combo_display = new /atom/movable/screen/combo()
	infodisplay += combo_display

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_icon()

	update_locked_slots()

/datum/hud/human/update_locked_slots()
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob
	if(!istype(H) || !H.dna.species)
		return
	var/datum/species/S = H.dna.species
	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			if(inv.slot_id in S.no_equip)
				inv.alpha = 128
			else
				inv.alpha = initial(inv.alpha)

/datum/hud/human/hidden_inventory_update(mob/viewer)
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used.inventory_shown && screenmob.hud_used.hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = ui_shoes
			screenmob.client.screen += H.shoes
		if(H.gloves)
			H.gloves.screen_loc = ui_gloves
			screenmob.client.screen += H.gloves
		if(H.ears)
			H.ears.screen_loc = ui_ears
			screenmob.client.screen += H.ears
		if(H.glasses)
			H.glasses.screen_loc = ui_glasses
			screenmob.client.screen += H.glasses
		if(H.w_uniform)
			H.w_uniform.screen_loc = ui_iclothing
			screenmob.client.screen += H.w_uniform
		if(H.wear_suit)
			H.wear_suit.screen_loc = ui_oclothing
			screenmob.client.screen += H.wear_suit
		if(H.wear_mask)
			H.wear_mask.screen_loc = ui_mask
			screenmob.client.screen += H.wear_mask
		if(H.wear_neck)
			H.wear_neck.screen_loc = ui_neck
			screenmob.client.screen += H.wear_neck
		if(H.head)
			H.head.screen_loc = ui_head
			screenmob.client.screen += H.head
	else
		if(H.shoes)		screenmob.client.screen -= H.shoes
		if(H.gloves)	screenmob.client.screen -= H.gloves
		if(H.ears)		screenmob.client.screen -= H.ears
		if(H.glasses)	screenmob.client.screen -= H.glasses
		if(H.w_uniform)	screenmob.client.screen -= H.w_uniform
		if(H.wear_suit)	screenmob.client.screen -= H.wear_suit
		if(H.wear_mask)	screenmob.client.screen -= H.wear_mask
		if(H.wear_neck)	screenmob.client.screen -= H.wear_neck
		if(H.head)		screenmob.client.screen -= H.head



/datum/hud/human/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return
	..()
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used)
		if(screenmob.hud_used.hud_shown)
			if(H.s_store)
				H.s_store.screen_loc = ui_sstore1
				screenmob.client.screen += H.s_store
			if(H.wear_id)
				H.wear_id.screen_loc = ui_id
				screenmob.client.screen += H.wear_id
			if(H.belt)
				H.belt.screen_loc = ui_belt
				screenmob.client.screen += H.belt
			if(H.back)
				H.back.screen_loc = ui_back
				screenmob.client.screen += H.back
			if(H.l_store)
				H.l_store.screen_loc = ui_storage1
				screenmob.client.screen += H.l_store
			if(H.r_store)
				H.r_store.screen_loc = ui_storage2
				screenmob.client.screen += H.r_store
		else
			if(H.s_store)
				screenmob.client.screen -= H.s_store
			if(H.wear_id)
				screenmob.client.screen -= H.wear_id
			if(H.belt)
				screenmob.client.screen -= H.belt
			if(H.back)
				screenmob.client.screen -= H.back
			if(H.l_store)
				screenmob.client.screen -= H.l_store
			if(H.r_store)
				screenmob.client.screen -= H.r_store

	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I))
			screenmob.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			screenmob.client.screen -= I


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = FALSE
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = TRUE
