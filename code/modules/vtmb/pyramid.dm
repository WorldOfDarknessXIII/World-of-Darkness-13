/obj/item/arcane_tome
	name = "arcane tome"
	desc = "The secrets of Blood Magic..."
	icon_state = "arcane"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	is_magic = TRUE
	var/list/rituals = list()

/obj/item/arcane_tome/Initialize()
	. = ..()
	for(var/i in subtypesof(/obj/ritualrune))
		if(i)
			var/obj/ritualrune/R = new i(src)
			rituals |= R

/obj/item/arcane_tome/attack_self(mob/user)
	. = ..()
	for(var/obj/ritualrune/R in rituals)
		if(R)
			if(R.sacrifice)
				var/obj/item/I = new R.sacrifice(src)
				to_chat(user, "[R.thaumlevel] [R.name] - [R.desc] Requirements: [I].")
				qdel(I)
			else
				to_chat(user, "[R.thaumlevel] [R.name] - [R.desc]")

/obj/ritualrune
	name = "Tremere Rune"
	desc = "Learn the secrets of blood, neonate..."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rune1"
	color = rgb(128,0,0)
	anchored = TRUE
	var/word = "IDI NAH"
	var/activator_bonus = 0
	var/activated = FALSE
	var/mob/living/last_activator
	var/thaumlevel = 1
	var/sacrifice

/obj/ritualrune/proc/complete()
	return

/obj/ritualrune/attack_hand(mob/user)
	if(!activated)
		var/mob/living/L = user
		if(L.thaumaturgy_knowledge)
			L.say("[word]")
			L.Immobilize(30)
			last_activator = user
			activator_bonus = L.thaum_damage_plus
			if(sacrifice)
				for(var/obj/item/I in get_turf(src))
					if(I)
						if(istype(I, sacrifice))
							qdel(I)
							complete()
			else
				complete()

/obj/ritualrune/AltClick(mob/user)
	..()
	qdel(src)

/obj/ritualrune/selfgib
	name = "Self Destruction"
	desc = "Meet the Final Death."
	icon_state = "rune2"
	word = "CHNGE DA'WORD, GDBE"

/obj/ritualrune/selfgib/complete()
	last_activator.death()

/obj/ritualrune/blood_guardian
	name = "Blood Guardian"
	desc = "Creates the Blood Guardian to protect tremere or his domain."
	icon_state = "rune1"
	word = "UR'JOLA"
	thaumlevel = 3

/obj/ritualrune/blood_guardian/complete()
	var/mob/living/carbon/human/H = last_activator
	if(!length(H.beastmaster))
		var/datum/action/beastmaster_stay/E1 = new()
		E1.Grant(last_activator)
		var/datum/action/beastmaster_deaggro/E2 = new()
		E2.Grant(last_activator)
	var/mob/living/simple_animal/hostile/beastmaster/blood_guard/BG = new(loc)
	BG.beastmaster = last_activator
	H.beastmaster |= BG
	BG.my_creator = last_activator
	BG.melee_damage_lower = BG.melee_damage_lower+activator_bonus
	BG.melee_damage_upper = BG.melee_damage_upper+activator_bonus
	playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
	if(length(H.beastmaster) > 3+H.mentality)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(H.beastmaster)
		B.death()
	qdel(src)

/mob/living/simple_animal/hostile/beastmaster/blood_guard
	name = "blood guardian"
	desc = "A clot of blood in humanoid form."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "blood_guardian"
	icon_living = "blood_guardian"
	del_on_death = 1
	healable = 0
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	speed = 0
	maxHealth = 150
	health = 150

	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	speak_emote = list("gnashes")

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list("Tremere")
	pressure_resistance = 200
	bloodpool = 1
	maxbloodpool = 1

/obj/ritualrune/blood_trap
	name = "Blood Trap"
	desc = "Creates the Blood Trap to protect tremere or his domain."
	icon_state = "rune2"
	word = "DUH'K-A'U"

/obj/ritualrune/blood_trap/complete()
	if(!activated)
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		activated = TRUE
		alpha = 28

/obj/ritualrune/blood_trap/Crossed(atom/movable/AM)
	..()
	if(isliving(AM) && activated)
		var/mob/living/L = AM
		L.adjustFireLoss(50+activator_bonus)
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		qdel(src)

/obj/ritualrune/blood_wall
	name = "Blood Wall"
	desc = "Creates the Blood Wall to protect tremere or his domain."
	icon_state = "rune3"
	word = "SOT'PY-O"
	thaumlevel = 2

/obj/ritualrune/blood_wall/complete()
	new /obj/structure/bloodwall(loc)
	playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
	qdel(src)

/obj/structure/bloodwall
	name = "blood wall"
	desc = "Wall from BLOOD."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "bloodwall"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	max_integrity = 100
	obj_integrity = 100

/obj/structure/fleshwall
	name = "flesh wall"
	desc = "Wall from FLESH."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "fleshwall"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	max_integrity = 100
	obj_integrity = 100

/obj/ritualrune/identification
	name = "Identification Rune"
	desc = "Identifies a single occult item."
	icon_state = "rune4"
	word = "IN'DAR"

/obj/ritualrune/identification/complete()
	for(var/obj/item/vtm_artifact/VA in loc)
		if(VA)
			VA.identificate()
			playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			qdel(src)
			return

/obj/ritualrune/question
	name = "Question to Ancestors Rune"
	desc = "Summon souls from the dead. Ask a question and get answers. Requires a bloodpack."
	icon_state = "rune5"
	word = "TE-ME'LL"
	thaumlevel = 3
	sacrifice = /obj/item/drinkable_bloodpack

/mob/living/simple_animal/hostile/ghost/tremere
	maxHealth = 1
	health = 1
	melee_damage_lower = 1
	melee_damage_upper = 1
	faction = list("Tremere")

/obj/ritualrune/question/complete()
	visible_message("<span class='notice'>A call rings out to the dead from the [src.name] rune...</span>")
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to answer a question? (You are allowed to spread meta information)", null, null, null, 10 SECONDS, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, "<span class='ghostalert'>Question rune has been triggered.</span>")
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		var/mob/living/simple_animal/hostile/ghost/tremere/TR = new(loc)
		TR.key = C.key
		TR.name = C.name
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		qdel(src)
	else
		visible_message("<span class='notice'>No one answers the [src.name] rune's call.</span>")

/obj/ritualrune/teleport
	name = "Teleportation Rune"
	desc = "Move your body among the city streets. Requires a bloodpack."
	icon_state = "rune6"
	word = "POR'TALE"
	thaumlevel = 5
	sacrifice = /obj/item/drinkable_bloodpack

/obj/ritualrune/teleport/complete()
	if(!activated)
		activated = TRUE
		color = rgb(255,255,255)
		icon_state = "teleport"

/obj/ritualrune/teleport/attack_hand(mob/user)
	..()
	var/x_dir = 1
	var/y_dir = 1
	if(activated)
		var/x = input(user, "Choose x direction:\n(1-255)", "Teleportation Rune") as num|null
		if(x)
			x_dir = max(min(round(text2num(x)), 255),1)
			var/y = input(user, "Choose y direction:\n(1-255)", "Teleportation Rune") as num|null
			if(y)
				y_dir = max(min(round(text2num(y)), 255),1)
				var/atom/movable/AM = new(user.loc)
				AM.x = x_dir
				AM.y = y_dir
				if(istype(get_area(AM), /area/vtm))
					var/area/vtm/V = get_area(AM)
					if(V.name != "San Francisco")
						playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
						user.forceMove(get_turf(AM))
						qdel(AM)
						qdel(src)
						return
				else
					to_chat(user, "<span class='warning'>There is no available teleportation place by this coordinates!</span>")
					qdel(AM)

/obj/ritualrune/curse
	name = "Curse Rune"
	desc = "Curse your enemies in distance. Requires a heart."
	icon_state = "rune7"
	word = "CUS-RE'S"
	thaumlevel = 5
	sacrifice = /obj/item/organ/heart

/obj/ritualrune/curse/complete()
	if(!activated)
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		color = rgb(255,0,0)
		activated = TRUE

/obj/ritualrune/curse/attack_hand(mob/user)
	..()
	var/cursed
	if(activated)
		var/namem = input(user, "Choose target name:", "Curse Rune") as text|null
		if(namem)
			cursed = namem
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(H.real_name == cursed)
					H.adjustFireLoss(20)
					playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
					to_chat(H, "<span class='warning'>You feel someone repeating your name from the shadows...</span>")
					H.Stun(10)
					qdel(src)
					return
			to_chat(user, "<span class='warning'>There is no such names in the city!</span>")

/obj/ritualrune/blood_to_water
	name = "Blood To Water"
	desc = "Purges all blood in range into the water."
	icon_state = "rune8"
	word = "CL-ENE"

/obj/ritualrune/blood_to_water/complete()
	for(var/atom/A in range(7, src))
		if(A)
			A.wash(CLEAN_WASH)
	qdel(src)

/obj/ritualrune/gargoyle
	name = "Gargoyle Transformation"
	desc = "Create a Gargoyle."
	icon_state = "rune9"
	word = "GRORRR'RRR"
	thaumlevel = 4

/obj/ritualrune/gargoyle/complete()
	for(var/mob/living/carbon/human/H in loc)
		if(H)
			if(H.stat > SOFT_CRIT)
				for(var/datum/action/A in H.actions)
					if(A)
						if(A.vampiric)
							A.Remove(H)
				H.revive(TRUE)
				H.set_species(/datum/species/kindred)
				H.clane = new /datum/vampireclane/gargoyle()
				H.clane.on_gain(H)
				H.clane.post_gain(H)
				H.forceMove(get_turf(src))
				H.create_disciplines(FALSE, H.clane.clane_disciplines)
				if(!H.key)
					var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to play as Sentient Gargoyle?", null, null, null, 50, src)
					for(var/mob/dead/observer/G in GLOB.player_list)
						if(G.key)
							to_chat(G, "<span class='ghostalert'>Gargoyle Transformation rune has been triggered.</span>")
					if(LAZYLEN(candidates))
						var/mob/dead/observer/C = pick(candidates)
						H.key = C.key
//					Y.key = C.key
//					Y.my_creator = last_activator
				playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
				qdel(src)
				return
			else
				playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
				H.adjustBruteLoss(25)
				H.emote("scream")
				return
