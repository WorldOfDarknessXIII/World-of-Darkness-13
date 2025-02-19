/mob/living/carbon/human/npc/proc/Aggro(mob/victim, attacked = FALSE)
	if(attacked && danger_source != victim)
		walk(src,0)
	if(victim == src)
		return
	if (istype(victim, /mob/living/carbon/human/npc))
		return
	if((stat != DEAD) && !HAS_TRAIT(victim, TRAIT_DEATHCOMA))
		danger_source = victim
		if(attacked)
			last_attacker = victim
			if(health != last_health)
				last_health = health
				last_damager = victim
	if(CheckMove())
		return
	if((last_danger_meet + 5 SECONDS) < world.time)
		last_danger_meet = world.time
		if(prob(50))
			if(!my_weapon)
				if(prob(50))
					emote("scream")
				else
					RealisticSay(pick(socialrole.help_phrases))
			else
				RealisticSay(pick(socialrole.help_phrases))

/mob/living/carbon/human/npc/proc/handle_gun(obj/item/gun/ballistic/weapon, mob/living/user, atom/target, params, zone_override)
	SIGNAL_HANDLER
	if(weapon.loc != src)
		UnregisterSignal(weapon, COMSIG_GUN_FIRED)
		UnregisterSignal(weapon, COMSIG_GUN_EMPTY)
		return

	if(!istype(weapon, /obj/item/gun/ballistic))
		return

	if(istype(weapon.magazine, /obj/item/ammo_box/magazine/internal))
		var/obj/item/ammo_box/magazine/internal_mag = weapon.magazine
		if(extra_loaded_rounds)
			internal_mag.give_round(new internal_mag.ammo_type())
			extra_loaded_rounds--
		addtimer(CALLBACK(src, PROC_REF(rack_held_gun), weapon), weapon.rack_delay)
		return

	if(!weapon.magazine.ammo_count() && extra_mags)
		extra_mags--
		weapon.eject_magazine_npc(src, new weapon.mag_type(src))
		weapon.rack(src)
		if(!weapon.chambered)
			weapon.chamber_round()

/mob/living/carbon/human/npc/proc/rack_held_gun(obj/item/gun/ballistic/weapon)
	if(weapon.bolt_locked)
		weapon.drop_bolt()
	weapon.rack(src)

/mob/living/carbon/human/npc/proc/handle_empty_gun()
	SIGNAL_HANDLER
	UnregisterSignal(my_weapon, COMSIG_GUN_FIRED)
	UnregisterSignal(my_weapon, COMSIG_GUN_EMPTY)
	npc_stow_weapon()
	if(my_backup_weapon && !spawned_backup_weapon)
		npc_draw_backup_weapon()
		my_weapon = my_backup_weapon
		spawned_backup_weapon = TRUE

/mob/living/carbon/human/npc/proc/npc_stow_weapon()
	if(my_weapon)
		REMOVE_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
		temporarilyRemoveItemFromInventory(my_weapon, TRUE)
		equip_to_appropriate_slot(my_weapon)
		ADD_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
		spawned_weapon = FALSE

/mob/living/carbon/human/npc/proc/npc_draw_weapon()
	if(my_weapon)
		REMOVE_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
		temporarilyRemoveItemFromInventory(my_weapon, TRUE)
		put_in_active_hand(my_weapon)
		ADD_TRAIT(my_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
		spawned_weapon = TRUE

/mob/living/carbon/human/npc/proc/npc_draw_backup_weapon()
	if(my_backup_weapon)
		REMOVE_TRAIT(my_backup_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
		temporarilyRemoveItemFromInventory(my_backup_weapon, TRUE)
		put_in_active_hand(my_backup_weapon)
		ADD_TRAIT(my_backup_weapon, TRAIT_NODROP, NPC_ITEM_TRAIT)
		spawned_weapon = TRUE
