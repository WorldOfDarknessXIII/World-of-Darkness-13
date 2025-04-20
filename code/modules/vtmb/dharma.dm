/datum/dharma
	var/name
	var/desc
	var/level = 1
	//Lists for tenets of the path to call on
	var/list/tenets
	//Lists for actions which decrease the dharma
	var/list/fails

/datum/dharma/devil_tiger
	name = "Devil Tiger (P'o)"
	desc = "This path encourages to explore your inner Demon Nature, but to never let it take full control of you. You may find enlightment in grief, torturing and exploring your body's darkest desires, but doing the opposite or letting your Po to take control of you will bring you back."
	tenets = list("grief", "torture", "desire")
	fails = list("extinguish", "savelife", "letpo")

/datum/dharma/song_of_the_shadow
	name = "Song of the Shadow (Yin)"
	desc = "This path desires to explore the dark part of Circle, Yin. Learning the darkest knowledge, respecting dead and protecting your kind is your way to enlight. But if you fail you might find yourself falling from it."
	tenets = list("respect", "learn", "protect")
	fails = list("letdie", "disrespect")

/datum/dharma/resplendent_crane
	name = "Resplendent Crane (Hun)"
	desc = "This path respects the justice and staying to your Mortal Nature, Hun. Preventing the grief of things and providing the justified judgement will bring you up, but if you fail to your desires - it's your fall."
	tenets = list("judgement", "extinguish")
	fails = list("killfirst", "steal", "desire")

/datum/dharma/thrashing_dragon
	name = "Thrashing Dragon (Yang)"
	desc = "This path encourages to live with the light part of Circle, Yang. Live, love and laugh, save lives, meet your friends and lovers, clean the nature and grow it like a garden. However, killing, griefing and stealing leads you to the opposite."
	tenets = list("savelife", "meet", "cleangrow")
	fails = list("killfirst", "extinguish")

/datum/dharma/flame_of_rising_phoenix
	name = "Flame of the Rising Phoenix (Yang+Hun)"
	desc = "This path is heretic amongst other kuei-jin, it doesn't use typical training and bases around morality. It encourages the kuei-jin to stay as close as possible to human, to the moral standards instead of High Mission. Save lives of mortals, meet the debts of mortal life and protect your fellows. But don't try to grief."
	tenets = list("savelife", "meet", "protect")
	fails = list("killfirst", "steal", "desire", "grief", "torture")

/proc/emit_po_call(atom/source, po_type)
	if(!po_type)
		return

	for (var/mob/living/carbon/human/cathayan in viewers(6, source))
		var/datum/splat/hungry_dead/kuei_jin/kuei_jin = is_kuei_jin(cathayan)
		if (!kuei_jin)
			return

		kuei_jin.po_trigger(source, po_type)

/mob/living/carbon/human/frenzystep()
	var/datum/splat/hungry_dead/kuei_jin/kuei_jin = is_kuei_jin(src)
	if (!kuei_jin)
		return ..()

	if (kuei_jin.po_combat)
		if (!frenzy_target)
			return

		if (get_dist(frenzy_target, src) > 1)
			step_to(src,frenzy_target,0)
			face_atom(frenzy_target)
			return

		if (!isliving(frenzy_target))
			return
		var/mob/living/target = frenzy_target
		if(target.stat == DEAD)
			return

		if ((last_rage_hit + 0.5 SECONDS) <= world.time)
			return
		last_rage_hit = world.time

		a_intent = INTENT_HARM
		UnarmedAttack(target)

		return

	switch (kuei_jin.po)
		if ("Rebel")
			if (!frenzy_target)
				return

			if (get_dist(frenzy_target, src) > 1)
				step_to(src, frenzy_target, 1)
				face_atom(frenzy_target)
				return

			if (!isliving(frenzy_target))
				return
			var/mob/living/target = frenzy_target
			if(target.stat == DEAD)
				return

			if ((last_rage_hit + 0.5 SECONDS) >= world.time)
				return
			last_rage_hit = world.time

			a_intent = INTENT_HARM
			UnarmedAttack(target)

		if ("Legalist")
			if (!kuei_jin.po_focus)
				return

			if (prob(5))
				say(pick("Kneel to me!", "Obey my orders!", "I command you!"), forced = "frenzy")
				point_at(kuei_jin.po_focus)

			if (get_dist(kuei_jin.po_focus, src) > 1)
				step_to(src, kuei_jin.po_focus, 1)
				face_atom(kuei_jin.po_focus)
				return

			if (!isliving(kuei_jin.po_focus))
				return
			var/mob/living/target = kuei_jin.po_focus
			if (target.stat == DEAD)
				return

			if (last_rage_hit + 0.5 SECONDS >= world.time)
				return
			last_rage_hit = world.time

			a_intent = INTENT_GRAB
			dropItemToGround(get_active_held_item())
			UnarmedAttack(target)

		if ("Monkey")
			if (!kuei_jin.po_focus)
				return

			if (get_dist(kuei_jin.po_focus, src) > 1)
				step_to(src, kuei_jin.po_focus, 1)
				face_atom(kuei_jin.po_focus)

			a_intent = INTENT_HELP

			if (istype(get_active_held_item(), /obj/item/toy))
				var/obj/item/toy/toy = get_active_held_item()
				toy.attack_self(src)

				if (prob(5))
					emote(pick("laugh", "giggle", "chuckle", "smile"))

				return
			else
				dropItemToGround(get_active_held_item())

			if (last_rage_hit + 5 SECONDS < world.time)
				return
			last_rage_hit = world.time

		if ("Demon")
			if (!kuei_jin.po_focus)
				return

			if (get_dist(kuei_jin.po_focus, src) > 1)
				step_to(src, kuei_jin.po_focus, 0)
				face_atom(kuei_jin.po_focus)

			a_intent = INTENT_GRAB
			dropItemToGround(get_active_held_item())

			if ((last_rage_hit + 0.5 SECONDS) >= world.time)
				return
			last_rage_hit = world.time

			UnarmedAttack(kuei_jin.po_focus)
			if (hud_used.drinkblood_icon)
				hud_used.drinkblood_icon.bite()

		if ("Fool")
			if (prob(5))
				emote(pick("cry", "scream", "groan"))
				point_at(kuei_jin.po_focus)

			resist_fire()
