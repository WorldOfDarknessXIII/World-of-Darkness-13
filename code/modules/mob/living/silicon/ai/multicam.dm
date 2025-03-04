//Turf, area, and landmark for the viewing room

/turf/open/ai_visible
	name = ""
	icon = 'icons/hud/pic_in_pic.dmi'
	icon_state = "room_background"
	turf_flags = NOJAUNT

/turf/open/ai_visible/Initialize(mapload)
	. = ..()
	RegisterSignal(SSmapping, COMSIG_PLANE_OFFSET_INCREASE, PROC_REF(multiz_offset_increase))
	multiz_offset_increase(SSmapping)

/turf/open/ai_visible/proc/multiz_offset_increase(datum/source)
	SIGNAL_HANDLER
	SET_PLANE_W_SCALAR(src, initial(plane), SSmapping.max_plane_offset)

/area/centcom/ai_multicam_room
	name = "ai_multicam_room"
	icon_state = "ai_camera_room"
	static_lighting = FALSE

	base_lighting_alpha = 255
	area_flags = NOTELEPORT | HIDDEN_AREA | UNIQUE_AREA
	ambientsounds = null
	flags_1 = NONE

GLOBAL_DATUM(ai_camera_room_landmark, /obj/effect/landmark/ai_multicam_room)

/obj/effect/landmark/ai_multicam_room
	name = "ai camera room"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"

/obj/effect/landmark/ai_multicam_room/Initialize(mapload)
	. = ..()
	qdel(GLOB.ai_camera_room_landmark)
	GLOB.ai_camera_room_landmark = src

/obj/effect/landmark/ai_multicam_room/Destroy()
	if(GLOB.ai_camera_room_landmark == src)
		GLOB.ai_camera_room_landmark = null
	return ..()

//Dummy camera eyes

/mob/eye/camera/ai/pic_in_pic
	name = "Secondary AI Eye"
	icon_state = "ai_pip_camera"
	invisibility = INVISIBILITY_OBSERVER
	mouse_opacity = MOUSE_OPACITY_ICON
	ai_detector_color = COLOR_ORANGE

	var/atom/movable/screen/movable/pic_in_pic/ai/screen
	var/list/cameras_telegraphed = list()
	var/telegraph_cameras = TRUE
	var/telegraph_range = 7

/mob/eye/camera/ai/pic_in_pic/GetViewerClient()
	if(screen?.ai)
		return screen.ai.client

/mob/eye/camera/ai/pic_in_pic/update_visibility()
	if(screen?.ai)
		screen.ai.camera_visibility(src)
	else
		..()

/mob/eye/camera/ai/pic_in_pic/setLoc(turf/destination, force_update = FALSE)
	. = ..()
	update_camera_telegraphing()
	update_ai_detect_hud()

/mob/eye/camera/ai/pic_in_pic/get_visible_turfs()
	SHOULD_CALL_PARENT(FALSE) //we do our own thing here
	return screen ? screen.get_visible_turfs() : list()

/mob/eye/camera/ai/pic_in_pic/proc/update_camera_telegraphing()
	if(!telegraph_cameras)
		return
	var/list/obj/machinery/camera/add = list()
	var/list/obj/machinery/camera/remove = list()
	var/list/obj/machinery/camera/visible = list()
	for (var/datum/camerachunk/chunk as anything in visibleCameraChunks)
		for (var/z_key in chunk.cameras)
			for(var/obj/machinery/camera/camera as anything in chunk.cameras[z_key])
				if (!camera.can_use() || (get_dist(camera, src) > telegraph_range))
					continue
				visible |= camera

	add = visible - cameras_telegraphed
	remove = cameras_telegraphed - visible

	for (var/obj/machinery/camera/C as anything in remove)
		if(QDELETED(C))
			continue
		cameras_telegraphed -= C
		C.in_use_lights--
		C.update_appearance()
	for (var/obj/machinery/camera/C as anything in add)
		if(QDELETED(C))
			continue
		cameras_telegraphed |= C
		C.in_use_lights++
		C.update_appearance()

/mob/eye/camera/ai/pic_in_pic/proc/disable_camera_telegraphing()
	telegraph_cameras = FALSE
	for (var/obj/machinery/camera/C as anything in cameras_telegraphed)
		if(QDELETED(C))
			continue
		C.in_use_lights--
		C.update_appearance()
	cameras_telegraphed.Cut()

/mob/eye/camera/ai/pic_in_pic/Destroy()
	disable_camera_telegraphing()
	return ..()
