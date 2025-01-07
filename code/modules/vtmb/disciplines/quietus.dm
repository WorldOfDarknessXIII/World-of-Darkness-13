/datum/discipline/quietus
    name = "Quietus"
    desc = "Make a poison out of nowhere and forces all beings in range to mute, poison your touch, poison your weapon, poison your spit and make it acid. Violates Masquerade."
    icon_state = "quietus"
    cost = 1
    ranged = FALSE
    delay = 50
//    range = 2
    violates_masquerade = TRUE
    clane_restricted = TRUE

/*
/datum/discipline/quietus/post_gain(mob/living/carbon/human/H)
	if(level >= 3)
		var/datum/action/silence_radius/SI = new()
		SI.Grant(H)
*/

/datum/discipline/quietus/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    caster.playsound_local(target.loc, 'code/modules/wod13/sounds/quietus.ogg', 50, TRUE)
    switch(level_casting)
        if(1)
            for(var/mob/living/carbon/human/H in oviewers(7, caster))
                ADD_TRAIT(H, TRAIT_DEAF, "quietus")
                if(H.get_confusion() < 15)
                    var/diff = 15 - H.get_confusion()
                    H.add_confusion(min(15, diff))
                spawn(50)
                    if(H)
                        REMOVE_TRAIT(H, TRAIT_DEAF, "quietus")
        if(2)
            caster.drop_all_held_items()
            caster.put_in_active_hand(new /obj/item/melee/touch_attack/quietus(caster))
        if(3)
            if(caster.lastattacked)
                if(isliving(caster.lastattacked))
                    var/mob/living/L = caster.lastattacked
                    L.adjustStaminaLoss(80)
                    L.adjustFireLoss(10)
                    to_chat(caster, "You send your curse on [L], the last creature you attacked.")
                else
                    to_chat(caster, "You don't seem to have last attacked soul earlier...")
                    return
            else
                to_chat(caster, "You don't seem to have last attacked soul earlier...")
                return
        if(4)
            caster.drop_all_held_items()
            caster.put_in_active_hand(new /obj/item/quietus_upgrade(caster))
        if(5)
            caster.drop_all_held_items()
            caster.put_in_active_hand(new /obj/item/gun/magic/quietus(caster))

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
            caster.bloodpool = min(caster.maxbloodpool, caster.bloodpool+transfered)
            target.bloodpool = transfered
    if(ishuman(target))
        var/mob/living/carbon/human/H = target
        H.remove_overlay(MUTATIONS_LAYER)
        var/mutable_appearance/quietus_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "quietus", -MUTATIONS_LAYER)
        H.overlays_standing[MUTATIONS_LAYER] = quietus_overlay
        H.apply_overlay(MUTATIONS_LAYER)
        spawn(5*level_casting)
            H.remove_overlay(MUTATIONS_LAYER)
*/
