/mob/living/carbon/human/proc/check_kuei_jin_alive()
	if(iscathayan(src))
		if(mind?.dharma)
			if(mind.dharma.animated == "Yang")
				return TRUE
			else if (max_yang_chi > max_yin_chi + 2)
				return TRUE
	else
		return FALSE

	return TRUE

/mob/living/Life()
	. = ..()

	if(!iscathayan(src))
		if((yang_chi == 0 && max_yang_chi != 0) && (yang_chi == 0 && max_yang_chi != 0))
			to_chat(src, "<span clas='warning'>Your vital energies seem to disappear...</span>")
			adjustCloneLoss(5, TRUE)
		else if(yang_chi == 0 && max_yang_chi != 0)
			if(max_yin_chi != 0)
				to_chat(src, "<span clas='warning'>You lack dynamic part of life...</span>")
				adjust_bodytemperature(-15)
				adjustFireLoss(5, TRUE)
			else
				to_chat(src, "<span clas='warning'>Your vital energies seem to disappear...</span>")
				adjustCloneLoss(5, TRUE)
		else if(yin_chi == 0 && max_yin_chi != 0)
			if(max_yang_chi != 0)
				to_chat(src, "<span clas='warning'>You lack static part of life...</span>")
				adjust_bodytemperature(15)
				adjustFireLoss(5, TRUE)
			else
				to_chat(src, "<span clas='warning'>Your vital energies seem to disappear...</span>")
				adjustCloneLoss(5, TRUE)

	if(!iscathayan(src))
		if (COOLDOWN_FINISHED(src, chi_restore))
			COOLDOWN_START(src, chi_restore, 30 SECONDS)
			if(yang_chi < max_yang_chi)
				yang_chi = min(yang_chi+1, max_yang_chi)
			else if(yin_chi < max_yin_chi)
				yin_chi = min(yin_chi+1, max_yin_chi)

/datum/species/kuei_jin
	name = "Kuei-Jin"
	id = "kuei-jin"
	default_color = "FFFFFF"
	mutant_bodyparts = list("wings" = "None")
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_VIRUSIMMUNE, TRAIT_PERFECT_ATTACKER, TRAIT_NOBREATH)
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
	var/turf/fool_turf
	var/fool_fails = 0

/atom/breathing_overlay
	icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	icon_state = "drain"
	alpha = 64
	density = FALSE

/mob/living/proc/update_chi_hud()
	if(!client || !hud_used)
		return
	if(iscathayan(src))
		hud_used.yin_chi_icon.icon_state = "yin-[round((yin_chi/max_yin_chi)*12)]"
		hud_used.yang_chi_icon.icon_state = "yang-[round((yang_chi/max_yang_chi)*12)]"
		hud_used.demon_chi_icon.icon_state = "demon-[round((demon_chi/max_demon_chi)*12)]"
		if(max_yin_chi > max_yang_chi + 2)
			hud_used.imbalance_chi_icon.icon_state = "yin_imbalance"
		else if(max_yang_chi > max_yin_chi + 2)
			hud_used.imbalance_chi_icon.icon_state = "yang_imbalance"
		else
			hud_used.imbalance_chi_icon.icon_state = "base"

/atom/movable/screen/chi_pool
	name = "Chi Pool"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "base"
	layer = HUD_LAYER
	plane = HUD_PLANE
	var/image/upper_layer

/atom/movable/screen/yang_chi
	name = "Yang Chi"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "yang-0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/yin_chi
	name = "Yin Chi"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "yin-0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/imbalance_chi
	name = "Chi Imbalance"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "base"
	layer = HUD_LAYER-1
	plane = HUD_PLANE

/atom/movable/screen/demon_chi
	name = "Demon Chi"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "base"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/chi_pool/Initialize()
	. = ..()
	upper_layer = image(icon = 'code/modules/wod13/UI/chi.dmi', icon_state = "add", layer = HUD_LAYER+1)
	add_overlay(upper_layer)

/atom/movable/screen/chi_pool/Click()
	var/mob/living/C = usr
	to_chat(usr, "Yin Chi: [C.yin_chi]/[C.max_yin_chi], Yang Chi: [C.yang_chi]/[C.max_yang_chi], Demon Chi: [C.demon_chi]/[C.max_demon_chi]")

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
		var/masquerade_level = " is clueless about my presence."
		switch(host.masquerade)
			if(4)
				masquerade_level = " has some thoughts of awareness."
			if(3)
				masquerade_level = " is barely spotting the truth."
			if(2)
				masquerade_level = " is starting to know."
			if(1)
				masquerade_level = " knows me and my true nature."
			if(0)
				masquerade_level = " thinks I'm a monster and is hunting me."
		dat += "West[masquerade_level]<BR>"
		var/dharma = "I'm mindless carrion-eater!"
		switch(host.mind.dharma?.level)
			if(1)
				dharma = "I have not proved my worthiness to exist as Kuei-jin..."
			if(2 to 3)
				dharma = "I'm only at the basics of my Dharma."
			if(4 to 5)
				dharma = "I'm so enlighted I can be a guru."
			if(6)
				dharma = "I have mastered the Dharma so far!"

		dat += "[dharma]<BR>"

		dat += "The <b>[host.mind.dharma?.animated]</b> Chi Energy helps me to stay alive...<BR>"
		dat += "My P'o is [host.mind.dharma?.Po]<BR>"
		dat += "<b>Yin/Yang</b>[host.max_yin_chi]/[host.max_yang_chi]<BR>"
		dat += "<b>Hun/P'o</b>[host.mind.dharma?.Hun]/[host.max_demon_chi]<BR>"

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
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
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
	var/datum/action/reanimate_yang/YG = new()
	YG.Grant(C)
	var/datum/action/reanimate_yin/YN = new()
	YN.Grant(C)

/datum/species/kuei_jin/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	for(var/datum/action/kueijininfo/VI in C.actions)
		if(VI)
			VI.Remove(C)
	for(var/datum/action/breathe_chi/QI in C.actions)
		if(QI)
			QI.Remove(C)
	for(var/datum/action/area_chi/AI in C.actions)
		if(AI)
			AI.Remove(C)
	for(var/datum/action/reanimate_yang/YG in C.actions)
		if(YG)
			YG.Remove(C)
	for(var/datum/action/reanimate_yin/YN in C.actions)
		if(YN)
			YN.Remove(C)
	for(var/datum/action/rebalance/R in C.actions)
		if(R)
			R.Remove(C)
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

	if(H.key && (H.stat <= HARD_CRIT) && H.mind.dharma)
		var/datum/preferences/P = GLOB.preferences_datums[ckey(H.key)]
		if(P)
			if(H.mind.dharma.level < 1)
				H.enter_frenzymod()
				to_chat(H, "<span class='userdanger'>You have lost control of the P'o within you, and it has taken your body. Stay closer to your Dharma next time.</span>")
				H.ghostize(FALSE)
				P.reason_of_death = "Lost control to the P'o ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
				return
			if(P.hun != H.mind.dharma.Hun)
				P.hun = H.mind.dharma.Hun
				P.save_preferences()
				P.save_character()
			if(P.po != H.max_demon_chi)
				P.po = H.max_demon_chi
				P.save_preferences()
				P.save_character()
			if(P.yin != H.max_yin_chi)
				P.yin = H.max_yin_chi
				P.save_preferences()
				P.save_character()
			if(P.yang != H.max_yang_chi)
				P.yang = H.max_yang_chi
				P.save_preferences()
				P.save_character()
			if(P.masquerade != H.masquerade)
				P.masquerade = H.masquerade
				P.save_preferences()
				P.save_character()

		H.update_chi_hud()
		if(!H.in_frenzy)
			H.mind.dharma.Po_combat = FALSE
		if(H.demon_chi == H.max_demon_chi && H.max_demon_chi != 0 && !H.in_frenzy)
			H.rollfrenzy()

		if(H.mind.dharma.Po == "Monkey")
			if(COOLDOWN_FINISHED(H.mind.dharma, po_call))
				var/atom/trigger1
				var/atom/trigger2
				var/atom/trigger3
				for(var/obj/structure/pole/pole in view(5, H))
					if(pole)
						trigger1 = pole
				if(trigger1)
					H.mind.dharma.roll_po(trigger1, H)
					COOLDOWN_START(H.mind.dharma, po_call, 5 SECONDS)

				for(var/obj/item/toy/toy in view(5, H))
					if(toy)
						trigger2 = toy
				var/obj/item/toy/toy = locate() in H
				if (toy)
					trigger2 = toy
				if(trigger2)
					H.mind.dharma.roll_po(trigger2, H)
					COOLDOWN_START(H.mind.dharma, po_call, 5 SECONDS)

				if(trigger3)
					H.mind.dharma.roll_po(trigger3, H)
					COOLDOWN_START(H.mind.dharma, po_call, 5 SECONDS)

		if(H.mind.dharma.Po == "Fool")
			if(fool_turf != get_turf(H))
				fool_fails = 0
				fool_turf = get_turf(H)
			else
				if(H.client)
					fool_fails = fool_fails+1
					if(fool_fails >= 10)
						H.mind.dharma.roll_po(H, H)
						COOLDOWN_START(H.mind.dharma, po_call, 5 SECONDS)
						fool_fails = 0

		if(H.mind.dharma.Po == "Demon")
			if(COOLDOWN_FINISHED(H.mind.dharma, po_call))
				var/atom/trigger
				for(var/mob/living/carbon/human/hum in viewers(5, H))
					if(hum != H)
						if(hum.stat > CONSCIOUS && hum.stat < DEAD)
							trigger = hum
				if(trigger)
					H.mind.dharma.roll_po(trigger, H)
					COOLDOWN_START(H.mind.dharma, po_call, 5 SECONDS)
	H.nutrition = NUTRITION_LEVEL_START_MAX
	if((H.last_bloodpool_restore + 60 SECONDS) <= world.time)
		H.last_bloodpool_restore = world.time
		H.bloodpool = min(H.maxbloodpool, H.bloodpool+1)

/datum/action/breathe_chi
	name = "Inhale Chi"
	desc = "Get chi from a target by inhaling their breathe."
	button_icon_state = "breathe"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/cooldown = 10 SECONDS
	COOLDOWN_DECLARE(use)

/datum/action/breathe_chi/Trigger()
	if(!COOLDOWN_FINISHED(src, use))
		to_chat(usr, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, use))] to Inhale Chi again!</span>")
		return
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	COOLDOWN_START(src, use, cooldown)

	var/list/mob/living/victims_list = list()
	for (var/mob/living/adding_victim in oviewers(3, kueijin))
		victims_list += adding_victim
	if(!length(victims_list))
		to_chat(owner, "<span class='warning'>There's no one with <b>Chi</b> around...</span>")
		return

	var/mob/living/victim
	if (length(victims_list) == 1)
		victim = victims_list[1]
	else
		victim = input(owner, "Choose whose breath to inhale", "Inhale Chi") as null|anything in victims_list
	if(!victim)
		return

	drain_breath(kueijin, victim)

	button.color = "#970000"
	animate(button, color = "#ffffff", time = cooldown)

/datum/action/breathe_chi/proc/drain_breath(mob/living/carbon/human/kueijin, mob/living/victim)
	//this one is on carbon instead of living which means it needs some annoying extra code
	var/has_gnosis = FALSE
	if (iscarbon(victim))
		var/mob/living/carbon/werewolf_victim = victim
		if (werewolf_victim.auspice?.gnosis > 0)
			has_gnosis = TRUE

	//this method of feeding targets splat-specific Quintessence sources first
	if ((iskindred(victim) || isghoul(victim)) && (victim.bloodpool > 0)) //drain vitae bloodpool
		victim.bloodpool = max(0, victim.bloodpool - 1)
		kueijin.yin_chi = min(kueijin.yin_chi + 1, kueijin.max_yin_chi)
		to_chat(kueijin, "<span class='medradio'>Some bitter <b>Yin</b> Chi enters you...</span>")
	else if ((isgarou(victim) || iswerewolf(victim)) && has_gnosis) //drain gnosis
		adjust_gnosis(-1, victim, sound = TRUE)
		kueijin.yang_chi = min(kueijin.yang_chi + 1, kueijin.max_yang_chi)
		to_chat(kueijin, "<span class='engradio'>Some fiery <b>Yang</b> Chi enters you...</span>")
	else if ((victim.yin_chi > 0) || (victim.yang_chi > 0)) //normally drain chi from humans and simplemobs and kuei-jin
		if ((prob(50) || victim.yang_chi == 0) && (victim.yin_chi > 0))
			victim.yin_chi = max(0, victim.yin_chi - 1)
			kueijin.yin_chi = min(kueijin.yin_chi + 1, kueijin.max_yin_chi)
			to_chat(kueijin, "<span class='medradio'>Some <b>Yin</b> Chi enters you...</span>")
		else if ((victim.yang_chi > 0))
			victim.yang_chi = max(0, victim.yang_chi - 1)
			kueijin.yang_chi = min(kueijin.yang_chi + 1, kueijin.max_yang_chi)
			to_chat(kueijin, "<span class='engradio'>Some <b>Yang</b> Chi enters you...</span>")
	else
		return

	//it would be nice for this to be invisible at a SEE_INVISIBLE_QUINTESSENCE or SEE_INVISIBLE_SPIRITUAL level, but that can come later...
	var/atom/movable/chi_particle = new (get_turf(victim))
	chi_particle.density = FALSE
	chi_particle.anchored = TRUE
	chi_particle.icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	chi_particle.icon_state = "drain"
	var/matrix/face_kueijin = matrix()
	face_kueijin.Turn(get_angle_raw(victim.x, victim.y, 0, 0, owner.x, owner.y, 0, 0))
	chi_particle.transform = face_kueijin

	kueijin.update_chi_hud()

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), chi_particle), 3 SECONDS)

/datum/action/area_chi
	name = "Area Chi"
	desc = "Get chi from an area by injecting the tides."
	button_icon_state = "area"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/cooldown = 30 SECONDS
	COOLDOWN_DECLARE(use)

/datum/action/area_chi/Trigger()
	if(!COOLDOWN_FINISHED(src, use))
		to_chat(usr, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, use))] to gather Chi again!</span>")
		return
	if(!istype(owner, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/kueijin = usr

	to_chat(usr, "<span class='notify'>You begin to gather <b>Chi</b> from your environment...</span>")
	if (do_after(kueijin, 15 SECONDS))
		COOLDOWN_START(src, use, cooldown)
		var/area/draining_area = get_area(kueijin)
		if(draining_area.yang_chi)
			kueijin.yang_chi = min(kueijin.yang_chi + draining_area.yang_chi, kueijin.max_yang_chi)
			to_chat(kueijin, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
		if(draining_area.yin_chi)
			kueijin.yin_chi = min(kueijin.yin_chi + draining_area.yin_chi, kueijin.max_yin_chi)
			to_chat(kueijin, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")

		button.color = "#970000"
		animate(button, color = "#ffffff", time = cooldown)

/datum/action/reanimate_yin
	name = "Yin Reanimate"
	desc = "Reanimate your body with Yin Chi energy."
	button_icon_state = "yin"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/cooldown = 3 SECONDS

/datum/action/reanimate_yin/Trigger()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	if(HAS_TRAIT(owner, TRAIT_TORPOR))
		return
	if (!kueijin.yin_chi > 0)
		to_chat(kueijin, "<span class='warning'>You don't have enough Yin Chi to heal!</span>")
		return
	if (!kueijin.mind?.dharma)
		return
	if (!COOLDOWN_FINISHED(kueijin.mind.dharma, chi_heal))
		to_chat(kueijin, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(kueijin.mind.dharma, chi_heal))] before you can heal again!</span>")
		return
	COOLDOWN_START(kueijin.mind.dharma, chi_heal, cooldown)

	SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
	kueijin.visible_message("<span class='warning'>Some of [kueijin]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
	kueijin.mind.dharma?.animated = "Yin"
	kueijin.skin_tone = get_vamp_skin_color(kueijin.skin_tone)
	kueijin.dna?.species.brutemod = initial(kueijin.dna?.species.brutemod)
	kueijin.dna?.species.burnmod = initial(kueijin.dna?.species.burnmod)
	kueijin.update_body()

	for (var/i in 1 to 5)
		if(length(kueijin.all_wounds))
			var/datum/wound/wound = pick(kueijin.all_wounds)
			wound.remove_wound()

	var/obj/item/organ/eyes/eyes = kueijin.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		kueijin.adjust_blindness(-2)
		kueijin.adjust_blurriness(-2)
		eyes.applyOrganDamage(-5)

	var/obj/item/organ/brain/brain = kueijin.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.applyOrganDamage(-100)

	var/heal_level = min(kueijin.mind.dharma.level, 4)
	kueijin.heal_ordered_damage(20 * heal_level, list(OXY, STAMINA, BRUTE, TOX))
	kueijin.heal_ordered_damage(5 * heal_level, list(BURN, CLONE))
	kueijin.blood_volume = min(kueijin.blood_volume + 56, 560)
	kueijin.yin_chi = max(0, kueijin.yin_chi - 1)

	button.color = "#970000"
	animate(button, color = "#ffffff", time = cooldown)

/datum/action/reanimate_yang
	name = "Yang Reanimate"
	desc = "Reanimate your body with Yang Chi energy."
	button_icon_state = "yang"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/cooldown = 3 SECONDS

/datum/action/reanimate_yang/Trigger()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	if(HAS_TRAIT(owner, TRAIT_TORPOR))
		return
	if (!kueijin.yang_chi > 0)
		to_chat(kueijin, "<span class='warning'>You don't have enough Yang Chi to heal!</span>")
		return
	if (!kueijin.mind?.dharma)
		return
	if (!COOLDOWN_FINISHED(kueijin.mind.dharma, chi_heal))
		to_chat(kueijin, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(kueijin.mind.dharma, chi_heal))] before you can heal again!</span>")
		return
	COOLDOWN_START(kueijin.mind.dharma, chi_heal, cooldown)

	SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
	kueijin.visible_message("<span class='warning'>Some of [kueijin]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
	kueijin.mind.dharma?.animated = "Yang"
	kueijin.skin_tone = kueijin.mind.dharma?.initial_skin_color
	kueijin.dna?.species.brutemod = 1
	kueijin.dna?.species.burnmod = 0.5
	kueijin.update_body()

	for (var/i in 1 to 5)
		if(length(kueijin.all_wounds))
			var/datum/wound/wound = pick(kueijin.all_wounds)
			wound.remove_wound()

	var/obj/item/organ/eyes/eyes = kueijin.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		kueijin.adjust_blindness(-2)
		kueijin.adjust_blurriness(-2)
		eyes.applyOrganDamage(-5)

	var/obj/item/organ/brain/brain = kueijin.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.applyOrganDamage(-100)

	var/heal_level = min(kueijin.mind.dharma.level, 4)
	kueijin.heal_ordered_damage(10 * heal_level, list(OXY, STAMINA, BRUTE, TOX))
	kueijin.heal_ordered_damage(2.5 * heal_level, list(BURN, CLONE))
	kueijin.blood_volume = min(kueijin.blood_volume + 28, 560)
	kueijin.yang_chi = max(0, kueijin.yang_chi - 1)

	button.color = "#970000"
	animate(button, color = "#ffffff", time = cooldown)

/datum/action/rebalance
	name = "Rebalance"
	desc = "Rebalance Dharma virtues."
	button_icon_state = "assign"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/rebalance/Trigger()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	if(!kueijin.mind?.dharma)
		return

	var/max_limit = max(10, kueijin.mind.dharma.level * 2)
	var/max_yin = input(kueijin, "Enter the maximum of Yin your character has (from 1 to [max_limit - 1]):", "Yin/Yang") as num|null
	if(max_yin)
		max_yin = clamp(max_yin, 1, max_limit - 1)
		kueijin.max_yin_chi = max_yin
		kueijin.max_yang_chi = max_limit - max_yin
		kueijin.yin_chi = min(kueijin.yin_chi, kueijin.max_yin_chi)
		kueijin.yang_chi = min(kueijin.yang_chi, kueijin.max_yang_chi)
	var/max_hun = input(kueijin, "Enter the maximum of Hun your character has (from 1 to [max_limit-1]):", "Hun/P'o") as num|null
	if(max_hun)
		max_hun = clamp(max_hun, 1, max_limit - 1)
		kueijin.mind.dharma.Hun = max_hun
		kueijin.max_demon_chi = max_limit - max_hun
		kueijin.demon_chi = min(kueijin.demon_chi, kueijin.max_demon_chi)
