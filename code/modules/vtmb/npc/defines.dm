/*/datum/component/npc_controller
	var/mob/living/carbon/human/my_parent	//Who will be npc
	var/list/dangers = list()			//What are dangers to the npc, etc fire, shooters, hostile mobs
	var/list/attackers = list()			//Who are enemies to the npc
	var/atom/current_target				//Where is npc going
	var/talking = FALSE					//Is npc talking? Prevents movement then
	var/hostile = FALSE
	var/fights_anyway = FALSE

/datum/component/npc_controller/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	my_parent = parent

	RegisterSignal(my_parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/datum/component/npc_controller/proc/check_move()	//Can we call the movement?
	if(my_parent.stat >= 2)
		return FALSE
	if(my_parent.key)
		return FALSE
	if(my_parent.IsSleeping())
		return FALSE
	if(my_parent.IsUnconscious())
		return FALSE
	if(my_parent.IsParalyzed())
		return FALSE
	if(my_parent.IsKnockdown())
		return FALSE
	if(my_parent.IsStun())
		return FALSE
	if(HAS_TRAIT(my_parent, TRAIT_RESTRAINED))
		return FALSE
	if(talking)
		return FALSE
	if(my_parent.pulledby)
		return FALSE
//		if(prob(20))
//			resist()
//		else
//			return TRUE
	return TRUE

/datum/component/npc_controller/proc/remove()
	SIGNAL_HANDLER
	if(!QDELETED(my_parent))
		UnregisterSignal(my_parent, COMSIG_MOVABLE_MOVED)

/datum/component/npc_controller/proc/on_moved(datum/source, OldLoc, Dir, Forced)
	if(!check_move())
		walk(my_parent,0)
	if(get_dist(my_parent, current_target) < 3)
		get_target()
//	for(var/atom/M in dangers)
//		if(get_dist(my_parent, M) > 9)
//			dangers -= M
//	var/mindistance = 9
//	var/mob/living/A
//	for(var/mob/living/L in attackers)
//		if(get_dist(my_parent, L) <= mindistance)
//			mindistance = get_dist(my_parent, L)
//			A = L
//		else
//			attackers -= L
//	if(A)
//		var/allowed_to_click = FALSE
//		var/obj/item/I = my_parent.get_active_held_item()
//		if(I.force > 10)
//			allowed_to_click = TRUE
//		if(istype(I, /obj/item/gun))
//			allowed_to_click = TRUE
//		if(fights_anyway)
//			allowed_to_click = TRUE

//		if(allowed_to_click)
//			my_parent.ClickOn(A)

// /datum/component/npc_controller/proc/get_target()
	var/list/possible_interests = list()
//	for(var/obj/effect/landmark/activity/A in GLOB.npc_activities)
//		if((A.x-my_parent.x) > -7 && (A.x-my_parent.x) < 7 && get_dist(my_parent, A) > 5 && get_dist(my_parent, A) < 128)
//			possible_interests += A
//		if((A.y-my_parent.y) > -7 && (A.y-my_parent.y) < 7 && get_dist(my_parent, A) > 5 && get_dist(my_parent, A) < 128)
//			possible_interests += A
//	if(!length(possible_interests))
//		for(var/obj/effect/landmark/activity/A in GLOB.npc_activities)
//			possible_interests += A
//
//		current_target = A
//
//	!USE DEFAULT DM TABULATION AND FONT TO SEE CORRECT IMAGE!
//	\ | /
		- . -
		/ | \
	Here is illustration of which pattern npc will be using while walking to the target
	More closer to the target - more chance of choosing the pattern, but it'll be never fully 100%
	Straight way is always 50%, so npc will use side ways

	o - aggro target
	i - danger target

	�1
	  o
		\ | /
		- .
		/
			 i
	�2
		i
		  .	-
		/ | \
		  o

	If there is an obstacle in the possible way of movement - chance is 0%
	Always choosing the nearest target to move to, from list. If there are a couple of dangers - pattern will seek for optimal way to avoid all


/obj/effect/landmark/activity
	name = "NPC Activity"
	icon_state = "activity"

/obj/effect/landmark/activity/Initialize()
	. = ..()
	GLOB.npc_activities += src

*/
