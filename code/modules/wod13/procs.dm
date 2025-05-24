/mob/living/proc/AdjustHumanity(value, limit, forced)
	// Only vampires have a "working" morality system currently
	if (!iskindred(src))
		return

	// "Enlightenment" is essentially the Path of Pure Evil. Inverts Humanity changes and limits.
	var/is_enlightenment = client?.prefs?.enlightenment
	var/path = is_enlightenment ? "Enlightenment" : "Humanity"
	if (is_enlightenment && !forced)
		value = -value
		limit = 10 - limit

	// Work out actual change in Humanity
	var/new_humanity
	var/humanity_change
	if (value > 0)
		new_humanity = clamp(humanity + value, 0, limit)
		humanity_change = new_humanity - humanity

		// Hit the limit for increase, no change
		if (humanity_change <= 0)
			return
	else if (value < 0)
		var/loss_modifier = HAS_TRAIT(src, TRAIT_SENSITIVE_HUMANITY) ? 2 : 1
		value *= loss_modifier

		new_humanity = clamp(humanity + value, limit, 10)
		humanity_change = humanity - new_humanity

		// Hit the limit for decrease, no change
		if (humanity_change >= 0)
			return
	else
		return

	var/signal_return = SEND_SIGNAL(src, COMSIG_LIVING_CHANGING_HUMANITY, humanity_change)
	if (signal_return & BLOCK_HUMANITY_CHANGE)
		return

	// Change Humanity according to calculated values
	humanity += humanity_change
	if (humanity_change > 0)
		SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
		to_chat(src, span_userhelp(span_bold("[uppertext(path)] INCREASED!")))

		// Gaining Path flavour text
		switch (humanity)
			if (10)
				to_chat(src, span_userhelp("As your [path] reaches its peak, you feel the Beast [is_enlightenment ? "reaching perfect harmony with you" : "falling into a deep slumber, waiting"]."))
	else if (humanity_change < 0)
		SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
		to_chat(src, span_userdanger(span_bold("[uppertext(path)] DECREASED!")))

		// Losing Path flavour text
		switch (humanity)
			if (1)
				to_chat(src, span_userdanger(span_bold("BLOOD. FEED. HUNGER.")))
			if (2)
				to_chat(src, span_userdanger("You are losing your mind. The [span_bold("BEAST")] commands you."))
			if (3)
				to_chat(src, span_danger("Your higher reason is eroding. The Beast is gaining control..."))
			if (4)
				to_chat(src, span_danger("You feel the Beast gnawing at the edges of your mind..."))
			if (9)
				to_chat(src, span_warning("As you fall from your perfect [path], you feel the Beast [is_enlightenment ? "taking power over" : "reawakening in"] a dark corner of your soul."))

	SEND_SIGNAL(src, COMSIG_LIVING_CHANGED_HUMANITY, humanity_change)

/mob/living/carbon/human/proc/AdjustMasquerade(var/value, var/forced = FALSE)
	if(!iskindred(src) && !isghoul(src) && !iscathayan(src))
		return
	if(!GLOB.canon_event)
		return
	if (!forced)
		if(value > 0)
			if(HAS_TRAIT(src, TRAIT_VIOLATOR))
				return
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type != "masquerade")
				return
	if(!is_special_character(src) || forced)
		if(((last_masquerade_violation + 10 SECONDS) < world.time) || forced)
			last_masquerade_violation = world.time
			if(value < 0)
				if(masquerade > 0)
					masquerade = max(0, masquerade+value)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/masquerade_violation.ogg', 0, 0, 75))
					to_chat(src, "<span class='userdanger'><b>MASQUERADE VIOLATION!</b></span>")
				SSbad_guys_party.next_fire = max(world.time, SSbad_guys_party.next_fire - 2 MINUTES)
			if(value > 0)
				if(client?.prefs?.enlightenment && !forced)
					AdjustHumanity(1, 10)
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					H.voted_for -= dna.real_name
				if(masquerade < 5)
					masquerade = min(5, masquerade+value)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/general_good.ogg', 0, 0, 75))
					to_chat(src, "<span class='userhelp'><b>MASQUERADE REINFORCED!</b></span>")
				SSbad_guys_party.next_fire = max(world.time, SSbad_guys_party.next_fire + 1 MINUTES)

	if(src in GLOB.masquerade_breakers_list)
		if(masquerade > 2)
			GLOB.masquerade_breakers_list -= src
	else if(masquerade < 3)
		GLOB.masquerade_breakers_list |= src

/mob/living/carbon/human/npc/proc/backinvisible(var/atom/A)
	switch(dir)
		if(NORTH)
			if(A.y >= y)
				return TRUE
		if(SOUTH)
			if(A.y <= y)
				return TRUE
		if(EAST)
			if(A.x >= x)
				return TRUE
		if(WEST)
			if(A.x <= x)
				return TRUE
	return FALSE

/mob/living/proc/CheckEyewitness(var/mob/living/source, var/mob/attacker, var/range = 0, var/affects_source = FALSE)
	var/actual_range = max(1, round(range*(attacker.alpha/255)))
	/*
	if(SScityweather.fogging)
		actual_range = round(actual_range/2)
	*/
	var/list/seenby = list()
	if(source.ignores_warrant)
		return
	else
		for(var/mob/living/carbon/human/npc/NPC in oviewers(1, source))
			if(!NPC.CheckMove())
				if(get_turf(src) != turn(NPC.dir, 180))
					seenby |= NPC
					NPC.Aggro(attacker, FALSE)
		for(var/mob/living/carbon/human/npc/NPC in viewers(actual_range, source))
			if(!NPC.CheckMove())
				if(affects_source)
					if(NPC == source)
						NPC.Aggro(attacker, TRUE)
						seenby |= NPC
				if(!NPC.pulledby)
					var/turf/LC = get_turf(attacker)
					if(LC.get_lumcount() > 0.25 || get_dist(NPC, attacker) <= 1)
						if(NPC.backinvisible(attacker))
							seenby |= NPC
							NPC.Aggro(attacker, FALSE)
		if(length(seenby) >= 1)
			return TRUE
		return FALSE

/mob/proc/can_respawn()
	if (client?.ckey)
		if (GLOB.respawn_timers[client.ckey])
			if ((GLOB.respawn_timers[client.ckey] + 10 MINUTES) > world.time)
				return FALSE
	return TRUE

/**
 * Rolls a number of dice according to Storyteller system rules to find
 * success or number of successes.
 *
 * Rolls a number of 10-sided dice, counting them as a "success" if
 * they land on a number equal to or greater than the difficulty. Dice
 * that land on 1 subtract a success from the total, and the minimum
 * difficulty is 2. The number of successes is returned if numerical
 * is true, or the roll outcome (botch, failure, success) as a defined
 * number if false.
 *
 * Arguments:
 * * dice - number of 10-sided dice to roll.
 * * difficulty - the number that a dice must come up as to count as a success.
 * * numerical - whether the proc returns number of successes or outcome (botch, failure, success)
 */
/proc/storyteller_roll(dice = 1, difficulty = 6, numerical = FALSE)
	var/successes = 0
	var/had_one = FALSE
	var/had_success = FALSE

	if (dice < 1)
		if (numerical)
			return 0
		else
			return ROLL_FAILURE

	for (var/i in 1 to dice)
		var/roll = rand(1, 10)

		if (roll == 1)
			successes--
			if (!had_one)
				had_one = TRUE
			continue

		if (roll >= difficulty)
			successes++
			if (!had_success)
				had_success = TRUE

	if (numerical)
		return successes
	else
		if (!had_success && had_one)
			return ROLL_BOTCH
		else if (successes <= 0)
			return ROLL_FAILURE
		else
			return ROLL_SUCCESS

/proc/vampireroll(var/dices_num = 1, var/hardness = 1, var/atom/rollviewer)
	var/wins = 0
	var/crits = 0
	var/brokes = 0
	for(var/i in 1 to dices_num)
		var/roll = rand(1, 10)
		if(roll == 10)
			crits += 1
		if(roll == 1)
			brokes += 1
		else if(roll >= hardness)
			wins += 1
	if(crits > brokes)
		if(rollviewer)
			to_chat(rollviewer, "<b>Critical <span class='nicegreen'>hit</span>!</b>")
			return DICE_CRIT_WIN
	if(crits < brokes)
		if(rollviewer)
			to_chat(rollviewer, "<b>Critical <span class='danger'>failure</span>!</b>")
			return DICE_CRIT_FAILURE
	if(crits == brokes && !wins)
		if(rollviewer)
			to_chat(rollviewer, "<span class='danger'>Failed</span>")
			return DICE_FAILURE
	if(wins)
		switch(wins)
			if(1)
				to_chat(rollviewer, "<span class='tinynotice'>Maybe</span>")
				return DICE_WIN
			if(2)
				to_chat(rollviewer, "<span class='smallnotice'>Okay</span>")
				return DICE_WIN
			if(3)
				to_chat(rollviewer, "<span class='notice'>Good</span>")
				return DICE_WIN
			if(4)
				to_chat(rollviewer, "<span class='notice'>Lucky</span>")
				return DICE_WIN
			else
				to_chat(rollviewer, "<span class='boldnotice'>Phenomenal</span>")
				return DICE_WIN

/proc/get_vamp_skin_color(var/value = "albino")
	switch(value)
		if("caucasian1")
			return "vamp1"
		if("caucasian2")
			return "vamp2"
		if("caucasian3")
			return "vamp3"
		if("latino")
			return "vamp4"
		if("mediterranean")
			return "vamp5"
		if("asian1")
			return "vamp6"
		if("asian2")
			return "vamp7"
		if("arab")
			return "vamp8"
		if("indian")
			return "vamp9"
		if("african1")
			return "vamp10"
		if("african2")
			return "vamp11"
		else
			return value
