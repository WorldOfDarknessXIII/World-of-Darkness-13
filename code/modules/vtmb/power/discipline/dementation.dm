/datum/discipline/dementation
	name = "Dementation"
	desc = "Makes all humans in radius mentally ill for a moment, supressing their defending ability."
	icon_state = "dementation"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/dementation

/datum/discipline/dementation/post_gain()
	. = ..()
	owner.add_quirk(/datum/quirk/insanity)

/datum/discipline_power/dementation
	name = "Dementation power name"
	desc = "Dementation power description"

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	vitae_cost = 1
	target_type = TARGET_LIVING
	range = 7

	activate_sound = 'code/modules/wod13/sounds/insanity.ogg'

	fire_and_forget = TRUE
	cooldown = 10 SECONDS
	duration_length = 0

/datum/discipline_power/dementation/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
	dementation_overlay.pixel_z = 1
	target.add_overlay(dementation_overlay)

/datum/discipline_power/dementation/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/datum/discipline_power/dementation/can_activate(mob/living/target, alert = FALSE)
	. = ..()
	if (!.)
		return .
	if(target.spell_immunity)
		return FALSE
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	if(theirpower >= mypower)
		if (alert)
			to_chat(owner, "<span class='warning'>[target]'s mind is too powerful to corrupt!</span>")
		return FALSE
	if(!ishuman(target))
		if (alert)
			to_chat(owner, "<span class='warning'>[target] doesn't have enough mind to get affected by this discipline!</span>")
		return FALSE
	return TRUE

//PASSION
/datum/discipline_power/dementation/passion
	name = "Passion"
	desc = "Stir the deepest parts of your target to manipulate their psyche."

	level = 1

/datum/discipline_power/dementation/passion/activate(mob/living/carbon/human/target)
	. = ..()
	target.Stun(0.5 SECONDS)
	target.emote("laugh")
	to_chat(target, "<span class='userdanger'><b>HAHAHAHAHAHAHAHAHAHAHAHA!!</b></span>")
	owner.playsound_local(get_turf(H), pick('sound/items/SitcomLaugh1.ogg', 'sound/items/SitcomLaugh2.ogg', 'sound/items/SitcomLaugh3.ogg'), 100, FALSE)
	if(target.body_position == STANDING_UP)
		target.toggle_resting()

//THE HAUNTING
/datum/discipline_power/dementation/the_haunting
	name = "The Haunting"
	desc = "Manipulate your target's senses, making them perceive what isn't there."

	level = 2

/datum/discipline_power/dementation/the_haunting/activate(mob/living/carbon/human/target)
	. = ..()
	target.hallucination += 50
	new /datum/hallucination/oh_yeah(target, TRUE)

//EYES OF CHAOS
/datum/discipline_power/dementation/eyes_of_chaos
	name = "Eyes of Chaos"
	desc = "See the hidden patterns in the world and uncover people's true selves."

	level = 3

/datum/discipline_power/dementation/eyes_of_chaos/activate(mob/living/carbon/human/target)
	. = ..()
	target.Immobilize(2 SECONDS)
	if(!HAS_TRAIT(target, TRAIT_KNOCKEDOUT) && !HAS_TRAIT(target, TRAIT_IMMOBILIZED) && !HAS_TRAIT(target, TRAIT_RESTRAINED))
		if(prob(50))
			dancefirst(target)
		else
			dancesecond(target)

/proc/dancefirst(mob/living/M)
	if(M.dancing)
		return
	M.dancing = TRUE
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 75)
		if (!M)
			return
		switch(i)
			if (1 to 15)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (16 to 30)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (31 to 45)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (46 to 60)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (61 to 75)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(0.1 SECONDS)
	M.lying_fix()
	M.dancing = FALSE

/proc/dancesecond(mob/living/M)
	if(M.dancing)
		return
	M.dancing = TRUE
	animate(M, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 60)
		if (!M)
			return
		if (i<31)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		if (i>30)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,-1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(0.1 SECONDS)
	M.lying_fix()
	M.dancing = FALSE

//VOICE OF MADNESS
/datum/discipline_power/dementation/voice_of_madness
	name = "Voice of Madness"
	desc = "Your voice becomes a source of utter insanity, affecting you and all those around you."

	level = 4

/datum/discipline_power/dementation/voice_of_madness/activate(mob/living/carbon/human/target)
	. = ..()
	new /datum/hallucination/death(target, TRUE)

//TOTAL INSANITY
/datum/discipline_power/dementation/total_insanity
	name = "Total Insanity"
	desc = "Bring out the darkest parts of a person's psyche, bringing them to utter insanity."

	level = 5

/datum/discipline_power/dementation/total_insanity/activate(mob/living/carbon/human/target)
	. = ..()
	var/datum/cb = CALLBACK(target, /mob/living/carbon/human/proc/attack_myself_command)
	for(var/i in 1 to 20)
		addtimer(cb, (i - 1) * 1.5 SECONDS)
