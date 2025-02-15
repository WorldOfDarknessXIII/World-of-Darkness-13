//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want

/**
 *Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 *category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 *path is a type path of the actual alert type to throw
 *severity is an optional number that will be placed at the end of the icon_state for this alert
 *for example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 *new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 *flicks are forwarded to master
 *override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */
/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE)

	if(!category || QDELETED(src))
		return

	var/atom/movable/screen/alert/thealert
	if(alerts[category])
		thealert = alerts[category]
		if(thealert.override_alerts)
			return 0
		if(new_master && new_master != thealert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [thealert.master]")

			clear_alert(category)
			return .()
		else if(thealert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == thealert.severity)
			if(thealert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return 0
	else
		thealert = new type()
		thealert.override_alerts = override
		if(override)
			thealert.timeout = null
	thealert.owner = src

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.layer = FLOAT_LAYER
		new_master.plane = FLOAT_PLANE
		thealert.add_overlay(new_master)
		new_master.layer = old_layer
		new_master.plane = old_plane
		thealert.icon_state = "template" // We'll set the icon to the client's ui pref in reorganize_alerts()
		thealert.master = new_master
	else
		thealert.icon_state = "[initial(thealert.icon_state)][severity]"
		thealert.severity = severity

	alerts[category] = thealert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	thealert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(thealert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	if(thealert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), thealert.timeout)
		thealert.timeout = world.time + thealert.timeout - world.tick_lag
	return thealert

/mob/proc/alert_timeout(atom/movable/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/atom/movable/screen/alert/alert = alerts[category]
	if(!alert)
		return 0
	if(alert.override_alerts && !clear_override)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

/atom/movable/screen/alert
	icon = 'icons/hud/screen_alert.dmi'
	icon_state = "default"
	name = "Alert"
	desc = "Something seems to have gone wrong with this alert, so report this bug please"
	mouse_opacity = MOUSE_OPACITY_ICON
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = ""
	var/override_alerts = FALSE //If it is overriding other alerts of the same type
	var/mob/owner //Alert owner


/atom/movable/screen/alert/MouseEntered(location,control,params)
	if(!QDELETED(src))
		openToolTip(usr,src,params,title = name,content = desc,theme = alerttooltipstyle)


/atom/movable/screen/alert/MouseExited()
	closeToolTip(usr)


//Gas alerts
/atom/movable/screen/alert/not_enough_oxy
	name = "Choking (No O2)"
	desc = "You're not getting enough oxygen. Find some good air before you pass out! The box in your backpack has an oxygen tank and breath mask in it."
	icon_state = "not_enough_oxy"

/atom/movable/screen/alert/too_much_oxy
	name = "Choking (O2)"
	desc = "There's too much oxygen in the air, and you're breathing it in! Find some good air before you pass out!"
	icon_state = "too_much_oxy"

/atom/movable/screen/alert/not_enough_nitro
	name = "Choking (No N2)"
	desc = "You're not getting enough nitrogen. Find some good air before you pass out!"
	icon_state = "not_enough_nitro"

/atom/movable/screen/alert/too_much_nitro
	name = "Choking (N2)"
	desc = "There's too much nitrogen in the air, and you're breathing it in! Find some good air before you pass out!"
	icon_state = "too_much_nitro"

/atom/movable/screen/alert/not_enough_co2
	name = "Choking (No CO2)"
	desc = "You're not getting enough carbon dioxide. Find some good air before you pass out!"
	icon_state = "not_enough_co2"

/atom/movable/screen/alert/too_much_co2
	name = "Choking (CO2)"
	desc = "There's too much carbon dioxide in the air, and you're breathing it in! Find some good air before you pass out!"
	icon_state = "too_much_co2"

/atom/movable/screen/alert/not_enough_tox
	name = "Choking (No Plasma)"
	desc = "You're not getting enough plasma. Find some good air before you pass out!"
	icon_state = "not_enough_tox"

/atom/movable/screen/alert/too_much_tox
	name = "Choking (Plasma)"
	desc = "There's highly flammable, toxic plasma in the air and you're breathing it in. Find some fresh air. The box in your backpack has an oxygen tank and gas mask in it."
	icon_state = "too_much_tox"

/atom/movable/screen/alert/not_enough_n2o
	name = "Choking (No N2O)"
	desc = "You're not getting enough N2O. Find some good air before you pass out!"
	icon_state = "not_enough_n2o"

/atom/movable/screen/alert/too_much_n2o
	name = "Choking (N2O)"
	desc = "There's semi-toxic sleeping gas in the air and you're breathing it in. Find some fresh air. The box in your backpack has an oxygen tank and gas mask in it."
	icon_state = "too_much_n2o"

//End gas alerts


/atom/movable/screen/alert/fat
	name = "Fat"
	desc = "You ate too much food, lardass. Run around the station and lose some weight."
	icon_state = "fat"

/atom/movable/screen/alert/hungry
	name = "Hungry"
	desc = "Some food would be good right about now."
	icon_state = "hungry"

/atom/movable/screen/alert/starving
	name = "Starving"
	desc = "You're severely malnourished. The hunger pains make moving around a chore."
	icon_state = "starving"

/atom/movable/screen/alert/gross
	name = "Grossed out."
	desc = "That was kind of gross..."
	icon_state = "gross"

/atom/movable/screen/alert/verygross
	name = "Very grossed out."
	desc = "You're not feeling very well..."
	icon_state = "gross2"

/atom/movable/screen/alert/disgusted
	name = "DISGUSTED"
	desc = "ABSOLUTELY DISGUSTIN'"
	icon_state = "gross3"

/atom/movable/screen/alert/hot
	name = "Too Hot"
	desc = "You're flaming hot! Get somewhere cooler and take off any insulating clothing like a fire suit."
	icon_state = "hot"

/atom/movable/screen/alert/cold
	name = "Too Cold"
	desc = "You're freezing cold! Get somewhere warmer and take off any insulating clothing like a space suit."
	icon_state = "cold"



/atom/movable/screen/alert/blind
	name = "Blind"
	desc = "You can't see! This may be caused by a genetic defect, eye trauma, being unconscious, \
or something covering your eyes."
	icon_state = "blind"

/atom/movable/screen/alert/high
	name = "High"
	desc = "Whoa man, you're tripping balls! Careful you don't get addicted... if you aren't already."
	icon_state = "high"

/atom/movable/screen/alert/hypnosis
	name = "Hypnosis"
	desc = "Something's hypnotizing you, but you're not really sure about what."
	icon_state = "hypnosis"
	var/phrase

/atom/movable/screen/alert/mind_control
	name = "Mind Control"
	desc = "Your mind has been hijacked! Click to view the mind control command."
	icon_state = "mind_control"
	var/command

/atom/movable/screen/alert/mind_control/Click()
	var/mob/living/L = usr
	if(L != owner)
		return
	to_chat(L, "<span class='mind_control'>[command]</span>")

/atom/movable/screen/alert/drunk
	name = "Drunk"
	desc = "All that alcohol you've been drinking is impairing your speech, motor skills, and mental cognition. Make sure to act like it."
	icon_state = "drunk"

/atom/movable/screen/alert/embeddedobject
	name = "Embedded Object"
	desc = "Something got lodged into your flesh and is causing major bleeding. It might fall out with time, but surgery is the safest way. \
If you're feeling frisky, examine yourself and click the underlined item to pull the object out."
	icon_state = "embeddedobject"

/atom/movable/screen/alert/embeddedobject/Click()
	if(isliving(usr) && usr == owner)
		var/mob/living/carbon/M = usr
		return M.help_shake_act(M)

/atom/movable/screen/alert/weightless
	name = "Weightless"
	desc = "Gravity has ceased affecting you, and you're floating around aimlessly. You'll need something large and heavy, like a \
wall or lattice, to push yourself off if you want to move. A jetpack would enable free range of motion. A pair of \
magboots would let you walk around normally on the floor. Barring those, you can throw things, use a fire extinguisher, \
or shoot a gun to move around via Newton's 3rd Law of Motion."
	icon_state = "weightless"

/atom/movable/screen/alert/highgravity
	name = "High Gravity"
	desc = "You're getting crushed by high gravity, picking up items and movement will be slowed."
	icon_state = "paralysis"

/atom/movable/screen/alert/veryhighgravity
	name = "Crushing Gravity"
	desc = "You're getting crushed by high gravity, picking up items and movement will be slowed. You'll also accumulate brute damage!"
	icon_state = "paralysis"

/atom/movable/screen/alert/fire
	name = "On Fire"
	desc = "You're on fire. Stop, drop and roll to put the fire out or move to a vacuum area."
	icon_state = "fire"

/atom/movable/screen/alert/fire/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist() || L != owner)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.mobility_flags & MOBILITY_MOVE)
		return L.resist_fire() //I just want to start a flame in your hearrrrrrtttttt.

/atom/movable/screen/alert/give // information set when the give alert is made
	icon_state = "default"
	var/mob/living/carbon/giver
	var/obj/item/receiving

/**
 * Handles assigning most of the variables for the alert that pops up when an item is offered
 *
 * Handles setting the name, description and icon of the alert and tracking the person giving
 * and the item being offered, also registers a signal that removes the alert from anyone who moves away from the giver
 * Arguments:
 * * taker - The person receiving the alert
 * * giver - The person giving the alert and item
 * * receiving - The item being given by the giver
 */
/atom/movable/screen/alert/give/proc/setup(mob/living/carbon/taker, mob/living/carbon/giver, obj/item/receiving)
	name = "[giver] is offering [receiving]"
	desc = "[giver] is offering [receiving]. Click this alert to take it."
	icon_state = "template"
	cut_overlays()
	add_overlay(receiving)
	src.receiving = receiving
	src.giver = giver
	RegisterSignal(taker, COMSIG_MOVABLE_MOVED, PROC_REF(check_in_range))

/atom/movable/screen/alert/give/proc/check_in_range(atom/taker)
	SIGNAL_HANDLER

	if (!giver.CanReach(taker))
		to_chat(owner, "<span class='warning'>You moved out of range of [giver]!</span>")
		owner.clear_alert("[giver]")

/atom/movable/screen/alert/give/Click(location, control, params)
	. = ..()
	var/mob/living/carbon/C = owner
	C.take(giver, receiving)

/atom/movable/screen/alert/highfive
	icon_state = "default"
	var/mob/living/carbon/giver
	var/obj/item/slapper/slapper_item

/atom/movable/screen/alert/highfive/proc/setup(mob/living/carbon/taker, mob/living/carbon/giver, obj/item/slapper/slap)
	name = "[giver] is offering a high-five"
	desc = "[giver] wants a high-five! Click this alert to take it."
	icon_state = "template"
	cut_overlays()
	add_overlay(slap)
	src.slapper_item = slap
	src.giver = giver

/atom/movable/screen/alert/highfive/Click(location, control, params)
	. = ..()
	var/datum/status_effect/high_fiving/high_five_effect = giver.has_status_effect(STATUS_EFFECT_HIGHFIVE)
	if(high_five_effect)
		high_five_effect.we_did_it(owner)

/// Gives the player the option to succumb while in critical condition
/atom/movable/screen/alert/succumb
	name = "Succumb"
	desc = "Shuffle off this mortal coil."
	icon_state = "succumb"

/atom/movable/screen/alert/succumb/Click()
	if (isobserver(usr))
		return

	var/mob/living/living_owner = owner
	var/last_whisper = input("Do you have any last words?", "Final Words") as null | text
	if (isnull(last_whisper) || !CAN_SUCCUMB(living_owner))
		return

	if (length(last_whisper))
		living_owner.say("#[last_whisper]")

	living_owner.succumb(whispered = length(last_whisper) > 0)

/atom/movable/screen/alert/untorpor
	name = "Awaken"
	desc = "Free yourself of your Torpor."
	icon_state = "awaken"

/atom/movable/screen/alert/untorpor/Click()
	if(isobserver(usr))
		return
	var/mob/living/living_owner = owner
	if (iskindred(living_owner))
		var/mob/living/carbon/human/vampire = living_owner
		var/datum/species/kindred/kindred_species = vampire.dna.species
		if (COOLDOWN_FINISHED(kindred_species, torpor_timer) && (vampire.bloodpool > 0))
			vampire.untorpor()
			spawn()
				vampire.clear_alert("succumb")
		else
			to_chat(usr, "<span class='purple'><i>You are in Torpor, the sleep of death that vampires go into when injured, starved, or exhausted.</i></span>")
			if (vampire.bloodpool > 0)
				to_chat(usr, "<span class='purple'><i>You will be able to awaken in <b>[DisplayTimeText(COOLDOWN_TIMELEFT(kindred_species, torpor_timer))]</b>.</i></span>")
				to_chat(usr, "<span class='purple'><i>The time to re-awaken depends on your [(vampire.humanity > 5) ? "high" : "low"] [vampire.client.prefs.enlightenment ? "Enlightenment" : "Humanity"] rating of [vampire.humanity].</i></span>")
			else
				to_chat(usr, "<span class='danger'><i>You will not be able to re-awaken, because you have no blood available to do so.</i></span>")
	if(iscathayan(living_owner))
		var/mob/living/carbon/human/vampire = living_owner
		var/datum/dharma/dharma = vampire.mind.dharma
		if (COOLDOWN_FINISHED(dharma, torpor_timer) && (vampire.yang_chi > 0 || vampire.yin_chi > 0))
			vampire.untorpor()
			spawn()
				vampire.clear_alert("succumb")
		else
			to_chat(usr, "<span class='purple'><i>You are in the Little Death, the state that Kuei-Jin go into when injured or exhausted.</i></span>")
			if (vampire.yang_chi > 0 || vampire.yin_chi > 0)
				to_chat(usr, "<span class='purple'><i>You will be able to awaken in <b>[DisplayTimeText(COOLDOWN_TIMELEFT(dharma, torpor_timer))]</b>.</i></span>")
				to_chat(usr, "<span class='purple'><i>The time to re-awaken depends on your [vampire.max_yin_chi <= 4 ? "low" : "high"] permanent Yin Chi rating of [vampire.max_yin_chi].</i></span>")
			else
				to_chat(usr, "<span class='danger'><i>You will not be able to re-awaken, because you have no Chi available to do so.</i></span>")


//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/atom/movable/screen/alert/notify_cloning
	name = "Revival"
	desc = "Someone is trying to revive you. Re-enter your corpse if you want to be revived!"
	icon_state = "template"
	timeout = 300

/atom/movable/screen/alert/notify_cloning/Click()
	if(!usr || !usr.client || usr != owner)
		return
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/alert/notify_action
	name = "Body created"
	desc = "A body was created. You can enter it."
	icon_state = "template"
	timeout = 300
	var/atom/target = null
	var/action = NOTIFY_JUMP

/atom/movable/screen/alert/notify_action/Click()
	if(!usr || !usr.client || usr != owner)
		return
	if(!target)
		return
	var/mob/dead/observer/G = usr
	if(!istype(G))
		return
	switch(action)
		if(NOTIFY_ATTACK)
			target.attack_ghost(G)
		if(NOTIFY_JUMP)
			var/turf/T = get_turf(target)
			if(T && isturf(T))
				G.forceMove(T)
		if(NOTIFY_ORBIT)
			G.ManualFollow(target)

//OBJECT-BASED

/atom/movable/screen/alert/restrained/buckled
	name = "Buckled"
	desc = "You've been buckled to something. Click the alert to unbuckle unless you're handcuffed."
	icon_state = "buckled"

/atom/movable/screen/alert/restrained/handcuffed
	name = "Handcuffed"
	desc = "You're handcuffed and can't act. If anyone drags you, you won't be able to move. Click the alert to free yourself."

/atom/movable/screen/alert/restrained/legcuffed
	name = "Legcuffed"
	desc = "You're legcuffed, which slows you down considerably. Click the alert to free yourself."

/atom/movable/screen/alert/restrained/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist() || L != owner)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if((L.mobility_flags & MOBILITY_MOVE) && (L.last_special <= world.time))
		return L.resist_restraints()

/atom/movable/screen/alert/restrained/buckled/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist() || L != owner)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.last_special <= world.time)
		return L.resist_buckle()

/atom/movable/screen/alert/shoes/untied
	name = "Untied Shoes"
	desc = "Your shoes are untied! Click the alert or your shoes to tie them."
	icon_state = "shoealert"

/atom/movable/screen/alert/shoes/knotted
	name = "Knotted Shoes"
	desc = "Someone tied your shoelaces together! Click the alert or your shoes to undo the knot."
	icon_state = "shoealert"

/atom/movable/screen/alert/shoes/Click()
	var/mob/living/carbon/C = usr
	if(!istype(C) || !C.can_resist() || C != owner || !C.shoes)
		return
	C.changeNext_move(CLICK_CD_RESIST)
	C.shoes.handle_tying(C)

// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts(mob/viewmob)
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i = 1, i <= alerts.len, i++)
			screenmob.client.screen -= alerts[alerts[i]]
		return 1
	for(var/i = 1, i <= alerts.len, i++)
		var/atom/movable/screen/alert/alert = alerts[alerts[i]]
		if(alert.icon_state == "template")
			alert.icon = ui_style
		switch(i)
			if(1)
				. = ui_alert1
			if(2)
				. = ui_alert2
			if(3)
				. = ui_alert3
			if(4)
				. = ui_alert4
			if(5)
				. = ui_alert5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		screenmob.client.screen |= alert
	if(!viewmob)
		for(var/M in mymob.observers)
			reorganize_alerts(M)
	return 1

/atom/movable/screen/alert/Click(location, control, params)
	if(!usr || !usr.client)
		return
	var/paramslist = params2list(params)
	if(paramslist["shift"]) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr, "<span class='boldnotice'>[name]</span> - <span class='info'>[desc]</span>")
		return
	if(usr != owner)
		return
	if(master)
		return usr.client.Click(master, location, control, params)

/atom/movable/screen/alert/Destroy()
	. = ..()
	severity = 0
	master = null
	owner = null
	screen_loc = ""

