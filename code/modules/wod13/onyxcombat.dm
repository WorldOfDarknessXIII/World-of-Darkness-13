/datum/preferences
	var/last_torpor = 0

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
			for(var/obj/item/p25radio/police/radio in GLOB.p25_radios)
				if(radio.linked_network == "police")
					radio.announce_crime("murder", get_turf(src))
	GLOB.masquerade_breakers_list -= src
	GLOB.sabbatites -= src

	if(is_kindred(src))
		qdel(getorganslot(ORGAN_SLOT_BRAIN)) //NO REVIVAL EVER
		if(in_frenzy)
			exit_frenzymod()
		var/years_undead = chronological_age - age
		switch (years_undead)
			if (-INFINITY to 10) //normal corpse
				return
			if (10 to 50)
				clane.rot_body(1) //skin takes on a weird colouration
				visible_message("<span class='notice'>[src]'s skin loses some of its colour.</span>")
				update_body()
				update_body() //this seems to be necessary due to stuff being set on update_body() and then only refreshing with a new call
			if (50 to 100)
				clane.rot_body(2) //looks slightly decayed
				visible_message("<span class='notice'>[src]'s skin rapidly decays.</span>")
				update_body()
				update_body()
			if (100 to 150)
				clane.rot_body(3) //looks very decayed
				visible_message("<span class='warning'>[src]'s body rapidly decomposes!</span>")
				update_body()
				update_body()
			if (150 to 200)
				clane.rot_body(4) //mummified skeletonised corpse
				visible_message("<span class='warning'>[src]'s body rapidly skeletonises!</span>")
				update_body()
				update_body()
			if (200 to INFINITY)
				playsound(src, 'code/modules/wod13/sounds/burning_death.ogg', 80, TRUE)
				SEND_SOUND(src, sound('code/modules/wod13/sounds/final_death.ogg', 0, 0, 50))
				lying_fix()
				dir = SOUTH
				spawn(1 SECONDS)
					dust(TRUE, TRUE) //turn to ash

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
		spawn(10)
			clear_parrying()
	return

/mob/living/carbon/human/proc/clear_parrying()
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

/atom/Click(location,control,params)
/mob/living/carbon/werewolf/Life()
	. = ..()
	update_blood_hud()
	update_rage_hud()
	update_auspex_hud()

/mob/living/carbon/human/Life()
	if(!is_kindred(src))
		if(prob(5))
			adjustCloneLoss(-1, TRUE)
	update_blood_hud()
	update_zone_hud()
	update_rage_hud()
	update_shadow()
	handle_vampire_music()
	update_auspex_hud()
	if(warrant)
		last_nonraid = world.time
		if(key)
			if(stat != DEAD)
				if(istype(get_area(src), /area/vtm))
					var/area/vtm/V = get_area(src)
					if(V.upper)
						last_showed = world.time
						if(last_raid+600 < world.time)
							last_raid = world.time
							for(var/turf/open/O in range(1, src))
								if(prob(25))
									new /obj/effect/temp_visual/desant(O)
							playsound(loc, 'code/modules/wod13/sounds/helicopter.ogg', 50, TRUE)
				if(last_showed+9000 < world.time)
					to_chat(src, "<b>POLICE STOPPED SEARCHING</b>")
					SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
					killed_count = 0
					warrant = FALSE
			else
				warrant = FALSE
		else
			warrant = FALSE
	else
		if(last_nonraid+1800 < world.time)
			last_nonraid = world.time
			killed_count = max(0, killed_count-1)
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
	if(is_garou(src) || iswerewolf(src))
		if(hud_used.rage_icon)
			hud_used.rage_icon.overlays -= gnosis
			var/mob/living/carbon/C = src
			hud_used.rage_icon.icon_state = "rage[C.auspice.rage]"
