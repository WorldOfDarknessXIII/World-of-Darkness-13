SUBSYSTEM_DEF(factionwar)
	name = "Faction War"
	init_order = INIT_ORDER_DEFAULT
	wait = 6000
	priority = FIRE_PRIORITY_VERYLOW

	var/list/marks_camarilla = list()
	var/list/marks_anarch = list()
	var/list/marks_sabbat = list()

	var/camarilla_power = 500
	var/list/camarilla_members = list()
	var/anarch_power = 500
	var/list/anarch_members = list()

/datum/controller/subsystem/factionwar/proc/move_mark(var/obj/graffiti/G, var/vampire_faction)

/obj/graffiti
	name = "faction mark"
	desc = "Reminds anyone who sees it which faction it belongs to..."
	icon = 'code/modules/wod13/48x48.dmi'
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	pixel_w = -8
	pixel_z = -8
	alpha = 128
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/repainting = FALSE
	var/permanent = FALSE