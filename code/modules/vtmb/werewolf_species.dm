/datum/species/garou
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
	brutemod = 0.75
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
	var/mob/living/carbon/human/host

/datum/action/garouinfo/Trigger()
	if(host)
		var/dat = {"
			<style type="text/css">

			body {
				padding: 5px;
				background-color: #090909; color: white;
			}

			</style>
			"}
		dat += "<p><center><h2>Memories</h2></center></p>"
		dat += "<p>[icon2html(getFlatIcon(host), host)]I am "
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
			dat += "</p>"
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
			if(host.bank_id == account.bank_id)
				dat += "<p>My bank account code is: [account.code]</b></p>"
				break
		if(host.mind.special_role)
			for(var/datum/antagonist/A in host.mind.antag_datums)
				if(A.objectives)
					dat += "<p>[printobjectives(A.objectives)]</p>"

		dat += "<p>"
		dat += "<b>Physique</b>: [host.physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity]<BR>"
		dat += "<b>Social</b>: [host.social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood]<BR>"
		dat += "</p>"
		if(host.Myself)
			if(host.Myself.Friend)
				if(host.Myself.Friend.owner)
					dat += "<p>My friend's name is [host.Myself.Friend.owner.true_real_name].</b><BR>"
					if(host.Myself.Friend.phone_number)
						dat += "Their number is [host.Myself.Friend.phone_number].<BR>"
					if(host.Myself.Friend.friend_text)
						dat += "[host.Myself.Friend.friend_text]</p>"
			if(host.Myself.Enemy)
				if(host.Myself.Enemy.owner)
					dat += "<p><b>My nemesis is [host.Myself.Enemy.owner.true_real_name]!</b><BR>"
					if(host.Myself.Enemy.enemy_text)
						dat += "[host.Myself.Enemy.enemy_text]</p>"
			if(host.Myself.Lover)
				if(host.Myself.Lover.owner)
					dat += "<p><b>I'm in love with [host.Myself.Lover.owner.true_real_name].</b><BR>"
					if(host.Myself.Lover.phone_number)
						dat += "Their number is [host.Myself.Lover.phone_number].<BR>"
					if(host.Myself.Lover.lover_text)
						dat += "[host.Myself.Lover.lover_text]</p>"
		if(length(host.knowscontacts) > 0)
			dat += "<p><b>I know some other of my kind in this city. Need to check my phone, there definetely should be:</b><BR>"
			for(var/i in host.knowscontacts)
				dat += "-[i] contact<BR>"
			dat += "</p>"
		host << browse(HTML_SKELETON(dat), "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)

/datum/species/garou/on_species_gain(mob/living/carbon/human/C)
	. = ..()
//	ADD_TRAIT(C, TRAIT_NOBLEED, HIGHLANDER)
	C.update_body(0)
	C.last_experience = world.time+3000
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

/datum/species/garou/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
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

/datum/species/garou/check_roundstart_eligible()
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
/datum/species/garou/proc/on_garou_bitten(datum/source, mob/living/carbon/being_bitten)
	SIGNAL_HANDLER

	if(isgarou(being_bitten) || iswerewolf(being_bitten))
		return COMPONENT_RESIST_VAMPIRE_KISS
