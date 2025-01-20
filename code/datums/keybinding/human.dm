/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/datum/keybinding/human/quick_equip
	hotkey_keys = list("E")
	name = "quick_equip"
	full_name = "Quick equip"
	description = "Quickly puts an item in the best slot available"
	keybind_signal = COMSIG_KB_HUMAN_QUICKEQUIP_DOWN

/datum/keybinding/human/quick_equip/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE

/datum/keybinding/human/quick_equip_belt
	hotkey_keys = list("ShiftE")
	name = "quick_equip_belt"
	full_name = "Quick equip belt"
	description = "Put held thing in belt or take out most recent thing from belt"
	///which slot are we trying to quickdraw from/quicksheathe into?
	var/slot_type = ITEM_SLOT_BELT
	///what we should call slot_type in messages (including failure messages)
	var/slot_item_name = "belt"
	keybind_signal = COMSIG_KB_HUMAN_QUICKEQUIPBELT_DOWN

/datum/keybinding/human/quick_equip_belt/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.smart_equip_targeted(slot_type, slot_item_name)
	return TRUE

/datum/keybinding/human/quick_equip_belt/quick_equip_bag
	hotkey_keys = list("ShiftB")
	name = "quick_equip_bag"
	full_name = "Quick equip bag"
	description = "Put held thing in backpack or take out most recent thing from backpack"
	slot_type = ITEM_SLOT_BACK
	slot_item_name = "backpack"
	keybind_signal = COMSIG_KB_HUMAN_BAGEQUIP_DOWN

/datum/keybinding/human/quick_equip_belt/quick_equip_suit_storage
	hotkey_keys = list("ShiftQ")
	name = "quick_equip_suit_storage"
	full_name = "Quick equip suit storage slot"
	description = "Put held thing in suit storage slot item or take out most recent thing from suit storage slot item"
	slot_type = ITEM_SLOT_SUITSTORE
	slot_item_name = "suit storage slot item"
	keybind_signal = COMSIG_KB_HUMAN_SUITEQUIP_DOWN

/datum/keybinding/human/block
	hotkey_keys = list("C")
	name = "enable_blocking"
	full_name = " Enable or disable blocking mod"
	description = "Toggles blocking mode for combat"
	keybind_signal = COMSIG_KB_HUMAN_BLOCK

/datum/keybinding/human/block/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.SwitchBlocking()
	return TRUE

/datum/keybinding/human/bite
	hotkey_keys = list("F")
	name = "bite"
	full_name = "Bite"
	description = "Bite whoever you're aggressively grabbing, and feed on them if possible."
	keybind_signal = COMSIG_KB_HUMAN_BITE_DOWN

/datum/keybinding/human/bite/down(client/user)
	. = ..()
	if(.)
		return
	//the code below is directly imported from onyxcombat.dm's /atom/movable/screen/drinkblood/Click() proc
	//turning all of this into one centralised proc would be preferable, but it requires more effort than I'm willing to put in right now
	if(ishuman(user.mob))
		var/mob/living/carbon/human/BD = user.mob
		BD.update_blood_hud()
		if(world.time < BD.last_drinkblood_use+30)
			return
		if(world.time < BD.last_drinkblood_click+10)
			return
		BD.last_drinkblood_click = world.time
//		if(BD.bloodpool >= BD.maxbloodpool)
//			SEND_SOUND(BD, sound('code/modules/wod13/need_blood.ogg'))
//			to_chat(BD, "<span class='warning'>You're full of <b>BLOOD</b>.</span>")
//			return
		if(BD.grab_state > GRAB_PASSIVE)
			if(ishuman(BD.pulling))
				var/mob/living/carbon/human/PB = BD.pulling
				if(isghoul(user.mob))
					if(!iskindred(PB))
						SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
						to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
						return
				if(!isghoul(user.mob) && !iskindred(user.mob))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				if(PB.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				if(PB.bloodpool <= 0 && !iskindred(BD.pulling))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(BD.clane)
					var/special_clan = FALSE
					if(BD.clane.name == "Salubri")
						if(!PB.IsSleeping())
							to_chat(BD, "<span class='warning'>You can't drink from aware targets!</span>")
							return
						special_clan = TRUE
						PB.emote("moan")
					if(BD.clane.name == "Giovanni")
						PB.emote("scream")
						special_clan = TRUE
					if(!special_clan)
						PB.emote("groan")
				PB.add_bite_animation()
			if(isliving(BD.pulling))
				if (!iskindred(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				var/mob/living/LV = BD.pulling
				if(LV.bloodpool <= 0 && !iskindred(BD.pulling))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(LV.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				var/skipface = (BD.wear_mask && (BD.wear_mask.flags_inv & HIDEFACE)) || (BD.head && (BD.head.flags_inv & HIDEFACE))
				if(!skipface)
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						playsound(BD, 'code/modules/wod13/sounds/drinkblood1.ogg', 50, TRUE)
						LV.visible_message("<span class='warning'><b>[BD] bites [LV]'s neck!</b></span>", "<span class='warning'><b>[BD] bites your neck!</b></span>")
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						if(BD.CheckEyewitness(LV, BD, 7, FALSE))
							BD.AdjustMasquerade(-1)
					else
						playsound(BD, 'code/modules/wod13/sounds/kiss.ogg', 50, TRUE)
						LV.visible_message("<span class='italics'><b>[BD] kisses [LV]!</b></span>", "<span class='userlove'><b>[BD] kisses you!</b></span>")
					if(iskindred(LV))
						var/mob/living/carbon/human/HV = BD.pulling
						if(HV.stakeimmune)
							to_chat(BD, "<span class='warning'>There is no <b>HEART</b> in this creature.</span>")
							return
					BD.drinksomeblood(LV)
	return TRUE
