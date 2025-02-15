
/*

CONTAINS:
T-RAY
HEALTH ANALYZER
GAS ANALYZER
SLIME SCANNER
NANITE SCANNER
GENE SCANNER

*/

// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH		0
#define SCANMODE_CHEMICAL 	1
#define SCANMODE_WOUND	 	2
#define SCANNER_CONDENSED 	0
#define SCANNER_VERBOSE 	1

/obj/item/t_scanner
	name = "\improper T-ray scanner"
	desc = "A terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	custom_price = PAYCHECK_ASSISTANT * 0.7
	icon = 'icons/obj/device.dmi'
	icon_state = "t-ray0"
	var/on = FALSE
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'

/obj/item/t_scanner/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to emit terahertz-rays into [user.p_their()] brain with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return TOXLOSS

/obj/item/t_scanner/proc/toggle_on()
	on = !on
	icon_state = copytext_char(icon_state, 1, -1) + "[on]"
	if(on)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/t_scanner/attack_self(mob/user)
	toggle_on()

/obj/item/t_scanner/process()
	if(!on)
		STOP_PROCESSING(SSobj, src)
		return null
	scan()

/obj/item/t_scanner/proc/scan()
	t_ray_scan(loc)

/proc/t_ray_scan(mob/viewer, flick_time = 8, distance = 3)
	if(!ismob(viewer) || !viewer.client)
		return
	var/list/t_ray_images = list()
	for(var/obj/O in orange(distance, viewer) )
		if(HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
			var/image/I = new(loc = get_turf(O))
			var/mutable_appearance/MA = new(O)
			MA.alpha = 128
			MA.dir = O.dir
			I.appearance = MA
			t_ray_images += I
	if(t_ray_images.len)
		flick_overlay(t_ray_images, list(viewer.client), flick_time)

/obj/item/healthanalyzer
	name = "health analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A hand-held body scanner capable of distinguishing vital signs of the subject."
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	var/mode = SCANNER_VERBOSE
	var/scanmode = SCANMODE_HEALTH
	var/advanced = FALSE
	custom_price = PAYCHECK_HARD

/obj/item/healthanalyzer/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins to analyze [user.p_them()]self with [src]! The display shows that [user.p_theyre()] dead!</span>")
	return BRUTELOSS

/obj/item/healthanalyzer/attack_self(mob/user)
	scanmode = (scanmode + 1) % 3
	switch(scanmode)
		if(SCANMODE_HEALTH)
			to_chat(user, "<span class='notice'>You switch the health analyzer to check physical health.</span>")
		if(SCANMODE_CHEMICAL)
			to_chat(user, "<span class='notice'>You switch the health analyzer to scan chemical contents.</span>")
		if(SCANMODE_WOUND)
			to_chat(user, "<span class='notice'>You switch the health analyzer to report extra info on wounds.</span>")

/obj/item/healthanalyzer/attack(mob/living/M, mob/living/carbon/human/user)
	flick("[icon_state]-scan", src)	//makes it so that it plays the scan animation upon scanning, including clumsy scanning

	// Clumsiness/brain damage check
	if ((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		user.visible_message("<span class='warning'>[user] analyzes the floor's vitals!</span>", \
							"<span class='notice'>You stupidly try to analyze the floor's vitals!</span>")
		to_chat(user, "<span class='info'>Analyzing results for The floor:\n\tOverall status: <b>Healthy</b></span>\
				\n<span class='info'>Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FF8000'>Burn</font>/<font color='red'>Brute</font></span>\
				\n<span class='info'>\tDamage specifics: <font color='blue'>0</font>-<font color='green'>0</font>-<font color='#FF8000'>0</font>-<font color='red'>0</font></span>\
				\n<span class='info'>Body temperature: ???</span>")
		return

	user.visible_message("<span class='notice'>[user] analyzes [M]'s vitals.</span>", \
						"<span class='notice'>You analyze [M]'s vitals.</span>")

	if(scanmode == SCANMODE_HEALTH)
		healthscan(user, M, mode, advanced)
	else if(scanmode == SCANMODE_CHEMICAL)
		chemscan(user, M)
	else
		woundscan(user, M, src)

	add_fingerprint(user)


// Used by the PDA medical scanner too
/proc/healthscan(mob/user, mob/living/M, mode = SCANNER_VERBOSE, advanced = FALSE)
	if(user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, "<span class='warning'>You realize that your scanner has no accessibility support for the blind!</span>")
		return

	// the final list of strings to render
	var/render_list = list()

	// Damage specifics
	var/oxy_loss = M.getOxyLoss()
	var/tox_loss = M.getToxLoss()
	var/fire_loss = M.getFireLoss()
	var/brute_loss = M.getBruteLoss()
	var/mob_status = (M.stat == DEAD ? "<span class='alert'><b>Deceased</b></span>" : "<b>[round(M.health/M.maxHealth,0.01)*100]% healthy</b>")

	var/mob/living/carbon/human/humhum = M

	if(iskindred(M) || (iscathayan(M) && !humhum.check_kuei_jin_alive()))
		mob_status = "<span class='alert'><b>Deceased</b></span>"
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss)))

	if(HAS_TRAIT(M, TRAIT_FAKEDEATH) && !advanced)
		mob_status = "<span class='alert'><b>Deceased</b></span>"
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.undergoing_cardiac_arrest() && H.stat != DEAD)
			render_list += "<span class='alert'>Subject suffering from heart attack: Apply defibrillation or other electric shock immediately!</span>\n"

	render_list += "<span class='info'>Analyzing results for [M]:</span>\n<span class='info ml-1'>Overall status: [mob_status]</span>\n"

	// Husk detection
	if(advanced && HAS_TRAIT_FROM(M, TRAIT_HUSK, BURN))
		render_list += "<span class='alert ml-1'>Subject has been husked by severe burns.</span>\n"
	else if (advanced && HAS_TRAIT_FROM(M, TRAIT_HUSK, CHANGELING_DRAIN))
		render_list += "<span class='alert ml-1'>Subject has been husked by dessication.</span>\n"
	else if(HAS_TRAIT(M, TRAIT_HUSK))
		render_list += "<span class='alert ml-1'>Subject has been husked.</span>\n"

	// Damage descriptions
	if(brute_loss > 10)
		render_list += "<span class='alert ml-1'>[brute_loss > 50 ? "Severe" : "Minor"] tissue damage detected.</span>\n"
	if(fire_loss > 10)
		render_list += "<span class='alert ml-1'>[fire_loss > 50 ? "Severe" : "Minor"] burn damage detected.</span>\n"
	if(oxy_loss > 10)
		render_list += "<span class='info ml-1'><span class='alert'>[oxy_loss > 50 ? "Severe" : "Minor"] oxygen deprivation detected.</span>\n"
	if(tox_loss > 10)
		render_list += "<span class='alert ml-1'>[tox_loss > 50 ? "Severe" : "Minor"] amount of toxin damage detected.</span>\n"
	if(M.getStaminaLoss())
		render_list += "<span class='alert ml-1'>Subject appears to be suffering from fatigue.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Fatigue Level: [M.getStaminaLoss()]%.</span>\n"
	if (M.getCloneLoss())
		render_list += "<span class='alert ml-1'>Subject appears to have [M.getCloneLoss() > 30 ? "Severe" : "Minor"] cellular damage.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Cellular Damage Level: [M.getCloneLoss()].</span>\n"
	if (!M.getorganslot(ORGAN_SLOT_BRAIN)) // brain not added to carbon/human check because it's funny to get to bully simple mobs
		render_list += "<span class='alert ml-1'>Subject lacks a brain.</span>\n"
	if(ishuman(M))
		var/mob/living/carbon/human/the_dude = M
		var/datum/species/the_dudes_species = the_dude.dna.species
		if (!(NOBLOOD in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_HEART))
			render_list += "<span class='alert ml-1'>Subject lacks a heart.</span>\n"
		if (!(TRAIT_NOBREATH in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_LUNGS))
			render_list += "<span class='alert ml-1'>Subject lacks lungs.</span>\n"
		if (!(TRAIT_NOMETABOLISM in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_LIVER))
			render_list += "<span class='alert ml-1'>Subject lacks a liver.</span>\n"
		if (!(NOSTOMACH in the_dudes_species.species_traits) && !the_dude.getorganslot(ORGAN_SLOT_STOMACH))
			render_list += "<span class='alert ml-1'>Subject lacks a stomach.</span>\n"

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(LAZYLEN(C.get_traumas()))
			var/list/trauma_text = list()
			for(var/datum/brain_trauma/B in C.get_traumas())
				var/trauma_desc = ""
				switch(B.resilience)
					if(TRAUMA_RESILIENCE_SURGERY)
						trauma_desc += "severe "
					if(TRAUMA_RESILIENCE_LOBOTOMY)
						trauma_desc += "deep-rooted "
					if(TRAUMA_RESILIENCE_WOUND)
						trauma_desc += "fracture-derived "
					if(TRAUMA_RESILIENCE_MAGIC, TRAUMA_RESILIENCE_ABSOLUTE)
						trauma_desc += "permanent "
				trauma_desc += B.scan_desc
				trauma_text += trauma_desc
			render_list += "<span class='alert ml-1'>Cerebral traumas detected: subject appears to be suffering from [english_list(trauma_text)].</span>\n"
//		if(C.roundstart_quirks.len)
//			render_list += "<span class='info ml-1'>Subject Major Disabilities: [C.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY)].</span>\n"
//			if(advanced)
//				render_list += "<span class='info ml-1'>Subject Minor Disabilities: [C.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY)].</span>\n"
	if(advanced)
		if(iskindred(M) || (iscathayan(M) && !humhum.check_kuei_jin_alive()))
			render_list += "<span class='info ml-1'>Brain Activity Level: 0%.</span>\n"
		else
			render_list += "<span class='info ml-1'>Brain Activity Level: [(200 - M.getOrganLoss(ORGAN_SLOT_BRAIN))/2]%.</span>\n"

	if (M.radiation)
		render_list += "<span class='alert ml-1'>Subject is irradiated.</span>\n"
		if(advanced)
			render_list += "<span class='info ml-1'>Radiation Level: [M.radiation]%.</span>\n"

	if(advanced && M.hallucinating())
		render_list += "<span class='info ml-1'>Subject is hallucinating.</span>\n"

	// Body part damage report
	if(iscarbon(M) && mode == SCANNER_VERBOSE)
		var/mob/living/carbon/C = M
		var/list/damaged = C.get_damaged_bodyparts(1,1)
		if(length(damaged)>0 || oxy_loss>0 || tox_loss>0 || fire_loss>0)
			var/dmgreport = "<span class='info ml-1'>General status:</span>\
							<table class='ml-2'><tr><font face='Verdana'>\
							<td style='width:7em;'><font color='#0000CC'>Damage:</font></td>\
							<td style='width:5em;'><font color='red'><b>Brute</b></font></td>\
							<td style='width:4em;'><font color='orange'><b>Burn</b></font></td>\
							<td style='width:4em;'><font color='green'><b>Toxin</b></font></td>\
							<td style='width:8em;'><font color='purple'><b>Suffocation</b></font></td></tr>\
							<tr><td><font color='#0000CC'>Overall:</font></td>\
							<td><font color='red'>[CEILING(brute_loss,1)]</font></td>\
							<td><font color='orange'>[CEILING(fire_loss,1)]</font></td>\
							<td><font color='green'>[CEILING(tox_loss,1)]</font></td>\
							<td><font color='blue'>[CEILING(oxy_loss,1)]</font></td></tr>"

			for(var/o in damaged)
				var/obj/item/bodypart/org = o //head, left arm, right arm, etc.
				dmgreport += "<tr><td><font color='#0000CC'>[capitalize(org.name)]:</font></td>\
								<td><font color='red'>[(org.brute_dam > 0) ? "[CEILING(org.brute_dam,1)]" : "0"]</font></td>\
								<td><font color='orange'>[(org.burn_dam > 0) ? "[CEILING(org.burn_dam,1)]" : "0"]</font></td></tr>"
			dmgreport += "</font></table>"
			render_list += dmgreport // tables do not need extra linebreak

	//Eyes and ears
	if(advanced && iscarbon(M))
		var/mob/living/carbon/C = M

		// Ear status
		var/obj/item/organ/ears/ears = C.getorganslot(ORGAN_SLOT_EARS)
		var/message = "\n<span class='alert ml-2'>Subject does not have ears.</span>"
		if(istype(ears))
			message = ""
			if(HAS_TRAIT_FROM(C, TRAIT_DEAF, GENETIC_MUTATION))
				message = "\n<span class='alert ml-2'>Subject is genetically deaf.</span>"
			else if(HAS_TRAIT_FROM(C, TRAIT_DEAF, EAR_DAMAGE))
				message = "\n<span class='alert ml-2'>Subject is deaf from ear damage.</span>"
			else if(HAS_TRAIT(C, TRAIT_DEAF))
				message = "\n<span class='alert ml-2'>Subject is deaf.</span>"
			else
				if(ears.damage)
					message += "\n<span class='alert ml-2'>Subject has [ears.damage > ears.maxHealth ? "permanent ": "temporary "]hearing damage.</span>"
				if(ears.deaf)
					message += "\n<span class='alert ml-2'>Subject is [ears.damage > ears.maxHealth ? "permanently ": "temporarily "] deaf.</span>"
		render_list += "<span class='info ml-1'>Ear status:</span>[message == "" ? "\n<span class='info ml-2'>Healthy.</span>" : message]\n"

		// Eye status
		var/obj/item/organ/eyes/eyes = C.getorganslot(ORGAN_SLOT_EYES)
		message = "\n<span class='alert ml-2'>Subject does not have eyes.</span>"
		if(istype(eyes))
			message = ""
			if(C.is_blind())
				message += "\n<span class='alert ml-2'>Subject is blind.</span>"
			if(HAS_TRAIT(C, TRAIT_NEARSIGHT))
				message += "\n<span class='alert ml-2'>Subject is nearsighted.</span>"
			if(eyes.damage > 30)
				message += "\n<span class='alert ml-2'>Subject has severe eye damage.</span>"
			else if(eyes.damage > 20)
				message += "\n<span class='alert ml-2'>Subject has significant eye damage.</span>"
			else if(eyes.damage)
				message += "\n<span class='alert ml-2'>Subject has minor eye damage.</span>"
		render_list += "<span class='info ml-1'>Eye status:</span>[message == "" ? "\n<span class='info ml-2'>Healthy.</span>" : message]\n"

	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		// Organ damage
		if (H.internal_organs && H.internal_organs.len)
			var/render = FALSE
			var/toReport = "<span class='info ml-1'>Organs:</span>\
				<table class='ml-2'><tr>\
				<td style='width:6em;'><font color='#0000CC'><b>Organ</b></font></td>\
				[advanced ? "<td style='width:3em;'><font color='#0000CC'><b>Dmg</b></font></td>" : ""]\
				<td style='width:12em;'><font color='#0000CC'><b>Status</b></font></td>"

			for(var/obj/item/organ/organ in H.internal_organs)
				var/status = ""
				if (iskindred(H) || (iscathayan(H) && !H.check_kuei_jin_alive())) status = "<font color='#E42426'>Non-Functional</font>"
				else if (organ.organ_flags & ORGAN_FAILING) status = "<font color='#E42426'>Non-Functional</font>"
				else if (organ.damage > organ.high_threshold) status = "<font color='#EC6224'>Severely Damaged</font>"
				else if (organ.damage > organ.low_threshold) status = "<font color='#F28F1F'>Mildly Damaged</font>"
				if (status != "")
					render = TRUE
					toReport += "<tr><td><font color='#0000CC'>[organ.name]</font></td>\
						[advanced ? "<td><font color='#0000CC'>[CEILING(organ.damage,1)]</font></td>" : ""]\
						<td>[status]</td></tr>"

			if (render)
				render_list += toReport + "</table>" // tables do not need extra linebreak

		//Genetic damage
		if(advanced && H.has_dna())
			render_list += "<span class='info ml-1'>Genetic Stability: [H.dna.stability]%.</span>\n"

		// Species and body temperature
		/*
		var/datum/species/S = H.dna.species
		var/mutant = H.dna.check_mutation(HULK) \
			|| S.mutantlungs != initial(S.mutantlungs) \
			|| S.mutantbrain != initial(S.mutantbrain) \
			|| S.mutantheart != initial(S.mutantheart) \
			|| S.mutanteyes != initial(S.mutanteyes) \
			|| S.mutantears != initial(S.mutantears) \
			|| S.mutanthands != initial(S.mutanthands) \
			|| S.mutanttongue != initial(S.mutanttongue) \
			|| S.mutantliver != initial(S.mutantliver) \
			|| S.mutantstomach != initial(S.mutantstomach) \
			|| S.mutantappendix != initial(S.mutantappendix) \
			|| S.flying_species != initial(S.flying_species)
		*/

//		render_list += "<span class='info ml-1'>Species: [S.name][mutant ? "-derived mutant" : ""]</span>\n"
		render_list += "<span class='info ml-1'>Core temperature: [round(H.coretemperature-T0C,0.1)] &deg;C ([round(H.coretemperature*1.8-459.67,0.1)] &deg;F)</span>\n"
	render_list += "<span class='info ml-1'>Body temperature: [round(M.bodytemperature-T0C,0.1)] &deg;C ([round(M.bodytemperature*1.8-459.67,0.1)] &deg;F)</span>\n"

	// Time of death
	if(M.tod && (M.stat == DEAD || ((HAS_TRAIT(M, TRAIT_FAKEDEATH)) && !advanced)))
		render_list += "<span class='info ml-1'>Time of Death: [M.tod]</span>\n"
		var/tdelta = round(world.time - M.timeofdeath)
		render_list += "<span class='alert ml-1'><b>Subject died [DisplayTimeText(tdelta)] ago.</b></span>\n"

	// Wounds
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/list/wounded_parts = C.get_wounded_bodyparts()
		for(var/i in wounded_parts)
			var/obj/item/bodypart/wounded_part = i
			render_list += "<span class='alert ml-1'><b>Warning: Physical trauma[LAZYLEN(wounded_part.wounds) > 1? "s" : ""] detected in [wounded_part.name]</b>"
			for(var/k in wounded_part.wounds)
				var/datum/wound/W = k
				render_list += "<div class='ml-2'>Type: [W.name]\nSeverity: [W.severity_text()]\nRecommended Treatment: [W.treat_text]</div>\n" // less lines than in woundscan() so we don't overload people trying to get basic med info
			render_list += "</span>"

	for(var/thing in M.diseases)
		var/datum/disease/D = thing
		if(!(D.visibility_flags & HIDDEN_SCANNER))
			render_list += "<span class='alert ml-1'><b>Warning: [D.form] detected</b>\n\
			<div class='ml-2'>Name: [D.name].\nType: [D.spread_text].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure_text]</div>\
			</span>" // divs do not need extra linebreak

	// Blood Level
	if(M.has_dna())
		var/mob/living/carbon/C = M
		var/blood_id = C.get_blood_id()
		if(blood_id)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				if(H.is_bleeding())
					render_list += "<span class='alert ml-1'><b>Subject is bleeding!</b></span>\n"
			var/blood_percent =  round((C.blood_volume / BLOOD_VOLUME_NORMAL)*100)
			var/blood_type = C.dna.blood_type
			if(blood_id != /datum/reagent/blood) // special blood substance
				var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
				blood_type = R ? R.name : blood_id
			if(iskindred(C))
				render_list += "<span class='alert ml-1'>Blood level: LOW 0 %, 0 cl,</span> <span class='info'>type: [blood_type]</span>\n"
			else if(C.blood_volume <= BLOOD_VOLUME_SAFE && C.blood_volume > BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Blood level: LOW [blood_percent] %, [C.blood_volume] cl,</span> <span class='info'>type: [blood_type]</span>\n"
			else if(C.blood_volume <= BLOOD_VOLUME_OKAY)
				render_list += "<span class='alert ml-1'>Blood level: <b>CRITICAL [blood_percent] %</b>, [C.blood_volume] cl,</span> <span class='info'>type: [blood_type]</span>\n"
			else
				render_list += "<span class='info ml-1'>Blood level: [blood_percent] %, [C.blood_volume] cl, type: [blood_type]</span>\n"

		var/cyberimp_detect
		for(var/obj/item/organ/cyberimp/CI in C.internal_organs)
			if(CI.status == ORGAN_ROBOTIC && !CI.syndicate_implant)
				cyberimp_detect += "[!cyberimp_detect ? "[CI.get_examine_string(user)]" : ", [CI.get_examine_string(user)]"]"
		if(cyberimp_detect)
			render_list += "<span class='notice ml-1'>Detected cybernetic modifications:</span>\n"
			render_list += "<span class='notice ml-2'>[cyberimp_detect]</span>\n"

	SEND_SIGNAL(M, COMSIG_NANITE_SCAN, user, FALSE)
	to_chat(user, jointext(render_list, ""), trailing_newline = FALSE) // we handled the last <br> so we don't need handholding

/proc/chemscan(mob/living/user, mob/living/M)
	if(user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, "<span class='warning'>You realize that your scanner has no accessibility support for the blind!</span>")
		return

	if(istype(M) && M.reagents)
		var/render_list = list()
		if(M.reagents.reagent_list.len)
			render_list += "<span class='notice ml-1'>Subject contains the following reagents in their blood:</span>\n"
			for(var/r in M.reagents.reagent_list)
				var/datum/reagent/reagent = r
				render_list += "<span class='notice ml-2'>[round(reagent.volume, 0.001)] units of [reagent.name][reagent.overdosed ? "</span> - <span class='boldannounce'>OVERDOSING</span>" : ".</span>"]\n"
		else
			render_list += "<span class='notice ml-1'>Subject contains no reagents in their blood.</span>\n"
		var/obj/item/organ/stomach/belly = M.getorganslot(ORGAN_SLOT_STOMACH)
		if(belly)
			if(belly.reagents.reagent_list.len)
				render_list += "<span class='notice ml-1'>Subject contains the following reagents in their stomach:</span>\n"
				for(var/bile in belly.reagents.reagent_list)
					var/datum/reagent/bit = bile
					if(!belly.food_reagents[bit.type])
						render_list += "<span class='notice ml-2'>[round(bit.volume, 0.001)] units of [bit.name][bit.overdosed ? "</span> - <span class='boldannounce'>OVERDOSING</span>" : ".</span>"]\n"
					else
						var/bit_vol = bit.volume - belly.food_reagents[bit.type]
						if(bit_vol > 0)
							render_list += "<span class='notice ml-2'>[round(bit_vol, 0.001)] units of [bit.name][bit.overdosed ? "</span> - <span class='boldannounce'>OVERDOSING</span>" : ".</span>"]\n"
			else
				render_list += "<span class='notice ml-1'>Subject contains no reagents in their stomach.</span>\n"

		if(LAZYLEN(M.reagents.addiction_list))
			render_list += "<span class='boldannounce ml-1'>Subject is addicted to the following reagents:</span>\n"
			for(var/a in M.reagents.addiction_list)
				var/datum/reagent/addiction = a
				render_list += "<span class='alert ml-2'>[addiction.name]</span>\n"
		else
			render_list += "<span class='notice ml-1'>Subject is not addicted to any reagents.</span>\n"

		to_chat(user, jointext(render_list, ""), trailing_newline = FALSE) // we handled the last <br> so we don't need handholding

/obj/item/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	if(usr.incapacitated())
		return

	mode = !mode
	to_chat(usr, mode == SCANNER_VERBOSE ? "The scanner now shows specific limb damage." : "The scanner no longer shows limb damage.")

/obj/item/healthanalyzer/advanced
	name = "advanced health analyzer"
	icon_state = "health_adv"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject with high accuracy."
	advanced = TRUE

/// Displays wounds with extended information on their status vs medscanners
/proc/woundscan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/wound/scanner)
	if(!istype(patient) || user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, "<span class='warning'>You realize that your scanner has no accessibility support for the blind!</span>")
		return

	var/render_list = ""
	for(var/i in patient.get_wounded_bodyparts())
		var/obj/item/bodypart/wounded_part = i
		render_list += "<span class='alert ml-1'><b>Warning: Physical trauma[LAZYLEN(wounded_part.wounds) > 1? "s" : ""] detected in [wounded_part.name]</b>"
		for(var/k in wounded_part.wounds)
			var/datum/wound/W = k
			render_list += "<div class='ml-2'>[W.get_scanner_description()]</div>\n"
		render_list += "</span>"

	if(render_list == "")
		if(istype(scanner))
			// Only emit the cheerful scanner message if this scan came from a scanner
			playsound(scanner, 'sound/machines/ping.ogg', 50, FALSE)
			to_chat(user, "<span class='notice'>\The [scanner] makes a happy ping and briefly displays a smiley face with several exclamation points! It's really excited to report that [patient] has no wounds!</span>")
		else
			to_chat(user, "<span class='notice ml-1'>No wounds detected in subject.</span>")
	else
		to_chat(user, jointext(render_list, ""))

/obj/item/healthanalyzer/wound
	name = "first aid analyzer"
	icon_state = "adv_spectrometer"
	desc = "A prototype MeLo-Tech medical scanner used to diagnose injuries and recommend treatment for serious wounds, but offers no further insight into the patient's health. You hope the final version is less annoying to read!"
	var/next_encouragement
	var/greedy

/obj/item/healthanalyzer/wound/attack_self(mob/user)
	if(next_encouragement < world.time)
		playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
		var/list/encouragements = list("briefly displays a happy face, gazing emptily at you", "briefly displays a spinning cartoon heart", "displays an encouraging message about eating healthy and exercising", \
				"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a sincere thank-you for your interest in first-aid", "formally absolves you of all your sins")
		to_chat(user, "<span class='notice'>\The [src] makes a happy ping and [pick(encouragements)]!</span>")
		next_encouragement = world.time + 10 SECONDS
		greedy = FALSE
	else if(!greedy)
		to_chat(user, "<span class='warning'>\The [src] displays an eerily high-definition frowny face, chastizing you for asking it for too much encouragement.</span>")
		greedy = TRUE
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		if(isliving(user))
			var/mob/living/L = user
			to_chat(L, "<span class='warning'>\The [src] makes a disappointed buzz and pricks your finger for being greedy. Ow!</span>")
			L.adjustBruteLoss(4)
			L.dropItemToGround(src)

/obj/item/healthanalyzer/wound/attack(mob/living/carbon/patient, mob/living/carbon/human/user)
	add_fingerprint(user)
	user.visible_message("<span class='notice'>[user] scans [patient] for serious injuries.</span>", "<span class='notice'>You scan [patient] for serious injuries.</span>")

	if(!istype(patient))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		to_chat(user, "<span class='notice'>\The [src] makes a sad buzz and briefly displays a frowny face, indicating it can't scan [patient].</span>")
		return

	woundscan(user, patient, src)


#undef SCANMODE_HEALTH
#undef SCANMODE_CHEMICAL
#undef SCANMODE_WOUND
#undef SCANNER_CONDENSED
#undef SCANNER_VERBOSE
