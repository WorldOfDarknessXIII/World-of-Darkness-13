/datum/vampireclane/lasombra
	name = "Lasombra"
	desc = "The Lasombra exist for their own success, fighting for personal victories rather than solely for a crown to wear or a throne to sit upon. They believe that might makes right, and are willing to sacrifice anything to achieve their goals. A clan that uses spirituality as a tool rather than seeking honest enlightenment, their fickle loyalties are currently highlighted by half their clan's defection from the Sabbat."
	curse = "Technology refuse."
	clane_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/dominate,
		/datum/discipline/obtenebration
	)
	male_clothes = /obj/item/clothing/under/vampire/emo
	female_clothes = /obj/item/clothing/under/vampire/business
	enlightenment = TRUE
	whitelisted = TRUE

/datum/vampireclane/lasombra/post_gain(mob/living/carbon/human/H)
	..()
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
	H.vis_flags |= VIS_HIDE
	H.faction |= "Lasombra"

/datum/discipline/obtenebration/post_gain(mob/living/carbon/human/H)
	if(level >= 1)
		var/datum/action/shadowcontrol/control = new()
		control.Grant(H)
		H.mysticism_knowledge = TRUE
	if(level >= 3)
		var/datum/action/lastentacles/tentacles = new()
		tentacles.Grant(H)
	if(level >= 4)
		var/datum/action/lasarmor/armor = new()
		armor.Grant(H)
	if(level >= 5)
		var/datum/action/mysticism/mystic = new()
		mystic.Grant(H)
		mystic.level = level
		var/obj/effect/proc_holder/spell/targeted/shadowwalk/S = new(H)
		H.mind.AddSpell(S)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/mystome)

/datum/action/lastentacles
	name = "Summon Tentacles"
	desc = "Summon tentacles from shadows to assist you."
	button_icon_state = "tentacles"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/abuse_fix = 0

/datum/action/lastentacles/Trigger()
	. = ..()
	if(abuse_fix+100 > world.time)
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 1)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return
	H.bloodpool = max(0, H.bloodpool-1)
	playsound(H.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	abuse_fix = world.time
	H.drop_all_held_items()
	H.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(H))
	H.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(H))
//	H.physiology.armor.melee += 50
//	H.physiology.armor.bullet += 50
//	animate(H, color = "#000000", time = 10, loop = 1)
	if(H.CheckEyewitness(H, H, 7, FALSE))
		H.AdjustMasquerade(-1)
	spawn(20 SECONDS)
		if(H)
			playsound(H.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
			for(var/obj/item/melee/vampirearms/knife/gangrel/lasombra/G in H.contents)
				if(G)
					qdel(G)
//			H.physiology.armor.melee -= 50
//			H.physiology.armor.bullet -= 50
//			H.color = initial(H.color)

/datum/action/lasarmor
	name = "Shadow Armor"
	desc = "Turn into shadow abomination for your safety."
	button_icon_state = "armor"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/abuse_fix = 0

/datum/action/lasarmor/Trigger()
	. = ..()
	if(abuse_fix+250 > world.time)
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return
	H.bloodpool = max(0, H.bloodpool-2)
	playsound(H.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	abuse_fix = world.time
	H.physiology.damage_resistance += 60
	animate(H, color = "#000000", time = 10, loop = 1)
	if(H.CheckEyewitness(H, H, 7, FALSE))
		H.AdjustMasquerade(-1)
	spawn(15 SECONDS)
		if(H)
			playsound(H.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
			H.physiology.damage_resistance -= 60
			H.color = initial(H.color)

/datum/action/shadowcontrol
	name = "Control Shadows"
	desc = "Control shadows around you"
	button_icon_state = "shadow"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/abuse_fix = 0

/datum/action/shadowcontrol/Trigger()
	. = ..()
	if((abuse_fix + 10 SECONDS) > world.time)
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 1)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return
	H.bloodpool = max(0, H.bloodpool-1)
	playsound(H.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	abuse_fix = world.time
	var/atom/movable/AM = new(H)
	AM.set_light(3, -7)
	if(H.CheckEyewitness(H, H, 7, FALSE))
		H.AdjustMasquerade(-1)
	spawn(100)
		if(AM)
			qdel(AM)
			if(H)
				playsound(H.loc, 'sound/magic/voidblink.ogg', 50, FALSE)

/datum/crafting_recipe/mystome
	name = "Abyss Mysticism Tome"
	time = 100
	reqs = list(/obj/item/paper = 3, /obj/item/drinkable_bloodpack = 1)
	result = /obj/item/mystic_tome
	always_available = FALSE
	category = CAT_MISC

/datum/action/mysticism
	name = "Mysticism"
	desc = "Abyss Mysticism rune drawing."
	button_icon_state = "thaumaturgy"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/drawing = FALSE
	var/level = 1

/datum/action/mysticism/Trigger()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(H, "<span class='warning'>You need more <b>BLOOD</b> to do that!</span>")
		return
	if(drawing)
		return

	if(istype(H.get_active_held_item(), /obj/item/mystic_tome))
		var/list/shit = list()
		for(var/i in subtypesof(/obj/abyssrune))
			var/obj/abyssrune/R = new i(owner)
			if(R.mystlevel <= level)
				shit += i
			qdel(R)
		var/ritual = input(owner, "Choose rune to draw:", "Mysticism") as null|anything in shit
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
		for(var/i in subtypesof(/obj/abyssrune))
			var/obj/abyssrune/R = new i(owner)
			if(R.mystlevel <= level)
				shit += i
			qdel(R)
		var/ritual = input(owner, "Choose rune to draw (You need a Mystic Tome to reduce random):", "Mysticism") as null|anything in list("???")
		if(ritual)
			drawing = TRUE
			if(do_after(H, 30*max(1, 5-H.mentality), H))
				drawing = FALSE
//				var/list/runes = subtypesof(/obj/abyssrune)
				var/rune = pick(shit)
				new rune(H.loc)
				H.bloodpool = max(0, H.bloodpool-2)
				if(H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)
			else
				drawing = FALSE
