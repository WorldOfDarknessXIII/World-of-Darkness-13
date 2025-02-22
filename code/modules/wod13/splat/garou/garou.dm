/datum/splat/supernatural/garou
	name = "Werewolf"
	id = "garou"
	default_color = "FFFFFF"
	toxic_food = PINEAPPLE
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_VIRUSIMMUNE, TRAIT_PERFECT_ATTACKER)
	use_skintones = TRUE
	limbs_id = "human"
	wings_icon = "Dragon"
	mutant_bodyparts = list("tail_human" = "None", "ears" = "None", "wings" = "None")
	brutemod = 1
	heatmod = 1
	burnmod = 1
	dust_anim = "dust-h"

	whitelisted = TRUE
	selectable = TRUE
	var/glabro = FALSE

/datum/action/garouinfo
	name = "About Me"
	desc = "Check assigned role, auspice, generation, humanity, masquerade, known disciplines, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/host

/datum/action/garouinfo/Trigger()
	if(host)
		var/dat = {"
			<style type="text/css">

			body {
				background-color: #090909; color: white;
			}

			</style>
			"}
		dat += "<center><h2>Memories</h2><BR></center>"
		dat += "[icon2html(getFlatIcon(host), host)]I am "
		if(host.real_name)
			dat += "[host.real_name],"
		if(!host.real_name)
			dat += "Unknown,"
		dat += " [host.auspice.tribe] [host.auspice.base_breed]"
//		if(host.clane)
//			dat += " the [host.clane.name]"
//		if(!host.clane)
//			dat += " the caitiff"

		if(host.mind)

			if(host.mind.assigned_role)
				if(host.mind.special_role)
					dat += ", carrying the [host.mind.assigned_role] (<font color=red>[host.mind.special_role]</font>) role."
				else
					dat += ", carrying the [host.mind.assigned_role] role."
			if(!host.mind.assigned_role)
				dat += "."
			dat += "<BR>"
		if(host.mind.special_role)
			for(var/datum/antagonist/A in host.mind.antag_datums)
				if(A.objectives)
					dat += "[printobjectives(A.objectives)]<BR>"

		dat += "<b>Physique</b>: [host.physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity]<BR>"
		dat += "<b>Social</b>: [host.social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood]<BR>"
		if(host.Myself)
			if(host.Myself.Friend)
				if(host.Myself.Friend.owner)
					dat += "<b>My friend's name is [host.Myself.Friend.owner.true_real_name].</b><BR>"
					if(host.Myself.Friend.phone_number)
						dat += "Their number is [host.Myself.Friend.phone_number].<BR>"
					if(host.Myself.Friend.friend_text)
						dat += "[host.Myself.Friend.friend_text]<BR>"
			if(host.Myself.Enemy)
				if(host.Myself.Enemy.owner)
					dat += "<b>My nemesis is [host.Myself.Enemy.owner.true_real_name]!</b><BR>"
					if(host.Myself.Enemy.enemy_text)
						dat += "[host.Myself.Enemy.enemy_text]<BR>"
			if(host.Myself.Lover)
				if(host.Myself.Lover.owner)
					dat += "<b>I'm in love with [host.Myself.Lover.owner.true_real_name].</b><BR>"
					if(host.Myself.Lover.phone_number)
						dat += "Their number is [host.Myself.Lover.phone_number].<BR>"
					if(host.Myself.Lover.lover_text)
						dat += "[host.Myself.Lover.lover_text]<BR>"
		if(length(host.knowscontacts) > 0)
			dat += "<b>I know some other of my kind in this city. Need to check my phone, there definetely should be:</b><BR>"
			for(var/i in host.knowscontacts)
				dat += "-[i] contact<BR>"
		host << browse(dat, "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)

/datum/splat/supernatural/garou/on_species_gain(mob/living/carbon/human/C)
	. = ..()
//	ADD_TRAIT(C, TRAIT_NOBLEED, HIGHLANDER)
	C.update_body(0)
	C.last_experience = world.time + 5 MINUTES
	var/datum/action/garouinfo/infor = new()
	infor.host = C
	infor.Grant(C)
	var/datum/action/gift/glabro/glabro = new()
	glabro.Grant(C)
	var/datum/action/gift/rage_heal/GH = new()
	GH.Grant(C)
	C.transformator = new(C)
	C.transformator.human_form = C

	//garou resist vampire bites better than mortals
	RegisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))
	RegisterSignal(C.transformator.lupus_form, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))
	RegisterSignal(C.transformator.crinos_form, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))

/datum/splat/supernatural/garou/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED)
	UnregisterSignal(C.transformator.lupus_form, COMSIG_MOB_VAMPIRE_SUCKED)
	UnregisterSignal(C.transformator.crinos_form, COMSIG_MOB_VAMPIRE_SUCKED)
	for(var/datum/action/garouinfo/VI in C.actions)
		if(VI)
			VI.Remove(C)
	for(var/datum/action/gift/G in C.actions)
		if(G)
			G.Remove(C)

/datum/splat/supernatural/garou/check_roundstart_eligible()
	return FALSE

/proc/adjust_rage(var/amount, var/mob/living/carbon/C, var/sound = TRUE)
	if(amount > 0)
		if(C.auspice.rage < 10)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_increase.ogg', 0, 0, 75))
			to_chat(C, "<span class='userdanger'><b>RAGE INCREASES</b></span>")
			C.auspice.rage = min(10, C.auspice.rage+amount)
	if(amount < 0)
		if(C.auspice.rage > 0)
			C.auspice.rage = max(0, C.auspice.rage+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 75))
			to_chat(C, "<span class='userdanger'><b>RAGE DECREASES</b></span>")
	C.update_rage_hud()

	if(amount && sound)
		if(prob(20))
			C.emote("growl")
			if(iscrinos(C))
				playsound(get_turf(C), 'code/modules/wod13/sounds/crinos_growl.ogg', 75, FALSE)
			if(islupus(C))
				playsound(get_turf(C), 'code/modules/wod13/sounds/lupus_growl.ogg', 75, FALSE)
			if(isgarou(C))
				if(C.gender == FEMALE)
					playsound(get_turf(C), 'code/modules/wod13/sounds/female_growl.ogg', 75, FALSE)
				else
					playsound(get_turf(C), 'code/modules/wod13/sounds/male_growl.ogg', 75, FALSE)

/proc/adjust_gnosis(var/amount, var/mob/living/carbon/C, var/sound = TRUE)
	if(amount > 0)
		if(C.auspice.gnosis < C.auspice.start_gnosis)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS INCREASES</b></span>")
			C.auspice.gnosis = min(C.auspice.start_gnosis, C.auspice.gnosis+amount)
	if(amount < 0)
		if(C.auspice.gnosis > 0)
			C.auspice.gnosis = max(0, C.auspice.gnosis+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 75))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS DECREASES</b></span>")
	C.update_rage_hud()

/**
 * On being bit by a vampire
 *
 * This handles vampire bite sleep immunity and any future special interactions.
 */
/datum/splat/supernatural/garou/proc/on_garou_bitten(datum/source, mob/living/carbon/being_bitten)
	SIGNAL_HANDLER

	if(isgarou(being_bitten) || iswerewolf(being_bitten))
		return COMPONENT_RESIST_VAMPIRE_KISS


/proc/adjust_rage(var/amount, var/mob/living/carbon/C, var/sound = TRUE)
	if(amount > 0)
		if(C.auspice.rage < 10)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_increase.ogg', 0, 0, 75))
			to_chat(C, "<span class='userdanger'><b>RAGE INCREASES</b></span>")
			C.auspice.rage = min(10, C.auspice.rage+amount)
	if(amount < 0)
		if(C.auspice.rage > 0)
			C.auspice.rage = max(0, C.auspice.rage+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 75))
			to_chat(C, "<span class='userdanger'><b>RAGE DECREASES</b></span>")
	C.update_rage_hud()

	if(amount && sound)
		if(prob(20))
			C.emote("growl")
			if(iscrinos(C))
				playsound(get_turf(C), 'code/modules/wod13/sounds/crinos_growl.ogg', 75, FALSE)
			if(islupus(C))
				playsound(get_turf(C), 'code/modules/wod13/sounds/lupus_growl.ogg', 75, FALSE)
			if(isgarou(C))
				if(C.gender == FEMALE)
					playsound(get_turf(C), 'code/modules/wod13/sounds/female_growl.ogg', 75, FALSE)
				else
					playsound(get_turf(C), 'code/modules/wod13/sounds/male_growl.ogg', 75, FALSE)

/proc/adjust_gnosis(var/amount, var/mob/living/carbon/C, var/sound = TRUE)
	if(amount > 0)
		if(C.auspice.gnosis < C.auspice.start_gnosis)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS INCREASES</b></span>")
			C.auspice.gnosis = min(C.auspice.start_gnosis, C.auspice.gnosis+amount)
	if(amount < 0)
		if(C.auspice.gnosis > 0)
			C.auspice.gnosis = max(0, C.auspice.gnosis+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 75))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS DECREASES</b></span>")
	C.update_rage_hud()

/datum/splat/supernatural/garou/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1)
	if(istype(get_area(H), /area/vtm))
		var/area/vtm/V = get_area(H)
		if(V.zone_type == "masquerade" && V.upper)
			if(H.pulling)
				if(ishuman(H.pulling))
					var/mob/living/carbon/human/pull = H.pulling
					if(pull.stat == DEAD)
						var/obj/item/card/id/id_card = H.get_idcard(FALSE)
						if(!istype(id_card, /obj/item/card/id/clinic))
							if(H.CheckEyewitness(H, H, 7, FALSE))
								if(H.last_loot_check+50 <= world.time)
									H.last_loot_check = world.time
									H.last_nonraid = world.time
									H.killed_count = H.killed_count+1
									if(!H.warrant && !H.ignores_warrant)
										if(H.killed_count >= 5)
											H.warrant = TRUE
											SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
										else
											SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (corpse)</b></span>")
			for(var/obj/item/I in H.contents)
				if(I)
					if(I.masquerade_violating)
						if(I.loc == H)
							if(H.CheckEyewitness(H, H, 7, FALSE))
								if(H.last_loot_check+50 <= world.time)
									H.last_loot_check = world.time
									H.last_nonraid = world.time
									H.killed_count = H.killed_count+1
									if(!H.warrant && !H.ignores_warrant)
										if(H.killed_count >= 5)
											H.warrant = TRUE
											SEND_SOUND(H, sound('code/modules/wod13/sounds/suspect.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
										else
											SEND_SOUND(H, sound('code/modules/wod13/sounds/sus.ogg', 0, 0, 75))
											to_chat(H, "<span class='userdanger'><b>SUSPICIOUS ACTION (equipment)</b></span>")
	if((H.last_bloodpool_restore + 60 SECONDS) <= world.time)
		H.last_bloodpool_restore = world.time
		H.bloodpool = min(H.maxbloodpool, H.bloodpool+1)
	if(glabro)
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1)
/mob/living/carbon/werewolf/Initialize()
	var/datum/action/gift/rage_heal/GH = new()
	GH.Grant(src)
	add_verb(src, /mob/living/proc/mob_sleep)
	add_verb(src, /mob/living/proc/toggle_resting)

	create_bodyparts() //initialize bodyparts

	create_internal_organs()

	ADD_TRAIT(src, TRAIT_NEVER_WOUNDED, ROUNDSTART_TRAIT)

	. = ..()

/mob/living/carbon/werewolf/create_internal_organs()
	internal_organs += new /obj/item/organ/brain
	internal_organs += new /obj/item/organ/tongue
	internal_organs += new /obj/item/organ/eyes/night_vision
	internal_organs += new /obj/item/organ/liver
	internal_organs += new /obj/item/organ/stomach
	internal_organs += new /obj/item/organ/heart
	internal_organs += new /obj/item/organ/lungs
	internal_organs += new /obj/item/organ/ears
	..()

/mob/living/carbon/werewolf/crinos
	name = "werewolf"
	icon_state = "black"
	mob_size = MOB_SIZE_HUGE
	butcher_results = list(/obj/item/food/meat/slab = 5)
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	limb_destroyer = 1
	hud_type = /datum/hud/werewolf
	melee_damage_lower = 35
	melee_damage_upper = 65
//	speed = -1  doesn't work on carbons
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 30
	pixel_w = -8
//	deathsound = 'sound/voice/hiss6.ogg'
	bodyparts = list(
		/obj/item/bodypart/chest,
		/obj/item/bodypart/head,
		/obj/item/bodypart/l_arm,
		/obj/item/bodypart/r_arm,
		/obj/item/bodypart/r_leg,
		/obj/item/bodypart/l_leg,
	)

	werewolf_armor = 30

/datum/movespeed_modifier/crinosform
	multiplicative_slowdown = -0.25

/datum/movespeed_modifier/silver_slowdown
	multiplicative_slowdown = 0.3

/mob/living/carbon/werewolf/crinos/Initialize()
	. = ..()
	var/datum/action/change_apparel/A = new()
	A.Grant(src)
//	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 0.5, -11)

/mob/living/carbon/werewolf/lupus/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 0.5, -11)
	var/datum/action/gift/hispo/hispo = new()
	hispo.Grant(src)


/mob/living/carbon/werewolf/Stun(amount, ignore_canstun = FALSE)
	. = ..()
	if(!.)
		move_delay_add = min(move_delay_add + round(amount / 2), 10) //a maximum delay of 10

/mob/living/carbon/werewolf/SetStun(amount, ignore_canstun = FALSE)
	. = ..()
	if(!.)
		move_delay_add = min(move_delay_add + round(amount / 2), 10)

/mob/living/carbon/werewolf/AdjustStun(amount, ignore_canstun = FALSE)
	. = ..()
	if(!.)
		move_delay_add = clamp(move_delay_add + round(amount/2), 0, 10)

///aliens are immune to stamina damage.
/mob/living/carbon/werewolf/adjustStaminaLoss(amount, updating_health = 1, forced = FALSE)
	return FALSE

///aliens are immune to stamina damage.
/mob/living/carbon/werewolf/setStaminaLoss(amount, updating_health = 1)
	return FALSE
/mob/living/carbon/werewolf/lupus
	name = "wolf"
	icon_state = "black"
	icon = 'icons/wod13/werewolf_lupus.dmi'
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	butcher_results = list(/obj/item/food/meat/slab = 5)
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	hud_type = /datum/hud/werewolf
	limb_destroyer = 1
	has_limbs = 0
//	dextrous = FALSE
//	speed = -1.5     doesn't work on carbons
//	var/move_delay_add = -1.5 // movement delay to add    also didn't work
	melee_damage_lower = 15
	melee_damage_upper = 35
//	bodyparts = list(
//		/obj/item/bodypart/chest,
//		/obj/item/bodypart/head,
//		/obj/item/bodypart/r_arm,
//		/obj/item/bodypart/l_arm,
//		/obj/item/bodypart/r_leg,
//		/obj/item/bodypart/l_leg,
//		)
	var/hispo = FALSE

/datum/movespeed_modifier/lupusform
	multiplicative_slowdown = -0.80

/mob/living/carbon/werewolf/lupus/update_icons()
	cut_overlays()

	var/laid_down = FALSE

	if(stat == UNCONSCIOUS || IsSleeping() || stat == HARD_CRIT || stat == SOFT_CRIT || IsParalyzed() || stat == DEAD || body_position == LYING_DOWN)
		icon_state = "[sprite_color]_rest"
		laid_down = TRUE
	else
		icon_state = "[sprite_color]"

	switch(getFireLoss()+getBruteLoss())
		if(25 to 75)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage1[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)
		if(75 to 150)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage2[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)
		if(150 to INFINITY)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage3[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)

	var/mutable_appearance/eye_overlay = mutable_appearance(icon, "eyes[laid_down ? "_rest" : ""]")
	eye_overlay.color = sprite_eye_color
	eye_overlay.plane = ABOVE_LIGHTING_PLANE
	eye_overlay.layer = ABOVE_LIGHTING_LAYER
	add_overlay(eye_overlay)

/mob/living/carbon/werewolf/lupus/regenerate_icons()
	if(!..())
	//	update_icons() //Handled in update_transform(), leaving this here as a reminder
		update_transform()

/mob/living/carbon/werewolf/lupus/update_transform() //The old method of updating lying/standing was update_icons(). Aliens still expect that.
	. = ..()
	update_icons()

/mob/living/carbon/werewolf/lupus/Life()
	if(hispo)
		CheckEyewitness(src, src, 7, FALSE)
	..()

