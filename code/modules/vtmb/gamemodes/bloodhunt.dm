/atom/movable/screen/alert/bloodhunt
	name = "The Red Hunt is on!"
	icon_state = "bloodhunt"

/atom/movable/screen/alert/bloodhunt/Click()
	SSbloodhunt.inform_bloodhunt(src)

SUBSYSTEM_DEF(bloodhunt)
	name = "Blood Hunt"
	init_order = INIT_ORDER_DEFAULT
	wait = 600
	priority = FIRE_PRIORITY_VERYLOW

	/* Associated list: Hunted = list("message" = yadda, "reason" = yadda) */
	var/list/hunted = list()


/datum/controller/subsystem/bloodhunt/fire()
	update_shit()

/datum/controller/subsystem/bloodhunt/proc/update_shit()
	if(!length(hunted))
		SEND_SIGNAL(SSmasquerade, COMSIG_BLOODHUNT_INACTIVE)
		return
	for(var/mob/living/prey in hunted)
		if(QDELETED(prey))
			hunted -= prey
			if(!length(hunted))
				SEND_SIGNAL(SSmasquerade, COMSIG_BLOODHUNT_INACTIVE)
			continue
		var/area/vtm/last_known_location = get_area(prey)
		if(!istype(A, /area/vtm) || A.zone_type == "battle")
			continue	//PSEUDO_M todo: add signals for checking if they're in an area sympathetic to them, snitches get stitches
		update_bloodhunt_message(prey, reason, last_known_location)
	SEND_SIGNAL(SSmasquerade, COMSIG_BLOODHUNT_ACTIVE)

/datum/controller/subsystem/bloodhunt/proc/update_bloodhunt_message(mob/living/carbon/human/prey, reason, area/vtm/last_known_location, initial_announcement = FALSE)
		var/location_name = null
		if(initial_announcement && (!istype(last_known_location, /area/vtm) || last_known_location.zone_type == "battle"))
			location_name = "Whereabouts unknown."
		var/hunted_reason = reason
		var/hunted_message = "\
		[icon2html(getFlatIcon(prey))][prey.true_real_name], \
		[prey.mind ? prey.mind.assigned_role : "Citizen"].<br>\
		Crime pronounced by the Camarilla: [hunted_reason]\
		<br>[location_name]."


		H.throw_alert("bloodhunt", /atom/movable/screen/alert/bloodhunt)
	else
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(iskindred(H) || isghoul(H))
				H.clear_alert("bloodhunt")

/datum/controller/subsystem/bloodhunt/proc/announce_hunted(mob/living/carbon/human/prey, reason)
	if(!ishuman(prey))
		return
	if(!prey.bloodhunted)
		prey.bloodhunted = TRUE
	hunted[prey] = list(
		"message" = SSbloodhunt.update_bloodhunt_message(prey, reason, /*last_known_location =*/get_area(prey), /*initial_announcement =*/TRUE),
		"reason" = reason
	)
	SEND_SIGNAL(SSmasquerade, COMSIG_BLOODHUNT_ANNOUNCED, prey, reason)