

/proc/create_number_on_mob(mob/Mob, what_color, text)
	var/image/message = image(loc = message_loc, layer = CHAT_LAYER + CHAT_LAYER_Z_STEP * current_z_idx++)
	message.plane = RUNECHAT_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
//	message.alpha = 0
	message.pixel_y = rand(16, 24)
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight
	message.maptext_x = rand(22, 28)
	message.maptext = MAPTEXT(complete_text)
	var/turf/T = get_turf(Mob)
	if(T)
		var/atom/movable/message_atom = new (T)
		message_atom.density = 0
		message_atom.add_overlay(message)
		message_atom.color = what_color
		animate(message_atom, pixel_y = message_atom.pixel_y+8, time = 10, loop = 1)
		animate(message_atom, pixel_y = message_atom.pixel_y+32, alpha = 0, time = 10)
		spawn(20)
			qdel(message_atom)

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
