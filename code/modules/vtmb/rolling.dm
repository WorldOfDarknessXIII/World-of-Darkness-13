GLOBAL_LIST_EMPTY(vampireroll_numbers)
SUBSYSTEM_DEF(woddices)
	name = "World of Darkness dices"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_VERYLOW
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 10 SECONDS

/datum/controller/subsystem/woddices/fire(resumed = FALSE)
	if(MC_TICK_CHECK)
		return
	if(length(GLOB.vampireroll_numbers))
		var/atom/a = pick(GLOB.vampireroll_numbers)
		if(a)
			GLOB.vampireroll_numbers -= a
			qdel(a)
	if(length(GLOB.vampireroll_numbers))
		var/atom/a = pick(GLOB.vampireroll_numbers)
		if(a)
			GLOB.vampireroll_numbers -= a
			qdel(a)
	if(length(GLOB.vampireroll_numbers))
		var/atom/a = pick(GLOB.vampireroll_numbers)
		if(a)
			GLOB.vampireroll_numbers -= a
			qdel(a)
	if(length(GLOB.vampireroll_numbers))
		var/atom/a = pick(GLOB.vampireroll_numbers)
		if(a)
			GLOB.vampireroll_numbers -= a
			qdel(a)
	if(length(GLOB.vampireroll_numbers))
		var/atom/a = pick(GLOB.vampireroll_numbers)
		if(a)
			GLOB.vampireroll_numbers -= a
			qdel(a)

/proc/create_number_on_mob(mob/Mob, what_color, text)
	var/turf/T = get_turf(Mob)
	if(T)
		var/atom/movable/message_atom = new (T)
		message_atom.density = 0
		message_atom.layer = ABOVE_LIGHTING_LAYER
		message_atom.plane = ABOVE_LIGHTING_PLANE
		message_atom.pixel_y = rand(12, 16)
		message_atom.maptext_width = 96
		message_atom.maptext_height = 16
		message_atom.maptext_x = rand(22, 28)
		message_atom.maptext = MAPTEXT(text)
		message_atom.color = what_color
		animate(message_atom, pixel_y = message_atom.pixel_y+8, time = 20, loop = 1)
		animate(message_atom, pixel_y = message_atom.pixel_y+32, alpha = 0, time = 10)
		spawn(20)
			GLOB.vampireroll_numbers += message_atom

/mob/living
	var/datum/attributes/attributes

/mob/living/Initialize()
	. = ..()
	attributes = new ()

/datum/attributes
	var/strength = 1
	var/dexterity = 1
	var/stamina = 1

	var/strength_bonus = 0
	var/dexterity_bonus = 0
	var/stamina_bonus = 0

	var/strength_reagent = 0
	var/dexterity_reagent = 0
	var/stamina_reagent = 0

	var/charisma = 1
	var/manipulation = 1
	var/appearance = 1

	var/charisma_bonus = 0
	var/manipulation_bonus = 0
	var/appearance_bonus = 0

	var/charisma_reagent = 0
	var/manipulation_reagent = 0
	var/appearance_reagent = 0

	var/perception = 1
	var/intelligence = 1
	var/wits = 1

	var/perception_bonus = 0
	var/intelligence_bonus = 0
	var/wits_bonus = 0

	var/perception_reagent = 0
	var/intelligence_reagent = 0
	var/wits_reagent = 0

	var/Alertness = 0
	var/Athletics = 0
	var/Brawl = 0
	var/Empathy = 0
	var/Intimidation = 0

	var/Crafts = 0
	var/Melee = 0
	var/Firearms = 0
	var/Drive = 0
	var/Security = 0

	var/Finance = 0
	var/Investigation = 0
	var/Medicine = 0
	var/Linguistics = 0
	var/Occult = 0

	var/fortitude_bonus = 0
	var/potence_bonus = 0
	var/visceratika_bonus = 0
	var/bloodshield_bonus = 0
	var/lasombra_shield = 0
	var/tzimisce_bonus = 0

/datum/attributes/proc/randomize()
	strength = rand(1, 3)
	dexterity = rand(1, 3)
	stamina = rand(1, 3)

	charisma = rand(1, 3)
	manipulation = rand(1, 3)
	appearance = rand(1, 3)

	perception = rand(1, 3)
	intelligence = rand(1, 3)
	wits = rand(1, 3)

	Alertness = rand(0, 3)
	Athletics = rand(0, 3)
	Brawl = rand(0, 3)
	Empathy = rand(0, 3)
	Intimidation = rand(0, 3)

	Crafts = rand(0, 3)
	Melee = rand(0, 3)
	Firearms = rand(0, 3)
	Drive = rand(0, 3)
	Security = rand(0, 3)

	Finance = rand(0, 3)
	Investigation = rand(0, 3)
	Medicine = rand(0, 3)
	Linguistics = rand(0, 3)
	Occult = rand(0, 3)

/proc/get_fortitude_dices(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.fortitude_bonus
	else
		return 0

/proc/get_potence_dices(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.potence_bonus
	else
		return 0

/proc/get_visceratika_dices(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.visceratika_bonus
	else
		return 0

/proc/get_tzimisce_dices(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.tzimisce_bonus
	else
		return 0

/proc/get_bloodshield_dices(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.bloodshield_bonus
	else
		return 0

/proc/get_lasombra_dices(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.lasombra_shield
	else
		return 0

/proc/get_a_alertness(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Alertness
	else
		return 0

/proc/get_a_athletics(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Athletics
	else
		return 0

/proc/get_a_brawl(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Brawl
	else
		return 0

/proc/get_a_empathy(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Empathy
	else
		return 0

/proc/get_a_intimidation(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Intimidation
	else
		return 0

/proc/get_a_crafts(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Crafts
	else
		return 0

/proc/get_a_melee(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Melee
	else
		return 0

/proc/get_a_firearms(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Firearms
	else
		return 0

/proc/get_a_drive(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Drive
	else
		return 0

/proc/get_a_security(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Security
	else
		return 0

/proc/get_a_finance(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Finance
	else
		return 0

/proc/get_a_investigation(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Investigation
	else
		return 0

/proc/get_a_medicine(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Medicine
	else
		return 0

/proc/get_a_linguistics(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Linguistics
	else
		return 0

/proc/get_a_occult(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.Occult
	else
		return 0

/proc/get_a_strength(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.strength+Living.attributes.strength_bonus+Living.attributes.strength_reagent
	else
		return 3

/proc/get_a_dexterity(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.dexterity+Living.attributes.dexterity_bonus+Living.attributes.dexterity_reagent
	else
		return 3

/proc/get_a_stamina(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.stamina+Living.attributes.stamina_bonus+Living.attributes.stamina_reagent
	else
		return 3

/proc/get_a_manipulation(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.manipulation+Living.attributes.manipulation_bonus+Living.attributes.manipulation_reagent
	else
		return 3

/proc/get_a_charisma(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.charisma+Living.attributes.charisma_bonus+Living.attributes.charisma_reagent
	else
		return 3

/proc/get_a_appearance(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.appearance+Living.attributes.appearance_bonus+Living.attributes.appearance_reagent
	else
		return 3

/proc/get_a_perception(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.perception+Living.attributes.perception_bonus+Living.attributes.perception_reagent
	else
		return 3

/proc/get_a_intelligence(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.intelligence+Living.attributes.intelligence_bonus+Living.attributes.intelligence_reagent
	else
		return 3

/proc/get_a_wits(mob/living/Living)
	if(Living.attributes)
		return Living.attributes.wits+Living.attributes.wits_bonus+Living.attributes.wits_reagent
	else
		return 3

/proc/secret_vampireroll(var/dices_num = 1, var/hardness = 1, var/mob/living/rollperformer)
	hardness = clamp(hardness, 1, 10)
	var/dices_decap = rollperformer.get_health_difficulty()
	dices_num = max(1, dices_num-dices_decap)
	var/wins = 0
	var/crits = 0
	var/brokes = 0
	for(var/i in 1 to dices_num)
		var/roll = rand(1, 10)
		if(roll == 10)
			crits += 1
		else if(roll == 1)
			brokes += 1
		else if(roll >= hardness)
			wins += 1
	wins = wins+(max(0, crits-brokes))
	if(wins < 0)
		create_number_on_mob(rollperformer, "#ff0000", "Botch!")
		to_chat(rollperformer, "<span class='danger'>Botch!</span>")
		return -1
	if(wins == 0)
		create_number_on_mob(rollperformer, "#646464", "0")
	if(wins == 1)
		create_number_on_mob(rollperformer, "#dc9f2d", "1")
	if(wins == 2)
		create_number_on_mob(rollperformer, "#e6de29", "2")
	if(wins == 3)
		create_number_on_mob(rollperformer, "#7af321", "3")
	if(wins == 4)
		create_number_on_mob(rollperformer, "#00ff77", "4")
	if(wins == 5)
		create_number_on_mob(rollperformer, "#00c6ff", "5")
	if(wins == 6)
		create_number_on_mob(rollperformer, "#0066ff", "6")
	if(wins >= 7)
		create_number_on_mob(rollperformer, "#b200ff", "7+")
	if(wins)
		to_chat(rollperformer, "<span class='help'><b>[wins] successes!</b></span>")
	else
		to_chat(rollperformer, "<b>No successes!</b>")
	return wins

/datum/action/aboutme
	name = "About Me"
	desc = "Check assigned role, attributes, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/aboutme/Trigger()
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

			if(iskindred(host))
				if(host.clane)
					dat += " the [host.clane.name]"
				if(!host.clane)
					dat += " the caitiff"
			else if(isgarou(host) || iswerewolf(host))
				dat += " the garou"
			else if(iscathayan(host))
				dat += " the kuei-jin"
			else
				dat += " the mortal"

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
		if(iskindred(host) || isghoul(host))
			if(host.vampire_faction == "Camarilla" || host.vampire_faction == "Anarchs" || host.vampire_faction == "Sabbat")
				dat += "I belong to [host.vampire_faction] faction, I shouldn't disobey their rules.<BR>"
			if(host.generation)
				dat += "I'm from [host.generation] generation.<BR>"
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

		if(iskindred(host))
			if(host.clane.name == "Brujah")
				if(GLOB.brujahname != "")
					if(host.real_name != GLOB.brujahname)
						dat += " My primogen is: [GLOB.brujahname].<BR>"
			if(host.clane.name == "Malkavian")
				if(GLOB.malkavianname != "")
					if(host.real_name != GLOB.malkavianname)
						dat += " My primogen is: [GLOB.malkavianname].<BR>"
			if(host.clane.name == "Nosferatu")
				if(GLOB.nosferatuname != "")
					if(host.real_name != GLOB.nosferatuname)
						dat += " My primogen is: [GLOB.nosferatuname].<BR>"
			if(host.clane.name == "Toreador")
				if(GLOB.toreadorname != "")
					if(host.real_name != GLOB.toreadorname)
						dat += " My primogen is: [GLOB.toreadorname].<BR>"
			if(host.clane.name == "Ventrue")
				if(GLOB.ventruename != "")
					if(host.real_name != GLOB.ventruename)
						dat += " My primogen is: [GLOB.ventruename].<BR>"
		if(iscathayan(host))
			var/masquerade_level = " is clueless about my presence."
			switch(host.masquerade)
				if(4)
					masquerade_level = " has some thoughts of awareness."
				if(3)
					masquerade_level = " is barely spotting the truth."
				if(2)
					masquerade_level = " is starting to know."
				if(1)
					masquerade_level = " knows me and my true nature."
				if(0)
					masquerade_level = " thinks I'm a monster and is hunting me."
			dat += "West[masquerade_level]<BR>"
			var/dharma = "I'm mindless carrion-eater!"
			switch(host.mind.dharma?.level)
				if(1)
					dharma = "I have not proved my worthiness to exist as Kuei-jin..."
				if(2 to 3)
					dharma = "I'm only at the basics of my Dharma."
				if(4 to 5)
					dharma = "I'm so enlighted I can be a guru."
				if(6)
					dharma = "I have mastered the Dharma so far!"

			dat += "[dharma]<BR>"

			dat += "The <b>[host.mind.dharma?.animated]</b> Chi Energy helps me to stay alive...<BR>"
			dat += "My P'o is [host.mind.dharma?.Po]<BR>"
			dat += "<b>Yin/Yang</b>[host.max_yin_chi]/[host.max_yang_chi]<BR>"
			dat += "<b>Hun/P'o</b>[host.mind.dharma?.Hun]/[host.max_demon_chi]<BR>"

		dat += "<b>Attributes</b><BR>"
		dat += "Strength: [get_a_strength(host)]<BR>"
		dat += "Dexterity: [get_a_dexterity(host)]<BR>"
		dat += "Stamina: [get_a_stamina(host)]<BR>"
		dat += "Charisma: [get_a_charisma(host)]<BR>"
		dat += "Manipulation: [get_a_manipulation(host)]<BR>"
		dat += "Appearance: [get_a_appearance(host)]<BR>"
		dat += "Perception: [get_a_perception(host)]<BR>"
		dat += "Intelligence: [get_a_intelligence(host)]<BR>"
		dat += "Wits: [get_a_wits(host)]<BR>"
		dat += "<b>Abilities</b><BR>"
		dat += "Alertness: [get_a_alertness(host)]<BR>"
		dat += "Athletics: [get_a_athletics(host)]<BR>"
		dat += "Brawl: [get_a_brawl(host)]<BR>"
		dat += "Empathy: [get_a_empathy(host)]<BR>"
		dat += "Intimidation: [get_a_intimidation(host)]<BR>"
		dat += "Crafts: [get_a_crafts(host)]<BR>"
		dat += "Melee: [get_a_melee(host)]<BR>"
		dat += "Firearms: [get_a_firearms(host)]<BR>"
		dat += "Drive: [get_a_drive(host)]<BR>"
		dat += "Security: [get_a_security(host)]<BR>"
		dat += "Finance: [get_a_finance(host)]<BR>"
		dat += "Investigation: [get_a_investigation(host)]<BR>"
		dat += "Medicine: [get_a_medicine(host)]<BR>"
		dat += "Linguistics: [get_a_linguistics(host)]<BR>"
		dat += "Occult: [get_a_occult(host)]<BR>"


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
		if(host.hud_used && (iskindred(host) || isghoul(host)))
			dat += "<b>Known disciplines:</b><BR>"
			for(var/datum/action/discipline/D in host.actions)
				if(D)
					if(D.discipline)
						dat += "[D.discipline.name] [D.discipline.level] - [D.discipline.desc]<BR>"
		var/obj/keypad/armory/K = find_keypad(/obj/keypad/armory)
		if(K && (host.mind.assigned_role == "Prince" || host.mind.assigned_role == "Sheriff"))
			dat += "<b>The pincode for the armory keypad is: [K.pincode]</b><BR>"
		var/obj/structure/vaultdoor/pincode/bank/bankdoor = find_door_pin(/obj/structure/vaultdoor/pincode/bank)
		if(bankdoor && (host.mind.assigned_role == "Capo"))
			dat += "<b>The pincode for the bank vault is: [bankdoor.pincode]</b><BR>"
		if(bankdoor && (host.mind.assigned_role == "La Squadra"))
			if(prob(50))
				dat += "<b>The pincode for the bank vault is: [bankdoor.pincode]</b><BR>"
			else
				dat += "<b>Unfortunately you don't know the vault code.</b><BR>"
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
			if(host.bank_id == account.bank_id)
				dat += "<b>My bank account code is: [account.code]</b><BR>"
				break
		host << browse(dat, "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)
