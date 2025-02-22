/obj/effect/proc_holder/spell/targeted/forcewall
	name = "Forcewall"
	desc = "Create a magical barrier that only you can pass through."
	school = "transmutation"
	charge_max = 100
	clothes_req = FALSE
	invocation = "TARCOL MINTI ZHERI"
	invocation_type = INVOCATION_SHOUT
	sound = 'sound/magic/forcewall.ogg'
	action_icon_state = "shield"
	range = -1
	include_user = TRUE
	cooldown_min = 50 //12 deciseconds reduction per rank
	var/wall_type = /obj/effect/forcefield/wizard

/obj/effect/proc_holder/spell/targeted/forcewall/cast(list/targets,mob/user = usr)
	new wall_type(get_turf(user),user)
	if(user.dir == SOUTH || user.dir == NORTH)
		new wall_type(get_step(user, EAST),user)
		new wall_type(get_step(user, WEST),user)
	else
		new wall_type(get_step(user, NORTH),user)
		new wall_type(get_step(user, SOUTH),user)


/obj/effect/proc_holder/spell/targeted/forcewall/salubri/cast(list/targets, mob/user = usr)
	//[Lucia] TODO: when Disciplines are refactored, make this not terrible
	if (iskindred(user))
		var/mob/living/carbon/human/human_user = user
		human_user.bloodpool = max(0, human_user.bloodpool - 1)
		new wall_type(get_step(user, NORTH), user)
		new wall_type(get_step(user, SOUTH), user)
		new wall_type(get_step(user, EAST), user)
		new wall_type(get_step(user, WEST), user)
		new wall_type(get_step(get_step(user, NORTH), EAST), user) // Northeast
		new wall_type(get_step(get_step(user, NORTH), WEST), user) // Northwest
		new wall_type(get_step(get_step(user, SOUTH), EAST), user) // Southeast
		new wall_type(get_step(get_step(user, SOUTH), WEST), user) // Southwest

/obj/effect/forcefield/wizard
	var/mob/wizard

/obj/effect/forcefield/wizard/Initialize(mapload, mob/summoner)
	. = ..()
	wizard = summoner

/obj/effect/forcefield/wizard/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(mover == wizard)
		return TRUE
	if(ismob(mover))
		var/mob/M = mover
		if(M.anti_magic_check(chargecost = 0))
			return TRUE
