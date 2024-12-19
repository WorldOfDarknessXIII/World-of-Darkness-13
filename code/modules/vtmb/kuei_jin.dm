/datum/dharma
	var/name = "Path of Sniffing Good"
	var/level = 1
	var/list/tennets = list("sniff")
	var/list/tennets_done = list("sniff" = 0)
	var/list/fails = list("inhale")
	var/list/fails_done = list("inhale" = 0)

	var/Po = "Monkey"
	var/animated = "None"
	var/mob/living/breathing_on
	var/atom/last_breath_on_loc

/mob/living
	var/yang_chi = 0
	var/max_yang_chi = 0
	var/yin_chi = 0
	var/max_yin_chi = 0

/mob/living/carbon/human
	var/datum/dharma/dharma

/datum/species/kuei_jin
	name = "Kuei-Jin"
	id = "kuei-jin"
	default_color = "FFFFFF"
	mutant_bodyparts = list("wings" = "None")
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_VIRUSIMMUNE, TRAIT_PERFECT_ATTACKER)
	use_skintones = TRUE
	limbs_id = "human"
	wings_icon = "None"
	mutant_bodyparts = list("tail_human" = "None", "ears" = "None", "wings" = "None")
	brutemod = 0.5
	heatmod = 1
	burnmod = 3
	dust_anim = "dust-k"
	whitelisted = TRUE
	selectable = TRUE
	var/atom/breathing_overlay/breathing_overlay

/atom/breathing_overlay
	icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	icon_state = "drain"
	alpha = 64
	density = FALSE

/mob/living/proc/update_chi_hud()
	if(!client || !hud_used)
		return
	if(iscathayan(src))
		if(hud_used.chi_icon)
			hud_used.chi_icon.overlays -= hud_used.chi_icon.yin
			hud_used.chi_icon.overlays -= hud_used.chi_icon.yang
			hud_used.chi_icon.overlays -= hud_used.chi_icon.yin_imbalance
			hud_used.chi_icon.overlays -= hud_used.chi_icon.yang_imbalance
			hud_used.chi_icon.yin.icon_state = "[round((yin_chi/max_yin_chi)*12)]"
			hud_used.chi_icon.yang.icon_state = "[round((yang_chi/max_yang_chi)*12)]"
			hud_used.chi_icon.add_overlay(hud_used.chi_icon.yin)
			hud_used.chi_icon.add_overlay(hud_used.chi_icon.yang)
			if(yin_chi > yang_chi+2)
				hud_used.chi_icon.add_overlay(hud_used.chi_icon.yin_imbalance)
			if(yang_chi > yin_chi+2)
				hud_used.chi_icon.add_overlay(hud_used.chi_icon.yang_imbalance)


/atom/movable/screen/chi_pool
	name = "Chi Pool"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "base"
	layer = HUD_LAYER
	plane = HUD_PLANE
	var/image/yin
	var/image/yang
	var/image/yin_imbalance
	var/image/yang_imbalance
	var/image/upper_layer

/atom/movable/screen/chi_pool/Initialize()
	. = ..()
	yin = image(icon = 'code/modules/wod13/UI/chi.dmi', icon_state = "yin-0")
	yang = image(icon = 'code/modules/wod13/UI/chi.dmi', icon_state = "yang-0")
	yin_imbalance = image(icon = 'code/modules/wod13/UI/chi.dmi', icon_state = "yin_imbalance", layer = HUD_LAYER-1)
	yang_imbalance = image(icon = 'code/modules/wod13/UI/chi.dmi', icon_state = "yang_imbalance", layer = HUD_LAYER-1)
	upper_layer = image(icon = 'code/modules/wod13/UI/chi.dmi', icon_state = "add", layer = HUD_LAYER+1)

/atom/movable/screen/chi_pool/Click()
	var/mob/living/C = usr
	to_chat(usr, "Yin Chi: [C.yin_chi]/[C.max_yin_chi], Yang Chi: [C.yang_chi]/[C.max_yang_chi]")

/datum/action/kueijininfo
	name = "About Me"
	desc = "Check assigned role, dharma, known disciplines, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/kueijininfo/Trigger()
	if(host)
		var/dat = {"
			<style type="text/css">

			body {
				background-color: #090909; color: white;
			}

			</style>
			"}
		dat += "<center><h2>Memories</h2><BR></center>"
		dat += "[icon2html(getFlatIcon(host), host)]I am "
		if(host.real_name)
			dat += "[host.real_name],"
		if(!host.real_name)
			dat += "Unknown,"
		dat += " the Kuei-Jin"

		if(host.mind)

			if(host.mind.assigned_role)
				if(host.mind.special_role)
					dat += ", carrying the [host.mind.assigned_role] (<font color=red>[host.mind.special_role]</font>) role."
				else
					dat += ", carrying the [host.mind.assigned_role] role."
			if(!host.mind.assigned_role)
				dat += "."
			dat += "<BR>"
		if(host.mind.special_role)
			for(var/datum/antagonist/A in host.mind.antag_datums)
				if(A.objectives)
					dat += "[printobjectives(A.objectives)]<BR>"
//		var/masquerade_level = " followed the Masquerade Tradition perfectly."
//		switch(host.masquerade)
//			if(4)
//				masquerade_level = " broke the Masquerade rule once."
//			if(3)
//				masquerade_level = " made a couple of Masquerade breaches."
//			if(2)
//				masquerade_level = " provoked a moderate Masquerade breach."
//			if(1)
//				masquerade_level = " almost ruined the Masquerade."
//			if(0)
//				masquerade_level = "'m danger to the Masquerade and my own kind."
//		dat += "Camarilla thinks I[masquerade_level]<BR>"
		var/dharma = "I'm mindless carrion-eater!"
		switch(host.dharma?.level)
			if(1)
				dharma = "I have not proved my worthiness to exist as Kuei-jin..."
			if(2 to 3)
				dharma = "I'm only at the basics of my Dharma."
			if(4 to 5)
				dharma = "I'm so enlighted I can be a guru."
			if(6)
				dharma = "I have mastered the Dharma so far!"

		dat += "[dharma]<BR>"

		dat += "<b>Physique</b>: [host.physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity]<BR>"
		dat += "<b>Social</b>: [host.social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality]<BR>"
		dat += "<b>Lockpicking</b>: [host.lockpicking]<BR>"
		dat += "<b>Athletics</b>: [host.athletics]<BR>"
		dat += "<b>Cruelty</b>: [host.blood]<BR>"
//		if(host.hud_used)
//			dat += "<b>Known disciplines:</b><BR>"
//			for(var/datum/action/discipline/D in host.actions)
//				if(D)
//					if(D.discipline)
//						dat += "[D.discipline.name] [D.discipline.level] - [D.discipline.desc]<BR>"
		if(host.Myself)
			if(host.Myself.Friend)
				if(host.Myself.Friend.owner)
					dat += "<b>My friend's name is [host.Myself.Friend.owner.true_real_name].</b><BR>"
					if(host.Myself.Friend.phone_number)
						dat += "Their number is [host.Myself.Friend.phone_number].<BR>"
					if(host.Myself.Friend.friend_text)
						dat += "[host.Myself.Friend.friend_text]<BR>"
			if(host.Myself.Enemy)
				if(host.Myself.Enemy.owner)
					dat += "<b>My nemesis is [host.Myself.Enemy.owner.true_real_name]!</b><BR>"
					if(host.Myself.Enemy.enemy_text)
						dat += "[host.Myself.Enemy.enemy_text]<BR>"
			if(host.Myself.Lover)
				if(host.Myself.Lover.owner)
					dat += "<b>I'm in love with [host.Myself.Lover.owner.true_real_name].</b><BR>"
					if(host.Myself.Lover.phone_number)
						dat += "Their number is [host.Myself.Lover.phone_number].<BR>"
					if(host.Myself.Lover.lover_text)
						dat += "[host.Myself.Lover.lover_text]<BR>"

		if(length(host.knowscontacts) > 0)
			dat += "<b>I know some other of my kind in this city. Need to check my phone, there definetely should be:</b><BR>"
			for(var/i in host.knowscontacts)
				dat += "-[i] contact<BR>"
		for(var/datum/bank_account/account in GLOB.bank_account_list)
			if(host.bank_id == account.bank_id)
				dat += "<b>My bank account code is: [account.code]</b><BR>"
		host << browse(dat, "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)

/datum/species/kuei_jin/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	C.update_body(0)
	C.last_experience = world.time + 5 MINUTES
	var/datum/action/kueijininfo/infor = new()
	infor.host = C
	infor.Grant(C)

/datum/species/kuei_jin/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	for(var/datum/action/kueijininfo/VI in C.actions)
		if(VI)
			VI.Remove(C)
	for(var/datum/action/chi_discipline/A in C.actions)
		if(A)
			A.Remove(C)

/datum/species/kuei_jin/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(istype(get_area(H), /area/vtm))
		var/area/vtm/V = get_area(H)
		if(V.zone_type == "masquerade" && V.upper)
			if(H.pulling)
				if(ishuman(H.pulling))
					var/mob/living/carbon/human/pull = H.pulling
					if(pull.stat == DEAD)
						var/obj/item/card/id/id_card = H.get_idcard(FALSE)
						if(!istype(id_card, /obj/item/card/id/clinic) && !istype(id_card, /obj/item/card/id/police) && !istype(id_card, /obj/item/card/id/sheriff) && !istype(id_card, /obj/item/card/id/prince) && !istype(id_card, /obj/item/card/id/camarilla))
							if(H.CheckEyewitness(H, H, 7, FALSE))
								if(H.last_loot_check+50 <= world.time)
									H.last_loot_check = world.time
									H.last_nonraid = world.time
									H.killed_count = H.killed_count+1
									if(!H.warrant && !H.ignores_warrant)
										if(H.killed_count >= 5)
											H.warrant = TRUE
											SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
										else
											SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (corpse)</b></span>")
			for(var/obj/item/I in H.contents)
				if(I)
					if(I.masquerade_violating)
						if(I.loc == H)
							var/obj/item/card/id/id_card = H.get_idcard(FALSE)
							if(!istype(id_card, /obj/item/card/id/clinic) && !istype(id_card, /obj/item/card/id/police) && !istype(id_card, /obj/item/card/id/sheriff) && !istype(id_card, /obj/item/card/id/prince) && !istype(id_card, /obj/item/card/id/camarilla))
								if(H.CheckEyewitness(H, H, 7, FALSE))
									if(H.last_loot_check+50 <= world.time)
										H.last_loot_check = world.time
										H.last_nonraid = world.time
										H.killed_count = H.killed_count+1
										if(!H.warrant && !H.ignores_warrant)
											if(H.killed_count >= 5)
												H.warrant = TRUE
												SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
												to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
											else
												SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
												to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (equipment)</b></span>")

	H.max_yang_chi = 3+H.dharma?.level
	H.max_yin_chi = 3+H.dharma?.level
	H.update_chi_hud()

	if(H.dharma?.breathing_on)
		if((get_dist(H, H.dharma?.breathing_on) > 3) || H.z != H.dharma?.breathing_on.z || !isturf(H.loc) || !isturf(H.dharma?.breathing_on.loc))
			H.dharma?.breathing_on = null
			H.dharma?.last_breath_on_loc = null
			if(breathing_overlay)
				QDEL_NULL(breathing_overlay)
		if(H.dharma?.breathing_on.loc != H.dharma?.last_breath_on_loc)
			H.dharma?.breathing_on = null
			H.dharma?.last_breath_on_loc = null
			if(breathing_overlay)
				QDEL_NULL(breathing_overlay)
		else
			if(breathing_overlay)
				QDEL_NULL(breathing_overlay)
			breathing_overlay = new (get_turf(H))
			var/matrix/M = matrix()
			M.Turn(get_angle_raw(H.x, H.y, 0, 0, H.dharma?.breathing_on.x, H.dharma?.breathing_on.y, 0, 0))
			M.Scale(1, (1/32)*get_dist_in_pixels(H.x*32, H.y*32, H.dharma?.breathing_on.x*32, H.dharma?.breathing_on.y*32))
			breathing_overlay.transform = M

			if(H.dharma?.breathing_on.yang_chi > 0 || H.dharma?.breathing_on.yin_chi > 0)
				if(H.dharma?.breathing_on.yang_chi > H.dharma?.breathing_on.yin_chi)
					H.dharma?.breathing_on.yang_chi = H.dharma?.breathing_on.yang_chi-1
					H.yang_chi = min(H.yang_chi+1, H.max_yang_chi)
				else
					H.dharma?.breathing_on.yin_chi = H.dharma?.breathing_on.yin_chi-1
					H.yin_chi = min(H.yin_chi+1, H.max_yin_chi)
				H.update_chi_hud()
			else
				H.dharma?.breathing_on = null
				H.dharma?.last_breath_on_loc = null
				if(breathing_overlay)
					QDEL_NULL(breathing_overlay)

/datum/action/breathe_chi
	name = "Inhale Chi"
	desc = "Get chi from a target by inhaling their breathe."
	button_icon_state = "breathe"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/breathe_chi/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/BD = usr
		var/list/victims_list = list()
		for(var/mob/living/L in range(3, owner))
			if(L)
				victims_list |= L
		if(!length(victims_list))
			to_chat(owner, "<span class='warning'>There's no one with <b>Chi</b> around...</span>")
			return
		else
			var/mob/living/victim = input(owner, "Choose breathe to inhale.", "Breathe Chi") as null|anything in victims_list
			if(victim)
				if(!victim.yin_chi && !victim.yang_chi)
					to_chat(owner, "<span class='warning'>It doesn't have <b>Chi</b> to feed on...</span>")
					return
				else
					BD.dharma?.breathing_on = victim
					BD.dharma?.last_breath_on_loc = victim.loc
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/mob/living
	var/datum/action/chi_discipline/chi_ranged

/datum/action/chi_discipline
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi' //This is the file for the BACKGROUND icon
	background_icon_state = "discipline" //And this is the state for the background icon

	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi' //This is the file for the ACTION icon
	button_icon_state = "discipline" //And this is the state for the action icon
	var/level_icon_state = "1" //And this is the state for the action icon
	var/datum/chi_discipline/discipline
	var/active_check = FALSE

/datum/action/chi_discipline/Trigger()
	if(discipline && isliving(owner))
		var/mob/living/owning = owner
		if(discipline.ranged)
			if(!active_check)
				active_check = TRUE
				if(owning.chi_ranged)
					owning.chi_ranged.Trigger()
				owning.chi_ranged = src
				if(button)
					button.color = "#970000"
			else
				active_check = FALSE
				owning.chi_ranged = null
				button.color = "#ffffff"
		else
			if(discipline)
				if(discipline.check_activated(owner, owner))
					discipline.activate(owner, owner)
	. = ..()

/datum/action/chi_discipline/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays(TRUE)
		if(discipline)
			current_button.name = discipline.name
			current_button.desc = discipline.desc
			current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.icon_state]"))
			current_button.button_icon_state = "[discipline.icon_state]"
			if(discipline.leveled)
				current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.level_casting]"))
		else
			current_button.add_overlay(mutable_appearance(icon_icon, button_icon_state))
			current_button.button_icon_state = button_icon_state

/datum/action/chi_discipline/proc/switch_level()
	SEND_SOUND(owner, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))
	if(discipline)
		if(discipline.level_casting < discipline.level)
			discipline.level_casting = discipline.level_casting+1
			if(button)
				ApplyIcon(button, TRUE)
			return
		else
			discipline.level_casting = 1
			if(button)
				ApplyIcon(button, TRUE)
			return

/mob/living/Click()
	if(isliving(usr) && usr != src)
		var/mob/living/L = usr
		if(L.chi_ranged)
			L.chi_ranged.active_check = FALSE
			if(L.chi_ranged.button)
				animate(L.chi_ranged.button, color = "#ffffff", time = 10, loop = 1)
			if(L.chi_ranged.discipline.check_activated(src, usr))
				L.chi_ranged.discipline.activate(src, usr)
			L.chi_ranged = null
	. = ..()

//			if(DISCP)
//				if(DISCP.active)
//					DISCP.range_activate(src, SH)
//					SH.face_atom(src)
//					return

/atom/movable/screen/movable/action_button/Click(location,control,params)
	if(istype(linked_action, /datum/action/discipline))
		var/list/modifiers = params2list(params)
		if(LAZYACCESS(modifiers, "right"))
			var/datum/action/discipline/D = linked_action
			D.switch_level()
			return
	. = ..()

/datum/chi_discipline
	///Name of this Discipline.
	var/name = "Vampiric Discipline"
	///Text description of this Discipline.
	var/desc = "Discipline with powers such as..."
	///Icon for this Discipline as in disciplines.dmi
	var/icon_state
	///Cost in blood points of activating this Discipline.
	var/cost = 2
	///Whether this Discipline is ranged.
	var/ranged = FALSE
	///The range from which this Discipline can be used on a target.
	var/range_sh = 8
	///Duration of the Discipline.
	var/delay = 5
	///Whether this Discipline causes a Masquerade breach when used in front of mortals.
	var/violates_masquerade = FALSE
	///What rank, or how many dots the caster has in this Discipline.
	var/level = 1
	var/leveled = TRUE
	///The sound that plays when any power of this Discipline is activated.
	var/activate_sound = 'code/modules/wod13/sounds/bloodhealing.ogg'
	///Whether this Discipline's cooldowns are multipled by the level it's being casted at.
	var/leveldelay = FALSE
	///Whether this Discipline aggroes NPC targets.
	var/fearless = FALSE

	///What rank of this Discipline is currently being casted.
	var/level_casting = 1
	///Whether this Discipline is exclusive to one Clan.
	var/clane_restricted = FALSE
	///Whether this Discipline is restricted from affecting dead people.
	var/dead_restricted = TRUE

	var/next_fire_after = 0

/datum/chi_discipline/proc/post_gain(var/mob/living/carbon/human/H)
	return

/datum/chi_discipline/proc/check_activated(var/mob/living/target, var/mob/living/carbon/human/caster)
	if(caster.stat >= HARD_CRIT || caster.IsSleeping() || caster.IsUnconscious() || caster.IsParalyzed() || caster.IsStun() || HAS_TRAIT(caster, TRAIT_RESTRAINED) || !isturf(caster.loc))
		return FALSE

/datum/chi_discipline/proc/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	if(!target)
		return
	if(!caster)
		return
