/mob/living/carbon/human/npc/bouncer

	//Assigns an ID to NPCs that guard certain doors, must match a barrier's ID
	var/protected_zone_id = "test"

	var/list/denial_phrases = list("I HAVE NO DENIAL PHRASE")
	var/list/entry_phrases = list("I HAVE NO ENTRY PHRASE")
	var/list/police_block_phrases = list("I HAVE NO POLICE BAN PHRASE")
	var/list/block_phrases = list("I HAVE NO BLOCK PHRASE")

	staying = TRUE
	var/walk_home_timer = 30 SECONDS
	var/warp_home_timer = 40 SECONDS

	var/datum/vip_barrier_perm/linked_perm = null

	var/i_have_spoken = FALSE
	var/repeat_delay = 8 SECONDS
	var/resume_neutral_direction_delay = 4 SECONDS

	var/is_dominated = FALSE //Whether or not the man is dominated
	var/is_in_awe = FALSE //Whether or not the man is being hit by presence

	var/turf/start_turf = null //Where the creature spawns so it can return from whence it came


	//Behavior settings
	fights_anyway=TRUE

/mob/living/carbon/human/npc/bouncer/Initialize()
	..()

	my_weapon = new /obj/item/gun/ballistic/shotgun/vampire(src)

	my_backup_weapon = new /obj/item/melee/vampirearms/machete(src)

	AssignSocialRole(/datum/socialrole/bouncer)

	start_turf = get_turf(src)

	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(yearn_for_home))

	return INITIALIZE_HINT_LATELOAD


/mob/living/carbon/human/npc/bouncer/AssignSocialRole(var/datum/socialrole/bouncer/role, var/dont_random = FALSE)
	. = ..(role, dont_random)

	if(role && ispath(role, /datum/socialrole/bouncer))
		var/datum/socialrole/bouncer/social_role = new role()
		denial_phrases = social_role.denial_phrases
		entry_phrases = social_role.entry_phrases
		police_block_phrases = social_role.police_block_phrases
		block_phrases = social_role.block_phrases

/mob/living/carbon/human/npc/bouncer/LateInitialize()
	. = ..()

	//ideally this should never happen, but se la vie
	if(!GLOB.vip_barrier_perms[protected_zone_id])
		GLOB.vip_barrier_perms[protected_zone_id] = new /datum/vip_barrier_perm(protected_zone_id)

	linked_perm = GLOB.vip_barrier_perms[protected_zone_id]
	linked_perm.add_bouncer(src)


/mob/living/carbon/human/npc/bouncer/proc/yearn_for_home()
	SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	addtimer(CALLBACK(src, PROC_REF(go_home)), walk_home_timer)
	addtimer(CALLBACK(src, PROC_REF(position_hard_reset)), warp_home_timer)

/mob/living/carbon/human/npc/bouncer/proc/go_home()
	if(start_turf && loc == start_turf.loc)
		return
	walk_to(src, start_turf, 1, total_multiplicative_slowdown())

/mob/living/carbon/human/npc/bouncer/proc/position_hard_reset()
	if(start_turf && loc != start_turf.loc)
		forceMove(start_turf)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(yearn_for_home))

/mob/living/carbon/human/npc/bouncer/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item,/obj/item/card/id/police))
		to_chat(user, "<span class='notice'>You flash your [used_item] as you try to talk your way through.</span>")
		handle_social_bypass(user, used_badge=TRUE)
		return
	..()

/mob/living/carbon/human/npc/bouncer/attack_hand(mob/user)
	if (user.a_intent == INTENT_HELP)
		to_chat(user, "<span class='notice'>You try to talk your way through.</span>")
		handle_social_bypass(user)
		return
	..()

/mob/living/carbon/human/npc/bouncer/proc/can_be_reasoned_with()
	if(stat == DEAD || IsSleeping() || IsUnconscious() || loc!=initial(loc))
		return FALSE
	return TRUE

/mob/living/carbon/human/npc/bouncer/proc/handle_social_bypass(mob/user, used_badge = FALSE)
		linked_perm.notify_barrier_social_bypass(user, used_badge)


//====================================================================
//VERBAL CODE

/mob/living/carbon/human/npc/bouncer/proc/speak_entry_phrase(mob/target)
	speak_seldom(pick(entry_phrases), target)

/mob/living/carbon/human/npc/bouncer/proc/speak_denial_phrase(mob/target)
	speak_seldom(pick(denial_phrases), target)

/mob/living/carbon/human/npc/bouncer/proc/speak_police_block_phrase(mob/target)
	speak_seldom(pick(police_block_phrases), target)

/mob/living/carbon/human/npc/bouncer/proc/speak_block_phrase(mob/target)
	speak_seldom(pick(block_phrases), target)

//Say a phrase, only if something hasn't been said in awhile
/mob/living/carbon/human/npc/bouncer/proc/speak_seldom(var/phrase, mob/target)
	if(!i_have_spoken && loc != initial(loc))
		RealisticSay(phrase)
		i_have_spoken = TRUE
		addtimer(CALLBACK(src, PROC_REF(toggle_new_speak)), repeat_delay)

		dir = get_dir(loc, get_turf(target))
		addtimer(CALLBACK(src, PROC_REF(resume_neutral_direction)), resume_neutral_direction_delay)

/mob/living/carbon/human/npc/bouncer/proc/toggle_new_speak()
	i_have_spoken = FALSE

/mob/living/carbon/human/npc/bouncer/proc/resume_neutral_direction()
	dir = initial(dir)

//====================================================================
