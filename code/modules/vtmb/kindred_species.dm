/**
 * This is the splat (supernatural type, game line in the World of Darkness) container
 * for all vampire-related code. I think this is stupid and I don't want any of this to
 * be the way it is, but if we're going to work with the code that's been written then
 * my advice is to centralise all stuff directly relating to vampires to here if it isn't
 * already in another organisational structure.
 *
 * The same applies to other splats, like /datum/species/garou or /datum/species/ghoul.
 * Halfsplats like ghouls are going to share some code with their fullsplats (vampires).
 * I dunno what to do about this except a reorganisation to make this stuff actually good.
 * The plan right now is to create a /datum/splat parent type and then have everything branch
 * from there, but that's for the future.
 */

/datum/species/kindred
	name = "Vampire"
	id = "kindred"
	default_color = "FFFFFF"
	toxic_food = MEAT | VEGETABLES | RAW | JUNKFOOD | GRAIN | FRUIT | DAIRY | FRIED | ALCOHOL | SUGAR | PINEAPPLE
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LIMBATTACHMENT, TRAIT_VIRUSIMMUNE, TRAIT_NOBLEED, TRAIT_NOHUNGER, TRAIT_NOBREATH, TRAIT_TOXIMMUNE, TRAIT_NOCRITDAMAGE)
	use_skintones = TRUE
	limbs_id = "human"
	wings_icon = "Dragon"
	mutant_bodyparts = list("tail_human" = "None", "ears" = "None", "wings" = "None")
	mutantbrain = /obj/item/organ/brain/vampire
	brutemod = 0.5	// or change to 0.8
	heatmod = 1		//Sucking due to overheating	///THEY DON'T SUCK FROM FIRE ANYMORE
	burnmod = 2
	punchdamagelow = 10
	punchdamagehigh = 20
	dust_anim = "dust-h"
	var/datum/vampireclane/clane
	var/list/datum/discipline/disciplines = list()
	selectable = TRUE
	COOLDOWN_DECLARE(torpor_timer)

/datum/action/vampireinfo
	name = "About Me"
	desc = "Check assigned role, clan, generation, humanity, masquerade, known disciplines, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/vampireinfo/Trigger()
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
		if(host.clane)
			dat += " the [host.clane.name]"
		if(!host.clane)
			dat += " the caitiff"

		if(host.mind)

			if(host.mind.assigned_role)
				if(host.mind.special_role)
					dat += ", carrying the [host.mind.assigned_role] (<font color=red>[host.mind.special_role]</font>) role."
				else
					dat += ", carrying the [host.mind.assigned_role] role."
			if(!host.mind.assigned_role)
				dat += "."
			dat += "<BR>"
			if(host.mind.enslaved_to)
				dat += "My Regnant is [host.mind.enslaved_to], I should obey their wants.<BR>"
		if(host.generation)
			dat += "I'm from [host.generation] generation.<BR>"
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
		var/humanity = "I'm out of my mind."
		var/enlight = FALSE
		if(host.clane)
			if(host.clane.enlightenment)
				enlight = TRUE

		if(!enlight)
			switch(host.humanity)
				if(8 to 10)
					humanity = "I'm saintly."
				if(7)
					humanity = "I feel as human as when I lived."
				if(5 to 6)
					humanity = "I'm feeling distant from my humanity."
				if(4)
					humanity = "I don't feel any compassion for the Kine anymore."
				if(2 to 3)
					humanity = "I feel hunger for <b>BLOOD</b>. My humanity is slipping away."
				if(1)
					humanity = "Blood. Feed. Hunger. It gnaws. Must <b>FEED!</b>"

		else
			switch(host.humanity)
				if(8 to 10)
					humanity = "I'm <b>ENLIGHTENED</b>, my <b>BEAST</b> and I are in complete harmony."
				if(7)
					humanity = "I've made great strides in co-existing with my beast."
				if(5 to 6)
					humanity = "I'm starting to learn how to share this unlife with my beast."
				if(4)
					humanity = "I'm still new to my path, but I'm learning."
				if(2 to 3)
					humanity = "I'm a complete novice to my path."
				if(1)
					humanity = "I'm losing control over my beast!"

		dat += "[humanity]<BR>"

		if(host.clane.name == "Brujah")
			if(GLOB.brujahname != "")
				if(host.real_name != GLOB.brujahname)
					dat += " My primogen is:  [GLOB.brujahname].<BR>"
		if(host.clane.name == "Malkavian")
			if(GLOB.malkavianname != "")
				if(host.real_name != GLOB.malkavianname)
					dat += " My primogen is:  [GLOB.malkavianname].<BR>"
		if(host.clane.name == "Nosferatu")
			if(GLOB.nosferatuname != "")
				if(host.real_name != GLOB.nosferatuname)
					dat += " My primogen is:  [GLOB.nosferatuname].<BR>"
		if(host.clane.name == "Toreador")
			if(GLOB.toreadorname != "")
				if(host.real_name != GLOB.toreadorname)
					dat += " My primogen is:  [GLOB.toreadorname].<BR>"
		if(host.clane.name == "Ventrue")
			if(GLOB.ventruename != "")
				if(host.real_name != GLOB.ventruename)
					dat += " My primogen is:  [GLOB.ventruename].<BR>"

		dat += "<b>Physique</b>: [host.physique] + [host.additional_physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity] + [host.additional_dexterity]<BR>"
		dat += "<b>Social</b>: [host.social] + [host.additional_social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality] + [host.additional_mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood] + [host.additional_blood]<BR>"
		dat += "<b>Lockpicking</b>: [host.lockpicking] + [host.additional_lockpicking]<BR>"
		dat += "<b>Athletics</b>: [host.athletics] + [host.additional_athletics]<BR>"
		if(host.hud_used)
			dat += "<b>Known disciplines:</b><BR>"
			for(var/datum/action/discipline/D in host.actions)
				if(D)
					if(D.discipline)
						dat += "[D.discipline.name] [D.discipline.level] - [D.discipline.desc]<BR>"
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
		var/obj/keypad/armory/armory = find_keypad(/obj/keypad/armory)
		if(armory && (host.mind.assigned_role == "Prince" || host.mind.assigned_role == "Sheriff" || host.mind.assigned_role == "Seneschal"))
			dat += "The pincode for the armory keypad is<b>: [armory.pincode]</b><BR>"
		var/obj/keypad/panic_room/panic = find_keypad(/obj/keypad/panic_room)
		if(panic && (host.mind.assigned_role == "Prince" || host.mind.assigned_role == "Sheriff" || host.mind.assigned_role == "Seneschal"))
			dat += "The pincode for the panic room keypad is<b>: [panic.pincode]</b><BR>"
		var/obj/structure/vaultdoor/pincode/bank/bankdoor = find_door_pin(/obj/structure/vaultdoor/pincode/bank)
		if(bankdoor && (host.mind.assigned_role == "Capo"))
			dat += "The pincode for the bank vault is <b>: [bankdoor.pincode]</b><BR>"
		if(bankdoor && (host.mind.assigned_role == "La Squadra"))
			if(prob(50))
				dat += "<b>The pincode for the bank vault is: [bankdoor.pincode]</b><BR>"
			else
				dat += "<b>Unfortunately you don't know the vault code.</b><BR>"

		if(length(host.knowscontacts) > 0)
			dat += "<b>I know some other of my kind in this city. Need to check my phone, there definetely should be:</b><BR>"
			for(var/i in host.knowscontacts)
				dat += "-[i] contact<BR>"
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
			if(host.bank_id == account.bank_id)
				dat += "<b>My bank account code is: [account.code]</b><BR>"
		host << browse(dat, "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)

/datum/species/kindred/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	C.update_body(0)
	C.last_experience = world.time + 5 MINUTES

	var/datum/action/vampireinfo/infor = new()
	infor.host = C
	infor.Grant(C)

	var/datum/action/give_vitae/vitae = new()
	vitae.Grant(C)

	//this needs to be adjusted to be more accurate for blood spending rates
	var/datum/discipline/bloodheal/giving_bloodheal = new(clamp(11 - C.generation, 1, 10))
	C.give_discipline(giving_bloodheal)

	var/datum/action/blood_power/bloodpower = new()
	bloodpower.Grant(C)

	add_verb(C, /mob/living/carbon/human/verb/teach_discipline)

	C.yang_chi = 0
	C.max_yang_chi = 0
	C.yin_chi = 6
	C.max_yin_chi = 6

	//vampires go to -200 damage before dying
	for (var/obj/item/bodypart/bodypart in C.bodyparts)
		bodypart.max_damage *= 1.5

	//vampires die instantly upon having their heart removed
	RegisterSignal(C, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(lose_organ))

	//vampires don't die while in crit, they just slip into torpor after 2 minutes of being critted
	RegisterSignal(C, SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION), PROC_REF(slip_into_torpor))

	//vampires resist vampire bites better than mortals
	RegisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_vampire_bitten))

/datum/species/kindred/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED)
	for(var/datum/action/vampireinfo/VI in C.actions)
		VI.Remove(C)
	for(var/datum/action/A in C.actions)
		if (A.spell_button)
			A.Remove(C)

/datum/action/blood_power
	name = "Blood Power"
	desc = "Use vitae to gain supernatural abilities."
	button_icon_state = "bloodpower"
	button_icon = 'code/modules/wod13/UI/actions.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/actions.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	spell_button = TRUE

/datum/action/blood_power/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(!owner.client?.prefs)
		return ..()

	if (owner.client.prefs.old_discipline)
		button_icon = 'code/modules/wod13/disciplines.dmi'
		icon_icon = 'code/modules/wod13/disciplines.dmi'
	else
		button_icon = 'code/modules/wod13/UI/actions.dmi'
		icon_icon = 'code/modules/wod13/UI/actions.dmi'

	. = ..()

/datum/action/blood_power/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		if (HAS_TRAIT(owner, TRAIT_TORPOR))
			return
		var/mob/living/carbon/human/BD = usr
		if(world.time < BD.last_bloodpower_use+110)
			return
		var/plus = 0
		if(HAS_TRAIT(BD, TRAIT_HUNGRY))
			plus = 1
		if(BD.bloodpool >= 2+plus)
			playsound(usr, 'code/modules/wod13/sounds/bloodhealing.ogg', 50, FALSE)
			button.color = "#970000"
			animate(button, color = "#ffffff", time = 20, loop = 1)
			BD.last_bloodpower_use = world.time
			BD.bloodpool = max(0, BD.bloodpool-(2+plus))
			to_chat(BD, "<span class='notice'>You use blood to become more powerful.</span>")
			BD.dna.species.punchdamagehigh = BD.dna.species.punchdamagehigh+5
			BD.physiology.armor.melee = BD.physiology.armor.melee+15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet+15
			BD.dexterity = BD.dexterity+2
			BD.athletics = BD.athletics+2
			BD.lockpicking = BD.lockpicking+2
			if(!HAS_TRAIT(BD, TRAIT_IGNORESLOWDOWN))
				ADD_TRAIT(BD, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
			BD.update_blood_hud()
			spawn(100+BD.discipline_time_plus+BD.bloodpower_time_plus)
				end_bloodpower()
		else
			SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
			to_chat(BD, "<span class='warning'>You don't have enough <b>BLOOD</b> to become more powerful.</span>")

/datum/action/blood_power/proc/end_bloodpower()
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/BD = owner
		to_chat(BD, "<span class='warning'>You feel like your <b>BLOOD</b>-powers slowly decrease.</span>")
		if(BD.dna.species)
			BD.dna.species.punchdamagehigh = BD.dna.species.punchdamagehigh-5
			BD.physiology.armor.melee = BD.physiology.armor.melee-15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet-15
			if(HAS_TRAIT(BD, TRAIT_IGNORESLOWDOWN))
				REMOVE_TRAIT(BD, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
		BD.dexterity = BD.dexterity-2
		BD.athletics = BD.athletics-2
		BD.lockpicking = BD.lockpicking-2

/datum/action/give_vitae
	name = "Give Vitae"
	desc = "Give your vitae to someone, make the Blood Bond."
	button_icon_state = "vitae"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	spell_button = TRUE
	var/giving = FALSE

/datum/action/give_vitae/Trigger()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/vampire = owner

	if(vampire.bloodpool < 2)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return

	if(!ishuman(vampire.pulling))
		return
	var/mob/living/carbon/human/victim = vampire.pulling

	if(is_kuei_jin(victim))
		to_chat(owner, "<span class='warning'>[victim] vomits the vitae back!</span>")
		return

	if(!victim.client && !istype(vampire.pulling, /mob/living/carbon/human/npc))
		to_chat(owner, "<span class='warning'>You need [victim]'s attention to do that!</span>")
		return

	if(victim.stat == DEAD)
		if(!victim.key)
			to_chat(owner, "<span class='warning'>You need [victim]'s mind to Embrace!</span>")
			return
		message_admins("[ADMIN_LOOKUPFLW(vampire)] is Embracing [ADMIN_LOOKUPFLW(victim)]!")

	if(giving)
		return
	giving = TRUE
	owner.visible_message("<span class='warning'>[owner] tries to feed [victim] with their own blood!</span>", "<span class='notice'>You started to feed [victim] with your own blood.</span>")
	if(!do_mob(owner, victim, 10 SECONDS))
		giving = FALSE
		return

	vampire.bloodpool = max(0, vampire.bloodpool-2)
	giving = FALSE

	var/new_master = FALSE
	victim.drunked_of |= "[vampire.dna.real_name]"

	if(victim.stat == DEAD && !is_kindred(victim))
		if (!HAS_TRAIT(victim, TRAIT_CANNOT_BE_EMBRACED) || !victim.can_be_revived())
			to_chat(vampire, "<span class='notice'>[victim.name] doesn't respond to your Vitae.</span>")
			return

		if((victim.timeofdeath + 5 MINUTES) > world.time)
			if (victim.auspice?.level) //here be Abominations
				if (victim.auspice.force_abomination)
					to_chat(vampire, "<span class='danger'>Something terrible is happening.</span>")
					to_chat(victim, "<span class='userdanger'>Gaia has forsaken you.</span>")
					message_admins("[ADMIN_LOOKUPFLW(vampire)] has turned [ADMIN_LOOKUPFLW(victim)] into an Abomination through an admin setting the force_abomination var.")
					log_game("[key_name(vampire)] has turned [key_name(victim)] into an Abomination through an admin setting the force_abomination var.")
				else
					switch(storyteller_roll(victim.auspice.level))
						if (ROLL_BOTCH)
							to_chat(vampire, "<span class='danger'>Something terrible is happening.</span>")
							to_chat(victim, "<span class='userdanger'>Gaia has forsaken you.</span>")
							message_admins("[ADMIN_LOOKUPFLW(vampire)] has turned [ADMIN_LOOKUPFLW(victim)] into an Abomination.")
							log_game("[key_name(vampire)] has turned [key_name(victim)] into an Abomination.")
						if (ROLL_FAILURE)
							victim.visible_message("<span class='warning'>[victim.name] convulses in sheer agony!</span>")
							victim.Shake(15, 15, 5 SECONDS)
							playsound(victim.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE)
							ADD_TRAIT(victim, TRAIT_CANNOT_BE_EMBRACED, WEREWOLF_TRAIT)
							return
						if (ROLL_SUCCESS)
							to_chat(vampire, "<span class='notice'>[victim.name] does not respond to your Vitae...</span>")
							ADD_TRAIT(victim, TRAIT_CANNOT_BE_EMBRACED, WEREWOLF_TRAIT)
							return

			log_game("[key_name(vampire)] has Embraced [key_name(victim)].")
			message_admins("[ADMIN_LOOKUPFLW(vampire)] has Embraced [ADMIN_LOOKUPFLW(victim)].")
			giving = FALSE
			var/save_data_v = FALSE
			if(victim.revive(full_heal = TRUE, admin_revive = TRUE))
				victim.grab_ghost(force = TRUE)
				to_chat(victim, "<span class='userdanger'>You rise with a start, you're alive! Or not... You feel your soul going somewhere, as you realize you are embraced by a vampire...</span>")
				var/response_v = input(victim, "Do you wish to keep being a vampire on your save slot?(Yes will be a permanent choice and you can't go back!)") in list("Yes", "No")
				if(response_v == "Yes")
					save_data_v = TRUE
				else
					save_data_v = FALSE
			victim.roundstart_vampire = FALSE
			victim.set_species(/datum/species/kindred)
			victim.clane = null
			if(vampire.generation < 13)
				victim.generation = 13
				victim.skin_tone = get_vamp_skin_color(victim.skin_tone)
				victim.update_body()
				if (vampire.clane.whitelisted)
					if (!SSwhitelists.is_whitelisted(victim.ckey, vampire.clane.name))
						if(vampire.clane.name == "True Brujah")
							victim.clane = new /datum/vampireclane/brujah()
							to_chat(victim,"<span class='warning'> You don't got that whitelist! Changing to the non WL Brujah</span>")
						else if(vampire.clane.name == "Tzimisce")
							victim.clane = new /datum/vampireclane/old_clan_tzimisce()
							to_chat(victim,"<span class='warning'> You don't got that whitelist! Changing to the non WL Old Tzmisce</span>")
						else
							to_chat(victim,"<span class='warning'> You don't got that whitelist! Changing to a random non WL clan.</span>")
							var/list/non_whitelisted_clans = list(/datum/vampireclane/brujah,/datum/vampireclane/malkavian,/datum/vampireclane/nosferatu,/datum/vampireclane/gangrel,/datum/vampireclane/giovanni,/datum/vampireclane/ministry,/datum/vampireclane/salubri,/datum/vampireclane/toreador,/datum/vampireclane/tremere,/datum/vampireclane/ventrue)
							var/random_clan = pick(non_whitelisted_clans)
							victim.clane = new random_clan
					else
						victim.clane = new vampire.clane.type()
				else
					victim.clane = new vampire.clane.type()

				victim.clane.on_gain(victim)
				victim.clane.post_gain(victim)
				if(victim.clane.alt_sprite)
					victim.skin_tone = "albino"
					victim.update_body()

				//Gives the Childe the Sire's first three Disciplines

				var/list/disciplines_to_give = list()
				for (var/i in 1 to min(3, vampire.client.prefs.discipline_types.len))
					disciplines_to_give += vampire.client.prefs.discipline_types[i]
				victim.create_disciplines(FALSE, disciplines_to_give)

				victim.maxbloodpool = 10+((13-min(13, victim.generation))*3)
				victim.clane.enlightenment = vampire.clane.enlightenment
			else
				victim.maxbloodpool = 10+((13-min(13, victim.generation))*3)
				victim.generation = 14
				victim.clane = new /datum/vampireclane/caitiff()

			//Verify if they accepted to save being a vampire
			if (is_kindred(victim) && save_data_v)
				var/datum/preferences/BLOODBONDED_prefs_v = victim.client.prefs

				BLOODBONDED_prefs_v.pref_species.id = "kindred"
				BLOODBONDED_prefs_v.pref_species.name = "Vampire"
				if(vampire.generation < 13)

					BLOODBONDED_prefs_v.clane = victim.clane
					BLOODBONDED_prefs_v.generation = 13
					BLOODBONDED_prefs_v.skin_tone = get_vamp_skin_color(victim.skin_tone)
					BLOODBONDED_prefs_v.clane.enlightenment = vampire.clane.enlightenment


					//Rarely the new mid round vampires get the 3 brujah skil(it is default)
					//This will remove if it happens
					// Or if they are a ghoul with abunch of disciplines
					if(BLOODBONDED_prefs_v.discipline_types.len > 0)
						for (var/i in 1 to BLOODBONDED_prefs_v.discipline_types.len)
							var/removing_discipline = BLOODBONDED_prefs_v.discipline_types[1]
							if (removing_discipline)
								var/index = BLOODBONDED_prefs_v.discipline_types.Find(removing_discipline)
								BLOODBONDED_prefs_v.discipline_types.Cut(index, index + 1)
								BLOODBONDED_prefs_v.discipline_levels.Cut(index, index + 1)

					if(BLOODBONDED_prefs_v.discipline_types.len == 0)
						for (var/i in 1 to 3)
							BLOODBONDED_prefs_v.discipline_types += BLOODBONDED_prefs_v.clane.clane_disciplines[i]
							BLOODBONDED_prefs_v.discipline_levels += 1
					BLOODBONDED_prefs_v.save_character()

				else
					BLOODBONDED_prefs_v.generation = 13 // Game always set to 13 anyways, 14 is not possible.
					BLOODBONDED_prefs_v.clane = new /datum/vampireclane/caitiff()
					BLOODBONDED_prefs_v.save_character()

		else

			to_chat(owner, "<span class='notice'>[victim] is totally <b>DEAD</b>!</span>")
			giving = FALSE
			return
	else
		if(victim.has_status_effect(STATUS_EFFECT_INLOVE))
			victim.remove_status_effect(STATUS_EFFECT_INLOVE)
		victim.apply_status_effect(STATUS_EFFECT_INLOVE, owner)
		to_chat(owner, "<span class='notice'>You successfuly fed [victim] with vitae.</span>")
		to_chat(victim, "<span class='userlove'>You feel good when you drink this <b>BLOOD</b>...</span>")

		message_admins("[ADMIN_LOOKUPFLW(vampire)] has bloodbonded [ADMIN_LOOKUPFLW(victim)].")
		log_game("[key_name(vampire)] has bloodbonded [key_name(victim)].")

		if(vampire.reagents)
			if(length(vampire.reagents.reagent_list))
				vampire.reagents.trans_to(victim, min(10, vampire.reagents.total_volume), transfered_by = vampire, methods = VAMPIRE)
		victim.adjustBruteLoss(-25, TRUE)
		if(length(victim.all_wounds))
			var/datum/wound/W = pick(victim.all_wounds)
			W.remove_wound()
		victim.adjustFireLoss(-25, TRUE)
		victim.bloodpool = min(victim.maxbloodpool, victim.bloodpool+2)
		giving = FALSE

		if (is_kindred(victim))
			var/datum/species/kindred/species = victim.dna.species
			if (HAS_TRAIT(victim, TRAIT_TORPOR) && COOLDOWN_FINISHED(species, torpor_timer))
				victim.untorpor()

		if(!is_ghoul(victim) && istype(victim, /mob/living/carbon/human/npc))
			var/mob/living/carbon/human/npc/NPC = vampire.pulling
			if(NPC.ghoulificate(owner))
				new_master = TRUE
				NPC.roundstart_vampire = FALSE
		if(victim.mind)
			if(victim.mind.enslaved_to != owner)
				victim.mind.enslave_mind_to_creator(owner)
				to_chat(victim, "<span class='userdanger'><b>AS PRECIOUS VITAE ENTER YOUR MOUTH, YOU NOW ARE IN THE BLOODBOND OF [vampire]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b></span>")
				new_master = TRUE
		if(is_ghoul(victim))
			var/datum/species/ghoul/G = victim.dna.species
			G.master = owner
			G.last_vitae = world.time
			if(new_master)
				G.changed_master = TRUE
		else if(!is_kindred(victim) && !isnpc(victim))
			var/save_data_g = FALSE
			victim.set_species(/datum/species/ghoul)
			victim.clane = null
			var/response_g = input(victim, "Do you wish to keep being a ghoul on your save slot?(Yes will be a permanent choice and you can't go back)") in list("Yes", "No")
			victim.roundstart_vampire = FALSE
			var/datum/species/ghoul/G = victim.dna.species
			G.master = owner
			G.last_vitae = world.time
			if(new_master)
				G.changed_master = TRUE
			if(response_g == "Yes")
				save_data_g = TRUE
			else
				save_data_g = FALSE
			if(save_data_g)
				var/datum/preferences/BLOODBONDED_prefs_g = victim.client.prefs
				if(BLOODBONDED_prefs_g.discipline_types.len == 3)
					for (var/i in 1 to 3)
						var/removing_discipline = BLOODBONDED_prefs_g.discipline_types[1]
						if (removing_discipline)
							var/index = BLOODBONDED_prefs_g.discipline_types.Find(removing_discipline)
							BLOODBONDED_prefs_g.discipline_types.Cut(index, index + 1)
							BLOODBONDED_prefs_g.discipline_levels.Cut(index, index + 1)
				BLOODBONDED_prefs_g.pref_species.name = "Ghoul"
				BLOODBONDED_prefs_g.pref_species.id = "ghoul"
				BLOODBONDED_prefs_g.save_character()

/**
 * Initialises Disciplines for new vampire mobs, applying effects and creating action buttons.
 *
 * If discipline_pref is true, it grabs all of the source's Disciplines from their preferences
 * and applies those using the give_discipline() proc. If false, it instead grabs a given list
 * of Discipline typepaths and initialises those for the character. Only works for ghouls and
 * vampires, and it also applies the Clan's post_gain() effects
 *
 * Arguments:
 * * discipline_pref - Whether Disciplines will be taken from preferences. True by default.
 * * disciplines - list of Discipline typepaths to grant if discipline_pref is false.
 */
/mob/living/carbon/human/proc/create_disciplines(discipline_pref = TRUE, list/disciplines)	//EMBRACE BASIC
	if(client)
		client.prefs.slotlocked = TRUE
		client.prefs.save_preferences()
		client.prefs.save_character()

	if((dna.species.id == "kindred") || (dna.species.id == "ghoul")) //only splats that have Disciplines qualify
		var/list/datum/discipline/adding_disciplines = list()

		if (discipline_pref) //initialise player's own disciplines
			for (var/i in 1 to client.prefs.discipline_types.len)
				var/type_to_create = client.prefs.discipline_types[i]
				var/level = client.prefs.discipline_levels[i]
				var/datum/discipline/discipline = new type_to_create(level)

				//prevent Disciplines from being used if not whitelisted for them
				if (discipline.clan_restricted)
					if (!can_access_discipline(src, type_to_create))
						qdel(discipline)
						continue

				adding_disciplines += discipline
		else if (disciplines.len) //initialise given disciplines
			for (var/i in 1 to disciplines.len)
				var/type_to_create = disciplines[i]
				var/datum/discipline/discipline = new type_to_create(1)
				adding_disciplines += discipline

		for (var/datum/discipline/discipline in adding_disciplines)
			give_discipline(discipline)

		if(clane)
			clane.post_gain(src)

	if((dna.species.id == "kuei-jin")) //only splats that have Disciplines qualify
		var/list/datum/chi_discipline/adding_disciplines = list()

		if (discipline_pref) //initialise character's own disciplines
			for (var/i in 1 to client.prefs.discipline_types.len)
				var/type_to_create = client.prefs.discipline_types[i]
				var/datum/chi_discipline/discipline = new type_to_create
				discipline.level = client.prefs.discipline_levels[i]
				adding_disciplines += discipline

		for (var/datum/chi_discipline/discipline in adding_disciplines)
			give_chi_discipline(discipline)

/**
 * Creates an action button and applies post_gain effects of the given Discipline.
 *
 * Arguments:
 * * discipline - Discipline datum that is being given to this mob.
 */
/mob/living/carbon/human/proc/give_discipline(datum/discipline/discipline)
	if (discipline.level > 0)
		var/datum/action/discipline/action = new(discipline)
		action.Grant(src)
	var/datum/species/kindred/species = dna.species
	species.disciplines += discipline

/mob/living/carbon/human/proc/give_chi_discipline(datum/chi_discipline/discipline)
	if (discipline.level > 0)
		var/datum/action/chi_discipline/action = new
		action.discipline = discipline
		action.Grant(src)
	discipline.post_gain(src)

/**
 * Accesses a certain Discipline that a Kindred has. Returns false if they don't.
 *
 * Arguments:
 * * searched_discipline - Name or typepath of the Discipline being searched for.
 */
/datum/species/kindred/proc/get_discipline(searched_discipline)
	for(var/datum/discipline/discipline in disciplines)
		if (ispath(searched_discipline, /datum/discipline))
			if (istype(discipline, searched_discipline))
				return discipline
		else if (istext(searched_discipline))
			if (discipline.name == searched_discipline)
				return discipline

	return FALSE

/datum/species/kindred/check_roundstart_eligible()
	return TRUE

/datum/species/kindred/handle_body(mob/living/carbon/human/H)
	if (!H.clane)
		return ..()

	//deflate people if they're super rotten
	if ((H.clane.alt_sprite == "rotten4") && (H.base_body_mod == "f"))
		H.base_body_mod = ""

	if(H.clane.alt_sprite)
		H.dna.species.limbs_id = "[H.base_body_mod][H.clane.alt_sprite]"

	if (H.clane.no_hair)
		H.hairstyle = "Bald"

	if (H.clane.no_facial)
		H.facial_hairstyle = "Shaved"

	..()


/**
 * Signal handler for lose_organ to near-instantly kill Kindred whose hearts have been removed.
 *
 * Arguments:
 * * source - The Kindred whose organ has been removed.
 * * organ - The organ which has been removed.
 */
/datum/species/kindred/proc/lose_organ(var/mob/living/carbon/human/source, var/obj/item/organ/organ)
	SIGNAL_HANDLER

	if (istype(organ, /obj/item/organ/heart))
		spawn()
			if (!source.getorganslot(ORGAN_SLOT_HEART))
				source.death()

/datum/species/kindred/proc/slip_into_torpor(var/mob/living/carbon/human/source)
	SIGNAL_HANDLER

	to_chat(source, "<span class='warning'>You can feel yourself slipping into Torpor. You can use succumb to immediately sleep...</span>")
	spawn(2 MINUTES)
		if (source.stat >= SOFT_CRIT)
			source.torpor("damage")

/**
 * Verb to teach your Disciplines to vampires who have drank your blood by spending 10 experience points.
 *
 * Disciplines can be taught to any willing vampires who have drank your blood in the last round and do
 * not already have that Discipline. True Brujah learning Celerity or Old Clan Tzimisce learning Vicissitude
 * get kicked out of their bloodline and made into normal Brujah and Tzimisce respectively. Disciplines
 * are taught at the 0th level, unlocking them but not actually giving the Discipline to the student.
 * Teaching Disciplines takes 10 experience points, then the student can buy the 1st rank for another 10.
 * The teacher must have the Discipline at the 5th level to teach it to others.
 *
 * Arguments:
 * * student - human who this Discipline is being taught to.
 */
/mob/living/carbon/human/verb/teach_discipline(mob/living/carbon/human/student in (range(1, src) - src))
	set name = "Teach Discipline"
	set category = "IC"
	set desc ="Teach a Discipline to a Kindred who has recently drank your blood. Costs 10 experience points."

	var/mob/living/carbon/human/teacher = src
	var/datum/preferences/teacher_prefs = teacher.client.prefs
	var/datum/species/kindred/teacher_species = teacher.dna.species

	if (!student.client)
		to_chat(teacher, "<span class='warning'>Your student needs to be a player!</span>")
		return
	var/datum/preferences/student_prefs = student.client.prefs

	if (!is_kindred(student))
		to_chat(teacher, "<span class='warning'>Your student needs to be a vampire!</span>")
		return
	if (student.stat >= SOFT_CRIT)
		to_chat(teacher, "<span class='warning'>Your student needs to be conscious!</span>")
		return
	if (teacher_prefs.true_experience < 10)
		to_chat(teacher, "<span class='warning'>You don't have enough experience to teach them this Discipline!</span>")
		return
	//checks that the teacher has blood bonded the student, this is something that needs to be reworked when blood bonds are made better
	if (student.mind.enslaved_to != teacher)
		to_chat(teacher, "<span class='warning'>You need to have fed your student your blood to teach them Disciplines!</span>")
		return

	var/possible_disciplines = teacher_prefs.discipline_types - student_prefs.discipline_types
	var/teaching_discipline = input(teacher, "What Discipline do you want to teach [student.name]?", "Discipline Selection") as null|anything in possible_disciplines

	if (teaching_discipline)
		var/datum/discipline/teacher_discipline = teacher_species.get_discipline(teaching_discipline)
		var/datum/discipline/giving_discipline = new teaching_discipline

		//if a Discipline is clan-restricted, it must be checked if the student has access to at least one Clan with that Discipline
		if (giving_discipline.clan_restricted)
			if (!can_access_discipline(student, teaching_discipline))
				to_chat(teacher, "<span class='warning'>Your student is not whitelisted for any Clans with this Discipline, so they cannot learn it.</span>")
				qdel(giving_discipline)
				return

		//ensure the teacher's mastered it, also prevents them from teaching with free starting experience
		if (teacher_discipline.level < 5)
			to_chat(teacher, "<span class='warning'>You do not know this Discipline well enough to teach it. You need to master it to the 5th rank.</span>")
			qdel(giving_discipline)
			return

		var/restricted = giving_discipline.clan_restricted
		if (restricted)
			if (alert(teacher, "Are you sure you want to teach [student] [giving_discipline], one of your Clan's most tightly guarded secrets? This will cost 10 experience points.", "Confirmation", "Yes", "No") != "Yes")
				qdel(giving_discipline)
				return
		else
			if (alert(teacher, "Are you sure you want to teach [student] [giving_discipline]? This will cost 10 experience points.", "Confirmation", "Yes", "No") != "Yes")
				qdel(giving_discipline)
				return

		var/alienation = FALSE
		if (student.clane.restricted_disciplines.Find(teaching_discipline))
			if (alert(student, "Learning [giving_discipline] will alienate you from the rest of the [student.clane], making you just like the false Clan. Do you wish to continue?", "Confirmation", "Yes", "No") != "Yes")
				visible_message("<span class='warning'>[student] refuses [teacher]'s mentoring!</span>")
				qdel(giving_discipline)
				return
			else
				alienation = TRUE
				to_chat(teacher, "<span class='notice'>[student] accepts your mentoring!</span>")

		if (get_dist(student.loc, teacher.loc) > 1)
			to_chat(teacher, "<span class='warning'>Your student needs to be next to you!</span>")
			qdel(giving_discipline)
			return

		visible_message("<span class='notice'>[teacher] begins mentoring [student] in [giving_discipline].</span>")
		if (do_after(teacher, 30 SECONDS, student))
			teacher_prefs.true_experience -= 10

			student_prefs.discipline_types += teaching_discipline
			student_prefs.discipline_levels += 0

			if (alienation)
				var/datum/vampireclane/main_clan
				switch(student.clane.type)
					if (/datum/vampireclane/true_brujah)
						main_clan = new /datum/vampireclane/brujah
					if (/datum/vampireclane/old_clan_tzimisce)
						main_clan = new /datum/vampireclane/tzimisce

				student_prefs.clane = main_clan
				student.clane = main_clan

			student_prefs.save_character()
			teacher_prefs.save_character()

			to_chat(teacher, "<span class='notice'>You finish teaching [student] the basics of [giving_discipline]. [student.p_they(TRUE)] seem[student.p_s()] to have absorbed your mentoring.[restricted ? " May your Clanmates take mercy on your soul for spreading their secrets." : ""]</span>")
			to_chat(student, "<span class='nicegreen'>[teacher] has taught you the basics of [giving_discipline]. You may now spend experience points to learn its first level in the character menu.</span>")

			message_admins("[ADMIN_LOOKUPFLW(teacher)] taught [ADMIN_LOOKUPFLW(student)] the Discipline [giving_discipline.name].")
			log_game("[key_name(teacher)] taught [key_name(student)] the Discipline [giving_discipline.name].")

		qdel(giving_discipline)


//Vampires take 4% of their max health in burn damage every tick they are on fire. Very potent against lower-gens.
//Set at 0.02 because they already take twice as much burn damage.
/datum/species/kindred/handle_fire(mob/living/carbon/human/H, no_protection)
	if(!..())
		H.adjustFireLoss(H.maxHealth * 0.02)

/**
 * Checks a vampire for whitelist access to a Discipline.
 *
 * Checks the given vampire to see if they have access to a certain Discipline through
 * one of their selectable Clans. This is only necessary for "unique" or Clan-restricted
 * Disciplines, as those have a chance to only be available to a certain Clan that
 * the vampire may or may not be whitelisted for.
 *
 * Arguments:
 * * vampire_checking - The vampire mob being checked for their access.
 * * discipline_checking - The Discipline type that access to is being checked.
 */
/proc/can_access_discipline(mob/living/carbon/human/vampire_checking, discipline_checking)
	if (is_ghoul(vampire_checking))
		return TRUE
	if (!is_kindred(vampire_checking))
		return FALSE
	if (!vampire_checking.client)
		return FALSE

	//make sure it's actually restricted and this check is necessary
	var/datum/discipline/discipline_object_checking = new discipline_checking
	if (!discipline_object_checking.clan_restricted)
		qdel(discipline_object_checking)
		return TRUE
	qdel(discipline_object_checking)

	//first, check their Clan Disciplines to see if that gives them access
	if (vampire_checking.clane.clane_disciplines.Find(discipline_checking))
		return TRUE

	//next, go through all Clans to check if they have access to any with the Discipline
	for (var/clan_type in subtypesof(/datum/vampireclane))
		var/datum/vampireclane/clan_checking = new clan_type

		//skip this if they can't access it due to whitelists
		if (clan_checking.whitelisted)
			if (!SSwhitelists.is_whitelisted(checked_ckey = vampire_checking.ckey, checked_whitelist = clan_checking.name))
				qdel(clan_checking)
				continue

		if (clan_checking.clane_disciplines.Find(discipline_checking))
			qdel(clan_checking)
			return TRUE

		qdel(clan_checking)

	//nothing found
	return FALSE

/**
 * On being bit by a vampire
 *
 * This handles vampire bite sleep immunity and any future special interactions.
 */
/datum/species/kindred/proc/on_vampire_bitten(datum/source, mob/living/carbon/being_bitten)
	SIGNAL_HANDLER

	if(is_kindred(being_bitten))
		return COMPONENT_RESIST_VAMPIRE_KISS
