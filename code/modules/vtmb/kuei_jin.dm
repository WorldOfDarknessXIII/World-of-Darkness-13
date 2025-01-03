/datum/dharma
	var/name = "Path of Sniffing Good"
	var/desc = "Be cool, stay cool, play cool"
	var/level = 1
	//Lists for Tennets of the path to call on
	var/list/tennets = list("sniff")
	var/list/tennets_done = list("sniff" = 0)
	//Lists for actions which decrease the dharma
	var/list/fails = list("inhale")

	//I dunno where to stuff these so they go in dharma
	//What type of P'o
	var/Po = "Monkey"
	var/Hun = 1
	var/atom/Po_Focus
	//Is P'o doing it's thing or defending the host
	var/Po_combat = FALSE
	//Which Chi is used to animate last
	var/animated = "None"
	var/initial_skin_color = "asian1"
	var/initial_social = 1
	//For better kill code, if a person deserves death or not
	var/list/deserving = list()
	var/list/judgement = list()
	var/last_dharma_update = 0
	var/last_po_call = 0

/datum/dharma/devil_tiger
	name = "Devil Tiger (P'o)"
	desc = "This path encourages to explore your inner Demon Nature, but to never let it take full control of you. You may find enlightment in grief, torturing and exploring your body's darkest desires, but doing the opposite or letting your Po to take control of you will bring you back."
	tennets = list("grief", "torture", "desire")
	tennets_done = list("grief" = 0, "torture" = 0, "desire" = 0)
	fails = list("extinguish", "savelife", "letpo")

/datum/dharma/song_of_the_shadow
	name = "Song of the Shadow (Yin)"
	desc = "This path desires to explore the dark part of Circle, Yin. Learning the darkest knowledge, respecting dead and protecting your kind is your way to enlight. But if you fail you might find yourself falling from it."
	tennets = list("respect", "learn", "protect")
	tennets_done = list("respect" = 0, "learn" = 0, "protect" = 0)
	fails = list("letdie", "disrespect")

/datum/dharma/resplendent_crane
	name = "Resplendent Crane (Hun)"
	desc = "This path respects the justice and staying to your Mortal Nature, Hun. Preventing the grief of things and providing the justified judgement will bring you up, but if you fail to your desires - it's your fall."
	tennets = list("judgement", "extinguish")
	tennets_done = list("judgement" = 0, "extinguish" = 0)
	fails = list("killfirst", "steal", "desire")

/datum/dharma/thrashing_dragon
	name = "Thrashing Dragon (Yang)"
	desc = "This path encourages to live with the light part of Circle, Yang. Live, love and laugh, save lives, meet your friends and lovers, clean the nature and grow it like a garden. However, killing, griefing and stealing leads you to the opposite."
	tennets = list("savelife", "meet", "cleangrow")
	tennets_done = list("savelife" = 0, "meet" = 0, "cleangrow" = 0)
	fails = list("kill", "grief", "steal")

/mob/living/carbon/human/proc/check_kuei_jin_alive()
	if(iscathayan)
		if(mind.dharma)
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

/datum/dharma/proc/on_gain(var/mob/living/carbon/human/mob)
	mob.mind.dharma = src
	initial_skin_color = mob.skin_tone
	initial_social = mob.social
	var/current_animate = rand(1, 10)
	if(current_animate == 1)
		animated = "Yang"
		mob.yang_chi = max(0, mob.yang_chi-1)
		mob.dna?.species.brutemod = 1
		mob.dna?.species.burnmod = 0.5
	else
		animated = "Yin"
		mob.yin_chi = max(0, mob.yin_chi-1)
		mob.skin_tone = get_vamp_skin_color(mob.skin_tone)
		mob.social = 0
		mob.dna?.species.brutemod = initial(mob.dna?.species.brutemod)
		mob.dna?.species.burnmod = initial(mob.dna?.species.burnmod)

	if(level >= 3)
		if(!locate(/datum/action/breathe_chi) in mob.actions)
			var/datum/action/breathe_chi/breathec = new()
			breathec.Grant(mob)
	if(level >= 6)
		if(!locate(/datum/action/area_chi) in mob.actions)
			var/datum/action/area_chi/areac = new()
			areac.Grant(mob)

	mob.maxHealth = initial(mob.maxHealth)-(initial(mob.maxHealth)/4)+(initial(mob.maxHealth)/4)*((mob.physique+mob.additional_physique)+6-mob.mind?.dharma?.level)
	mob.health = mob.maxHealth

/datum/dharma/proc/align_virtues(var/mob/living/owner)
	if(level <= 0)
		return
	var/total_chi = owner.max_yin_chi+owner.max_yang_chi
	var/total_virtues = Hun+owner.max_demon_chi
	if(total_chi > level*2)
		if(owner.max_yang_chi == 1)
			owner.max_yin_chi = max(1, owner.max_yin_chi-2)
		else if(owner.max_yin_chi == 1)
			owner.max_yang_chi = max(1, owner.max_yang_chi-2)
		else
			owner.max_yang_chi = max(1, owner.max_yang_chi-1)
			owner.max_yin_chi = max(1, owner.max_yin_chi-1)
		owner.yang_chi = min(owner.yang_chi, owner.max_yang_chi)
		owner.yin_chi = min(owner.yin_chi, owner.max_yin_chi)
	if(total_chi < level*2)
		owner.max_yang_chi = min(owner.mind.dharma?.level*2-1, owner.max_yang_chi+1)
		owner.max_yin_chi = min(owner.mind.dharma?.level*2-1, owner.max_yin_chi+1)

	if(total_virtues > level*2)
		if(owner.max_demon_chi == 1)
			Hun = max(1, Hun-2)
		else if(Hun == 1)
			owner.max_demon_chi = max(1, owner.max_demon_chi-2)
		else
			owner.max_demon_chi = max(1, owner.max_demon_chi-1)
			Hun = max(1, Hun-1)
		owner.demon_chi = min(owner.demon_chi, owner.max_demon_chi)
	if(total_virtues < level*2)
		owner.max_demon_chi = min(owner.mind.dharma?.level*2-1, owner.max_demon_chi+1)
		Hun = min(owner.mind.dharma?.level*2-1, Hun+1)

/proc/update_dharma(var/mob/living/carbon/human/H, var/dot)		//PLEASE USE ONLY 1 DOT PER CHANGE OR ELSE IT MAY BREAK
	if(dot < 0)
		if(H.mind.dharma)
			if(H.mind.dharma.last_dharma_update + 15 SECONDS > world.time)
				return
			H.mind.dharma.last_dharma_update = world.time
		if(H.mind.dharma?.level > 0)
			H.mind.dharma?.level = max(0, H.mind.dharma?.level+dot)
			H.mind.dharma?.align_virtues(H)
		SEND_SOUND(H, sound('code/modules/wod13/sounds/dharma_decrease.ogg', 0, 0, 75))
		to_chat(H, "<span class='userdanger'><b>DHARMA FALLS!</b></span>")
	if(dot > 0)
		if(H.mind.dharma?.level < 6)
			H.mind.dharma?.level = min(6, H.mind.dharma?.level+dot)
			H.mind.dharma?.align_virtues(H)
		SEND_SOUND(H, sound('code/modules/wod13/sounds/dharma_increase.ogg', 0, 0, 75))
		to_chat(H, "<span class='userdanger'><b>DHARMA RISES!</b></span>")

	if(H.mind.dharma?.level < 3)
		for(var/datum/action/breathe_chi/QI in H.actions)
			if(QI)
				QI.Remove(H)
	else
		if(!locate(/datum/action/breathe_chi) in H.actions)
			var/datum/action/breathe_chi/breathec = new()
			breathec.Grant(H)
	if(H.mind.dharma?.level < 6)
		for(var/datum/action/area_chi/AI in H.actions)
			if(AI)
				AI.Remove(H)
	else
		if(!locate(/datum/action/area_chi) in H.actions)
			var/datum/action/area_chi/areac = new()
			areac.Grant(H)

	if(H.health == H.maxHealth)
		H.maxHealth = initial(H.maxHealth)-(initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*((H.physique+H.additional_physique)+6-H.mind?.dharma?.level)
		H.health = H.maxHealth
	else
		H.maxHealth =initial(H.maxHealth)-(initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*((H.physique+H.additional_physique)+6-H.mind?.dharma?.level)
		H.health = min(H.health, H.maxHealth)

/datum/dharma/proc/get_done_tennets()
	var/total = 0
	for(var/i in tennets)
		if(tennets_done[i])
			if(tennets_done[i] > 0)
				total = total+1
	return total

/proc/call_dharma(var/mod, var/mob/living/carbon/human/cathayan)
	if(cathayan)
		if(cathayan.mind.dharma)
			for(var/i in cathayan.mind.dharma.tennets)
				if(i == mod)
					if(cathayan.mind.dharma.tennets_done[i] == 0)
						cathayan.mind.dharma.tennets_done[i] = 1
						to_chat(cathayan, "<span class='help'>You find this action helping you on your path ([cathayan.mind.dharma.get_done_tennets()]/[length(cathayan.mind.dharma.tennets)]).</span>")
			for(var/i in cathayan.mind.dharma.fails)
				if(i == mod)
					to_chat(cathayan, "<span class='userdanger'>This action is against your path's philosophy.</span>")
					update_dharma(cathayan, -1)
			var/tennets_needed = length(cathayan.mind.dharma.tennets)
			var/tennets_done = 0
			for(var/i in cathayan.mind.dharma.tennets)
				if(cathayan.mind.dharma.tennets_done[i] == 1)
					tennets_done = tennets_done+1
			if(tennets_done >= tennets_needed)
				for(var/i in cathayan.mind.dharma.tennets)
					cathayan.mind.dharma.tennets_done[i] = 0
				update_dharma(cathayan, 1)

/proc/emit_po_call(var/atom/source, var/po_type)
	if(po_type)
		for(var/mob/living/carbon/human/H in viewers(6, source))
			if(H)
				if(iscathayan(H))
					if(H.mind.dharma?.Po == po_type)
						H.mind.dharma?.roll_po(source, H)

/datum/dharma/proc/roll_po(var/atom/Source, var/mob/living/carbon/human/owner)
	if(last_po_call + 5 SECONDS > world.time)
		return
	last_po_call = world.time
	Po_Focus = Source
	owner.demon_chi = min(owner.demon_chi+1, owner.max_demon_chi)
	to_chat(owner, "<span class='warning'>Some <b>DEMON</b> Chi energy fills you...</span>")

/mob/living/carbon/human/frenzystep()
	if(iscathayan(src))
		if(!mind?.dharma?.Po_combat)
			switch(mind?.dharma?.Po)
				if("Rebel")
					if(frenzy_target)
						if(get_dist(frenzy_target, src) <= 1)
							if(isliving(frenzy_target))
								var/mob/living/L = frenzy_target
								if(L.stat != DEAD)
									a_intent = INTENT_HARM
									if(last_rage_hit+5 < world.time)
										last_rage_hit = world.time
										UnarmedAttack(L)
						else
							step_to(src,frenzy_target,0)
							face_atom(frenzy_target)
				if("Legalist")
					if(mind?.dharma?.Po_Focus)
						if(prob(5))
							say(pick("Kneel to me!", "Obey my orders!", "I command you!"))
							point_at(mind?.dharma?.Po_Focus)
						if(get_dist(mind?.dharma?.Po_Focus, src) <= 1)
							if(isliving(mind?.dharma?.Po_Focus))
								var/mob/living/L = mind?.dharma?.Po_Focus
								if(L.stat != DEAD)
									a_intent = INTENT_GRAB
									dropItemToGround(get_active_held_item())
									if(last_rage_hit+5 < world.time)
										last_rage_hit = world.time
										UnarmedAttack(L)
						else
							step_to(src,mind?.dharma?.Po_Focus,0)
							face_atom(mind?.dharma?.Po_Focus)
				if("Monkey")
					if(mind?.dharma?.Po_Focus)
						if(get_dist(mind?.dharma?.Po_Focus, src) <= 1)
							a_intent = INTENT_HELP
							if(!istype(get_active_held_item(), /obj/item/toy))
								dropItemToGround(get_active_held_item())
							else
								var/obj/item/toy/T = get_active_held_item()
								T.attack_self(src)
								if(prob(5))
									emote(pick("laugh", "giggle", "chuckle", "smile"))
								return
							if(last_rage_hit+50 < world.time)
								last_rage_hit = world.time
								if(istype(mind?.dharma?.Po_Focus, /obj/machinery/computer/slot_machine))
									var/obj/machinery/computer/slot_machine/slot = mind?.dharma?.Po_Focus
									for(var/obj/item/stack/dollar/D in src)
										if(D)
											slot.attackby(D, src)
									slot.spin(src)
						else
							step_to(src,mind?.dharma?.Po_Focus,0)
							face_atom(mind?.dharma?.Po_Focus)
				if("Demon")
					if(mind?.dharma?.Po_Focus)
						if(get_dist(mind?.dharma?.Po_Focus, src) <= 1)
							a_intent = INTENT_GRAB
							dropItemToGround(get_active_held_item())
							if(last_rage_hit+5 < world.time)
								last_rage_hit = world.time
								UnarmedAttack(mind?.dharma?.Po_Focus)
								if(hud_used.drinkblood_icon)
									hud_used.drinkblood_icon.bite()
						else
							step_to(src,mind?.dharma?.Po_Focus,0)
							face_atom(mind?.dharma?.Po_Focus)
				if("Fool")
					if(prob(5))
						emote(pick("cry", "scream", "groan"))
						point_at(mind?.dharma?.Po_Focus)
					resist_fire()
		else
			if(frenzy_target)
				if(get_dist(frenzy_target, src) <= 1)
					if(isliving(frenzy_target))
						var/mob/living/L = frenzy_target
						if(L.stat != DEAD)
							a_intent = INTENT_HARM
							if(last_rage_hit+5 < world.time)
								last_rage_hit = world.time
								UnarmedAttack(L)
				else
					step_to(src,frenzy_target,0)
					face_atom(frenzy_target)
	else
		. = ..()

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
				for(var/obj/structure/pole/pole in view(5, H))
					if(pole)
						H.mind.dharma.roll_po(pole, H)
				for(var/obj/item/toy/toy in view(5, H))
					if(toy)
						H.mind.dharma.roll_po(toy, H)
				for(var/obj/machinery/computer/slot_machine/slot in view(5, H))
					if(slot)
						H.mind.dharma.roll_po(slot, H)

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
				for(var/mob/living/carbon/human/hum in viewers(5, H))
					if(hum != H)
						if(hum.stat > CONSCIOUS && hum.stat < DEAD)
							H.mind.dharma.roll_po(hum, H)
	H.nutrition = NUTRITION_LEVEL_START_MAX

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
						var/atom/chi_particle = new (get_turf(victim))
						chi_particle.density = FALSE
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
		SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
		var/mob/living/carbon/human/BD = usr
		BD.visible_message("<span class='warning'>Some of [BD]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
		BD.mind.dharma?.animated = "Yin"
		BD.skin_tone = get_vamp_skin_color(BD.skin_tone)
		BD.social = 0
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
			BD.adjustFireLoss(-10*min(4, BD.mind.dharma.level), TRUE)
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
		SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
		var/mob/living/carbon/human/BD = usr
		BD.visible_message("<span class='warning'>Some of [BD]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
		BD.mind.dharma?.animated = "Yang"
		BD.skin_tone = BD.mind.dharma?.initial_skin_color
		BD.social = BD.mind.dharma?.initial_social
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
			BD.adjustBruteLoss(-10*min(4, BD.mind.dharma.level), TRUE)
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
		var/sett = input(BD, "Enter the maximum of Yin your character has:", "Yin/Yang") as num|null
		if(sett)
			sett = max(1, min(sett, max_limit-1))
			BD.max_yin_chi = sett
			BD.max_yang_chi = max_limit-sett
			BD.yin_chi = min(BD.yin_chi, BD.max_yin_chi)
			BD.yang_chi = min(BD.yang_chi, BD.max_yang_chi)
			var/sett2 = input(BD, "Enter the maximum of Hun your character has:", "Hun/P'o") as num|null
			if(sett2)
				sett2 = max(1, min(sett2, max_limit-1))
				BD.mind.dharma.Hun = sett2
				BD.max_demon_chi = max_limit-sett2
				BD.demon_chi = min(BD.demon_chi, BD.max_demon_chi)
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/datum/action/chi_discipline
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_CONSCIOUS
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi' //This is the file for the BACKGROUND icon
	background_icon_state = "discipline" //And this is the state for the background icon

	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi' //This is the file for the ACTION icon
	button_icon_state = "discipline" //And this is the state for the action icon
	vampiric = TRUE
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
	if(istype(linked_action, /datum/action/chi_discipline))
		var/list/modifiers = params2list(params)
		if(LAZYACCESS(modifiers, "right"))
			var/datum/action/chi_discipline/D = linked_action
			D.switch_level()
			return
	. = ..()

/datum/chi_discipline
	///Name of this Discipline.
	var/name = "Chi Discipline"
	///Text description of this Discipline.
	var/desc = "Discipline with powers such as..."
	///Icon for this Discipline as in disciplines.dmi
	var/icon_state
	///Cost in yin points of activating this Discipline.
	var/cost_yin = 0
	///Cost in yang points of activating this Discipline.
	var/cost_yang = 0
	///Cost in demon points of activating this Discipline.
	var/cost_demon = 0
	//Is ranged?
	var/ranged = FALSE
	///Duration of the Discipline.
	var/delay = 5
	var/next_fire_after
	///Whether this Discipline causes a Masquerade breach when used in front of mortals.
	var/violates_masquerade = FALSE
	///What rank, or how many dots the caster has in this Discipline.
	var/level = 1
	///The sound that plays when any power of this Discipline is activated.
	var/activate_sound = 'code/modules/wod13/sounds/chi_use.ogg'

	var/dead_restricted
	///What rank of this Discipline is currently being casted.
	var/level_casting = 1

/datum/chi_discipline/proc/post_gain(var/mob/living/carbon/human/H)
	return

/datum/chi_discipline/proc/check_activated(var/mob/living/target, var/mob/living/carbon/human/caster)
	if(caster.stat >= HARD_CRIT || caster.IsSleeping() || caster.IsUnconscious() || caster.IsParalyzed() || caster.IsStun() || HAS_TRAIT(caster, TRAIT_RESTRAINED) || !isturf(caster.loc))
		return FALSE
	if(world.time < next_fire_after)
		to_chat(caster, "<span class='warning'>It's too soon to use this discipline again!</span>")
		return FALSE
	if(caster.yin_chi < cost_yin)
		SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(caster, "<span class='warning'>You don't have enough <b>Yin Chi</b> to use this discipline.</span>")
		return FALSE
	if(caster.yang_chi < cost_yang)
		SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(caster, "<span class='warning'>You don't have enough <b>Yang Chi</b> to use this discipline.</span>")
		return FALSE
	if(caster.demon_chi < cost_demon)
		SEND_SOUND(caster, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
		to_chat(caster, "<span class='warning'>You don't have enough <b>Demon Chi</b> to use this discipline.</span>")
		return FALSE
	if(HAS_TRAIT(caster, TRAIT_PACIFISM))
		return FALSE
	if(target.stat == DEAD && dead_restricted)
		return FALSE
	if(target.resistant_to_disciplines || target.spell_immunity)
		to_chat(caster, "<span class='danger'>[target] resists your powers!</span>")
		return FALSE
	caster.yin_chi = max(0, caster.yin_chi-cost_yin)
	caster.yang_chi = max(0, caster.yang_chi-cost_yang)
	caster.demon_chi = max(0, caster.demon_chi-cost_demon)
	caster.update_chi_hud()
	if(ranged)
		to_chat(caster, "<span class='notice'>You activate [name] on [target].</span>")
	else
		to_chat(caster, "<span class='notice'>You activate [name].</span>")
	if(ranged)
		if(isnpc(target))
			var/mob/living/carbon/human/npc/NPC = target
			NPC.Aggro(caster, TRUE)
	if(activate_sound)
		caster.playsound_local(caster, activate_sound, 50, FALSE)
	if(violates_masquerade)
		if(caster.CheckEyewitness(target, caster, 7, TRUE))
			caster.AdjustMasquerade(-1)
	return TRUE

/datum/chi_discipline/proc/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	if(!target)
		return
	if(!caster)
		return
	next_fire_after = world.time+delay

	log_attack("[key_name(caster)] casted level [src.level_casting] of the Discipline [src.name][target == caster ? "." : " on [key_name(target)]"]")

/datum/chi_discipline/blood_shintai
	name = "Blood Shintai"
	desc = "Manipulate the liquid flow inside."
	icon_state = "blood"
	ranged = FALSE
	delay = 10 SECONDS
	cost_yin = 1
	var/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler/kuei_jin/BC

/datum/movespeed_modifier/blood_fat
	multiplicative_slowdown = 1

/datum/movespeed_modifier/necroing
	multiplicative_slowdown = 2

/datum/movespeed_modifier/wall_passing
	multiplicative_slowdown = 5

/datum/movespeed_modifier/blood_slim
	multiplicative_slowdown = -0.5

/obj/item/reagent_containers/spray/pepper/kuei_jin
	alpha = 0
	stream_mode = 1
	stream_range = 5
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/consumable/condensedcapsaicin = 30, /datum/reagent/blood = 20)

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin
	name = "blood splatter"
	desc = "Just a moving blood splatter on the floor..."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	icon_living = "floor1"
	speed = 5
	maxHealth = 100
	health = 100
	melee_damage_lower = 1
	melee_damage_upper = 1
	a_intent = INTENT_HELP
	attack_verb_continuous = "splashes"
	attack_verb_simple = "splash"

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin/Initialize()
	. = ..()
	icon_state = "floor[rand(1, 7)]"
	icon_living = "floor[rand(1, 7)]"

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin/Crossed(atom/movable/O)
	. = ..()
	if(ishuman(O))
		var/mob/living/carbon/C = O
		to_chat(C, "<span class='notice'>You slipped[ O ? " on the [O.name]" : ""]!</span>")
		playsound(C.loc, 'sound/misc/slip.ogg', 50, TRUE, -3)

		SEND_SIGNAL(C, COMSIG_ON_CARBON_SLIP)
		for(var/obj/item/I in C.held_items)
			C.accident(I)

//		var/olddir = C.dir
		C.moving_diagonally = 0 //If this was part of diagonal move slipping will stop it.
		C.Knockdown(20)

/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler/kuei_jin
	shapeshift_type = /mob/living/simple_animal/hostile/bloodcrawler/kuei_jin

/obj/item/gun/magic/blood_shintai
	name = "blood spit"
	desc = "Spit blood on your targets."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "leaper"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/blood_shintai
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/blood_shintai
	name = "blood spit"
	desc = "A spit."
	projectile_type = /obj/projectile/blood_wave
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/blood_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/projectile/blood_wave
	name = "blood wave"
	icon_state = "leaper"
	speed = 20
	animate_movement = SLIDE_STEPS
	ricochets_max = 5
	ricochet_chance = 100
	ricochet_decay_chance =1
	ricochet_decay_damage = 1

	damage = 75
	damage_type = BRUTE
	armour_penetration = 50
	range = 50
	stun = 20
	eyeblur = 20
	dismemberment = 20

	impact_effect_type = /obj/effect/temp_visual/impact_effect

	hit_stunned_targets = TRUE

/datum/chi_discipline/blood_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			var/result = alert(caster, "How do you manage your shape?",,"Shrink","Inflate")
			if(result == "Inflate")
				var/matrix/M = matrix()
				M.Scale(1.2, 1)
				var/matrix/initial = caster.transform
				animate(caster, transform = M, 1 SECONDS)
				caster.physiology.armor.melee += 20
				caster.physiology.armor.bullet += 20
				caster.add_movespeed_modifier(/datum/movespeed_modifier/blood_fat)
				spawn(delay+caster.discipline_time_plus)
					if(caster)
						animate(caster, transform = initial, 1 SECONDS)
						caster.physiology.armor.melee -= 20
						caster.physiology.armor.bullet -= 20
						caster.remove_movespeed_modifier(/datum/movespeed_modifier/blood_fat)
			else if(result == "Shrink")
				var/matrix/M = matrix()
				M.Scale(0.8, 1)
				var/matrix/initial = caster.transform
				animate(caster, transform = M, 1 SECONDS)
				caster.add_movespeed_modifier(/datum/movespeed_modifier/blood_slim)
				spawn(delay+caster.discipline_time_plus)
					if(caster)
						animate(caster, transform = initial, 1 SECONDS)
						caster.remove_movespeed_modifier(/datum/movespeed_modifier/blood_slim)
		if(2)
			playsound(get_turf(caster), 'code/modules/wod13/sounds/spit.ogg', 50, FALSE)
			spawn(1 SECONDS)
				var/obj/item/reagent_containers/spray/pepper/kuei_jin/K = new (get_turf(caster))
				K.spray(get_step(get_step(get_step(get_turf(caster), caster.dir), caster.dir), caster.dir), caster)
				qdel(K)
		if(3)
			if(!BC)
				BC = new (caster)
			BC.Shapeshift(H)
			spawn(delay+caster.discipline_time_plus)
				if(BC)
					var/mob/living/simple_animal/hostile/bloodcrawler/BD = BC.myshape
					if(BD.collected_blood > 1)
						H.adjustBruteLoss(-5*round(BD.collected_blood/2), TRUE)
						H.adjustFireLoss(-5*round(BD.collected_blood/2), TRUE)
					BC.Restore(BC.myshape)
					caster.Stun(15)
					caster.do_jitter_animation(30)
		if(4)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/gun/magic/blood_shintai(caster))
		if(5)
			var/obj/item/melee/vampirearms/katana/blood/F = new (caster)
			caster.drop_all_held_items()
			caster.put_in_active_hand(F)
			spawn(delay+caster.discipline_time_plus)
				if(F)
					qdel(F)

/datum/chi_discipline/jade_shintai
	name = "Jade Shintai"
	desc = "Manipulate own weight and capabilities."
	icon_state = "jade"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1

/obj/item/melee/powerfist/stone
	name = "stone-fist"
	desc = "A stone gauntlet to punch someone."
	item_flags = DROPDEL

/obj/item/tank/internals/oxygen/stone_shintai
	item_flags = DROPDEL
	alpha = 0

/obj/item/melee/powerfist/stone/Initialize()
	tank = new /obj/item/tank/internals/oxygen/stone_shintai()

/obj/item/melee/powerfist/stone/updateTank(obj/item/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	return FALSE

/datum/chi_discipline/jade_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			var/obj/structure/bury_pit/B = new (get_turf(caster))
			B.icon_state = "pit0"
			caster.forceMove(B)
		if(2)
			caster.pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
			caster.jade_shintai_override = 11
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.pass_flags = initial(caster.pass_flags)
					caster.jade_shintai_override = 0
		if(3)
			caster.gargoyle_pass = TRUE
			caster.alpha = 128
			caster.obfuscate_level = 3
			caster.add_movespeed_modifier(/datum/movespeed_modifier/wall_passing)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.obfuscate_level = 0
					caster.alpha = 255
					caster.gargoyle_pass = FALSE
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/wall_passing)
		if(4)
			caster.dna.species.ToggleFlight(caster)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.dna.species.ToggleFlight(caster)
		if(5)
			caster.remove_overlay(POTENCE_LAYER)
			var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "[caster.base_body_mod]rock", -POTENCE_LAYER)
			caster.overlays_standing[POTENCE_LAYER] = fortitude_overlay
			caster.apply_overlay(POTENCE_LAYER)
			caster.physiology.armor.melee += 50
			caster.physiology.armor.bullet += 50
			caster.drop_all_held_items()
			var/obj/item/melee/powerfist/stone/S1 = new (caster)
			var/obj/item/melee/powerfist/stone/S2 = new (caster)
			caster.put_in_r_hand(S1)
			caster.put_in_l_hand(S2)
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.physiology.armor.melee -= 50
					caster.physiology.armor.bullet -= 50
					caster.remove_overlay(POTENCE_LAYER)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					if(S1)
						qdel(S1)
					if(S2)
						qdel(S2)

/datum/chi_discipline/bone_shintai
	name = "Bone Shintai"
	desc = "Manipulate the matter static around."
	icon_state = "bone"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yin = 1

/obj/effect/particle_effect/smoke/bad/green/bone_shintai
	name = "green dangerous smoke"

/datum/effect_system/smoke_spread/bad/green/bone_shintai
	effect_type = /obj/effect/particle_effect/smoke/bad/green/bone_shintai

/obj/effect/particle_effect/smoke/bad/green/bone_shintai/smoke_mob(mob/living/carbon/M)
	. = ..()
	if(.)
		M.adjustToxLoss(15, TRUE)
		M.emote("cough")
		return TRUE

/obj/item/melee/vampirearms/knife/bone_shintai
	name = "claws"
	icon_state = "claws"
	w_class = WEIGHT_CLASS_BULKY
	force = 35
	armour_penetration = 100	//It's magical damage
	block_chance = 20
	item_flags = DROPDEL
	masquerade_violating = TRUE
	is_iron = FALSE

/datum/chi_discipline/bone_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			ADD_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
			ADD_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
			caster.physiology.armor.melee += 25
			caster.physiology.armor.bullet += 25
			caster.add_movespeed_modifier(/datum/movespeed_modifier/necroing)
			var/initial_limbs_id = caster.dna.species.limbs_id
			caster.dna.species.limbs_id = "rotten1"
			caster.update_body()
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
					caster.physiology.armor.melee -= 25
					caster.physiology.armor.bullet -= 25
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/necroing)
					caster.dna.species.limbs_id = initial_limbs_id
					caster.update_body()
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
		if(2)
			var/initial_hair = caster.hairstyle
			var/initial_facial = caster.facial_hairstyle
			caster.unique_body_sprite = "nothing"
			caster.hairstyle = "Bald"
			caster.facial_hairstyle = "Shaved"
			caster.update_body()
			caster.freezing_aura = TRUE
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.unique_body_sprite = null
					caster.hairstyle = initial_hair
					caster.facial_hairstyle = initial_facial
					caster.update_body()
					caster.freezing_aura = FALSE
		if(3)
			var/obj/item/melee/vampirearms/knife/bone_shintai/S1 = new (caster)
			var/obj/item/melee/vampirearms/knife/bone_shintai/S2 = new (caster)
			caster.put_in_r_hand(S1)
			caster.put_in_l_hand(S2)
			spawn(delay+caster.discipline_time_plus)
				if(S1)
					qdel(S1)
				if(S2)
					qdel(S2)
		if(4)
			playsound(get_turf(caster), 'sound/effects/smoke.ogg', 50, TRUE, -3)
			var/datum/effect_system/smoke_spread/bad/green/bone_shintai/smoke = new
			smoke.set_up(4, caster)
			smoke.start()
			qdel(smoke)
		if(5)
			ADD_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
			ADD_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
			caster.physiology.armor.melee += 25
			caster.physiology.armor.bullet += 25
			caster.unique_body_sprite = "rotten1"
			caster.update_body()
			caster.set_light(1.4,5,"#34D352")
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_NOSOFTCRIT, MAGIC_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_NOHARDCRIT, MAGIC_TRAIT)
					caster.physiology.armor.melee -= 25
					caster.physiology.armor.bullet -= 25
					caster.unique_body_sprite = null
					caster.update_body()
					caster.set_light(0)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)

/datum/chi_discipline/ghost_flame_shintai
	name = "Ghost Flame Shintai"
	desc = "Manipulate fire and temperature."
	icon_state = "ghostflame"
	ranged = FALSE
	delay = 12 SECONDS
	cost_yang = 1

/mob/living/simple_animal/hostile/beastmaster/fireball
	name = "fireball"
	desc = "FIREBALL!!"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fireball"
	icon_living = "fireball"
	del_on_death = TRUE
	attack_verb_continuous = "burns"
	attack_verb_simple = "burn"
	attack_sound = 'sound/effects/extinguish.ogg'
	speak_chance = 0
	turns_per_move = 3
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_UNDEAD
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	bloodpool = 0
	maxbloodpool = 0
	maxHealth = 30
	health = 30
	yang_chi = 1
	max_yang_chi = 1
	yin_chi = 0
	max_yin_chi = 0
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 30
	melee_damage_type = BURN
	speed = 2
	dodging = TRUE

/obj/item/gun/magic/ghostflame_shintai
	name = "fire spit"
	desc = "Spit fire on your targets."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fireball"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/ghostflame_shintai
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/ghostflame_shintai
	name = "fire spit"
	desc = "A spit."
	projectile_type = /obj/projectile/magic/aoe/fireball/firebreath
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/ghostflame_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)

/datum/chi_discipline/ghost_flame_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/limit = min(2, level) + caster.social + caster.more_companions - 1
	if(length(caster.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(caster.beastmaster)
		B.death()
	switch(level_casting)
		if(1)
			target.overlay_fullscreen("ghostflame", /atom/movable/screen/fullscreen/see_through_darkness)
			caster.set_light(1.4,5,"#ff8c00")
			caster.burning_aura = TRUE
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					target.clear_fullscreen("ghostflame", 5)
					caster.burning_aura = FALSE
					caster.set_light(0)
		if(2)
			if(!length(caster.beastmaster))
				var/datum/action/beastmaster_stay/E1 = new()
				E1.Grant(caster)
				var/datum/action/beastmaster_deaggro/E2 = new()
				E2.Grant(caster)
			var/mob/living/simple_animal/hostile/beastmaster/fireball/C = new(get_turf(caster))
			C.my_creator = caster
			caster.beastmaster |= C
			C.beastmaster = caster
		if(3)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/gun/magic/ghostflame_shintai(caster))
		if(4)
			caster.drop_all_held_items()
			var/obj/item/melee/vampirearms/katana/fire/F = new (caster)
			caster.put_in_active_hand(F)
			spawn(delay+caster.discipline_time_plus)
				if(F)
					qdel(F)
		if(5)
			caster.dna.species.burnmod = 0
			ADD_TRAIT(caster, TRAIT_PERMANENTLY_ONFIRE, MAGIC_TRAIT)
			ADD_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
			caster.set_fire_stacks(7)
			caster.IgniteMob()
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					REMOVE_TRAIT(caster, TRAIT_PERMANENTLY_ONFIRE, MAGIC_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
					caster.extinguish_mob()
					if(caster.mind.dharma)
						switch(caster.mind.dharma.animated)
							if("Yang")
								caster.dna.species.burnmod = 0.5
							if("Yin")
								caster.dna.species.burnmod = initial(caster.dna.species.burnmod)
					else
						caster.dna.species.burnmod = initial(caster.dna.species.burnmod)

/datum/chi_discipline/flesh_shintai
	name = "Flesh Shintai"
	desc = "Manipulate own flesh and flexibility."
	icon_state = "flesh"
	ranged = FALSE
	cost_yin = 1
	delay = 12 SECONDS
	var/datum/component/tackler

/obj/item/chameleon/temp
	name = "Appearance Projector"
	item_flags = DROPDEL

//obj/item/chameleon/temp/Initialize()
//	. = ..()
//	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)

//Meat Hook
/obj/item/gun/magic/hook/flesh_shintai
	name = "obviously long arm"
	ammo_type = /obj/item/ammo_casing/magic/hook/flesh_shintai
	icon_state = "hook_hand"
	icon = 'code/modules/wod13/weapons.dmi'
	inhand_icon_state = "hook_hand"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	fire_sound = 'code/modules/wod13/sounds/vicissitude.ogg'
	max_charges = 1
	item_flags = DROPDEL | NOBLUDGEON
	force = 18

/obj/item/ammo_casing/magic/hook/flesh_shintai
	name = "hand"
	desc = "A hand."
	projectile_type = /obj/projectile/flesh_shintai
	caliber = CALIBER_HOOK
	icon_state = "hook"

/obj/projectile/flesh_shintai
	name = "hand"
	icon_state = "hand"
	icon = 'code/modules/wod13/icons.dmi'
	pass_flags = PASSTABLE
	damage = 0
	stamina = 20
	hitsound = 'sound/effects/splat.ogg'
	var/chain
	var/knockdown_time = (0.5 SECONDS)

/obj/projectile/flesh_shintai/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "arm")
		if(iscathayan(firer))
			var/mob/living/carbon/human/H = firer
			if(H.CheckEyewitness(H, H, 7, FALSE))
				H.AdjustMasquerade(-1)
	..()

/obj/projectile/flesh_shintai/on_hit(atom/target)
	. = ..()
	if(ismovable(target))
		var/atom/movable/A = target
		if(A.anchored)
			return
		A.visible_message("<span class='danger'>[A] is snagged by [firer]'s hand!</span>")
		A.forceMove(get_turf(get_step_towards(firer, A)))
		if (isliving(target))
			var/mob/living/fresh_meat = target
			fresh_meat.grabbedby(firer, supress_message = FALSE)
			fresh_meat.Knockdown(knockdown_time)
			return
		//TODO: keep the chain beamed to A
		//TODO: needs a callback to delete the chain

/obj/projectile/flesh_shintai/Destroy()
	qdel(chain)
	return ..()

/obj/structure/flesh_grip
	name = "flesh grip"
	desc = "A huge flesh meat structure."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "flesh_grip"
	can_buckle = TRUE
	anchored = TRUE
	density = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/flesh_grip/user_unbuckle_mob(mob/living/buckled_mob, mob/living/carbon/human/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			M.visible_message("<span class='notice'>[user] tries to pull [M] free of [src]!</span>",\
				"<span class='notice'>[user] is trying to pull you off [src], opening up fresh wounds!</span>",\
				"<span class='hear'>You hear a squishy wet noise.</span>")
			if(!do_after(user, 300, target = src))
				if(M?.buckled)
					M.visible_message("<span class='notice'>[user] fails to free [M]!</span>",\
					"<span class='notice'>[user] fails to pull you off of [src].</span>")
				return

		else
			M.visible_message("<span class='warning'>[M] struggles to break free from [src]!</span>",\
			"<span class='notice'>You struggle to break free from [src], exacerbating your wounds! (Stay still for two minutes.)</span>",\
			"<span class='hear'>You hear a wet squishing noise..</span>")
			M.adjustBruteLoss(30)
			if(!do_after(M, 1200, target = src))
				if(M?.buckled)
					to_chat(M, "<span class='warning'>You fail to free yourself!</span>")
				return
		if(!M.buckled)
			return
		release_mob(M)

/obj/structure/flesh_grip/proc/release_mob(mob/living/M)
	var/matrix/m180 = matrix(M.transform)
	m180.Turn(180)
	animate(M, transform = m180, time = 3)
	M.pixel_y = M.base_pixel_y + PIXEL_Y_OFFSET_LYING
	M.adjustBruteLoss(30)
	src.visible_message(text("<span class='danger'>[M] falls free of [src]!</span>"))
	unbuckle_mob(M,force=1)
	M.emote("scream")
	M.AdjustParalyzed(20)

/datum/chi_discipline/flesh_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			var/obj/item/gun/magic/hook/flesh_shintai/F = new (caster)
			caster.drop_all_held_items()
			caster.put_in_active_hand(F)
			spawn(delay+caster.discipline_time_plus)
				qdel(F)
		if(2)
			caster.remove_overlay(PROTEAN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "flesh_arms", -PROTEAN_LAYER)
			caster.overlays_standing[PROTEAN_LAYER] = potence_overlay
			caster.apply_overlay(PROTEAN_LAYER)
			caster.dna.species.punchdamagelow += 20
			caster.dna.species.punchdamagehigh += 20
			caster.dna.species.meleemod += 1
			caster.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
			tackler = caster.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 2+level_casting, speed = 1, skill_mod = 0, min_distance = 0)
			caster.potential = 4
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(PROTEAN_LAYER)
					caster.potential = 0
					caster.dna.species.punchdamagelow -= 20
					caster.dna.species.punchdamagehigh -= 20
					caster.dna.species.meleemod -= 1
					caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
					qdel(tackler)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
		if(3)
			caster.flesh_shintai_dodge = TRUE
			to_chat(caster, "<span class='notice'>Your muscles relax and start moving unintentionally. You feel perfect at projectile evasion skills...</span>")
			spawn(delay+caster.discipline_time_plus)
				if(caster)
					caster.flesh_shintai_dodge = FALSE
					to_chat(caster, "<span class='warning'>Your muscles feel natural again..</span>")
		if(4)
			var/obj/structure/flesh_grip/F = new (get_turf(caster))
			if(caster.pulling)
				if(isliving(caster.pulling))
					F.buckle_mob(caster.pulling, TRUE, FALSE)
			else
				for(var/mob/living/L in range(2, caster))
					if(L != caster)
						if(L.stat != DEAD)
							F.buckle_mob(L, TRUE, FALSE)
		if(5)
			caster.drop_all_held_items()
			caster.put_in_active_hand(new /obj/item/chameleon/temp(caster))

/datum/chi_discipline/black_wind
	name = "Black Wind"
	desc = "Gain control over speed of reaction."
	icon_state = "blackwind"
	ranged = FALSE
	activate_sound = 'code/modules/wod13/sounds/celerity_activate.ogg'
	delay = 12 SECONDS
	cost_demon = 1

/datum/chi_discipline/black_wind/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(level_casting)
		if(1)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity)
					caster.celerity_visual = FALSE
		if(2)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity2)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity2)
					caster.celerity_visual = FALSE
		if(3)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity3)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity3)
					caster.celerity_visual = FALSE
		if(4)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity4)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity4)
					caster.celerity_visual = FALSE
		if(5)
			caster.add_movespeed_modifier(/datum/movespeed_modifier/celerity5)
			caster.celerity_visual = TRUE
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/celerity_deactivate.ogg', 50, FALSE)
					caster.remove_movespeed_modifier(/datum/movespeed_modifier/celerity5)
					caster.celerity_visual = FALSE

/datum/chi_discipline/demon_shintai
	name = "Demon Shintai"
	desc = "Transform into the P'o."
	icon_state = "demon"
	ranged = FALSE
	delay = 12 SECONDS
	cost_demon = 1
	var/current_form = "Samurai"

/datum/action/choose_demon_form
	name = "Choose Demon Form"
	desc = "Choose your form of a Demon."
	button_icon_state = "demon_form"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/choose_demon_form/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/BD = usr
		var/sett = input(BD, "Choose your Demon Form", "Demon Form") as null|anything in list("Samurai", "Tentacles", "Demon", "Giant", "Foul")
		if(sett)
			to_chat(BD, "Your new form is [sett].")
			for(var/datum/action/chi_discipline/C in BD.actions)
				if(C)
					if(istype(C.discipline, /datum/chi_discipline/demon_shintai))
						var/datum/chi_discipline/demon_shintai/D = C.discipline
						D.current_form = sett
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 20, loop = 1)

/datum/movespeed_modifier/tentacles1
	multiplicative_slowdown = -0.5
/datum/movespeed_modifier/tentacles2
	multiplicative_slowdown = -1

/datum/movespeed_modifier/demonform1
	multiplicative_slowdown = -0.5
/datum/movespeed_modifier/demonform2
	multiplicative_slowdown = -1
/datum/movespeed_modifier/demonform3
	multiplicative_slowdown = -2
/datum/movespeed_modifier/demonform4
	multiplicative_slowdown = -3
/datum/movespeed_modifier/demonform5
	multiplicative_slowdown = -5

/datum/chi_discipline/demon_shintai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	switch(current_form)
		if("Samurai")
			var/mod = 10*level_casting
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "samurai", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			caster.physiology.armor.melee += mod
			caster.physiology.armor.bullet += mod
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.physiology.armor.melee -= mod
					caster.physiology.armor.bullet -= mod
					caster.remove_overlay(UNICORN_LAYER)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
		if("Tentacles")
			var/mod = level_casting
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "tentacles", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			ADD_TRAIT(caster, TRAIT_SHOCKIMMUNE, SPECIES_TRAIT)
			ADD_TRAIT(caster, TRAIT_PASSTABLE, SPECIES_TRAIT)
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			if(mod > 1)
				caster.add_movespeed_modifier(/datum/movespeed_modifier/tentacles1)
				ADD_TRAIT(caster, TRAIT_PUSHIMMUNE, SPECIES_TRAIT)
				ADD_TRAIT(caster, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
			if(mod > 2)
				ADD_TRAIT(caster, TRAIT_IGNOREDAMAGESLOWDOWN, SPECIES_TRAIT)
				ADD_TRAIT(caster, TRAIT_SLEEPIMMUNE, SPECIES_TRAIT)
			if(mod > 3)
				caster.add_movespeed_modifier(/datum/movespeed_modifier/tentacles2)
			if(mod > 4)
				ADD_TRAIT(caster, TRAIT_STUNIMMUNE, SPECIES_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					REMOVE_TRAIT(caster, TRAIT_SHOCKIMMUNE, SPECIES_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_PASSTABLE, SPECIES_TRAIT)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					if(mod > 1)
						caster.remove_movespeed_modifier(/datum/movespeed_modifier/tentacles1)
						REMOVE_TRAIT(caster, TRAIT_PUSHIMMUNE, SPECIES_TRAIT)
						REMOVE_TRAIT(caster, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
					if(mod > 2)
						REMOVE_TRAIT(caster, TRAIT_IGNOREDAMAGESLOWDOWN, SPECIES_TRAIT)
						REMOVE_TRAIT(caster, TRAIT_SLEEPIMMUNE, SPECIES_TRAIT)
					if(mod > 3)
						caster.remove_movespeed_modifier(/datum/movespeed_modifier/tentacles2)
					if(mod > 4)
						REMOVE_TRAIT(caster, TRAIT_STUNIMMUNE, SPECIES_TRAIT)
		if("Demon")
			var/mod = level_casting
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "demon", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			switch(mod)
				if(1)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform1)
				if(2)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform2)
				if(3)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform3)
				if(4)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform4)
				if(5)
					caster.add_movespeed_modifier(/datum/movespeed_modifier/demonform5)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
					switch(mod)
						if(1)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform1)
						if(2)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform2)
						if(3)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform3)
						if(4)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform4)
						if(5)
							caster.remove_movespeed_modifier(/datum/movespeed_modifier/demonform5)
		if("Giant")
			var/mod = level_casting*10
			var/meleemod = level_casting*0.5
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "demon", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			caster.dna.species.punchdamagelow += mod
			caster.dna.species.punchdamagehigh += mod
			caster.dna.species.meleemod += meleemod
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					caster.dna.species.punchdamagelow -= mod
					caster.dna.species.punchdamagehigh -= mod
					caster.dna.species.meleemod -= meleemod
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
		if("Foul")
			caster.remove_overlay(UNICORN_LAYER)
			var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "foul", -UNICORN_LAYER)
			caster.overlays_standing[UNICORN_LAYER] = potence_overlay
			caster.apply_overlay(UNICORN_LAYER)
			caster.foul_aura = level_casting*5
			ADD_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
			spawn((delay)+caster.discipline_time_plus)
				if(caster)
					caster.remove_overlay(UNICORN_LAYER)
					caster.foul_aura = 0
					REMOVE_TRAIT(caster, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)

/datum/chi_discipline/hellweaving
	name = "Hellweaving"
	desc = "Translate the view of Hell to someone."
	icon_state = "hellweaving"
	ranged = TRUE
	delay = 12 SECONDS
	cost_demon = 1

/atom/movable/screen/fullscreen/yomi_world
	icon = 'icons/hud/fullscreen.dmi'
	icon_state = "hall"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/yomi_world/Initialize()
	. = ..()
	dir = pick(NORTH, EAST, WEST, SOUTH, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/effect/particle_effect/smoke/bad/yomi
	name = "dark red smoke"
	color = "#6f0000"
	opaque = FALSE

/datum/effect_system/smoke_spread/bad/yomi
	effect_type = /obj/effect/particle_effect/smoke/bad/yomi

/obj/effect/particle_effect/smoke/bad/yomi/smoke_mob(mob/living/carbon/M)
	. = ..()
	if(.)
		M.adjustCloneLoss(10, TRUE)
		M.emote(pick("scream", "groan", "cry"))
		return TRUE

/datum/movespeed_modifier/yomi_flashback
	multiplicative_slowdown = 6

/datum/chi_discipline/hellweaving/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/mypower = caster.social + caster.additional_social
	var/theirpower = target.mentality + target.additional_mentality
	if(theirpower >= mypower)
		to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to flashback!</span>")
		return
	switch(level_casting)
		if(1)
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)
		if(2)
			playsound(get_turf(target), 'code/modules/wod13/sounds/portal.ogg', 50, TRUE, -3)
			var/datum/effect_system/smoke_spread/bad/yomi/smoke = new
			smoke.set_up(2, target)
			smoke.start()
		if(3)
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)
			target.add_movespeed_modifier(/datum/movespeed_modifier/yomi_flashback)
			target.emote("cry")
			spawn(30)
				if(target)
					target.remove_movespeed_modifier(/datum/movespeed_modifier/yomi_flashback)
		if(4)
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/attack_myself_command)
				for(var/i in 1 to 20)
					addtimer(cb, (i - 1)*15)
				target.emote("scream")
				target.do_jitter_animation(30)
		if(5)
			target.emote(pick("cry", "scream", "groan"))
			target.point_at(caster)
			target.resist_fire()
			target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
			target.clear_fullscreen("yomi", 5)


/datum/chi_discipline/iron_mountain
	name = "Iron Mountain"
	desc = "Gain the stoicism and endurability of your P'o."
	icon_state = "ironmountain"
	ranged = FALSE
	activate_sound = 'code/modules/wod13/sounds/fortitude_activate.ogg'
	delay = 12 SECONDS
	cost_demon = 1

/datum/chi_discipline/iron_mountain/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/mod = level_casting
	var/armah = 15*mod
//	caster.remove_overlay(FORTITUDE_LAYER)
//	var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "mountain", -FORTITUDE_LAYER)
//	caster.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
//	caster.apply_overlay(FORTITUDE_LAYER)
	caster.physiology.armor.melee += armah
	caster.physiology.armor.bullet += armah
	spawn(delay+caster.discipline_time_plus)
		if(caster)
			caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/fortitude_deactivate.ogg', 50, FALSE)
			caster.physiology.armor.melee -= armah
			caster.physiology.armor.bullet -= armah
//			caster.remove_overlay(FORTITUDE_LAYER)

/datum/chi_discipline/kiai
	name = "Kiai"
	desc = "Manipulate reality by voice."
	icon_state = "kiai"
	ranged = TRUE
	delay = 12 SECONDS
	cost_demon = 1

/mob/living/carbon/human/proc/combat_to_caster()
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_to(src,caster,0)
		face_atom(caster)
		a_intent = INTENT_HARM
		drop_all_held_items()
		UnarmedAttack(caster)

/datum/chi_discipline/kiai/activate(var/mob/living/target, var/mob/living/carbon/human/caster)
	..()
	var/sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
	switch(caster.gender)
		if(MALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
		if(FEMALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_female.ogg'
	caster.emote("scream")
	playsound(caster.loc, sound_gender, 100, FALSE)
	var/mypower = caster.social + caster.additional_social
	var/theirpower = target.mentality + target.additional_mentality
	if(theirpower >= mypower)
		to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to affect!</span>")
		return
	switch(level_casting)
		if(1)
			target.emote(pick("shiver", "pale"))
			target.Stun(2 SECONDS)
		if(2)
			target.emote("stare")
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/combat_to_caster)
				for(var/i in 1 to 20)
					addtimer(cb, (i - 1)*15)
		if(3)
			target.emote("scream")
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/step_away_caster)
				for(var/i in 1 to 20)
					addtimer(cb, (i - 1)*15)
		if(4)
			if(prob(25))
				target.resist_fire()
			new /datum/hallucination/fire(target, TRUE)
		if(5)
			if(prob(25))
				target.resist_fire()
			new /datum/hallucination/fire(target, TRUE)
			for(var/mob/living/L in viewers(5, target))
				if(L != caster && L != target)
					if(prob(20))
						L.resist_fire()
					new /datum/hallucination/fire(L, TRUE)

/datum/chi_discipline/beast_shintai
	name = "Beast Shintai"
	desc = "Use the chi energy flow to control animals or become one."
	icon_state = "ironmountain"
	ranged = FALSE
	activate_sound = 'code/modules/wod13/sounds/fortitude_activate.ogg'
	delay = 12 SECONDS
	cost_demon = 1
