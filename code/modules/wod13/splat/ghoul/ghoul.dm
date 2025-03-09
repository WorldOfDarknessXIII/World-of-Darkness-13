/datum/splat/supernatural/kindred/ghoul
	splat_id = "ghoul"
	splat_traits = list(TRAIT_VIRUSIMMUNE, TRAIT_NOCRITDAMAGE)
	var/mob/living/carbon/human/master
	selectable = TRUE
	splat_flag = GHOUL_SPLAT
	torpor_timer = null
	//We're subtyping ghouls under kindred since most of their abilities are just kindred if they were weak
	//so we make sure they don't get kindred dam resist when they become a ghoul
	damage_mods = DEFAULT_DAMAGE_MODS

/datum/splat/supernatural/kindred/ghoul/on_apply()
	..()
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED_TO, PROC_REF(check_ghoulish_validity))

/datum/splat/supernatural/kindred/ghoul/proc/check_ghoulish_validity(datum/source, datum/splat/splat_gained)
	if(istype(splat_gained, /datum/splat/supernatural/kindred))
		var/datum/splat/supernatural/kindred/new_kindred_splat = splat_gained
		new_kindred_splat.handle_ghoul_uplift(src)
		Remove(my_character)

/datum/action/my_info/ghoul
	name = "About Me"
	desc = "Check assigned role, master, humanity, masquerade, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/my_info/ghoul/Trigger()
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
		var/datum/splat/supernatural/kindred/ghoul/ghoul_splat
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

/datum/action/take_vitae
	name = "Take Vitae"
	desc = "Take vitae from a Vampire by force."
	button_icon_state = "ghoul"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/taking = FALSE

/**
 * Accesses a certain Discipline that a Ghoul has. Returns false if they don't.
 *
 * Arguments:
 * * searched_discipline - Name or typepath of the Discipline being searched for.
 */
/datum/splat/supernatural/kindred/ghoul/proc/get_discipline(searched_discipline)
	for(var/datum/discipline/discipline in disciplines)
		if (ispath(searched_discipline, /datum/discipline))
			if (istype(discipline, searched_discipline))
				return discipline
		else if (istext(searched_discipline))
			if (discipline.name == searched_discipline)
				return discipline

	return FALSE
