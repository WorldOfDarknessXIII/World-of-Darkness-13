/datum/vampireclane/tremere
	name = "Tremere"
	desc = "The arcane Clan Tremere were once a house of mortal mages who sought immortality but found only undeath. As vampires, they’ve perfected ways to bend their own Blood to their will, employing their sorceries to master and ensorcel both the mortal and vampire world. Their power makes them valuable, but few vampires trust their scheming ways."
	curse = "Blood magic."
	clane_disciplines = list(
		/datum/discipline/auspex = 1,
		/datum/discipline/dominate = 2,
		/datum/discipline/thaumaturgy = 3
	)
	male_clothes = /obj/item/clothing/under/vampire/tremere
	female_clothes = /obj/item/clothing/under/vampire/tremere/female

/datum/discipline/thaumaturgy/post_gain(mob/living/carbon/human/H)
	H.faction |= "Tremere"
	if(level >= 1)
		var/datum/action/thaumaturgy/T = new()
		T.Grant(H)
		T.level = level
		H.thaumaturgy_knowledge = TRUE
	if(level >= 3)
		var/datum/action/bloodshield/B = new()
		B.Grant(H)

/datum/action/thaumaturgy
	name = "Thaumaturgy"
	desc = "Blood magic rune drawing."
	button_icon_state = "thaumaturgy"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/drawing = FALSE
	var/level = 1

/datum/action/thaumaturgy/Trigger()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(H, "<span class='warning'>You need more <b>BLOOD</b> to do that!</span>")
		return
	if(drawing)
		return

	if(istype(H.get_active_held_item(), /obj/item/arcane_tome))
		var/list/shit = list()
		for(var/i in subtypesof(/obj/ritualrune))
			var/obj/ritualrune/R = new i(owner)
			if(R.thaumlevel <= level)
				shit += i
			qdel(R)
		var/ritual = input(owner, "Choose rune to draw:", "Thaumaturgy") as null|anything in shit
		if(ritual)
			drawing = TRUE
			if(do_after(H, 30*max(1, 5-H.mentality), H))
				drawing = FALSE
				new ritual(H.loc)
				H.bloodpool = max(0, H.bloodpool-2)
				if(H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)
			else
				drawing = FALSE
	else
		var/list/shit = list()
		for(var/i in subtypesof(/obj/ritualrune))
			var/obj/ritualrune/R = new i(owner)
			if(R.thaumlevel <= level)
				shit += i
			qdel(R)
		var/ritual = input(owner, "Choose rune to draw (You need an Arcane Tome to reduce random):", "Thaumaturgy") as null|anything in list("???")
		if(ritual)
			drawing = TRUE
			if(do_after(H, 30*max(1, 5-H.mentality), H))
				drawing = FALSE
//				var/list/runes = subtypesof(/obj/ritualrune)
				var/rune = pick(shit)
				new rune(H.loc)
				H.bloodpool = max(0, H.bloodpool-2)
				if(H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)
			else
				drawing = FALSE

/datum/action/bloodshield
	name = "Bloodshield"
	desc = "Gain armor with blood."
	button_icon_state = "bloodshield"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/abuse_fix = 0

/datum/action/bloodshield/Trigger()
	. = ..()
	if((abuse_fix + 25 SECONDS) > world.time)
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return
	H.bloodpool = max(0, H.bloodpool-2)
	playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
	abuse_fix = world.time
	H.physiology.damage_resistance += 60
	animate(H, color = "#ff0000", time = 1 SECONDS, loop = 1)
	if(H.CheckEyewitness(H, H, 7, FALSE))
		H.AdjustMasquerade(-1)
	spawn(15 SECONDS)
		if(H)
			playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			H.physiology.damage_resistance -= 60
			H.color = initial(H.color)
