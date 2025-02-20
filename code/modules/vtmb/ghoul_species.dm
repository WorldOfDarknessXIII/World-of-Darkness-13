/datum/species/ghoul
	name = "Ghoul"
	id = "ghoul"
	default_color = "FFFFFF"
	toxic_food = RAW
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_VIRUSIMMUNE, TRAIT_NOCRITDAMAGE)
	use_skintones = TRUE
	limbs_id = "human"
	mutant_bodyparts = list("tail_human" = "None", "ears" = "None", "wings" = "None")
	brutemod = 1	//0.8 instead, if changing.
	burnmod = 1
	punchdamagelow = 10
	punchdamagehigh = 20
	dust_anim = "dust-h"

	//splat variables
	var/mob/living/carbon/human/master
	var/spend_blood_per_turn = 1
	var/spent_blood_turn = 0
	COOLDOWN_DECLARE(spend_blood_timer)
	var/changed_master = FALSE
	var/last_vitae = 0
	var/list/datum/discipline/disciplines = list()
	selectable = TRUE

/datum/action/ghoulinfo
	name = "About Me"
	desc = "Check assigned role, master, humanity, masquerade, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/ghoulinfo/Trigger()
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
		var/datum/species/ghoul/G
		if(host.dna.species.name == "Ghoul")
			G = host.dna.species
			dat += " the ghoul"

		if(host.mind.assigned_role)
			if(host.mind.special_role)
				dat += ", carrying the [host.mind.assigned_role] (<font color=red>[host.mind.special_role]</font>) role."
			else
				dat += ", carrying the [host.mind.assigned_role] role."
		if(!host.mind.assigned_role)
			dat += "."
		dat += "<BR>"
		if(G.master)
			dat += "My Regnant is [G.master.real_name], I should obey their wants.<BR>"
			if(G.master.clane)
				if(G.master.clane.name != "Caitiff")
					dat += "Regnant's clan is [G.master.clane], maybe I can try some of it's disciplines..."
		if(host.mind.special_role)
			for(var/datum/antagonist/A in host.mind.antag_datums)
				if(A.objectives)
					dat += "[printobjectives(A.objectives)]<BR>"
		var/masquerade_level = " followed the Masquerade Tradition perfectly."
		switch(host.masquerade)
			if(4)
				masquerade_level = " broke the Masquerade rule once."
			if(3)
				masquerade_level = " made a couple of Masquerade breaches."
			if(2)
				masquerade_level = " provoked a moderate Masquerade breach."
			if(1)
				masquerade_level = " almost ruined the Masquerade."
			if(0)
				masquerade_level = "'m danger to the Masquerade and my own kind."
		dat += "Camarilla thinks I[masquerade_level]<BR>"
//		var/humanity = "I'm out of my mind."
//		switch(host.humanity)
//			if(8 to 10)
//				humanity = "I'm the best example of mercy and kindness."
//			if(7)
//				humanity = "I have nothing to complain about my humanity."
//			if(5 to 6)
//				humanity = "I'm slightly above the humane."
//			if(4)
//				humanity = "I don't care about kine."
//			if(2 to 3)
//				humanity = "There's nothing bad in murdering for <b>BLOOD</b>."
//			if(1)
//				humanity = "I'm slowly falling into madness..."
//		dat += "[humanity]<BR>"
		dat += "<b>Physique</b>: [host.physique] + [host.additional_physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity] + [host.additional_dexterity]<BR>"
		dat += "<b>Social</b>: [host.social] + [host.additional_social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality] + [host.additional_mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood] + [host.additional_blood]<BR>"
		dat += "<b>Lockpicking</b>: [host.lockpicking] + [host.additional_lockpicking]<BR>"
		dat += "<b>Athletics</b>: [host.athletics] + [host.additional_athletics]<BR>"
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
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
			if(host.bank_id == account.bank_id)
				dat += "<b>My bank account code is: [account.code]</b><BR>"
		host << browse(dat, "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "ghoul", src)

/datum/species/ghoul/on_species_gain(mob/living/carbon/human/C)
	..()
	C.update_body(0)
	C.last_experience = world.time + 5 MINUTES
	var/datum/action/ghoulinfo/infor = new()
	infor.host = C
	infor.Grant(C)
	C.generation = 13

	var/datum/discipline/bloodheal/giving_bloodheal = new(1) //poor ghoulies can only spend 1 blood per turn
	C.give_discipline(giving_bloodheal)

/datum/species/ghoul/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	for(var/datum/action/A in C.actions)
		if(A.vampiric)
			A.Remove(C)
	for(var/datum/action/ghoulinfo/infor in C.actions)
		infor.Remove(C)
	QDEL_LIST(disciplines)

/datum/action/take_vitae
	name = "Take Vitae"
	desc = "Take vitae from a Vampire by force."
	button_icon_state = "ghoul"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/taking = FALSE

/datum/action/take_vitae/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		if(istype(H.pulling, /mob/living/carbon/human))
			var/mob/living/carbon/human/VIT = H.pulling
			if(iskindred(VIT))
				if(VIT.bloodpool)
					if(VIT.getBruteLoss() > 30)
						taking = TRUE
						if(do_mob(owner, VIT, 10 SECONDS))
							taking = FALSE
							H.drunked_of |= "[VIT.dna.real_name]"
							H.adjustBruteLoss(-25, TRUE)
							H.adjustFireLoss(-25, TRUE)
							VIT.adjust_blood_points(-1)
							H.adjust_blood_points(1)
							to_chat(owner, "<span class='warning'>You feel precious <b>VITAE</b> entering your mouth and suspending your addiction.</span>")
							return
						else
							taking = FALSE
							return
					else
						to_chat(owner, "<span class='warning'>Damage [VIT] before taking vitae.</span>")
						return
				else
					to_chat(owner, "<span class='warning'>There is not enough <b>VITAE</b> in [VIT] to feed your addiction.</span>")
					return
			else
				to_chat(owner, "<span class='warning'>You don't sense the <b>VITAE</b> in [VIT].</span>")
				return

/datum/species/ghoul/check_roundstart_eligible()
	return TRUE

/datum/species/ghoul/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.AdjustMasquerade(-1)
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
	if(H.key && H.stat != DEAD)
		var/datum/preferences/P = GLOB.preferences_datums[ckey(H.key)]
		if(P)
			if(P.masquerade != H.masquerade)
				P.masquerade = H.masquerade
				P.save_preferences()
				P.save_character()

			if(H.humanity <= 2)
				if(prob(5))
					if(prob(50))
						H.Stun(20)
						to_chat(H, "<span class='warning'>You stop in fear and remember your crimes against humanity...</span>")
						H.emote("cry")
					else
						to_chat(H, "<span class='warning'>You feel the rage rising as your last sins come to your head...</span>")
						H.drop_all_held_items()
						H.emote("scream")

/datum/species/human/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.AdjustMasquerade(-1)
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
								if((H.last_loot_check + 5 SECONDS) <= world.time)
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

/datum/species/garou/spec_life(mob/living/carbon/human/H)
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
	if(glabro)
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1)

/**
 * Accesses a certain Discipline that a Ghoul has. Returns false if they don't.
 *
 * Arguments:
 * * searched_discipline - Name or typepath of the Discipline being searched for.
 */
/datum/species/ghoul/proc/get_discipline(searched_discipline)
	for(var/datum/discipline/discipline in disciplines)
		if (ispath(searched_discipline, /datum/discipline))
			if (istype(discipline, searched_discipline))
				return discipline
		else if (istext(searched_discipline))
			if (discipline.name == searched_discipline)
				return discipline

	return FALSE

/datum/species/ghoul/proc/can_spend_blood(mob/living/carbon/human/ghoul, amount)
	if ((spent_blood_turn + amount) > spend_blood_per_turn)
		return FALSE
	if (!ghoul.can_adjust_blood_points(-amount))
		return FALSE
	if (!COOLDOWN_FINISHED(src, spend_blood_timer))
		return FALSE
	return TRUE

/datum/species/ghoul/proc/spend_blood(mob/living/carbon/human/ghoul, amount)
	spent_blood_turn += amount
	ghoul.adjust_blood_points(-amount)
	//one decisecond shorter than a turn to allow powers to refresh on a full turn basis
	addtimer(CALLBACK(src, PROC_REF(refresh_spent_blood), amount), DURATION_TURN - 1)

/datum/species/ghoul/proc/try_spend_blood(mob/living/carbon/human/ghoul, amount)
	if (can_spend_blood(ghoul, amount))
		spend_blood(ghoul, amount)
		return TRUE
	return FALSE

/datum/species/ghoul/proc/refresh_spent_blood(amount)
	spent_blood_turn -= amount
