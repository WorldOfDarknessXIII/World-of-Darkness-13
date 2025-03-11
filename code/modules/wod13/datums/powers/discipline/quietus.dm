/datum/discipline/quietus
	name = "Quietus"
	desc = "Make a poison out of nowhere and forces all beings in range to mute, poison your touch, poison your weapon, poison your spit and make it acid. Violates Masquerade."
	icon_state = "quietus"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/quietus

/datum/discipline_power/quietus
	name = "Quietus power name"
	desc = "Quietus power description"

	activate_sound = 'code/modules/wod13/sounds/quietus.ogg'

//SILENCE OF DEATH
/datum/discipline_power/quietus/silence_of_death
	name = "Silence of Death"
	desc = "Create an area of pure silence around you, confusing those within it."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	duration_length = 5 SECONDS
	cooldown_length = 15 SECONDS
	duration_override = TRUE

/datum/discipline_power/quietus/silence_of_death/activate()
	. = ..()
	for(var/mob/living/carbon/human/H in viewers(7, owner))
		ADD_TRAIT(H, TRAIT_DEAF, "quietus")
		if(H.get_confusion() < 15)
			var/diff = 15 - H.get_confusion()
			H.add_confusion(min(15, diff))
		addtimer(CALLBACK(src, PROC_REF(deactivate), H), duration_length)

/datum/discipline_power/quietus/silence_of_death/deactivate(mob/living/carbon/human/deafened)
	. = ..()
	REMOVE_TRAIT(deafened, TRAIT_DEAF, "quietus")

//SCORPION'S TOUCH
/obj/item/melee/touch_attack/quietus
	name = "\improper poison touch"
	desc = "This is kind of like when you rub your feet on a shag rug so you can zap your friends, only a lot less safe."
	icon = 'code/modules/wod13/weapons.dmi'
	catchphrase = null
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "quietus"
	inhand_icon_state = "mansus"

/obj/item/melee/touch_attack/quietus/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/L = target
		L.adjustFireLoss(10)
		L.AdjustKnockdown(3 SECONDS)
		L.adjustStaminaLoss(50)
	return ..()

/datum/discipline_power/quietus/scorpions_touch
	name = "Scorpion's Touch"
	desc = "Create a powerful venom to apply to your enemies."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND

	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/quietus/scorpions_touch/activate()
	. = ..()
	owner.drop_all_held_items()
	//this should probably be changed to a normal ranged attack
	owner.put_in_active_hand(new /obj/item/melee/touch_attack/quietus(owner))

//DAGON'S CALL
/datum/discipline_power/quietus/dagons_call
	name = "Dagon's Call"
	desc = "Curse the last person you attacked to drown in their own blood."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	cooldown_length = 5 SECONDS

/datum/discipline_power/quietus/dagons_call/activate()
	. = ..()
	if(owner.lastattacked)
		if(isliving(owner.lastattacked))
			var/mob/living/L = owner.lastattacked
			L.adjustStaminaLoss(80)
			L.adjustFireLoss(10)
			to_chat(owner, "You send your curse on [L], the last creature you attacked.")
		else
			to_chat(owner, "You don't seem to have last attacked soul earlier...")
			return
	else
		to_chat(owner, "You don't seem to have last attacked soul earlier...")
		return

//BAAL'S CARESS
/datum/discipline_power/quietus/baals_caress
	name = "Baal's Caress"
	desc = "Transmute your vitae into a toxin that destroys all flesh it touches."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND
	vitae_cost = 3
	target_type = TARGET_OBJ
	range = 1

	violates_masquerade = TRUE

	cooldown_length = 15 SECONDS

/datum/discipline_power/quietus/baals_caress/can_activate(atom/target, alert = FALSE)
	. = ..()

	if (!istype(target, /obj/item/melee/vampirearms))
		if (alert)
			to_chat(owner, span_warning("[src] can only be used on weapons!"))
		return FALSE
	var/obj/item/melee/vampirearms/weapon = target

	//ensure the target is a weapon with an edge to use the toxin with
	if (!weapon.sharpness)
		if (alert)
			to_chat(owner, span_warning("[src] can only be used on bladed weapons!"))
		return FALSE

	return .

/datum/discipline_power/quietus/baals_caress/activate(obj/item/melee/vampirearms/target)
	. = ..()
	if(!target.quieted)
		target.quieted = TRUE
		target.armour_penetration = min(100, target.armour_penetration+30)
		target.force += 20
		target.color = "#72b27c"

//TASTE OF DEATH
/obj/projectile/quietus
	name = "acid spit"
	icon_state = "har4ok"
	pass_flags = PASSTABLE
	damage = 80
	damage_type = BURN
	hitsound = 'sound/weapons/effects/searwall.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	ricochets_max = 0
	ricochet_chance = 0

/obj/item/gun/magic/quietus
	name = "acid spit"
	desc = "Spit poison on your targets."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "har4ok"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/quietus
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/quietus
	name = "acid spit"
	desc = "A spit."
	projectile_type = /obj/projectile/quietus
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/quietus/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)
/*
	playsound(target.loc, 'code/modules/wod13/sounds/quietus.ogg', 50, TRUE)
	target.Stun(5*level_casting)
	if(level_casting >= 3)
		if(target.bloodpool > 1)
			var/transfered = max(1, target.bloodpool-3)
			owner.adjust_blood_points(transfered)
			target.adjust_blood_points(-transfered)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/quietus_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "quietus", -MUTATIONS_LAYER)
		H.overlays_standing[MUTATIONS_LAYER] = quietus_overlay
		H.apply_overlay(MUTATIONS_LAYER)
		spawn(5*level_casting)
			H.remove_overlay(MUTATIONS_LAYER)
*/

/datum/discipline_power/quietus/taste_of_death
	name = "Taste of Death"
	desc = "Spit a glob of caustic blood at your enemies."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND

	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/quietus/taste_of_death/activate()
	. = ..()
	owner.drop_all_held_items()
	//should be changed to a ranged attack targeting turfs
	owner.put_in_active_hand(new /obj/item/gun/magic/quietus(owner))
