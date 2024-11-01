#define INHAND_COOLDOWN 20 SECONDS
#define HEAL_COOLDOWN 5 SECONDS
#define BURN_COOLDOWN 5 SECONDS

#define VERY_HOLY 2
#define HOLY 1
//NONE is used for 0
#define UNHOLY -1
#define VERY_UNHOLY -2

#define HOLY_HEAL 12.5
#define UNHOLY_BURN 12.5

#define STUN_DURATION 3 SECONDS
#define ADVANCE_BLOCK_DURATION 6 SECONDS

/datum/component/faith_focus
	var/obj/item/parent_item

/datum/component/faith_focus/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(attack))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(attack_self))
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(pickup))
	parent_item = parent //still can't believe this works

/datum/component/faith_focus/proc/attack(source, var/mob/living/target, var/mob/living/user)
	SIGNAL_HANDLER

	//NO SELF HEALING
	if (user == target)
		return

	var/user_holiness = get_holiness(user)
	//no miracles for the wicked
	if (user_holiness < HOLY)
		user.visible_message(
			"<span class='notice'>[usr] presses their [parent_item.name] against [target].</span>",
			"<span class='notice'>You press your [parent_item.name] against [target]. You feel silly.</span>"
		)
		return

	var/target_holiness = get_holiness(target)
	var/modifier = get_modifier(target, user)

	//heal normal target or hurt unholy target
	if (target_holiness >= NONE)
		heal(target, user, modifier)
	else
		harm(target, user, modifier)

/datum/component/faith_focus/proc/attack_self(source, var/mob/user)
	SIGNAL_HANDLER

	var/user_holiness = get_holiness(user)
	//no miracles for the wicked
	if (user_holiness < HOLY)
		return

/datum/component/faith_focus/proc/pickup(source, var/mob/living/taker)
	SIGNAL_HANDLER

	var/taker_holiness = get_holiness(taker)
	switch (taker_holiness)
		if (VERY_HOLY)
			to_chat(taker, "<span class='nicegreen'>Your Faith burns within you.</span>")
		if (HOLY)
			to_chat(taker, "<span class='nicegreen'>You feel safe holding a symbol of the Lord.</span>")
		if (VERY_UNHOLY)
			to_chat(taker, "<span class='danger'>Your hand burns from touching the [parent_item.name]!</span>")
			taker.apply_damage(UNHOLY_BURN * 2, BURN, taker.get_active_hand())
			spawn()
				parent_item.forceMove(taker.loc) //forces the item to be dropped

/**
 * Gets the holiness of a mob.
 *
 * Internal proc that returns a number from -2 to 2 representing how holy the given mob is,
 * with VERY_HOLY = 2, HOLY = 1, NONE = 0, UNHOLY = -1, and VERY_UNHOLY = -2.
 * This determines how much a given mob should be affected by True Faith
 * abilities, and exactly how. Holy beings are ignored or given bonuses,
 * and unholy beings are given damage or debuffs.
 *
 * * checked_mob - The mob whose holiness to check.
 */
/datum/component/faith_focus/proc/get_holiness(var/mob/living/checked_mob)
	//check if human
	if (ishuman(checked_mob))
		var/mob/living/carbon/human/checked_human = checked_mob

		//check for True Faith
		if (checked_human.mind?.holy_role >= HOLY)
			//HOLY if chaplain or hunter, VERY_HOLY if True Faith hunter
			return checked_human.mind.holy_role

		//check for vampirism or vampiric influence
		if (iskindred(checked_human) || isghoul(checked_human))
			if (checked_human.clane?.name == "Baali")
				return VERY_UNHOLY
			else
				return UNHOLY

		//check for homid werewolves
		if (isgarou(checked_human))
			return UNHOLY

	//check for werewolves in crinos or lupus form
	else if (istype(checked_mob, /mob/living/carbon/werewolf))
		return UNHOLY

	//check if hostile simplemob
	else if (istype(checked_mob, /mob/living/simple_animal/hostile))
		return UNHOLY

	return NONE //default if nothing else is found

/datum/component/faith_focus/proc/get_modifier(var/mob/living/target, var/mob/living/user)
	var/target_holiness = get_holiness(target)
	var/user_holiness = get_holiness(user)

	if (target_holiness)
		return abs(user_holiness * target_holiness)
	else
		return abs(user_holiness)

/datum/component/faith_focus/proc/heal(var/mob/living/target, var/mob/living/user, var/modifier)
	//do the actual healing
	var/healed_amount = HOLY_HEAL * modifier
	var/previous_health = target.health
	target.heal_overall_damage(healed_amount, healed_amount, healed_amount)
	target.adjustOxyLoss(-healed_amount)
	if (modifier >= VERY_HOLY)
		target.adjustToxLoss(-healed_amount * 0.5) //this is a fervent priest, not a doctor
		target.adjustOrganLoss(BRAIN, -healed_amount * 0.5)

	//build healing flavor text
	var/focus_light_text
	var/target_health_text
	var/target_shown_text
	switch (modifier)
		if (1)
			focus_light_text = "glows"
			target_shown_text = "You feel comforted."
		if (2)
			focus_light_text = "shines"
			target_shown_text = "You feel the presence of God beside you."
		if (4)
			focus_light_text = "shines like the sun"
			target_shown_text = "THE LORD IS WITH YOU."

	//apparently switch statements want "constant expressions" so I have to do this
	if (target.stat == DEAD)
		target_health_text = "They are still dead!"
	else if (target.health == previous_health)
		target_health_text = pick("They look happier.", "", "They look calmer.", "They visibly relax.", "There's a sparkle in their eyes.")
	else if (target.health <= (target.maxHealth - 1))
		target_health_text = "Their wounds knit together before your eyes!"
	else if (target.health == target.maxHealth)
		target_health_text = "They are suddenly restored to perfect physical condition!"

	//and finally, give some flavour text in chat
	user.visible_message(
		"<span class='notice'>[usr]'s [parent_item.name] [focus_light_text] as they press it against [target]. [target_health_text]</span>",
		"<span class='notice'>Your [parent_item.name] [focus_light_text] as you press it against [target]. [target_health_text]</span>"
	)

	if (target_shown_text)
		to_chat(target, "<span class='nicegreen'>[target_shown_text]</span>")

/datum/component/faith_focus/proc/harm(var/mob/living/target, var/mob/living/user, var/modifier)
	//some universal flavour text variables
	var/focus_light_text
	var/target_health_text
	var/target_shown_class
	var/target_shown_text

	//actual logic for how to affect this creecher
	if (iskindred(target)) //kindred get burnt
		var/mob/living/carbon/human/human_target = target
		var/previous_health = target.health
		target.apply_damage(UNHOLY_BURN * modifier, CLONE)

		//build holy damage flavour text
		target_shown_class = "danger"
		switch (modifier)
			if (1)
				focus_light_text = "glows with heat"
				target_shown_text = "Your flesh is charred! The Beast recoils in fear!"
			if (2)
				focus_light_text = "radiates fire"
				target_shown_text = "Your flesh is incinerated. The Lord's judgement is here."
				//human_target.rollfrenzy()
				//[Lucia] TODO: reimplement Rotschreck pending better mechanics that don't just make them bite people
			if (4)
				focus_light_text = "burns with God's fury"
				target_shown_text = "THIS IS THE DAY YOU DIE. SAY YOUR PRAYERS, FOR THEY WILL NOT BE HEARD."
				//human_target.rollfrenzy()

		//apparently switch statements want "constant expressions" so I have to do this
		if (target.health <= -100)
			target_health_text = "God's vengeance returns the last of their flesh to dust!"
		else if (target.health < 0)
			if (previous_health > 0)
				target_health_text = "Their unliving muscles slow down as fire overtakes them!"
			else
				target_health_text = "Further chunks of their flesh turn to ash!"
		else if (target.health > 0)
			target_health_text = "They hiss as it chars their flesh!"

	else if (isghoul(target)) //ghouls get the vitae burnt out of them and their blood bond purged
		var/burnt_vitae = 0
		var/original_bloodpool = target.bloodpool
		if (target.bloodpool > 1)
			if (modifier == VERY_HOLY) //True Faith loadout bonus, ghouls have a max modifier of 2 or VERY_HOLY
				target.bloodpool -= 1
				burnt_vitae += 1
			if (prob(40) && target.bloodpool > 1)
				target.bloodpool -= 1
				burnt_vitae += 1
		target.apply_damage(UNHOLY_BURN * burnt_vitae, BURN)

		//different ways this can affect the ghoul
		switch (burnt_vitae)
			if (0)
				if ((original_bloodpool == 1) && (modifier == VERY_HOLY)) //True Faith loadout only, ghouls have a max modifier of 2 or VERY_HOLY
					focus_light_text = "radiates the Lord's mercy"
					target_health_text = "They look stunned."
					target_shown_class = "nicegreen"
					target_shown_text = "Finally, freedom... You have been released from the blood bond by the power of True Faith."
					//sets them free from the blood bond
					target.remove_status_effect(STATUS_EFFECT_INLOVE)
				else
					focus_light_text = "radiates light"
					target_health_text = "They are visibly panicked."
					target_shown_class = "boldwarning"
					target_shown_text = "You feel the light of God inside you! GET IT OUT!"
			if (1)
				focus_light_text = "radiates purifying light"
				target_health_text = "They look frenzied, and much more decrepit."
				target_shown_class = "danger"
				target_shown_text = "YOUR VITAE IS BURNING! RUN OR YOU'LL LOSE EVERYTHING!"
			if (2)
				focus_light_text = "shines like the sun"
				target_health_text = "They look like they've aged ten years."
				target_shown_class = "danger"
				target_shown_text = "ESCAPE. NOW. THE NECTAR IS BEING PURGED FROM YOUR VEINS. YOU NEED TO RUN."

	else if (isgarou(target) || istype(target, /mob/living/carbon/werewolf)) //garou get their rage reduced and forced out of human form
		//mob/living/carbon accounts for all forms
		var/mob/living/carbon/garou = target
		var/burnt_rage = 0
		var/original_rage = garou.auspice.rage
		if (original_rage > 0)
			if (modifier == VERY_HOLY) //True Faith loadout bonus, garou have a maximum modifier of 2 or VERY_HOLY
				burnt_rage += 1
			if ((prob(40)) && (original_rage - burnt_rage > 0))
				burnt_rage += 1
			spawn()
				adjust_rage(-burnt_rage, garou, TRUE)

		//different ways this can affect the garou
		target_shown_class = "nicegreen"
		switch (burnt_rage)
			if (0)
				if ((original_rage == 0) && (modifier == VERY_HOLY) && (!ishuman(garou)))
					focus_light_text = "radiates the Lord's mercy"
					target_health_text = "They look oddly calm as their body contorts back into the shape of a human!"
					target_shown_text = "You feel the calmest you've been since your First Change. You don't feel the need to be anything but human."
					spawn()
						garou.transformator.trans_gender(garou, "Homid", TRUE)
				else
					focus_light_text = "glows"
					target_health_text = "They seem conflicted."
					target_shown_text = "The [parent_item.name] is attempting to purge your Rage. It feels... soothing."
			if (1)
				focus_light_text = "glows beautifully"
				target_health_text = "They seem less energetic and twitchy."
				target_shown_text = "The fury within you is silenced by the [parent_item.name]."
			if (2)
				focus_light_text = "radiates peace"
				target_health_text = "They look much calmer."
				target_shown_text = "Your Rage is deadened by the power of the [parent_item.name]. Your connection to your Garou blood is dulled."

	else if (istype(target, /mob/living/simple_animal/hostile)) //creechers die
		var/previous_health = target.health
		var/previous_stat = target.stat
		target.apply_damage(UNHOLY_BURN * modifier, BURN)

		//build holy damage flavour text
		switch (modifier)
			if (1)
				focus_light_text = "glows with heat"
			if (2)
				focus_light_text = "radiates fire"

		//apparently switch statements want "constant expressions" so I have to do this
		if (previous_stat == DEAD)
			target_health_text = "More of their dead flesh sloughs off!"
		else if (target.stat == DEAD)
			target_health_text = "God's vengeance returns the last of their flesh to dust!"
		else if (target.health < 0)
			if (previous_health > 0)
				target_health_text = "Their muscles slow down as fire overtakes them!"
			else
				target_health_text = "Further chunks of their flesh turn to ash!"
		else if (target.health > 0)
			target_health_text = "They hiss as it chars their flesh!"

	//finally, display the flavour text to bystanders, the user, and the target
	user.visible_message(
		"<span class='notice'>[user]'s [parent_item.name] [focus_light_text] as they press it against [target]. [target_health_text]</span>",
		"<span class='notice'>Your [parent_item.name] [focus_light_text] as you press it against [target]. [target_health_text]</span>"
	)

	if (target_shown_text && target_shown_class)
		to_chat(target, "<span class='[target_shown_class]'>[target_shown_text]</span>")

#undef INHAND_COOLDOWN
#undef VERY_HOLY
#undef HOLY
#undef UNHOLY
#undef VERY_UNHOLY
#undef HOLY_HEAL
#undef UNHOLY_BURN
#undef STUN_DURATION
#undef ADVANCE_BLOCK_DURATION
