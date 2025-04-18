/mob/living/carbon/werewolf/Life()
	update_icons()
	update_rage_hud()
	return..()

/mob/living/carbon/Life()
	. = ..()
	var/datum/splat/werewolf/garou/lycanthropy = is_garou(src)
	if(!lycanthropy)
		return

	if(key && stat <= HARD_CRIT)
		var/datum/preferences/P = GLOB.preferences_datums[ckey(key)]
		if (P.masquerade != masquerade)
			P.masquerade = masquerade
			P.save_preferences()
			P.save_character()

	if(stat == DEAD)
		return

	var/area/current_area = get_area(src)

	var/gaining_rage = TRUE
	for(var/obj/structure/werewolf_totem/W in GLOB.totems)
		if (!W.totem_health)
			continue

		if (W.tribe != lycanthropy.tribe)
			continue

		if (get_area(W) != current_area || !client)
			continue

		gaining_rage = FALSE

		if (last_gnosis_buff + 30 SECONDS <= world.time)
			continue

		last_gnosis_buff = world.time
		lycanthropy.add_gnosis(1, TRUE)

	if (istype(src, lycanthropy.breed.form))
		gaining_rage = FALSE

	if(gaining_rage && client)
		if((last_rage_gain + 1 MINUTES) < world.time)
			last_rage_gain = world.time
			lycanthropy.add_rage(1, TRUE)

	if(masquerade == 0)
		if(!is_special_character(src))
			if(lycanthropy.get_gnosis())
				to_chat(src, span_warning("My Veil is too low to connect with the spirits of Umbra!"))
				lycanthropy.remove_gnosis(-1, FALSE)

	if(lycanthropy.get_rage() >= 9)
		if(!HAS_TRAIT(src, TRAIT_IN_FRENZY))
			if((last_frenzy_check + 40 SECONDS) <= world.time)
				last_frenzy_check = world.time
				rollfrenzy()

	if (istype(current_area, /area/vtm/interior/penumbra))
		if((last_veil_restore + 40 SECONDS) < world.time)
			adjust_veil(1, src, TRUE)
			last_veil_restore = world.time
	else if (istype(current_area, lycanthropy.tribe.caern_area))
		if((last_veil_restore + 50 SECONDS) <= world.time)
			adjust_veil(1, src, TRUE)
			last_veil_restore = world.time

/mob/living/carbon/werewolf/crinos/Life()
	. = ..()
	if(CheckEyewitness(src, src, 5, FALSE))
		adjust_veil(-1)

/mob/living/carbon/werewolf/check_breath(datum/gas_mixture/breath)
	return

/mob/living/carbon/werewolf/handle_status_effects()
	..()
	//natural reduction of movement delay due to stun.
	if(move_delay_add > 0)
		move_delay_add = max(0, move_delay_add - rand(1, 2))

/mob/living/carbon/werewolf/handle_changeling()
	return

/mob/living/carbon/werewolf/handle_fire()//Aliens on fire code
	. = ..()
	if(.) //if the mob isn't on fire anymore
		return
	adjust_bodytemperature(BODYTEMP_HEATING_MAX) //If you're on fire, you heat up!

/mob/living/carbon/proc/adjust_veil(var/amount)
	if(!GLOB.canon_event)
		return
	if(last_veil_adjusting+200 >= world.time)
		return
	if(amount > 0)
		if(HAS_TRAIT(src, TRAIT_VIOLATOR))
			return
	if(amount < 0)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type != "masquerade")
				return
	last_veil_adjusting = world.time
	if(!is_special_character(src))
		if(amount < 0)
			if(masquerade > 0)
				SEND_SOUND(src, sound('code/modules/wod13/sounds/veil_violation.ogg', 0, 0, 75))
				to_chat(src, "<span class='boldnotice'><b>VEIL VIOLATION</b></span>")
				masquerade = max(0, masquerade+amount)
		if(amount > 0)
			if(masquerade < 5)
				SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
				to_chat(src, "<span class='boldnotice'><b>VEIL REINFORCEMENT</b></span>")
				masquerade = min(5, masquerade+amount)
