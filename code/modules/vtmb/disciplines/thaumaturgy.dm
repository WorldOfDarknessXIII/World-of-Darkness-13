/datum/discipline/thaumaturgy
    name = "Thaumaturgy"
    desc = "Opens the secrets of blood magic and how you use it, allows to steal other's blood. Violates Masquerade."
    icon_state = "thaumaturgy"
    cost = 1
    ranged = TRUE
    delay = 5 SECONDS
    violates_masquerade = TRUE
    activate_sound = 'code/modules/wod13/sounds/thaum.ogg'
    clane_restricted = TRUE
    dead_restricted = FALSE

/datum/discipline/thaumaturgy/post_gain(mob/living/carbon/human/H)
	H.faction |= "Tremere"
	if(level >= 1)
		var/datum/action/thaumaturgy/T = new()
		T.Grant(H)
		T.level = level
		H.thaumaturgy_knowledge = TRUE
	if(level >= 3)
		var/datum/action/bloodshield/B = new()
		B.Grant(H)

/datum/discipline/thaumaturgy/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    switch(level_casting)
        if(1)
            var/turf/start = get_turf(caster)
            var/obj/projectile/thaumaturgy/H = new(start)
            H.firer = caster
            H.preparePixelProjectile(target, start)
            H.fire(direct_target = target)
        if(2)
            var/turf/start = get_turf(caster)
            var/obj/projectile/thaumaturgy/H = new(start)
            H.firer = caster
            H.damage = 10+caster.thaum_damage_plus
            H.preparePixelProjectile(target, start)
            H.level = 2
            H.fire(direct_target = target)
        if(3)
            var/turf/start = get_turf(caster)
            var/obj/projectile/thaumaturgy/H = new(start)
            H.firer = caster
            H.damage = 15+caster.thaum_damage_plus
            H.preparePixelProjectile(target, start)
            H.level = 2
            H.fire(direct_target = target)
        else
            if(iscarbon(target))
                target.Stun(2.5 SECONDS)
                target.visible_message("<span class='danger'>[target] throws up!</span>", "<span class='userdanger'>You throw up!</span>")
                playsound(get_turf(target), 'code/modules/wod13/sounds/vomit.ogg', 75, TRUE)
                target.add_splatter_floor(get_turf(target))
                target.add_splatter_floor(get_turf(get_step(target, target.dir)))
            else
                caster.bloodpool = min(caster.maxbloodpool, caster.bloodpool + target.bloodpool)
                if(!istype(target, /mob/living/simple_animal/hostile/megafauna))
//                if(isnpc(target))
//                    AdjustHumanity(caster, -1, 0)
                    target.tremere_gib()

/obj/effect/projectile/tracer/thaumaturgy
    name = "blood beam"
    icon_state = "cult"

/obj/effect/projectile/muzzle/thaumaturgy
    name = "blood beam"
    icon_state = "muzzle_cult"

/obj/effect/projectile/impact/thaumaturgy
    name = "blood beam"
    icon_state = "impact_cult"

/obj/projectile/thaumaturgy
    name = "blood beam"
    icon_state = "thaumaturgy"
    pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
    damage = 5
    damage_type = BURN
    hitsound = 'code/modules/wod13/sounds/drinkblood1.ogg'
    hitsound_wall = 'sound/weapons/effects/searwall.ogg'
    flag = LASER
    light_system = MOVABLE_LIGHT
    light_range = 1
    light_power = 1
    light_color = COLOR_SOFT_RED
    ricochets_max = 0
    ricochet_chance = 0
    tracer_type = /obj/effect/projectile/tracer/thaumaturgy
    muzzle_type = /obj/effect/projectile/muzzle/thaumaturgy
    impact_type = /obj/effect/projectile/impact/thaumaturgy
    var/level = 1

/obj/projectile/thaumaturgy/on_hit(atom/target, blocked = FALSE, pierce_hit)
    if(ishuman(firer))
        var/mob/living/carbon/human/VH = firer
        if(isliving(target))
            var/mob/living/VL = target
            if(isgarou(VL))
                if(VL.bloodpool >= 1 && VL.stat != DEAD)
                    var/sucked = min(VL.bloodpool, 2)
                    VL.bloodpool = VL.bloodpool-sucked
                    VL.blood_volume = max(VL.blood_volume-50, 0) // average blood_volume of most carbons seems to be 560
                    VL.apply_damage(45, BURN)
                    VL.visible_message("<span class='danger'>[target]'s wounds spray boiling hot blood!</span>", "<span class='userdanger'>Your blood boils!</span>")
                    VL.add_splatter_floor(get_turf(target))
                    VL.add_splatter_floor(get_turf(get_step(target, target.dir)))
                if(!iskindred(target))
                    if(VL.bloodpool >= 1 && VL.stat != DEAD)
                        var/sucked = min(VL.bloodpool, 2)
                        VL.bloodpool = VL.bloodpool-sucked
                        VL.blood_volume = max(VL.blood_volume-50, 0)
                    if(ishuman(VL))
                        if(VL.bloodpool >= 1 && VL.stat != DEAD)
                            var/mob/living/carbon/human/VHL = VL
                            VHL.blood_volume = max(VHL.blood_volume-25, 0)
                            if(VL.bloodpool == 0)
                                VHL.blood_volume = 0
                                VL.death()
//                            if(isnpc(VL))
//                                AdjustHumanity(VH, -1, 3)
                    else
                        if(VL.bloodpool == 0)
                            VL.death()
                    //VH.bloodpool = VH.bloodpool+(sucked*max(1, VL.bloodquality-1))
                    //VH.bloodpool = min(VH.maxbloodpool, VH.bloodpool)
            else
                if(VL.bloodpool >= 1)
                    var/sucked = min(VL.bloodpool, 1*level)
                    VL.bloodpool = VL.bloodpool-sucked
                    VH.bloodpool = VH.bloodpool+sucked
                    VH.bloodpool = min(VH.maxbloodpool, VH.bloodpool)
