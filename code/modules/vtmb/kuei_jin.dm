/mob/living/carbon/human/proc/check_kuei_jin_alive()
	if(iscathayan(src))
		if(mind?.dharma)
			if(mind.dharma.animated == "Yang")
				if(yin_chi < yang_chi+2)
					return TRUE
				else
					return FALSE
			else
				if(yang_chi > yin_chi+2)
					return TRUE
				else
					return FALSE
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
		if(yang_chi < max_yang_chi)
			if(last_chi_restore + 30 SECONDS <= world.time)
				last_chi_restore = world.time
				yang_chi = min(yang_chi+1, max_yang_chi)
		else if(yin_chi < max_yin_chi)
			if(last_chi_restore + 30 SECONDS <= world.time)
				last_chi_restore = world.time
				yin_chi = min(yin_chi+1, max_yin_chi)
		else
			last_chi_restore = world.time

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
		if(yin_chi > yang_chi+2)
			hud_used.imbalance_chi_icon.icon_state = "yin_imbalance"
		else if(yang_chi > yin_chi+2)
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
	var/datum/action/rebalance/R = new()
	R.Grant(C)

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
			if(H.mind.dharma.last_po_call + 5 SECONDS <= world.time)
				var/atom/trigger1
				var/atom/trigger2
				var/atom/trigger3
				for(var/obj/structure/pole/pole in view(5, H))
					if(pole)
						trigger1 = pole
				if(trigger1)
					H.mind.dharma.roll_po(trigger1, H)
				for(var/obj/item/toy/toy in view(5, H))
					if(toy)
						trigger2 = toy
				if(trigger2)
					H.mind.dharma.roll_po(trigger2, H)
				for(var/obj/machinery/computer/slot_machine/slot in view(5, H))
					if(slot)
						trigger3 = slot
				if(trigger3)
					H.mind.dharma.roll_po(trigger3, H)

		if(H.mind.dharma.Po == "Fool")
			if(fool_turf != get_turf(H))
				fool_fails = 0
				fool_turf = get_turf(H)
			else
				if(H.client)
					fool_fails = fool_fails+1
					if(fool_fails >= 10)
						H.mind.dharma.roll_po(H, H)
						fool_fails = 0

		if(H.mind.dharma.Po == "Demon")
			if(H.mind.dharma.last_po_call + 5 SECONDS <= world.time)
				var/atom/trigger
				for(var/mob/living/carbon/human/hum in viewers(5, H))
					if(hum != H)
						if(hum.stat > CONSCIOUS && hum.stat < DEAD)
							trigger = hum
				if(trigger)
					H.mind.dharma.roll_po(trigger, H)
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
	var/last_use = 0

/datum/action/breathe_chi/Trigger()
	if(last_use + 10 SECONDS > world.time)
		return
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/BD = usr
		last_use = world.time
		if(isliving(BD.pulling) && BD.grab_state > GRAB_PASSIVE)
			var/mob/living/L = BD.pulling
			if(!L.yin_chi)
				to_chat(owner, "<span class='warning'>It doesn't have <b>Yin Chi</b> to feed on, try some distance...</span>")
				return
			L.yin_chi = max(0, L.yin_chi-1)
			BD.yin_chi = min(BD.yin_chi+1, BD.max_yin_chi)
			L.last_chi_restore = world.time
			to_chat(BD, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")
			BD.update_chi_hud()
		else
			var/list/victims_list = list()
			for(var/mob/living/L in range(3, owner))
				if(L != owner)
					victims_list |= L
			if(!length(victims_list))
				to_chat(owner, "<span class='warning'>There's no one with <b>Chi</b> around...</span>")
				return
			else
				var/mob/living/victim = input(owner, "Choose breathe to inhale.", "Breathe Chi") as null|anything in victims_list
				if(victim)
					if(!victim.yang_chi)
						to_chat(owner, "<span class='warning'>It doesn't have <b>Yang Chi</b> to feed on, try getting closer...</span>")
						return
					else
						var/atom/movable/chi_particle = new (get_turf(victim))
						chi_particle.density = FALSE
						chi_particle.anchored = TRUE
						chi_particle.icon = 'code/modules/wod13/UI/kuei_jin.dmi'
						chi_particle.icon_state = "drain"
						var/matrix/M = matrix()
						M.Scale(1, get_dist_in_pixels(owner.x*32, owner.y*32, victim.x*32, victim.y*32)/32)
						M.Turn(get_angle_raw(victim.x, victim.y, 0, 0, owner.x, owner.y, 0, 0))
						chi_particle.transform = M
						var/sucking_chi = TRUE
						if(isanimal(victim))
							var/mob/living/simple_animal/S = victim
							if(S.mob_biotypes & MOB_UNDEAD)
								to_chat(owner, "<span class='warning'>This creature doesn't breathe cause it's <b>DEAD</b>!</span>")
								sucking_chi = FALSE
						if(victim.stat >= DEAD)
							to_chat(owner, "<span class='warning'>This creature doesn't breathe cause it's <b>DEAD</b>!</span>")
							sucking_chi = FALSE
						if(iskindred(victim))
							to_chat(owner, "<span class='warning'>This creature doesn't breathe cause it's <b>DEAD</b>!</span>")
							sucking_chi = FALSE
						if(sucking_chi)
							if(victim.yang_chi)
								victim.yang_chi = max(0, victim.yang_chi-1)
								BD.yang_chi = min(BD.yang_chi+1, BD.max_yang_chi)
								victim.last_chi_restore = world.time
								to_chat(BD, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
								BD.update_chi_hud()
							else
								to_chat(owner, "<span class='warning'>This creature doesn't have enough <b>Yang</b> Chi!</span>")
						spawn(3 SECONDS)
							qdel(chi_particle)

		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/datum/action/area_chi
	name = "Area Chi"
	desc = "Get chi from an area by injecting the tides."
	button_icon_state = "area"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/last_use = 0

/datum/action/area_chi/Trigger()
	if(last_use + 30 SECONDS > world.time)
		return
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/BD = usr
		var/area/A = get_area(BD)
		last_use = world.time
		if(A.yang_chi)
			BD.yang_chi = min(BD.yang_chi+A.yang_chi, BD.max_yang_chi)
			to_chat(BD, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
		if(A.yin_chi)
			BD.yin_chi = min(BD.yin_chi+A.yin_chi, BD.max_yin_chi)
			to_chat(BD, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")

		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/datum/action/reanimate_yin
	name = "Yin Reanimate"
	desc = "Reanimate your body with Yin Chi energy."
	button_icon_state = "yin"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE

/datum/action/reanimate_yin/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		if(HAS_TRAIT(owner, TRAIT_TORPOR))
			return
		SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
		var/mob/living/carbon/human/BD = usr
		BD.visible_message("<span class='warning'>Some of [BD]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
		BD.mind.dharma?.animated = "Yin"
		BD.skin_tone = get_vamp_skin_color(BD.skin_tone)
		BD.dna?.species.brutemod = initial(BD.dna?.species.brutemod)
		BD.dna?.species.burnmod = initial(BD.dna?.species.burnmod)
		BD.update_body()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		var/obj/item/organ/eyes/eyes = BD.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			BD.adjust_blindness(-2)
			BD.adjust_blurriness(-2)
			eyes.applyOrganDamage(-5)
		var/obj/item/organ/brain/brain = BD.getorganslot(ORGAN_SLOT_BRAIN)
		if(brain)
			brain.applyOrganDamage(-100)
		if(BD.yin_chi)
			BD.heal_overall_damage(15*min(4, BD.mind.dharma.level), 10*min(4, BD.mind.dharma.level), 20*min(4, BD.mind.dharma.level))
			BD.adjustBruteLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustFireLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustOxyLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustToxLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustCloneLoss(-5, TRUE)
			BD.blood_volume = min(BD.blood_volume + 56, 560)
		else
			BD.adjustBruteLoss(20, TRUE)
		BD.yin_chi = max(0, BD.yin_chi-1)
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/datum/action/reanimate_yang
	name = "Yang Reanimate"
	desc = "Reanimate your body with Yang Chi energy."
	button_icon_state = "yang"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE

/datum/action/reanimate_yang/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		if(HAS_TRAIT(owner, TRAIT_TORPOR))
			return
		SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
		var/mob/living/carbon/human/BD = usr
		BD.visible_message("<span class='warning'>Some of [BD]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
		BD.mind.dharma?.animated = "Yang"
		BD.skin_tone = BD.mind.dharma?.initial_skin_color
		BD.dna?.species.brutemod = 1
		BD.dna?.species.burnmod = 0.5
		BD.update_body()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		var/obj/item/organ/eyes/eyes = BD.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			BD.adjust_blindness(-2)
			BD.adjust_blurriness(-2)
			eyes.applyOrganDamage(-5)
		var/obj/item/organ/brain/brain = BD.getorganslot(ORGAN_SLOT_BRAIN)
		if(brain)
			brain.applyOrganDamage(-100)
		if(BD.yang_chi)
			BD.heal_overall_damage(15*min(4, BD.mind.dharma.level), 10*min(4, BD.mind.dharma.level), 20*min(4, BD.mind.dharma.level))
			BD.adjustBruteLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustFireLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustOxyLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustToxLoss(-20*min(4, BD.mind.dharma.level), TRUE)
			BD.adjustCloneLoss(-5, TRUE)
			BD.blood_volume = min(BD.blood_volume + 56, 560)
		else
			BD.adjustBruteLoss(10, TRUE)
		BD.yang_chi = max(0, BD.yang_chi-1)
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/datum/action/rebalance
	name = "Rebalance"
	desc = "Rebalance Dharma virtues."
	button_icon_state = "assign"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/rebalance/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/BD = usr
		var/max_limit = BD.mind.dharma.level*2
		var/sett = input(BD, "Enter the maximum of Yin your character has (from 1 to [max_limit-1]):", "Yin/Yang") as num|null
		if(sett)
			sett = max(1, min(sett, max_limit-1))
			BD.max_yin_chi = sett
			BD.max_yang_chi = max_limit-sett
			BD.yin_chi = min(BD.yin_chi, BD.max_yin_chi)
			BD.yang_chi = min(BD.yang_chi, BD.max_yang_chi)
			var/sett2 = input(BD, "Enter the maximum of Hun your character has (from 1 to [max_limit-1]):", "Hun/P'o") as num|null
			if(sett2)
				sett2 = max(1, min(sett2, max_limit-1))
				BD.mind.dharma.Hun = sett2
				BD.max_demon_chi = max_limit-sett2
				BD.demon_chi = min(BD.demon_chi, BD.max_demon_chi)
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)
