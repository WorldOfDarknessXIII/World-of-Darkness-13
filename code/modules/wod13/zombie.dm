/mob/living/basic/zombie/beastmaster
	var/my_creator = null
	var/beastmaster = null

/mob/living/basic/zombie/beastmaster/giovanni_zombie
	name = "Shambling Corpse"
	desc = "When there is no more room in hell, the dead will walk on Earth."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "zombie"
	icon_living = "zombie"
	icon_dead = "zombie_dead"
	mob_biotypes = MOB_UNDEAD
	maxHealth = 50
	health = 50
	speed = 1
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/hallucinations/growl1.ogg'
	status_flags = CANPUSH
	faction = list("Giovanni")
	bloodpool = 0
	maxbloodpool = 0

/mob/living/basic/zombie/beastmaster/giovanni_zombie/level1
	name = "ghost"
	desc = "A soul of the dead, spooky."
	icon = 'icons/mob/simple/mob.dmi'
	icon_state = "ghost"
	icon_living = "ghost"
	mob_biotypes = MOB_UNDEAD
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	speed = 2
	maxHealth = 50
	health = 50
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "grips"
	attack_verb_simple = "grip"
	attack_sound = 'sound/effects/hallucinations/growl1.ogg'
	speak_emote = list("weeps")
	pressure_resistance = 300
	gold_core_spawnable = NO_SPAWN //too spooky for science
	light_system = COMPLEX_LIGHT
	light_range = 1 // same glowing as visible player ghosts
	light_power = 2
	faction = list("Giovanni")
	bloodpool = 0
	maxbloodpool = 0

/mob/living/basic/zombie/beastmaster/giovanni_zombie/level2
	maxHealth = 75
	health = 75
	melee_damage_lower = 20
	melee_damage_upper = 20

/mob/living/basic/zombie/beastmaster/giovanni_zombie/level3
	maxHealth = 100
	health = 100
	icon_state = "zombieup"
	icon_living = "zombieup"
	icon_dead = "zombieup_dead"
	melee_damage_lower = 25
	melee_damage_upper = 25

/mob/living/basic/zombie/beastmaster/giovanni_zombie/level4
	maxHealth = 150
	health = 150
	melee_damage_lower = 30
	melee_damage_upper = 30
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "skeleton_dead"

/mob/living/basic/zombie/beastmaster/giovanni_zombie/level5
	maxHealth = 350
	health = 350
	melee_damage_lower = 35
	melee_damage_upper = 35
	icon_state = "zombietop"
	icon_living = "zombietop"
	icon_dead = "zombietop_dead"
	speed = 4

/mob/living/basic/zombie/beastmaster/proc/give_player()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghosts_for_target("Do you want to play as summoned ghost?", null, null, null, 50, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, "<span class='ghostalert'>Someone is summoning a ghost!</span>")
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		name = C.name
		key = C.key
		visible_message("<span class='danger'>[src] rises with fresh soul!</span>")
		return TRUE
	visible_message("<span class='warning'>[src] remains unsouled...</span>")
	return FALSE

/mob/living/basic/zombie/proc/handle_automated_patriotification()
	if(target_to_zombebe)
		if(get_dist(src, target_to_zombebe) > 7)
			target_to_zombebe = null
		else
			var/totalshit = 1

			var/reqsteps = round((SSzombiepool.next_fire-world.time)/totalshit)
			walk_to(src, target_to_zombebe, reqsteps+1)
			if(get_dist(src, target_to_zombebe) <= 1)
				ClickOn(target_to_zombebe)
			//code to attack pepol
	else
		//code to find target
		for(var/mob/living/L in oviewers(6, src))
			if(!iszomboid(L))
				target_to_zombebe = L
		//else, if we have no target :((( NO ONE TO BITE... BRAAAAAAAAAHH(ins)... FUCK IM LOOKING FOR GATE TO BRRRRRRR
		if(!target_to_zombebe)
			if(GLOB.vampgate)
				var/obj/structure/vampgate/V = GLOB.vampgate
				if(get_area(V) == get_area(src))
					var/totalshit = 1
					var/reqsteps = round((SSzombiepool.next_fire-world.time)/totalshit)
					walk_to(src, V, reqsteps)
					if(get_dist(V, src) <= 1)
						if(!V.density)
							if(prob(20))
								for(var/mob/living/carbon/human/L in GLOB.player_list)
									if(L)
										if(L.mind)
											if(L.mind.assigned_role == "Graveyard Keeper")
												if(L.client)
													if(istype(get_area(L), /area/vtm/graveyard))
														L.AdjustMasquerade(-1)
														SSgraveyard.total_bad += 1
								qdel(src)
						else
							V.punched()
							do_attack_animation(V)

