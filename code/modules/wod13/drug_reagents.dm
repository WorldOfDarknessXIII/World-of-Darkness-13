/datum/reagent/drug/methamphetamine/cocaine
	name = "Cocaine"
	description = "Reduces stun times by about 300%, speeds the user up, and allows the user to quickly recover stamina while dealing a small amount of Brain damage. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."
	reagent_state = LIQUID
	color = "#ffffff"
	overdose_threshold = 20
	addiction_threshold = 10
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/drug/methamphetamine/cocaine/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/methamphetamine)

/datum/reagent/drug/methamphetamine/cocaine/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/methamphetamine)
	..()

/datum/reagent/drug/methamphetamine/cocaine/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "tweaking", /datum/mood_event/stimulant_medium, name)
	M.AdjustStun(-40)
	M.AdjustKnockdown(-40)
	M.AdjustUnconscious(-40)
	M.AdjustParalyzed(-40)
	M.AdjustImmobilized(-40)
	M.adjustStaminaLoss(-2, 0)
	M.Jitter(2)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	..()
	. = 1

/datum/reagent/drug/methamphetamine/cocaine/overdose_process(mob/living/M)
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED) && !ismovable(M.loc))
		for(var/i in 1 to 4)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote("laugh")
	if(prob(33))
		M.visible_message("<span class='danger'>[M]'s hands flip out and flail everywhere!</span>")
		M.drop_all_held_items()
	..()
	M.adjustToxLoss(1, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, pick(0.5, 0.6, 0.7, 0.8, 0.9, 1))
	. = 1

/datum/reagent/drug/methamphetamine/cocaine/addiction_act_stage1(mob/living/M)
	M.Jitter(5)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/cocaine/addiction_act_stage2(mob/living/M)
	M.Jitter(10)
	M.Dizzy(10)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/cocaine/addiction_act_stage3(mob/living/M)
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED) && !ismovable(M.loc))
		for(var/i = 0, i < 4, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/cocaine/addiction_act_stage4(mob/living/carbon/human/M)
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED) && !ismovable(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(20)
	M.Dizzy(20)
	M.adjustToxLoss(5, 0)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1
