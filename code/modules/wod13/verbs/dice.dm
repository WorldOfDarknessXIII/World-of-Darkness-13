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
 * * roll header:
 */
/mob/proc/storyteller_roll(dice = 1, difficulty = 6, numerical = FALSE, roll_header="", show_player=TRUE, roll_viewers = list(src))
	#ifdef DEBUG
	show_player = TRUE
	#endif

	if(show_player)
		. = storyteller_roll_pretty(dice, difficulty, numerical, roll_header, roll_viewers)
	else
		. = storyteller_roll_basic(dice, difficulty, numerical)

//DO NOT CALL DIRECTLY
/mob/proc/storyteller_roll_basic(dice, difficulty, numerical)
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

//DO NOT CALL DIRECTLY
/mob/proc/storyteller_roll_pretty(dice, difficulty, numerical, roll_header, roll_viewers)
	var/successes = 0
	var/had_one = FALSE
	var/had_success = FALSE
	var/list/success_list = new()
	var/list/fail_list = new()
	var/roll_log = ""
	if(roll_header && roll_header != "")
		roll_log += "<h2>[roll_header]</h2><br>"
	roll_log += "<h2>Difficulty: [difficulty]</h2><br>"

	if (dice < 1)
		roll_log += "<h2>Your Roll: <span style='color:DarkRed'>Auto Failure!</span></h2><br>"
		if (numerical)
			return 0
		else
			return ROLL_FAILURE

	for (var/i in 1 to dice)
		var/roll = rand(1, 10)

		if (roll == 1)
			successes--
			fail_list.Add(roll)
			if (!had_one)
				had_one = TRUE
			continue

		if (roll < difficulty)
			fail_list.Add(roll)
		else
			successes++
			success_list.Add(roll)
			if (!had_success)
				had_success = TRUE

	roll_log += "<h2>Your Roll:"
	if(success_list)
		roll_log += "<span style='color:green'>"

		for(var/roll_result in success_list)
			roll_log += " [get_dice_char(roll_result)]"
		roll_log += "</span>"
	if(fail_list)
		roll_log += "<span style='color:DarkRed'>"
		for(var/roll_result in fail_list)
			roll_log += " [get_dice_char(roll_result)]"
		roll_log += "</span>"

	var/trinary_result
	if (!had_success && had_one)
		trinary_result = ROLL_BOTCH
		roll_log += " - <span style='color:DarkRed'><b>Botch!</b></span></h2>"

	else if (successes <= 0)
		trinary_result = ROLL_FAILURE
		roll_log += " - <span style='color:DarkRed'>Failure!</span></h2>"
	else
		roll_log += " - <span style='color:green'>[successes] Success[(successes > 1) ? "es":""]</span></h2>"
		trinary_result = ROLL_SUCCESS

	roll_to_chat_list(roll_viewers, roll_log)

	if (numerical)
		return successes
	else
		return trinary_result

/mob/proc/roll_to_chat_list(list/viewers, input)
	for(var/mob/viewer in viewers)
		if(viewer.client && viewer.client.prefs && viewer.client.prefs.chat_toggles & CHAT_ROLL_INFO)
			to_chat(viewer, input)

/mob/proc/get_dice_char(input)
	switch(input)
		if(1)
			return "❶"
		if(2)
			return "❷"
		if(3)
			return "❸"
		if(4)
			return "❹"
		if(5)
			return "❺"
		if(6)
			return "❻"
		if(7)
			return "❼"
		if(8)
			return "❽"
		if(9)
			return "❾"
		if(10)
			return "❿"
		else
			return "⓿"


/mob/proc/vampireroll(var/dices_num = 1, var/hardness = 1, var/atom/rollviewer)
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
