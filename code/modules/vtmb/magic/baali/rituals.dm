/datum/rune_ritual
	var/name = "Ritual Name"
	var/description = "Ritual Description"
	var/cost = 1
	var/category = "Unsorted"

/datum/rune_ritual/proc/Initialize()
	return TRUE

/datum/rune_ritual/proc/Execute(mob/user, obj/effect/decal/baalirune/rune)
	return FALSE

/datum/rune_ritual/concordance
	name = "Concordance"
	description = "Gain a permanent physical feature of your dark masters"
	cost = 1
	category = "Upgrades"

/datum/rune_ritual/concordance/Execute(mob/user, obj/effect/decal/baalirune/rune)
	to_chat(user, "You gained this!")
	return TRUE

/datum/rune_ritual/infernal_servitor
	name = "Infernal Servitor"
	description = "Summon a demon to serve you"
	cost = 20
	category = "Servers"

/datum/rune_ritual/infernal_servitor/Execute(mob/user, obj/effect/decal/baalirune/rune)
	playsound(get_turf(rune), 'sound/magic/demon_dies.ogg', 100, TRUE)
	new /mob/living/simple_animal/hostile/baali_guard(get_turf(rune))
	//var/datum/preferences/P = GLOB.preferences_datums[ckey(user.key)]
	//(P)
	//P.exper = min(calculate_mob_max_exper(user), P.exper+15)
	return TRUE

/datum/rune_ritual/vampire_to_baali
	name = "The Re-Embrace"
	description = "Transform a vampire into a Baali"
	cost = 5
	category = "Vampire"
	var/list/default_actions = list("About Me", "Give Vitae", "Blood Heal", "Blood Power")

/datum/rune_ritual/vampire_to_baali/Execute(mob/user, obj/effect/decal/baalirune/rune)
	var/mob/living/carbon/human/vampire = locate() in get_turf(rune)
	if(vampire)
		if(vampire.clane && !istype(vampire.clane, /datum/vampireclane/baali))
			for(var/datum/action/action in vampire.actions)
				if(action && !default_actions.Find(action.name))
					action.Remove(vampire)
			qdel(vampire.clane)
			vampire.clane = new /datum/vampireclane/baali()
			vampire.clane.on_gain(vampire)
			vampire.clane.post_gain(vampire)
			vampire.create_disciplines(FALSE, vampire.clane.clane_disciplines)
			to_chat(user, "<span class='baali'>Now [vampire] is in your clan, Baali clan</span>")
			to_chat(vampire, "<span class='baali'>Now you are in the Baali clan</span>")
			return TRUE
		else
			to_chat(user, "<span class='baali'>You can't do it on human or your clan's vampires!</span>")
	else
		to_chat(user, "<span class='baali'>There is no vampire on the Rune!</span>")
	return FALSE

/datum/rune_ritual/fire
	name = "Adramelech's Wrath"
	description = "Cause a Cainite to burn as if the sun itself were shining upon them"
	cost = 15
	category = "Vampire"

/datum/rune_ritual/fire/Execute(mob/user, obj/effect/decal/baalirune/rune)
	var/name = input(user, "Choose target name:", "Satanic Rune") as text|null
	if(name)
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(player.real_name == name)
				player.adjust_fire_stacks(10)
				player.IgniteMob()
				playsound(player.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
				to_chat(player, "<span class='userdanger'>You feel burn as if the sun itself were shining upon you!</span>")
				player.Stun(10)
				return TRUE
		to_chat(user, "<span class='baali'>There is no such vampire in the city!</span>")
	return FALSE

/datum/rune_ritual/condemnation
	name = "Condemnation"
	description = "Place a debilitating curse upon a target."
	cost = 10
	category = "Vampire"

/datum/rune_ritual/condemnation/Execute(mob/user, obj/effect/decal/baalirune/rune)
	var/name = input(user, "Choose target name:", "Satanic Rune") as text|null
	if(name)
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(player.real_name == name)
				// Заклятие
				return TRUE
		to_chat(user, "<span class='baali'>There is no such vampire in the city!</span>")
	return FALSE

/datum/rune_ritual/hellfear
	name = "Fear of the Void Below"
	description = "The Baali terrifies a target with feelings of going to Hell."
	cost = 3
	category = "Vampire"

/datum/rune_ritual/hellfear/Execute(mob/user, obj/effect/decal/baalirune/rune)
	var/name = input(user, "Choose target name:", "Satanic Rune") as text|null
	if(name)
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(player.real_name == name)
				player.Stun(20)
				playsound(player.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
				to_chat(player, "<span class='userdanger'>You feel you are going to HELL!</span>")
				return TRUE
		to_chat(user, "<span class='baali'>There is no such vampire in the city!</span>")
	return FALSE

#define MAX_BURN_COUNT 5

/datum/rune_ritual/sunfire
	name = "Unleash Hell's Fury"
	description = "Cause a Cainite to feel the sun's light no matter what shelter they have."
	cost = 10
	category = "Vampire"
	var/burn_count = 0

/datum/rune_ritual/sunfire/Execute(mob/user, obj/effect/decal/baalirune/rune)
	if(burn_count != 0)
		to_chat(user, "Someone already feel Sun's light!")
		return FALSE
	var/name = input(user, "Choose target name:", "Satanic Rune") as text|null
	if(name)
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(player.real_name == name)
				burn_vampire(player)
				playsound(player.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
				to_chat(player, "<span class='userdanger'>You feel the Sun is upon you!</span>")
				return TRUE
		to_chat(user, "<span class='baali'>There is no such vampire in the city!</span>")
	return FALSE

/datum/rune_ritual/sunfire/proc/burn_vampire(mob/living/carbon/human/vampire)
	vampire.adjustFireLoss(10)
	if(burn_count < MAX_BURN_COUNT)
		burn_count++
		spawn(5 SECONDS)
		burn_vampire(vampire)
		to_chat(vampire, "You are feel burns")
	else
		burn_count = 0

#undef MAX_BURN_COUNT

