/atom/movable/screen/alert/bloodhunt
	name = "Blood Hunt Is Going On"
	icon_state = "bloodhunt"

/atom/movable/screen/alert/bloodhunt/Click()
	for(var/mob/living/carbon/human/H in SSbloodhunt.hunted)
		if(H)
			var/area/A = get_area(H)
			to_chat(usr, "[icon2html(getFlatIcon(H), usr)][H.true_real_name], [H.mind ? H.mind.assigned_role : "Citizen"]. Was last seen at [A.name]")

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
		to_chat(world, "<b>The Blood Hunt after <span class='warning'>[H.true_real_name]</span> has been announced! <br> Reason: [reason]</b>")
		SEND_SOUND(world, sound('code/modules/wod13/sounds/announce.ogg'))
		hunted += H
		update_shit()
