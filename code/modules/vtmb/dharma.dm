/datum/dharma
	var/name = "Path of Sniffing Good"
	var/desc = "Be cool, stay cool, play cool"
	var/level = 1
	//Lists for tenets of the path to call on
	var/list/tenets = list("sniff")
	var/list/tenets_done = list("sniff" = 0)
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

	COOLDOWN_DECLARE(dharma_update)
	COOLDOWN_DECLARE(po_call)
	COOLDOWN_DECLARE(torpor_timer)
	COOLDOWN_DECLARE(chi_heal)

/datum/dharma/devil_tiger
	name = "Devil Tiger (P'o)"
	desc = "This path encourages to explore your inner Demon Nature, but to never let it take full control of you. You may find enlightment in grief, torturing and exploring your body's darkest desires, but doing the opposite or letting your Po to take control of you will bring you back."
	tenets = list("grief", "torture", "desire")
	tenets_done = list("grief" = 0, "torture" = 0, "desire" = 0)
	fails = list("extinguish", "savelife", "letpo")

/datum/dharma/song_of_the_shadow
	name = "Song of the Shadow (Yin)"
	desc = "This path desires to explore the dark part of Circle, Yin. Learning the darkest knowledge, respecting dead and protecting your kind is your way to enlight. But if you fail you might find yourself falling from it."
	tenets = list("respect", "learn", "protect")
	tenets_done = list("respect" = 0, "learn" = 0, "protect" = 0)
	fails = list("letdie", "disrespect")

/datum/dharma/resplendent_crane
	name = "Resplendent Crane (Hun)"
	desc = "This path respects the justice and staying to your Mortal Nature, Hun. Preventing the grief of things and providing the justified judgement will bring you up, but if you fail to your desires - it's your fall."
	tenets = list("judgement", "extinguish")
	tenets_done = list("judgement" = 0, "extinguish" = 0)
	fails = list("killfirst", "steal", "desire")

/datum/dharma/thrashing_dragon
	name = "Thrashing Dragon (Yang)"
	desc = "This path encourages to live with the light part of Circle, Yang. Live, love and laugh, save lives, meet your friends and lovers, clean the nature and grow it like a garden. However, killing, griefing and stealing leads you to the opposite."
	tenets = list("savelife", "meet", "cleangrow")
	tenets_done = list("savelife" = 0, "meet" = 0, "cleangrow" = 0)
	fails = list("killfirst", "extinguish")

/datum/dharma/flame_of_rising_phoenix
	name = "Flame of the Rising Phoenix (Yang+Hun)"
	desc = "This path is heretic amongst other kuei-jin, it doesn't use typical training and bases around morality. It encourages the kuei-jin to stay as close as possible to human, to the moral standards instead of High Mission. Save lives of mortals, meet the debts of mortal life and protect your fellows. But don't try to grief."
	tenets = list("savelife", "meet", "protect")
	tenets_done = list("savelife" = 0, "protect" = 0)
	fails = list("killfirst", "steal", "desire", "grief", "torture")

/datum/dharma/proc/on_gain(mob/living/carbon/human/mob)
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

	if(level >= 5)
		if(!locate(/datum/action/breathe_chi) in mob.actions)
			var/datum/action/breathe_chi/breathec = new()
			breathec.Grant(mob)
	if(level >= 6)
		if(!locate(/datum/action/area_chi) in mob.actions)
			var/datum/action/area_chi/areac = new()
			areac.Grant(mob)

/**
 * Updates virtues to new temporary and permanent ratings with a Dharma level change.
 *
 * After Dharma level is changed, also updates maximum Chi and maximum virtues according
 * to the new level's maximums. This is usually a total of 10 chi points and 10 virtues,
 * but that changes to 12 when reaching Dharma 6 and will revert back if downgraded to
 * Dharma 5.
 *
 * Arguments:
 * * owner - the mob that owns this Dharma and is being updated.
 */
/datum/dharma/proc/align_virtues(mob/living/owner)
	if(level <= 0)
		return

	var/virtue_pair_limit = max(10, level * 2)

	var/total_chi = owner.max_yin_chi + owner.max_yang_chi
	var/total_virtues = Hun + owner.max_demon_chi

	var/chi_discrepancy = virtue_pair_limit - total_chi
	var/virtue_discrepancy = virtue_pair_limit - total_virtues

	if ((chi_discrepancy == 0) && (virtue_discrepancy == 0))
		return

	owner.max_yin_chi += chi_discrepancy / 2
	owner.max_yang_chi += chi_discrepancy / 2
	owner.yin_chi = min(owner.yin_chi, owner.max_yin_chi)
	owner.yang_chi = min(owner.yang_chi, owner.max_yang_chi)

	Hun += virtue_discrepancy / 2
	owner.max_demon_chi += virtue_discrepancy / 2
	owner.demon_chi = min(owner.demon_chi, owner.max_demon_chi)

/proc/update_dharma(mob/living/carbon/human/kueijin, dot)
	if (!kueijin.mind?.dharma)
		return
	var/datum/dharma/dharma = kueijin.mind.dharma

	if(!COOLDOWN_FINISHED(dharma, dharma_update))
		return
	COOLDOWN_START(dharma, dharma_update, 15 SECONDS)

	dharma.level = clamp(dharma.level + dot, 0, 6)
	dharma.align_virtues(kueijin)

	if(dot < 0)
		SEND_SOUND(kueijin, sound('code/modules/wod13/sounds/dharma_decrease.ogg', 0, 0, 75))
		to_chat(kueijin, "<span class='userdanger'><b>DHARMA FALLS!</b></span>")
	else if(dot > 0)
		SEND_SOUND(kueijin, sound('code/modules/wod13/sounds/dharma_increase.ogg', 0, 0, 75))
		to_chat(kueijin, "<span class='userdanger'><b>DHARMA RISES!</b></span>")

	if(dharma.level < 5)
		for(var/datum/action/breathe_chi/breathe_action in kueijin.actions)
			breathe_action.Remove(kueijin)
	else if(!locate(/datum/action/breathe_chi) in kueijin.actions)
		var/datum/action/breathe_chi/breathec = new()
		breathec.Grant(kueijin)

	if(dharma.level < 6)
		for(var/datum/action/area_chi/area_action in kueijin.actions)
			area_action.Remove(kueijin)
	else if(!locate(/datum/action/area_chi) in kueijin.actions)
		var/datum/action/area_chi/areac = new()
		areac.Grant(kueijin)

	kueijin.maxHealth = initial(kueijin.maxHealth) + (initial(kueijin.maxHealth) / 4) * dharma.level

/datum/dharma/proc/get_done_tenets()
	var/total = 0
	for(var/i in tenets)
		if(tenets_done[i])
			if(tenets_done[i] > 0)
				total += 1
	return total

/proc/call_dharma(action, mob/living/carbon/human/cathayan)
	//disabled due to terrible implementation
	return

/proc/emit_po_call(atom/source, po_type)
	if(!po_type)
		return

	for(var/mob/living/carbon/human/cathayan in viewers(6, source))
		if(iscathayan(cathayan))
			if(cathayan.mind.dharma?.Po == po_type)
				cathayan.mind.dharma?.roll_po(source, cathayan)

/datum/dharma/proc/roll_po(atom/Source, mob/living/carbon/human/owner)
	if(owner.in_frenzy)
		return
	if(!COOLDOWN_FINISHED(src, po_call))
		return
	COOLDOWN_START(src, po_call, 5 SECONDS)

	Po_Focus = Source
	owner.demon_chi = min(owner.demon_chi + 1, owner.max_demon_chi)
	to_chat(owner, "<span class='warning'>Some <b>DEMON</b> Chi energy fills you...</span>")

//good luck to whoever wants to fix this thing
/mob/living/carbon/human/frenzystep()
	if(!iscathayan(src))
		return ..()

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
					else
						step_to(src, mind?.dharma?.Po_Focus, 0)
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
