/datum/discipline/animalism
    name = "Animalism"
    desc = "Summons Spectral Animals over your targets. Violates Masquerade."
    icon_state = "animalism"
    cost = 1
    delay = 8 SECONDS
    ranged = FALSE
    violates_masquerade = TRUE
    activate_sound = 'code/modules/wod13/sounds/wolves.ogg'
    dead_restricted = FALSE
    var/obj/effect/proc_holder/spell/targeted/shapeshift/animalism/AN

/obj/effect/spectral_wolf
    name = "Spectral Wolf"
    desc = "Bites enemies in other dimensions."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "wolf"
    plane = GAME_PLANE
    layer = ABOVE_ALL_MOB_LAYER

/obj/effect/proc_holder/spell/targeted/shapeshift/animalism
    name = "Animalism Form"
    desc = "Take on the shape a rat."
    charge_max = 50
    cooldown_min = 50
    revert_on_death = TRUE
    die_with_shapeshifted_form = FALSE
    shapeshift_type = /mob/living/simple_animal/pet/rat

/datum/discipline/animalism/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    if(!AN)
        AN = new(caster)
    var/limit = min(2, level) + caster.social + caster.more_companions - 1
    if(length(caster.beastmaster) >= limit)
        var/mob/living/simple_animal/hostile/beastmaster/B = pick(caster.beastmaster)
        B.death()
    switch(level_casting)
        if(1)
            if(!length(caster.beastmaster))
                var/datum/action/beastmaster_stay/E1 = new()
                E1.Grant(caster)
                var/datum/action/beastmaster_deaggro/E2 = new()
                E2.Grant(caster)
            var/mob/living/simple_animal/hostile/beastmaster/rat/R = new(get_turf(caster))
            R.my_creator = caster
            caster.beastmaster |= R
            R.beastmaster = caster
        if(2)
            if(!length(caster.beastmaster))
                var/datum/action/beastmaster_stay/E1 = new()
                E1.Grant(caster)
                var/datum/action/beastmaster_deaggro/E2 = new()
                E2.Grant(caster)
            var/mob/living/simple_animal/hostile/beastmaster/cat/C = new(get_turf(caster))
            C.my_creator = caster
            caster.beastmaster |= C
            C.beastmaster = caster
        if(3)
            if(!length(caster.beastmaster))
                var/datum/action/beastmaster_stay/E1 = new()
                E1.Grant(caster)
                var/datum/action/beastmaster_deaggro/E2 = new()
                E2.Grant(caster)
            var/mob/living/simple_animal/hostile/beastmaster/D = new(get_turf(caster))
            D.my_creator = caster
            caster.beastmaster |= D
            D.beastmaster = caster
        if(4)
            if(!length(caster.beastmaster))
                var/datum/action/beastmaster_stay/E1 = new()
                E1.Grant(caster)
                var/datum/action/beastmaster_deaggro/E2 = new()
                E2.Grant(caster)
            var/mob/living/simple_animal/hostile/beastmaster/rat/flying/F = new(get_turf(caster))
            F.my_creator = caster
            caster.beastmaster |= F
            F.beastmaster = caster
        if(5)
            AN.Shapeshift(caster)
//            caster.dna.species.attack_verb = "slash"
//            caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//            caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+20
//            caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+20
//            caster.add_movespeed_modifier(/datum/movespeed_modifier/protean3)
//            caster.remove_overlay(PROTEAN_LAYER)
//            caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//            caster.apply_overlay(PROTEAN_LAYER)
            spawn(20 SECONDS + caster.discipline_time_plus)
                if(caster && caster.stat != DEAD)
                    AN.Restore(AN.myshape)
                    caster.Stun(1.5 SECONDS)
