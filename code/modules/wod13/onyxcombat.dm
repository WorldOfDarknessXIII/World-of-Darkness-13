/mob/living/carbon/human/death()
	. = ..()

	if(is_kindred(src))
		SSmasquerade.dead_level = min(1000, SSmasquerade.dead_level+50)
	else
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type == "masquerade")
				SSmasquerade.dead_level = max(0, SSmasquerade.dead_level-25)

	if(bloodhunted)
		SSbloodhunt.hunted -= src
		bloodhunted = FALSE
		SSbloodhunt.update_shit()
	var/witness_count
	for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, usr))
		if(NEPIC && NEPIC.stat != DEAD)
			witness_count++
		if(witness_count > 1)
			for(var/obj/item/police_radio/radio in GLOB.police_radios)
				radio.announce_crime("murder", get_turf(src))
			for(var/obj/machinery/p25transceiver/police/radio in GLOB.p25_tranceivers)
				if(radio.p25_network == "police")
					radio.announce_crime("murder", get_turf(src))
					break
	GLOB.masquerade_breakers_list -= src
	GLOB.sabbatites -= src

	//So upon death the corpse is filled with yin chi
	yin_chi = min(max_yin_chi, yin_chi+yang_chi)
	yang_chi = 0

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
	if(CheckFrenzyMove() && blocking)
		SwitchBlocking()
	if(user.a_intent == INTENT_GRAB && ishuman(user))
		var/mob/living/carbon/human/ZIG = user
		if(ZIG.getStaminaLoss() < 50 && !ZIG.CheckFrenzyMove())
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
	if (!parrying)
		return

	parrying = null
	remove_overlay(FIGHT_LAYER)
	to_chat(src, span_warning("You lower your defense."))

/atom/movable/screen/jump
	name = "jump"
	icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	icon_state = "act_jump_off"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/jump/Click()
	var/mob/living/L = usr
	if (!L.prepared_to_jump)
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
	if (!isliving(usr) || (usr == src))
		return

	var/mob/living/L = usr
	if (!L.prepared_to_jump)
		return

	L.jump(src)

/atom/movable/screen/block
	name = "block"
	icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	icon_state = "act_block_off"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/block/Click()
	if (!ishuman(usr))
		return ..()

	var/mob/living/carbon/human/BL = usr
	BL.SwitchBlocking()

	. = ..()

/atom/movable/screen/vtm_zone
	name = "zone"
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "masquerade"
	layer = HUD_LAYER
	plane = HUD_PLANE
	alpha = 64

/atom/movable/screen/blood
	name = "bloodpool"
	icon = 'code/modules/wod13/UI/bloodpool.dmi'
	icon_state = "blood0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/addinv
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/blood/Click()
	if (!iscarbon(usr))
		return ..()

	var/mob/living/carbon/human/BD = usr
	BD.update_blood_hud()
	if (BD.bloodpool > 0)
		to_chat(BD, span_notice("You've got [BD.bloodpool]/[BD.maxbloodpool] blood points."))
	else
		to_chat(BD, span_warning("You've got [BD.bloodpool]/[BD.maxbloodpool] blood points!"))

	. = ..()

/atom/movable/screen/drinkblood
	name = "Drink Blood"
	icon = 'code/modules/wod13/disciplines.dmi'
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/drinkblood/Click()
	bite()

	. = ..()

/atom/movable/screen/drinkblood/proc/bite()
	if (!ishuman(usr))
		return
	var/mob/living/carbon/human/drinker = usr

	if (drinker.grab_state < GRAB_AGGRESSIVE)
		return
	if (!isliving(drinker.pulling))
		return
	var/mob/living/victim = drinker.pulling

	drinker.bite(victim)

/atom/MouseEntered(location,control,params)
	if (!isturf(src) && !ismob(src) && !isobj(src))
		return
	if (!loc || !iscarbon(usr))
		return
	var/mob/living/carbon/H = usr
	if(H.a_intent != INTENT_HARM)
		return
	if (H.IsSleeping() || H.IsUnconscious() || H.IsParalyzed() || H.IsKnockdown() || H.IsStun() || HAS_TRAIT(H, TRAIT_RESTRAINED))
		return

	H.face_atom(src)
	H.harm_focus = H.dir

/mob/living/carbon/Move(atom/newloc, direct, glide_size_override)
	. = ..()

	if (a_intent == INTENT_HARM && client)
		setDir(harm_focus)
	else
		harm_focus = dir

/atom/Click(location,control,params)
	if (!ishuman(usr))
		return ..()

	if (!isopenturf(src.loc) && !isopenturf(src))
		return ..()

	var/list/modifiers = params2list(params)
	var/mob/living/carbon/human/HUY = usr
	if (HUY.get_active_held_item() || !Adjacent(usr))
		return ..()

	if (!LAZYACCESS(modifiers, "right"))
		return ..()

	var/list/items_on_turf = list()
	var/obj/item/item_to_pick
	var/turf/T

	if (isturf(src))
		T = src
	else
		T = src.loc

	for (var/obj/item/I in T)
		if (!I.anchored)
			items_on_turf[I.name] = I
		if (length(items_on_turf) == 1)
			item_to_pick = I

	if (length(items_on_turf) >= 2)
		var/result = tgui_input_list(usr, "Select the item you want to pick up.", "Pick up", sortList(items_on_turf))
		if (result)
			item_to_pick = items_on_turf[result]
		else
			return

	if (item_to_pick)
		if (HUY.CanReach(item_to_pick))
			HUY.put_in_active_hand(item_to_pick)
		return

	. = ..()

/mob/living/carbon/werewolf/Life()
	. = ..()
	update_blood_hud()
	update_rage_hud()
	update_auspex_hud()

/mob/living/carbon/human/Life()
	if (!is_kindred(src) && !is_kuei_jin(src))
		if (prob(5))
			adjustCloneLoss(-5, TRUE)
	update_blood_hud()
	update_zone_hud()
	update_rage_hud()
	update_shadow()
	update_auspex_hud()

	if (!warrant)
		if (last_nonraid + 3 MINUTES < world.time)
			last_nonraid = world.time
			killed_count = max(0, killed_count-1)
		return ..()

	last_nonraid = world.time
	if (!key || (stat == DEAD))
		warrant = FALSE
		return ..()

	if (istype(get_area(src), /area/vtm))
		var/area/vtm/V = get_area(src)
		if (V.upper)
			last_showed = world.time
			if(last_raid + 60 SECONDS < world.time)
				last_raid = world.time
				for(var/turf/open/O in range(1, src))
					if(prob(25))
						new /obj/effect/temp_visual/desant(O)
				playsound(loc, 'code/modules/wod13/sounds/helicopter.ogg', 50, TRUE)

	if (last_showed + 15 MINUTES < world.time)
		to_chat(src, "<b>POLICE STOPPED SEARCHING</b>")
		SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
		killed_count = 0
		warrant = FALSE

	..()

/mob/living/Initialize()
	. = ..()
	gnosis = new(src)
	gnosis.icon = 'code/modules/wod13/48x48.dmi'
	gnosis.plane = ABOVE_HUD_PLANE
	gnosis.layer = ABOVE_HUD_LAYER

/mob/living/proc/update_rage_hud()
	if(!client || !hud_used)
		return

	var/datum/splat/werewolf/garou/lycanthropy = is_garou(src)
	if (!lycanthropy)
		return

	if (hud_used.rage_icon)
		hud_used.rage_icon.overlays -= gnosis
		hud_used.rage_icon.icon_state = "rage[lycanthropy.get_rage()]"
		gnosis.icon_state = "gnosis[lycanthropy.get_gnosis()]"
		hud_used.rage_icon.overlays |= gnosis

	if (hud_used.auspice_icon)
		if (lycanthropy.look_at_moon != 0)
			hud_used.auspice_icon.icon_state = "[GLOB.moon_state]"

/mob/living/proc/update_blood_hud()
	if (!client || !hud_used)
		return
	if (!hud_used.blood_icon)
		return

	var/percentage_full = clamp(round((bloodpool / maxbloodpool) * 10), 0, 10)
	hud_used.blood_icon.icon_state = "blood[percentage_full]"

/mob/living/proc/update_zone_hud()
	if (!client || !hud_used)
		return
	if (!hud_used.zone_icon)
		return
	if (!istype(get_area(src), /area/vtm))
		return

	var/area/vtm/current_zone = get_area(src)
	hud_used.zone_icon.icon_state = "[current_zone.zone_type]"
	if (current_zone.zone_type == "elysium")
		ADD_TRAIT(src, TRAIT_ELYSIUM, "elysium")
	else
		REMOVE_TRAIT(src, TRAIT_ELYSIUM, "elysium")
