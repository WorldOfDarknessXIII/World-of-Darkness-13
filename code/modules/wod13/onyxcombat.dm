/mob/living/carbon/human/toggle_move_intent(mob/living/user)
	if(blocking && m_intent == MOVE_INTENT_WALK)
		return
	..()

/mob/living/carbon/human/proc/SwitchBlocking()
	if(!blocking)
		visible_message("<span class='warning'>[src] prepares to block.</span>", "<span class='warning'>You prepare to block.</span>")
		blocking = TRUE
		if(hud_used)
			hud_used.block_icon.icon_state = "act_block_on"
		clear_parrying()
		remove_overlay(FIGHT_LAYER)
		var/mutable_appearance/block_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "block", -FIGHT_LAYER)
		overlays_standing[FIGHT_LAYER] = block_overlay
		apply_overlay(FIGHT_LAYER)
		last_m_intent = m_intent
		if(m_intent == MOVE_INTENT_RUN)
			toggle_move_intent(src)
	else
		to_chat(src, "<span class='warning'>You lower your defense.</span>")
		remove_overlay(FIGHT_LAYER)
		blocking = FALSE
		if(m_intent != last_m_intent)
			toggle_move_intent(src)
		if(hud_used)
			hud_used.block_icon.icon_state = "act_block_off"

/mob/living/carbon/human/attackby(obj/item/W, mob/living/user, params)
	if(user.blocking)
		return
	if(getStaminaLoss() >= 50 && blocking)
		SwitchBlocking()
	if(user.a_intent == INTENT_GRAB && ishuman(user))
		var/mob/living/carbon/human/ZIG = user
		if(ZIG.getStaminaLoss() < 50)
			ZIG.parry_class = W.w_class
			ZIG.Parry(src)
			return
	if(user == parrying && user != src)
		if(W.w_class == parry_class)
			user.apply_damage(60, STAMINA)
		if(W.w_class == parry_class-1 || W.w_class == parry_class+1)
			user.apply_damage(30, STAMINA)
		else
			user.apply_damage(10, STAMINA)
		user.do_attack_animation(src)
		visible_message("<span class='danger'>[src] parries the attack!</span>", "<span class='danger'>You parry the attack!</span>")
		playsound(src, 'code/modules/wod13/sounds/parried.ogg', 70, TRUE)
		clear_parrying()
		return
	if(HAS_TRAIT(src, TRAIT_ENHANCED_MELEE_DODGE))
		apply_damage(3, STAMINA)
		user.do_attack_animation(src)
		playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
		emote("flip")
		visible_message("<span class='danger'>[src] dodges the attack!</span>", "<span class='danger'>You dodge the attack!</span>")
		return
	if(blocking)
		if(istype(W, /obj/item/melee))
			var/obj/item/melee/WEP = W
			var/obj/item/bodypart/assexing = get_bodypart("[(active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			if(istype(get_active_held_item(), /obj/item))
				var/obj/item/IT = get_active_held_item()
				if(IT.w_class >= W.w_class)
					apply_damage(10, STAMINA)
					user.do_attack_animation(src)
					playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
					visible_message("<span class='danger'>[src] blocks the attack!</span>", "<span class='danger'>You block the attack!</span>")
					if(incapacitated(TRUE, TRUE) && blocking)
						SwitchBlocking()
					return
				else
					var/hand_damage = max(WEP.force - IT.force/2, 1)
					playsound(src, WEP.hitsound, 70, TRUE)
					apply_damage(hand_damage, WEP.damtype, assexing)
					apply_damage(30, STAMINA)
					user.do_attack_animation(src)
					visible_message("<span class='warning'>[src] weakly blocks the attack!</span>", "<span class='warning'>You weakly block the attack!</span>")
					if(incapacitated(TRUE, TRUE) && blocking)
						SwitchBlocking()
					return
			else
				playsound(src, WEP.hitsound, 70, TRUE)
				apply_damage(round(WEP.force/2), WEP.damtype, assexing)
				apply_damage(30, STAMINA)
				user.do_attack_animation(src)
				visible_message("<span class='warning'>[src] blocks the attack with [gender == MALE ? "his" : "her"] bare hands!</span>", "<span class='warning'>You block the attack with your bare hands!</span>")
				if(incapacitated(TRUE, TRUE) && blocking)
					SwitchBlocking()
				return
	..()

/mob/living/carbon/human/attack_hand(mob/user)
	if(getStaminaLoss() >= 50 && blocking)
		SwitchBlocking()
	if(CheckFrenzyMove() && blocking)
		SwitchBlocking()
	if(user.a_intent == INTENT_HARM && HAS_TRAIT(src, TRAIT_ENHANCED_MELEE_DODGE))
		playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
		apply_damage(3, STAMINA)
		user.do_attack_animation(src)
		emote("flip")
		visible_message("<span class='danger'>[src] dodges the punch!</span>", "<span class='danger'>You dodge the punch!</span>")
		return
	if(user.a_intent == INTENT_HARM && blocking)
		playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
		apply_damage(10, STAMINA)
		user.do_attack_animation(src)
		visible_message("<span class='danger'>[src] blocks the punch!</span>", "<span class='danger'>You block the punch!</span>")
		if(incapacitated(TRUE, TRUE) && blocking)
			SwitchBlocking()
		return
	..()

/mob/living/carbon/human/proc/Parry(var/mob/M)
	if(!pulledby && !parrying && world.time-parry_cd >= 30 && M != src)
		parrying = M
		if(blocking)
			SwitchBlocking()
		visible_message("<span class='warning'>[src] prepares to parry [M]'s next attack.</span>", "<span class='warning'>You prepare to parry [M]'s next attack.</span>")
		playsound(src, 'code/modules/wod13/sounds/parry.ogg', 70, TRUE)
		remove_overlay(FIGHT_LAYER)
		var/mutable_appearance/parry_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "parry", -FIGHT_LAYER)
		overlays_standing[FIGHT_LAYER] = parry_overlay
		apply_overlay(FIGHT_LAYER)
		parry_cd = world.time
//		update_icon()
		spawn(10)
			clear_parrying()
	return

/mob/living/carbon/human/proc/clear_parrying()
	if(parrying)
		parrying = null
		remove_overlay(FIGHT_LAYER)
		to_chat(src, "<span class='warning'>You lower your defense.</span>")
//	update_icon()

//(source.pulledby && source.pulledby.grab_state > GRAB_PASSIVE)

/atom/movable/screen/jump
	name = "jump"
	icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	icon_state = "act_jump_off"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/jump/Click()
	var/mob/living/L = usr
	if(!L.prepared_to_jump)
		L.prepared_to_jump = TRUE
		icon_state = "act_jump_on"
		to_chat(usr, "<span class='notice'>You prepare to jump.</span>")
	else
		L.prepared_to_jump = FALSE
		icon_state = "act_jump_off"
		to_chat(usr, "<span class='notice'>You are not prepared to jump anymore.</span>")
	..()

/atom/Click()
	. = ..()
	if(isliving(usr) && usr != src)
		var/mob/living/L = usr
		if(L.prepared_to_jump)
			L.jump(src)

/atom/movable/screen/block
	name = "block"
	icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	icon_state = "act_block_off"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/block/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/BL = usr
		BL.SwitchBlocking()
	..()

/atom/movable/screen/vtm_zone
	name = "zone"
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "masquerade"
	layer = HUD_LAYER
	plane = HUD_PLANE
	alpha = 64

/atom/movable/screen/addinv
	layer = HUD_LAYER
	plane = HUD_PLANE


/atom/movable/screen/disciplines
	layer = HUD_LAYER
	plane = HUD_PLANE
	var/datum/discipline/dscpln
	var/last_discipline_click = 0
	var/last_discipline_use = 0
	var/main_state = ""
	var/active = FALSE
	var/obj/overlay/level2
	var/obj/overlay/level3
	var/obj/overlay/level4
	var/obj/overlay/level5

/atom/movable/screen/disciplines/Initialize()
	. = ..()
	level2 = new(src)
	level2.icon = 'code/modules/wod13/disciplines.dmi'
	level2.icon_state = "2"
	level2.layer = ABOVE_HUD_LAYER+5
	level2.plane = HUD_PLANE
	level3 = new(src)
	level3.icon = 'code/modules/wod13/disciplines.dmi'
	level3.icon_state = "3"
	level3.layer = ABOVE_HUD_LAYER+5
	level3.plane = HUD_PLANE
	level4 = new(src)
	level4.icon = 'code/modules/wod13/disciplines.dmi'
	level4.icon_state = "4"
	level4.layer = ABOVE_HUD_LAYER+5
	level4.plane = HUD_PLANE
	level5 = new(src)
	level5.icon = 'code/modules/wod13/disciplines.dmi'
	level5.icon_state = "5"
	level5.layer = ABOVE_HUD_LAYER+5
	level5.plane = HUD_PLANE

/atom/MouseEntered(location,control,params)
	if(isturf(src) || ismob(src) || isobj(src))
		if(loc && iscarbon(usr))
			var/mob/living/carbon/H = usr
			if(H.a_intent == INTENT_HARM)
				if(!H.IsSleeping() && !H.IsUnconscious() && !H.IsParalyzed() && !H.IsKnockdown() && !H.IsStun() && !HAS_TRAIT(H, TRAIT_RESTRAINED))
					H.face_atom(src)
					H.harm_focus = H.dir

/mob/living/carbon/Move(atom/newloc, direct, glide_size_override)
	..()
	if(a_intent == INTENT_HARM && client)
		setDir(harm_focus)
	else
		harm_focus = dir

//mob/living/Click()
//	if(ishuman(usr) && usr != src)
//		var/mob/living/carbon/human/SH = usr
//		for(var/atom/movable/screen/disciplines/DISCP in SH.hud_used.static_inventory)
//			if(DISCP)
//				if(DISCP.active)
//					DISCP.range_activate(src, SH)
//					SH.face_atom(src)
//					return
//	..()

/atom/Click(location,control,params)
/*
	if(!isobserver(usr))
		usr.client.show_popup_menus = FALSE
	else
		usr.client.show_popup_menus = TRUE
*/
	if(ishuman(usr))
		if(isopenturf(src.loc) || isopenturf(src))
			var/list/modifiers = params2list(params)
			var/mob/living/carbon/human/HUY = usr
			if(!HUY.get_active_held_item() && Adjacent(usr))
				if(LAZYACCESS(modifiers, "right"))
					var/list/shit = list()
					var/obj/item/item_to_pick
					var/turf/T
					if(isturf(src))
						T = src
					else
						T = src.loc
					for(var/obj/item/I in T)
						if(I)
							if(!I.anchored)
								shit[I.name] = I
						if(length(shit) == 1)
							item_to_pick = I
					if(length(shit) >= 2)
						var/result = input(usr, "Select the item you want to pick up.", "Pick up") as null|anything in shit
						if(result)
							item_to_pick = shit[result]
						else
							return
					if(item_to_pick)
						if(HUY.CanReach(item_to_pick))
							HUY.put_in_active_hand(item_to_pick)
						return
	..()
/*
/atom/movable/screen/disciplines/Initialize()
	. = ..()

/atom/movable/screen/disciplines/Click(location,control,params)
	var/dadelay = dscpln.delay
	if(dscpln.leveldelay)
		dadelay = dscpln.delay*dscpln.level_casting
	SEND_SOUND(usr, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, "right"))
		if(dscpln)
			if(dscpln.level > 1)
				if(dscpln.level_casting < dscpln.level)
					dscpln.level_casting = min(dscpln.level_casting+1, dscpln.level)
				else
					dscpln.level_casting = 1
			else
				dscpln.level_casting = 1
			switch(dscpln.level_casting)
				if(1)
					overlays -= level2
					overlays -= level3
					overlays -= level4
					overlays -= level5
				if(2)
					overlays |= level2
					overlays -= level3
					overlays -= level4
					overlays -= level5
				if(3)
					overlays -= level2
					overlays |= level3
					overlays -= level4
					overlays -= level5
				if(4)
					overlays -= level2
					overlays -= level3
					overlays |= level4
					overlays -= level5
				if(5)
					overlays -= level2
					overlays -= level3
					overlays -= level4
					overlays |= level5
			to_chat(usr, "[dscpln.name] [dscpln.level_casting]/[dscpln.level] - [dscpln.desc]")
		return

	if(ishuman(usr))
		var/mob/living/carbon/human/BD = usr
		if(world.time < last_discipline_click+5)
			return
		if(world.time < last_discipline_use+dadelay+5)
			return
		last_discipline_click = world.time
		if(active)
			active = FALSE
			BD.toggled = null
			icon_state = main_state
			return
		var/plus = 0
		if(HAS_TRAIT(BD, TRAIT_HUNGRY))
			plus = 1
		if(BD.bloodpool < dscpln.cost+plus)
			SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
			to_chat(BD, "<span class='warning'>You don't have enough <b>BLOOD</b> to use this discipline.</span>")
			return
		if(dscpln.ranged)
			for(var/atom/movable/screen/disciplines/DISCP in BD.hud_used.static_inventory)
				if(DISCP)
					if(DISCP.active && DISCP != src && DISCP.dscpln.ranged)
						DISCP.active = FALSE
						BD.toggled = null
						DISCP.icon_state = DISCP.main_state
			active = TRUE
			BD.toggled = src
			icon_state = "[main_state]-on"
		else if(!dscpln.ranged)
			last_discipline_use = world.time
			if(dscpln.check_activated(BD, BD))
				icon_state = "[main_state]-on"
				dscpln.activate(BD, BD)
				spawn(dadelay+BD.discipline_time_plus)
					icon_state = main_state

/atom/movable/screen/disciplines/proc/range_activate(var/mob/living/trgt, var/mob/living/carbon/human/cstr)
	var/plus = 0
	if(HAS_TRAIT(cstr, TRAIT_HUNGRY))
		plus = 1
	if(cstr.bloodpool < dscpln.cost+plus)
		icon_state = main_state
		active = FALSE
		SEND_SOUND(cstr, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(cstr, "<span class='warning'>You don't have enough <b>BLOOD</b> to use this discipline.</span>")
		return

	if(dscpln.check_activated(trgt, cstr))
		dscpln.activate(trgt, cstr)
		last_discipline_use = world.time
	active = FALSE
	icon_state = main_state
*/

/mob/living/carbon/werewolf/Life()
	. = ..()
	update_blood_hud()
	update_rage_hud()
	update_auspex_hud()



/mob/living/Initialize()
	. = ..()
	gnosis = new(src)
	gnosis.icon = 'code/modules/wod13/48x48.dmi'
	gnosis.plane = ABOVE_HUD_PLANE
	gnosis.layer = ABOVE_HUD_LAYER

/mob/living/proc/update_rage_hud()
	if(!client || !hud_used)
		return
	if(isgarou(src) || iswerewolf(src))
		if(hud_used.rage_icon)
			hud_used.rage_icon.overlays -= gnosis
			var/mob/living/carbon/C = src
			hud_used.rage_icon.icon_state = "rage[C.auspice.rage]"
			gnosis.icon_state = "gnosis[C.auspice.gnosis]"
			hud_used.rage_icon.overlays |= gnosis
		if(hud_used.auspice_icon)
			var/mob/living/carbon/C = src
			if(C.last_moon_look != 0)
				hud_used.auspice_icon.icon_state = "[GLOB.moon_state]"

/mob/living/proc/update_zone_hud()
	if(!client || !hud_used)
		return
	if(hud_used.zone_icon)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			hud_used.zone_icon.icon_state = "[V.zone_type]"
			if(V.zone_type == "elysium")
				if(!HAS_TRAIT(src, TRAIT_ELYSIUM))
					ADD_TRAIT(src, TRAIT_ELYSIUM, "elysium")
			else
				elysium_checks = 0
				if(HAS_TRAIT(src, TRAIT_ELYSIUM))
					REMOVE_TRAIT(src, TRAIT_ELYSIUM, "elysium")
