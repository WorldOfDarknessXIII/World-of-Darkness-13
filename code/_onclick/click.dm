/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
//This is mainly modified by click code, to modify click delays elsewhere, use next_move and changeNext_move()
/mob/var/next_click	= 0

// THESE DO NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK
/mob/var/next_move_adjust = 0 //Amount to adjust action/click delays by, + or -
/mob/var/next_move_modifier = 1 //Value to multiply action/click delays by


//Delays the mob's next click/action by num deciseconds
// eg: 10-3 = 7 deciseconds of delay
// eg: 10*0.5 = 5 deciseconds of delay
// DOES NOT EFFECT THE BASE 1 DECISECOND DELAY OF NEXT_CLICK

/mob/proc/changeNext_move(num)
	next_move = world.time + ((num+next_move_adjust)*next_move_modifier)

/mob/living/changeNext_move(num)
	var/mod = next_move_modifier
	var/adj = next_move_adjust
	for(var/i in status_effects)
		var/datum/status_effect/S = i
		mod *= S.nextmove_modifier()
		adj += S.nextmove_adjust()
	next_move = world.time + ((num + adj)*mod)

/**
 * Before anything else, defer these calls to a per-mobtype handler.  This allows us to
 * remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.
 *
 * Alternately, you could hardcode every mob's variation in a flat [/mob/proc/ClickOn] proc; however,
 * that's a lot of code duplication and is hard to maintain.
 *
 * Note that this proc can be overridden, and is in the case of screen objects.
 */
/atom/Click(location,control,params)
	if(flags_1 & INITIALIZED_1)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)
		usr.ClickOn(src, params)

/atom/DblClick(location,control,params)
	if(flags_1 & INITIALIZED_1)
		usr.DblClickOn(src,params)

/atom/MouseWheel(delta_x,delta_y,location,control,params)
	if(flags_1 & INITIALIZED_1)
		usr.MouseWheelOn(src, delta_x, delta_y, params)

/**
 * Standard mob ClickOn()
 * Handles exceptions: Buildmode, middle click, modified clicks, mech actions
 *
 * After that, mostly just check your state, check whether you're holding an item,
 * check whether you're adjacent to the target, then pass off the click to whoever
 * is receiving it.
 * The most common are:
 * * [mob/proc/UnarmedAttack] (atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
 * * [atom/proc/attackby] (item,user) - used only when adjacent
 * * [obj/item/proc/afterattack] (atom,user,adjacent,params) - used both ranged and adjacent
 * * [mob/proc/RangedAttack] (atom,params) - used only ranged, only used for tk and laser eyes but could be changed
 */

/mob/proc/claw_swing()
	next_click = world.time+5
	new /obj/effect/temp_visual/dir_setting/claw_effect(get_turf(src), dir)
	playsound(loc, 'code/modules/wod13/sounds/swing.ogg', 50, TRUE)
	var/atom/M
	var/turf/T = get_step(src, dir)
	var/turf/T1 = get_step(T, turn(dir, -90))
	var/turf/T2 = get_step(T, turn(dir, 90))
	for(var/mob/living/MB in T)
		if(MB)
			M = MB
	if(!M)
		for(var/mob/living/MB in T1)
			if(MB)
				M = MB
		for(var/mob/living/MB in T2)
			if(MB)
				M = MB

	if(M)
		return M
	for(var/obj/OB in T)
		if(OB)
			M = OB
	return M

/mob/proc/melee_swing()
	next_click = world.time+5
	new /obj/effect/temp_visual/dir_setting/swing_effect(get_turf(src), dir)
	playsound(loc, 'code/modules/wod13/sounds/swing.ogg', 50, TRUE)
	var/atom/M
	var/turf/T = get_step(src, dir)
	var/turf/T1 = get_step(T, turn(dir, -90))
	var/turf/T2 = get_step(T, turn(dir, 90))
	SEND_SIGNAL(src, COMSIG_MOB_MELEE_SWING, M, T, T1, T2)
	for(var/mob/living/MB in T)
		if(MB)
			M = MB
	if(!M)
		for(var/mob/living/MB in T1)
			if(MB)
				M = MB
		for(var/mob/living/MB in T2)
			if(MB)
				M = MB

	if(M)
		return M
	for(var/obj/OB in T)
		if(OB)
			M = OB
	return M

/mob/proc/ClickOn( atom/A, params )
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(check_click_intercept(params,A))
		return

	if(notransform)
		return

	if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, A, params) & COMSIG_MOB_CANCEL_CLICKON)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["middle"])
		ShiftMiddleClickOn(A)
		return
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A, params)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(incapacitated(ignore_restraints = TRUE, ignore_stasis = TRUE))
		return

	face_atom(A)

	if(next_move > world.time) // in the year 2000...
		return

	if(!modifiers["catcher"] && A.IsObscured())
		return

	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		changeNext_move(CLICK_CD_HANDCUFFED)   //Doing shit in cuffs shall be vey slow
		UnarmedAttack(A)
		return

	if(in_throw_mode)
		changeNext_move(CLICK_CD_THROW)
		throw_item(A)
		return

	var/obj/item/W = get_active_held_item()

	if(W == A)
		W.attack_self(src)
		update_inv_hands()
		return

	//These are always reachable.
	//User itself, current loc, and user inventory
	if(A in DirectAccess())
		if(W)
			W.melee_attack_chain(src, A, params)
		else
			if(ismob(A))
				if(isliving(src))
					var/mob/living/L = src
					if(L.melee_professional)
						changeNext_move(CLICK_CD_RANGE)
					else
						changeNext_move(CLICK_CD_MELEE)
				else
					changeNext_move(CLICK_CD_MELEE)
			UnarmedAttack(A)
		return

	//Can't reach anything else in lockers or other weirdness

	var/atom/last_locc = null

	if(istype(loc, /obj/vampire_car))
		var/obj/vampire_car/V = loc
		if(V.driver != src)
			last_locc = loc
			forceMove(last_locc.loc)

	if(!loc.AllowClick() && !last_locc)
		return

	if(iswerewolf(src) && get_dist(src, A) <= 1)
		if(istype(A, /obj/manholeup))
			var/obj/manholeup/M = A
			if(!M.climbing)
				M.climbing = TRUE
				if(do_after(src, 30, A))
					M.climbing = FALSE
					var/turf/destination = get_step_multiz(A, UP)
					var/mob/living/L = src
					if(L.pulling)
						L.pulling.forceMove(destination)
					forceMove(destination)
					playsound(A, 'code/modules/wod13/sounds/manhole.ogg', 50, TRUE)
				else
					M.climbing = FALSE
		if(istype(A, /obj/manholedown))
			var/obj/manholeup/M = A
			if(!M.climbing)
				M.climbing = TRUE
				if(do_after(src, 30, A))
					M.climbing = FALSE
					var/turf/destination = get_step_multiz(A, DOWN)
					var/mob/living/L = src
					if(L.pulling)
						L.pulling.forceMove(destination)
					forceMove(destination)
					playsound(A, 'code/modules/wod13/sounds/manhole.ogg', 50, TRUE)
				else
					M.climbing = FALSE
		if(istype(A, /obj/structure/vampdoor))
			if(iscrinos(src))
				var/obj/structure/vampdoor/V = A
				playsound(get_turf(A), 'code/modules/wod13/sounds/get_bent.ogg', 100, FALSE)
				var/obj/item/shield/door/D = new(get_turf(A))
				D.icon_state = V.baseicon
				var/atom/throw_target = get_edge_target_turf(A, dir)
				D.throw_at(throw_target, rand(2, 4), 4, src)
				qdel(A)

	if(iscrinos(src))
		if(!W)
			var/mob/living/carbon/werewolf/wolf = src
			var/allowed_to_proceed = FALSE
			if(get_dist(A, src) <= 1)
				allowed_to_proceed = TRUE
			if(wolf.a_intent == INTENT_HARM && !isitem(A))
				allowed_to_proceed = TRUE
			if(allowed_to_proceed)
				switch(wolf.a_intent)
					if(INTENT_HARM)
						changeNext_move(CLICK_CD_MELEE)
						var/atom/B = claw_swing()
						UnarmedAttack(B)
					if(INTENT_HELP)
						UnarmedAttack(A)
					if(INTENT_GRAB)
						changeNext_move(CLICK_CD_GRABBING)
						if(A != src)
							if(isliving(A))
								var/mob/living/living = A
								living.grabbedby(wolf)
								return
							else
								UnarmedAttack(A)
					if(INTENT_DISARM)
						changeNext_move(CLICK_CD_MELEE)
						if(A != src)
							if(iscarbon(A))
								var/mob/living/carbon/living = A
								wolf.disarm(living)
								do_attack_animation(A)
								return
							else
								UnarmedAttack(A)
		else
			if(istype(W, /obj/item/melee))
				var/atom/B = melee_swing()
				W.melee_attack_chain(src, B, params)
			else if(CanReach(A,W))
				W.melee_attack_chain(src, A, params)

		if(last_locc)
			forceMove(last_locc)
		return

	if(istype(W, /obj/item/melee))
		if(A)
			if(CanReach(A,W))
				melee_swing()
				W.melee_attack_chain(src, A, params)
			else
				var/atom/B = melee_swing()
				if(B)
					W.melee_attack_chain(src, B, params)
		else
			var/atom/B = melee_swing()
			if(B)
				W.melee_attack_chain(src, B, params)
	else
	//Standard reach turf to turf or reaching inside storage
		if(CanReach(A,W))
			if(W)
				W.melee_attack_chain(src, A, params)
			else
				if(ismob(A))
					if(isliving(src))
						var/mob/living/L = src
						if(L.melee_professional)
							changeNext_move(CLICK_CD_RANGE)
						else
							changeNext_move(CLICK_CD_MELEE)
					else
						changeNext_move(CLICK_CD_MELEE)
				UnarmedAttack(A,1)
		else
			if(W)
				W.afterattack(A,src,0,params)
			else
				RangedAttack(A,params)

	if(last_locc)
		forceMove(last_locc)

/// Is the atom obscured by a PREVENT_CLICK_UNDER_1 object above it
/atom/proc/IsObscured()
	SHOULD_BE_PURE(TRUE)
	if(!isturf(loc)) //This only makes sense for things directly on turfs for now
		return FALSE
	var/turf/T = get_turf_pixel(src)
	if(!T)
		return FALSE
	for(var/atom/movable/AM in T)
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1 && AM.density && AM.layer > layer)
			return TRUE
	return FALSE

/turf/IsObscured()
	for(var/item in src)
		var/atom/movable/AM = item
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1)
			return TRUE
	return FALSE

/**
 * A backwards depth-limited breadth-first-search to see if the target is
 * logically "in" anything adjacent to us.
 */
/atom/movable/proc/CanReach(atom/ultimate_target, obj/item/tool, view_only = FALSE)
	var/list/direct_access = DirectAccess()
	var/depth = 1 + (view_only ? STORAGE_VIEW_DEPTH : INVENTORY_DEPTH)

	var/list/closed = list()
	var/list/checking = list(ultimate_target)
	while (checking.len && depth > 0)
		var/list/next = list()
		--depth

		for(var/atom/target in checking)  // will filter out nulls
			if(closed[target] || isarea(target))  // avoid infinity situations
				continue
			closed[target] = TRUE
			if(isturf(target) || isturf(target.loc) || (target in direct_access) || (isobj(target) && target.flags_1 & IS_ONTOP_1)) //Directly accessible atoms
				if(Adjacent(target) || (tool && CheckToolReach(src, target, tool.reach))) //Adjacent or reaching attacks
					return TRUE

			if (!target.loc)
				continue

			//Storage and things with reachable internal atoms need add to next here. Or return COMPONENT_ALLOW_REACH.
			if(SEND_SIGNAL(target.loc, COMSIG_ATOM_CANREACH, next) & COMPONENT_ALLOW_REACH)
				next += target.loc

		checking = next
	return FALSE

/atom/movable/proc/DirectAccess()
	return list(src, loc)

/mob/DirectAccess(atom/target)
	return ..() + contents

/mob/living/DirectAccess(atom/target)
	return ..() + GetAllContents()

/atom/proc/AllowClick()
	return FALSE

/turf/AllowClick()
	return TRUE

/proc/CheckToolReach(atom/movable/here, atom/movable/there, reach)
	if(!here || !there)
		return
	switch(reach)
		if(0)
			return FALSE
		if(1)
			return FALSE //here.Adjacent(there)
		if(2 to INFINITY)
			var/obj/dummy = new(get_turf(here))
			dummy.pass_flags |= PASSTABLE
			dummy.invisibility = INVISIBILITY_ABSTRACT
			for(var/i in 1 to reach) //Limit it to that many tries
				var/turf/T = get_step(dummy, get_dir(dummy, there))
				if(dummy.CanReach(there))
					qdel(dummy)
					return TRUE
				if(!dummy.Move(T)) //we're blocked!
					qdel(dummy)
					return
			qdel(dummy)

/// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	return


/**
 * Translates into [atom/proc/attack_hand], etc.
 *
 * Note: proximity_flag here is used to distinguish between normal usage (flag=1),
 * and usage when clicking on things telekinetically (flag=0).  This proc will
 * not be called at ranged except with telekinesis.
 *
 * proximity_flag is not currently passed to attack_hand, and is instead used
 * in human click code to allow glove touches only at melee range.
 */
/mob/proc/UnarmedAttack(atom/A, proximity_flag)
	if(ismob(A))
		changeNext_move(CLICK_CD_MELEE)
	return

/**
 * Ranged unarmed attack:
 *
 * This currently is just a default for all mobs, involving
 * laser eyes and telekinesis.  You could easily add exceptions
 * for things like ranged glove touches, spitting alien acid/neurotoxin,
 * animals lunging, etc.
 */
/mob/proc/RangedAttack(atom/A, params)
	if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED, A, params) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE


/**
 * Middle click
 * Mainly used for swapping hands
 */
/mob/proc/MiddleClickOn(atom/A, params)
	. = SEND_SIGNAL(src, COMSIG_MOB_MIDDLECLICKON, A, params)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	jump(A)

/**
 * Shift click
 * For most mobs, examine.
 * This is overridden in ai.dm
 */
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	var/flags = SEND_SIGNAL(src, COMSIG_CLICK_SHIFT, user)
	if(user.client && (user.client.eye == user || user.client.eye == user.loc || flags & COMPONENT_ALLOW_EXAMINATE))
		user.examinate(src)
	return

/**
 * Ctrl click
 * For most objects, pull
 */
/mob/proc/CtrlClickOn(atom/A)
	if(isitem(A))
		var/obj/item/flipper = A
		if((!usr.Adjacent(flipper) && !usr.DirectAccess(flipper)) || !isliving(usr) || usr.incapacitated())
			return
		var/old_width = flipper.grid_width
		var/old_height = flipper.grid_height
		flipper.grid_height = old_width
		flipper.grid_width = old_height
		to_chat(usr, "<span class='notice'>You flip the item for storage.</span>")
	A.CtrlClick(src)
	return

/atom/proc/CtrlClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL, user)
	SEND_SIGNAL(user, COMSIG_MOB_CTRL_CLICKED, src)
	var/mob/living/ML = user
	if(istype(ML))
		ML.pulled(src)

/mob/living/CtrlClick(mob/user)
	if(ishuman(user) && Adjacent(user) && !user.incapacitated())
		if(world.time < user.next_move)
			return FALSE
		var/mob/living/carbon/human/H = user
		H.dna.species.grab(H, src, H.mind.martial_art)
		H.changeNext_move(CLICK_CD_MELEE)
	else
		..()
/**
 * Alt click
 * Unused except for AI
 */
/mob/proc/AltClickOn(atom/A)
	. = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON, A)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	A.AltClick(src)

/atom/proc/AltClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_ALT, user)
	var/turf/T = get_turf(src)
	if(T && (isturf(loc) || isturf(src)) && user.TurfAdjacent(T))
		user.listed_turf = T
		user.client << output("[url_encode(json_encode(T.name))];", "statbrowser:create_listedturf")

/// Use this instead of [/mob/proc/AltClickOn] where you only want turf content listing without additional atom alt-click interaction
/atom/proc/AltClickNoInteract(mob/user, atom/A)
	var/turf/T = get_turf(A)
	if(T && user.TurfAdjacent(T))
		user.listed_turf = T
		user.client << output("[url_encode(json_encode(T.name))];", "statbrowser:create_listedturf")

/mob/proc/TurfAdjacent(turf/T)
	return T.Adjacent(src)

/**
 * Control+Shift click
 * Unused except for AI
 */
/mob/proc/CtrlShiftClickOn(atom/A)
	src.pointed(A)
	return

/mob/proc/ShiftMiddleClickOn(atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL_SHIFT)
	return

/*
	Misc helpers
	face_atom: turns the mob towards what you clicked on
*/

/// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(atom/A)
	if( buckled || stat != CONSCIOUS || !A || !x || !y || !A.x || !A.y )
		return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) // Wall items are graphically shifted but on the floor
		if(A.pixel_y > 16)
			setDir(NORTH)
		else if(A.pixel_y < -16)
			setDir(SOUTH)
		else if(A.pixel_x > 16)
			setDir(EAST)
		else if(A.pixel_x < -16)
			setDir(WEST)
		return

	if(abs(dx) < abs(dy))
		if(dy > 0)
			setDir(NORTH)
		else
			setDir(SOUTH)
	else
		if(dx > 0)
			setDir(EAST)
		else
			setDir(WEST)

//debug
/atom/movable/screen/proc/scale_to(x1,y1)
	if(!y1)
		y1 = x1
	var/matrix/M = new
	M.Scale(x1,y1)
	transform = M

/atom/movable/screen/click_catcher
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	screen_loc = "CENTER"

#define MAX_SAFE_BYOND_ICON_SCALE_TILES (MAX_SAFE_BYOND_ICON_SCALE_PX / world.icon_size)
#define MAX_SAFE_BYOND_ICON_SCALE_PX (33 * 32)			//Not using world.icon_size on purpose.

/atom/movable/screen/click_catcher/proc/UpdateGreed(view_size_x = 15, view_size_y = 15)
	var/icon/newicon = icon('icons/hud/screen_gen.dmi', "catcher")
	var/ox = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_x)
	var/oy = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_y)
	var/px = view_size_x * world.icon_size
	var/py = view_size_y * world.icon_size
	var/sx = min(MAX_SAFE_BYOND_ICON_SCALE_PX, px)
	var/sy = min(MAX_SAFE_BYOND_ICON_SCALE_PX, py)
	newicon.Scale(sx, sy)
	icon = newicon
	screen_loc = "CENTER-[(ox-1)*0.5],CENTER-[(oy-1)*0.5]"
	var/matrix/M = new
	M.Scale(px/sx, py/sy)
	transform = M

/atom/movable/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.jump(C.loc) //Calls (jump) instead of swap_hand()
	else
		var/turf/T = params2turf(modifiers["screen-loc"], get_turf(usr.client ? usr.client.eye : usr), usr.client)
		params += "&catcher=1"
		if(T)
			T.Click(location, control, params)
	. = 1

/// MouseWheelOn
/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	SEND_SIGNAL(src, COMSIG_MOUSE_SCROLL_ON, A, delta_x, delta_y, params)

/mob/dead/observer/MouseWheelOn(atom/A, delta_x, delta_y, params)
	var/list/modifier = params2list(params)
	if(modifier["shift"])
		var/view = 0
		if(delta_y > 0)
			view = -1
		else
			view = 1
		add_view_range(view)

/mob/proc/check_click_intercept(params,A)
	//Client level intercept
	if(client?.click_intercept)
		if(call(client.click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	//Mob level intercept
	if(click_intercept)
		if(call(click_intercept, "InterceptClickOn")(src, params, A))
			return TRUE

	return FALSE
