/atom/movable/screen/alert/bloodhunt
	name = "Blood Hunt Is Going On"
	icon_state = "bloodhunt"

/atom/movable/screen/alert/bloodhunt/Click()
	for(var/mob/living/carbon/human/H in SSbloodhunt.hunted)
		if(H)
			var/area/A = get_area(H)
			to_chat(usr, "[icon2html(getFlatIcon(H), usr)][H.true_real_name], [H.mind ? H.mind.assigned_role : "Citizen"]. Was last seen at [A.name]")

/*/mob/living/proc/check_elysium(var/instant = FALSE)
	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		if(human.obfuscate_level < 5)
			if(alpha != 255)
				playsound(loc, 'code/modules/wod13/sounds/obfuscate_deactivate.ogg', 50, FALSE)
				alpha = 255
	if(!HAS_TRAIT(src, TRAIT_ELYSIUM))
		return
	if(!ishuman(src))
		return
	if(!client)
		return
	var/area/vtm/V
	if(istype(get_area(src), /area/vtm))
		V = get_area(src)
		var/mob/living/carbon/human/H = src
		if(V.zone_owner == H.vampire_faction)
			return
		for(var/mob/living/carbon/human/HU in SSbloodhunt.hunted)
			if(HU)
				if(HU.true_real_name == H.true_real_name)
					return
	to_chat(src, "<span class='userdanger'><b>You feel like your actions are against the rules...</b></span>")
	if(instant)
		SSbloodhunt.announce_hunted(src)
		if(V)
			V.break_elysium()
	else
		elysium_checks = elysium_checks+1
		if(elysium_checks > 2)
			SSbloodhunt.announce_hunted(src)
			if(V)
				V.break_elysium()
*/
SUBSYSTEM_DEF(bloodhunt)
	name = "Blood Hunt"
	init_order = INIT_ORDER_DEFAULT
	wait = 600
	priority = FIRE_PRIORITY_VERYLOW

	var/list/hunted = list()

/datum/controller/subsystem/bloodhunt/fire()
	update_shit()

/datum/controller/subsystem/bloodhunt/proc/update_shit()
	for(var/mob/living/L in hunted)
		if(QDELETED(L))
			hunted -= L
	if(length(hunted))
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(iskindred(H) || isghoul(H))
				H.throw_alert("bloodhunt", /atom/movable/screen/alert/bloodhunt)
	else
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(iskindred(H) || isghoul(H))
				H.clear_alert("bloodhunt")

/datum/controller/subsystem/bloodhunt/proc/announce_hunted(var/mob/living/target, var/reason)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(!H.bloodhunted)
		H.bloodhunted = TRUE
		for(var/mob/living/carbon/human/R in GLOB.player_list)
			if(R && iskindred(R) && R.client)
				to_chat(R, "<b>The Blood Hunt after <span class='warning'>[H.true_real_name]</span> has been announced! <br> Reason: [reason]</b>")
				SEND_SOUND(R, sound('code/modules/wod13/sounds/announce.ogg'))
		hunted += H
		update_shit()
