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
	//For better kill code, if a person deserves death or not
	var/list/deserving = list()
	var/list/judgement = list()
	var/last_dharma_update = 0
	var/last_po_call = 0

	COOLDOWN_DECLARE(torpor_timer)

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

/datum/dharma/flame_of_rising_phoenix
	name = "Flame of the Rising Phoenix (Yang+Hun)"
	desc = "This path is heretic amongst other kuei-jin, it doesn't use typical training and bases around morality. It encourages the kuei-jin to stay as close as possible to human, to the moral standards instead of High Mission. Save lives of mortals, meet the debts of mortal life and protect your fellows. But don't try to grief."
	tennets = list("savelife", "meet", "protect")
	tennets_done = list("savelife" = 0, "protect" = 0)
	fails = list("killfirst", "steal", "desire", "grief", "torture")

/datum/dharma/proc/on_gain(var/mob/living/carbon/human/mob)
	mob.mind.dharma = src
	initial_skin_color = mob.skin_tone
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

	mob.maxHealth = mob.maxHealth+(initial(mob.maxHealth)/4)*level
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

	if(dot > 0)
		H.maxHealth = H.maxHealth+(initial(H.maxHealth)/4)
	if(dot < 0)
		H.maxHealth = H.maxHealth-(initial(H.maxHealth)/4)

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
//			for(var/i in cathayan.mind.dharma.fails)
//				if(i == mod)
//					to_chat(cathayan, "<span class='userdanger'>This action is against your path's philosophy.</span>")
//					update_dharma(cathayan, -1)							//I was asked to remove dharma sins. Gonna be here if someone decides to get them back
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
	if(!owner.in_frenzy)
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
