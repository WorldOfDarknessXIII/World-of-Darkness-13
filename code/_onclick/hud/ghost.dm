
/atom/movable/screen/ghost
	icon = 'code/modules/wod13/UI/buttons32.dmi'
	plane = 45 // [ChillRaccoon] - 42 was a value by default
/*
/atom/movable/screen/ghost/MouseEntered()
	flick(icon_state + "_anim", src)
*/
/atom/movable/screen/ghost/jumptomob
	name = "Jump to mob"
	icon_state = "jumptomob"

/atom/movable/screen/ghost/jumptomob/Click()
	var/mob/dead/observer/G = usr
	G.jumptomob()

/atom/movable/screen/ghost/orbit
	name = "Orbit"
	icon_state = "orbit"

/atom/movable/screen/ghost/orbit/Click()
	var/mob/dead/observer/G = usr
	G.follow()

/atom/movable/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"

/atom/movable/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/teleport
	name = "Teleport"
	icon_state = "teleport"

/atom/movable/screen/ghost/teleport/Click()
	var/mob/dead/observer/G = usr
	G.dead_tele()

/atom/movable/screen/ghost/pai
	name = "pAI Candidate"
	icon_state = "pai"

/atom/movable/screen/ghost/pai/Click()
	var/mob/dead/observer/G = usr
	G.register_pai()


// [ChillRaccoon] - LFWB like ghost GUI

/*
/atom/movable/screen/fullscreen/ghost/lfwbLike
	icon = 'icons/hud/fullscreen.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/fullscreen/ghost/lfwbLike/New()
	..()
	var/matrix/M = matrix()
	M.Scale(1.3, 1) // client.view has 19x19
	src.transform = M

/atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer1 // [ChillRaccoon] - this layer should overlap screenLayer2
	name = ""
	icon_state = "ghost1"
	alpha = 170
	plane = 43

/atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer2
	name = ""
	icon_state = "ghost2"
	alpha = 100
	plane = 42
*/
/datum/hud/ghost/New(mob/owner)
	..()
	var/atom/movable/screen/using
	using = new /atom/movable/screen/ghost/jumptomob()
	using.screen_loc = ui_ghost_jumptomob
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/orbit()
	using.screen_loc = ui_ghost_orbit
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_reenter_corpse
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/teleport()
	using.screen_loc = ui_ghost_teleport
	using.hud = src
	static_inventory += using

//	using = new /atom/movable/screen/ghost/pai()
//	using.screen_loc = ui_ghost_pai
//	using.hud = src
//	static_inventory += using

//	using = new /atom/movable/screen/language_menu
//	using.icon = ui_style
//	using.hud = src
//	static_inventory += using


	// [ChillRaccoon] - LFWB like GUI implementation

/*
	using = new /atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer1
	using.hud = src
	using.screen_loc = "CENTER-7,CENTER-7"
	static_inventory += using

	using = new /atom/movable/screen/fullscreen/ghost/lfwbLike/screenLayer2
	using.hud = src
	using.screen_loc = "CENTER-7,CENTER-7"
	static_inventory += using
*/
/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	/* // [ChillRaccoon] - do a little trolling
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else*/
	//if(!check_rights_for(screenmob.client, R_ADMIN)) // [ChillRaccoon] - administration shouldn't see overlays
	// to_chat(screenmob.client, "Check rights (overlays) - [check_rights_for(screenmob.client, R_ADMIN)]")

	screenmob.client.screen += static_inventory

//We should only see observed mob alerts.
/datum/hud/ghost/reorganize_alerts(mob/viewmob)
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		return
	. = ..()

