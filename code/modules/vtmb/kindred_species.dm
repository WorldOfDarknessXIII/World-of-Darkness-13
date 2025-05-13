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
	var/datum/vampireclan/clan
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
	if (!host)
		return

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
	if(host.clan)
		dat += " the [host.clan.name]"
	if(!host.clan)
		dat += " the caitiff"

	if (host.mind)
		if (host.mind.assigned_role)
			if(host.mind.special_role)
				dat += ", carrying the [host.mind.assigned_role] (<font color=red>[host.mind.special_role]</font>) role."
			else
				dat += ", carrying the [host.mind.assigned_role] role."
		if (!host.mind.assigned_role)
			dat += "."
		dat += "<BR>"
		if (host.mind.enslaved_to)
			dat += "My Regnant is [host.mind.enslaved_to], I should obey their wants.<BR>"

	if (host.generation)
		dat += "I'm from [host.generation] generation.<BR>"

	if (host.mind.special_role)
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
	if(host.clan)
		if(host.clan.enlightenment)
			enlight = TRUE

	if (!enlight)
		switch (host.humanity)
			if (8 to 10)
				humanity = "I'm saintly."
			if (7)
				humanity = "I feel as human as when I lived."
			if (5 to 6)
				humanity = "I'm feeling distant from my humanity."
			if (4)
				humanity = "I don't feel any compassion for the Kine anymore."
			if (2 to 3)
				humanity = "I feel hunger for <b>BLOOD</b>. My humanity is slipping away."
			if (1)
				humanity = "Blood. Feed. Hunger. It gnaws. Must <b>FEED!</b>"
	else
		switch (host.humanity)
			if (8 to 10)
				humanity = "I'm <b>ENLIGHTENED</b>, my <b>BEAST</b> and I are in complete harmony."
			if (7)
				humanity = "I've made great strides in co-existing with my beast."
			if (5 to 6)
				humanity = "I'm starting to learn how to share this unlife with my beast."
			if (4)
				humanity = "I'm still new to my path, but I'm learning."
			if (2 to 3)
				humanity = "I'm a complete novice to my path."
			if (1)
				humanity = "I'm losing control over my beast!"

	dat += "[humanity]<BR>"

	if(host.clan.name == "Brujah")
		if(GLOB.brujahname != "")
			if(host.real_name != GLOB.brujahname)
				dat += " My primogen is:  [GLOB.brujahname].<BR>"
	if(host.clan.name == "Malkavian")
		if(GLOB.malkavianname != "")
			if(host.real_name != GLOB.malkavianname)
				dat += " My primogen is:  [GLOB.malkavianname].<BR>"
	if(host.clan.name == "Nosferatu")
		if(GLOB.nosferatuname != "")
			if(host.real_name != GLOB.nosferatuname)
				dat += " My primogen is:  [GLOB.nosferatuname].<BR>"
	if(host.clan.name == "Toreador")
		if(GLOB.toreadorname != "")
			if(host.real_name != GLOB.toreadorname)
				dat += " My primogen is:  [GLOB.toreadorname].<BR>"
	if(host.clan.name == "Ventrue")
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
		for (var/datum/action/discipline/D in host.actions)
			if (!D.discipline)
				continue

			dat += "[D.discipline.name] [D.discipline.level] - [D.discipline.desc]<BR>"

	if (host.Myself)
		if (host.Myself.Friend)
			if (host.Myself.Friend.owner)
				dat += "<b>My friend's name is [host.Myself.Friend.owner.true_real_name].</b><BR>"
				if (host.Myself.Friend.phone_number)
					dat += "Their number is [host.Myself.Friend.phone_number].<BR>"
				if (host.Myself.Friend.friend_text)
					dat += "[host.Myself.Friend.friend_text]<BR>"
		if (host.Myself.Enemy)
			if (host.Myself.Enemy.owner)
				dat += "<b>My nemesis is [host.Myself.Enemy.owner.true_real_name]!</b><BR>"
				if (host.Myself.Enemy.enemy_text)
					dat += "[host.Myself.Enemy.enemy_text]<BR>"
		if (host.Myself.Lover?.owner)
			dat += "<b>I'm in love with [host.Myself.Lover.owner.true_real_name].</b><BR>"
			if (host.Myself.Lover.phone_number)
				dat += "Their number is [host.Myself.Lover.phone_number].<BR>"
			if (host.Myself.Lover.lover_text)
				dat += "[host.Myself.Lover.lover_text]<BR>"

	var/obj/keypad/armory/armory = find_keypad(/obj/keypad/armory)
	if (armory && (host.mind.assigned_role == "Prince" || host.mind.assigned_role == "Sheriff" || host.mind.assigned_role == "Seneschal"))
		dat += "The pincode for the armory keypad is<b>: [armory.pincode]</b><BR>"

	var/obj/keypad/panic_room/panic = find_keypad(/obj/keypad/panic_room)
	if (panic && (host.mind.assigned_role == "Prince" || host.mind.assigned_role == "Sheriff" || host.mind.assigned_role == "Seneschal"))
		dat += "The pincode for the panic room keypad is<b>: [panic.pincode]</b><BR>"

	var/obj/structure/vaultdoor/pincode/bank/bankdoor = find_door_pin(/obj/structure/vaultdoor/pincode/bank)
	if (bankdoor && (host.mind.assigned_role == "Capo"))
		dat += "The pincode for the bank vault is <b>: [bankdoor.pincode]</b><BR>"
	if (bankdoor && (host.mind.assigned_role == "La Squadra"))
		if(prob(50))
			dat += "<b>The pincode for the bank vault is: [bankdoor.pincode]</b><BR>"
		else
			dat += "<b>Unfortunately you don't know the vault code.</b><BR>"

	if (length(host.knowscontacts) > 0)
		dat += "<b>I know some other of my kind in this city. Need to check my phone, there definetely should be:</b><BR>"
		for(var/i in host.knowscontacts)
			dat += "-[i] contact<BR>"

	for (var/datum/vtm_bank_account/account in GLOB.bank_account_list)
		if(host.bank_id == account.bank_id)
			dat += "<b>My bank account code is: [account.code]</b><BR>"

	host << browse(HTML_SKELETON(dat), "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
	onclose(host, "vampire", src)

/datum/species/kindred/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	C.update_body(0)
	C.last_experience = world.time + 5 MINUTES

	var/datum/action/vampireinfo/infor = new()
	infor.host = C
	infor.Grant(C)

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

/datum/species/kindred/check_roundstart_eligible()
	return TRUE

/**
 * Signal handler for lose_organ to near-instantly kill Kindred whose hearts have been removed.
 *
 * Arguments:
 * * source - The Kindred whose organ has been removed.
 * * organ - The organ which has been removed.
 */
/datum/species/kindred/proc/lose_organ(mob/living/carbon/human/source, obj/item/organ/organ)
	SIGNAL_HANDLER

	if (!istype(organ, /obj/item/organ/heart))
		return

	if (!source.getorgan(/obj/item/organ/heart))
		INVOKE_ASYNC(source, TYPE_PROC_REF(/mob/living/carbon/human, death))

/datum/species/kindred/proc/slip_into_torpor(mob/living/carbon/human/source)
	SIGNAL_HANDLER

	to_chat(source, span_warning("You can feel yourself slipping into Torpor. You can use succumb to immediately sleep..."))
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
		if (student.clan.restricted_disciplines.Find(teaching_discipline))
			if (alert(student, "Learning [giving_discipline] will alienate you from the rest of the [student.clan], making you just like the false Clan. Do you wish to continue?", "Confirmation", "Yes", "No") != "Yes")
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
				var/datum/vampireclan/main_clan
				switch(student.clan.type)
					if (/datum/vampireclan/true_brujah)
						main_clan = new /datum/vampireclan/brujah
					if (/datum/vampireclan/old_clan_tzimisce)
						main_clan = new /datum/vampireclan/tzimisce

				student_prefs.clan = main_clan
				student.clan = main_clan

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
	if (vampire_checking.clan.clan_disciplines.Find(discipline_checking))
		return TRUE

	//next, go through all Clans to check if they have access to any with the Discipline
	for (var/clan_type in subtypesof(/datum/vampireclan))
		var/datum/vampireclan/clan_checking = new clan_type

		//skip this if they can't access it due to whitelists
		if (clan_checking.whitelisted)
			if (!SSwhitelists.is_whitelisted(checked_ckey = vampire_checking.ckey, checked_whitelist = clan_checking.name))
				qdel(clan_checking)
				continue

		if (clan_checking.clan_disciplines.Find(discipline_checking))
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
