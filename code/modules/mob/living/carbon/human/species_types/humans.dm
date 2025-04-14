/datum/species/human
	name = "Human"
	id = "human"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_FLESH,HAS_BONE)
	mutant_bodyparts = list("wings" = "None")
	use_skintones = 1
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1
	selectable = TRUE

/datum/action/humaninfo
	name = "About Me"
	desc = "Check assigned role, clane, generation, humanity, masquerade, known disciplines, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/humaninfo/Trigger()
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
		if(host.mind.special_role)
			for(var/datum/antagonist/A in host.mind.antag_datums)
				if(A.objectives)
					dat += "[printobjectives(A.objectives)]<BR>"
		dat += "<b>Physique</b>: [host.physique] + [host.additional_physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity] + [host.additional_dexterity]<BR>"
		dat += "<b>Social</b>: [host.social] + [host.additional_social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality] + [host.additional_mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood] + [host.additional_blood]<BR>"
		dat += "<b>Lockpicking</b>: [host.lockpicking] + [host.additional_lockpicking]<BR>"
		dat += "<b>Athletics</b>: [host.athletics] + [host.additional_athletics]<BR>"
		if(host.Myself?.Friend?.owner)
			dat += "<b>My friend's name is [host.Myself.Friend.owner.true_real_name].</b><BR>"
			if(host.Myself.Friend.phone_number)
				dat += "Their number is [host.Myself.Friend.phone_number].<BR>"
			if(host.Myself.Friend.friend_text)
				dat += "[host.Myself.Friend.friend_text]<BR>"
		if(host.Myself?.Enemy?.owner)
			dat += "<b>My nemesis is [host.Myself.Enemy.owner.true_real_name]!</b><BR>"
			if(host.Myself.Enemy.enemy_text)
				dat += "[host.Myself.Enemy.enemy_text]<BR>"
		if(host.Myself?.Lover?.owner)
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
				break
		host << browse(HTML_SKELETON(dat), "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)

/datum/species/human/on_species_gain(mob/living/carbon/human/C)
	. = ..()
//	ADD_TRAIT(C, TRAIT_NOBLEED, HIGHLANDER)
	C.update_body(0)
	var/datum/action/humaninfo/infor = new()
	infor.host = C
	infor.Grant(C)

/datum/species/human/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	for(var/datum/action/humaninfo/VI in C.actions)
		qdel(VI)

/datum/species/human/check_roundstart_eligible()
	return TRUE

/datum/species/human/felinid/check_roundstart_eligible()
	return FALSE
