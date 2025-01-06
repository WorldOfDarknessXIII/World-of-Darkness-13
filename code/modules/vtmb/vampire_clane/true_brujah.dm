/datum/vampireclane/true_brujah
	name = "True Brujah"
	desc = "The True Brujah are a bloodline of Clan Brujah that claim to be descendants of the original Antediluvian founder of the lineage and not his diablerist/childe Troile. They are also noted for their calm, detached behavior, which puts them in contrast to the main lineage who are known for their rather short, violent tempers and anti-establishment attitudes. "
	curse = "Absence of passion."
	clane_disciplines = list(
		/datum/discipline/potence = 1,
		/datum/discipline/presence = 2,
		/datum/discipline/temporis = 3
	)
	violating_appearance = FALSE
	enlightenment = TRUE
	male_clothes = /obj/item/clothing/under/vampire/rich
	female_clothes = /obj/item/clothing/under/vampire/business
	restricted_disciplines = list(/datum/discipline/celerity)
	whitelisted = TRUE

/datum/discipline/temporis/post_gain(mob/living/carbon/human/H)
	if(level >= 1)
		var/datum/action/clock/clocke = new()
		clocke.Grant(H)
	if(level >= 4)
		var/datum/action/temporis_step/tstep = new()
		tstep.Grant(H)
	if(level >= 5)
		var/datum/action/clotho/clot = new()
		clot.Grant(H)

/datum/action/clock
	name = "Check Time"
	desc = "Telling the time is easy when you're True Brujah."
	button_icon_state = "clock2"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE

/datum/action/clock/Trigger()
	. = ..()
	to_chat(usr, "<b>[SScity_time.timeofnight]</b>")

var/datum/martial_art/cowalker/style

/datum/action/temporis_step
	name = "Cowalker"
	desc = "Stop time for a moment in order to appear in two places at once."
	button_icon_state = "Cowalker"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/spam_fix = 0

/proc/tempstep(mob/living/M)
	style = new
	if(M.temporis_visual)
		return
	var/mob/living/carbon/carbon = M
	if (carbon.celerity_visual)
		to_chat(M, "<span class='userdanger'>As you try to stop time to co-locate, your active Celerity makes time slip out of control!</span>")
		carbon.emote("scream")
		spawn(3 SECONDS)
			carbon.gib()
		return
	M.temporis_visual = TRUE
	var/matrix/initial_matrix = matrix(M.transform)
	var/matrix/secondary_matrix = matrix(M.transform)
	var/matrix/tertiary_matrix = matrix(M.transform)
	initial_matrix.Translate(1,0)
	secondary_matrix.Translate(0,1)
	tertiary_matrix.Translate(1)
	animate(M, transform = initial_matrix, time = 10, loop = 0)
	animate(M, transform = secondary_matrix, time = 10, loop = 0, ANIMATION_PARALLEL)
	animate(M, transform = tertiary_matrix, time = 10, loop = 0, ANIMATION_PARALLEL)
	style.teach(M, make_temporary = TRUE)
	spawn(10 SECONDS)
		style.remove(M)
		M.temporis_visual = FALSE
		playsound(M.loc, 'code/modules/wod13/sounds/temporis end.ogg', 50, FALSE)

/datum/action/temporis_step/Trigger()
	if(spam_fix + 15 SECONDS > world.time)
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 1)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return
	H.bloodpool = max(0, H.bloodpool-1)
	playsound(H.loc, 'code/modules/wod13/sounds/temporis.ogg', 50, FALSE)
	spam_fix = world.time
	var/mob/living/carbon/human/M = usr
	tempstep(M)

/datum/action/clotho
	name = "Clotho's Gift"
	desc = "Accelerate your time frame in order to move and act faster."
	button_icon_state = "Clotho"
	check_flags = AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/spam_fix = 0

/proc/clothogift(mob/living/M)
	style = new
	if(M.temporis_blur)
		return
	var/mob/living/carbon/carbon = M
	if (carbon.celerity_visual)
		to_chat(M, "<span class='userdanger'>As you try to accelerate yourself, your active Celerity makes time rebound back at you!</span>")
		carbon.emote("scream")
		spawn(3 SECONDS)
			carbon.gib()
		return
	M.temporis_blur = TRUE
	M.add_movespeed_modifier(/datum/movespeed_modifier/temporis5)
	M.next_move_modifier *= TEMPORIS_ATTACK_SPEED_MODIFIER
	style.teach(M, make_temporary = TRUE)
	spawn(10 SECONDS)
		if(usr == M)
			style.remove(M)
			M.temporis_blur = FALSE
			M.playsound_local(M.loc, 'code/modules/wod13/sounds/temporis end.ogg', 50, FALSE)
			M.remove_movespeed_modifier(/datum/movespeed_modifier/temporis5)
			M.next_move_modifier /= TEMPORIS_ATTACK_SPEED_MODIFIER


/datum/action/clotho/Trigger()
	if(spam_fix + 15 SECONDS > world.time)
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 3)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return
	H.bloodpool = max(0, H.bloodpool-3)
	playsound(H.loc, 'code/modules/wod13/sounds/temporis.ogg', 50, FALSE)
	spam_fix = world.time
	var/mob/living/carbon/human/M = usr
	clothogift(M)
