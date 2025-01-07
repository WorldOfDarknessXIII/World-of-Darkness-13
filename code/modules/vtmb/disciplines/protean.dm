/datum/discipline/protean
    name = "Protean"
    desc = "Lets your beast out, making you stronger and faster. Violates Masquerade."
    icon_state = "protean"
    cost = 1
    ranged = FALSE
    delay = 20 SECONDS
    violates_masquerade = TRUE
    activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
    clane_restricted = TRUE
    var/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/GA

/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel
    name = "Gangrel Form"
    desc = "Take on the shape a wolf."
    charge_max = 50
    cooldown_min = 50
    revert_on_death = TRUE
    die_with_shapeshifted_form = FALSE
    shapeshift_type = /mob/living/simple_animal/hostile/gangrel

/datum/discipline/protean/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    var/mod = min(4, level_casting)
//    var/mutable_appearance/protean_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "protean[mod]", -PROTEAN_LAYER)
    if(!GA)
        GA = new(caster)
    switch(mod)
        if(1)
            caster.drop_all_held_items()
            caster.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
            caster.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
            caster.add_client_colour(/datum/client_colour/glass_colour/red)
//            caster.dna.species.attack_verb = "slash"
//            caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//            caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+10
//            caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+10
//            caster.remove_overlay(PROTEAN_LAYER)
//            caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//            caster.apply_overlay(PROTEAN_LAYER)
            spawn(delay+caster.discipline_time_plus)
                if(caster)
                    for(var/obj/item/melee/vampirearms/knife/gangrel/G in caster.contents)
                        if(G)
                            qdel(G)
                    caster.remove_client_colour(/datum/client_colour/glass_colour/red)
//                    if(caster.dna)
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//                        caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//                        caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//                        caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-10
//                        caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-10
//                        caster.remove_overlay(PROTEAN_LAYER)
        if(2)
            caster.drop_all_held_items()
            caster.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
            caster.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
            caster.add_client_colour(/datum/client_colour/glass_colour/red)
//            caster.dna.species.attack_verb = "slash"
//            caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//            caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+15
//            caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+15
            caster.add_movespeed_modifier(/datum/movespeed_modifier/protean2)
//            caster.remove_overlay(PROTEAN_LAYER)
//            caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//            caster.apply_overlay(PROTEAN_LAYER)
            spawn(delay+caster.discipline_time_plus)
                if(caster)
                    for(var/obj/item/melee/vampirearms/knife/gangrel/G in caster.contents)
                        if(G)
                            qdel(G)
                    caster.remove_client_colour(/datum/client_colour/glass_colour/red)
//                    if(caster.dna)
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//                        caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//                        caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//                        caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-15
//                        caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-15
                    caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean2)
//                        caster.remove_overlay(PROTEAN_LAYER)
        if(3)
            caster.drop_all_held_items()
            GA.Shapeshift(caster)
//            caster.dna.species.attack_verb = "slash"
//            caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//            caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+20
//            caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh+20
//            caster.add_movespeed_modifier(/datum/movespeed_modifier/protean3)
//            caster.remove_overlay(PROTEAN_LAYER)
//            caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//            caster.apply_overlay(PROTEAN_LAYER)
            spawn(delay+caster.discipline_time_plus)
                if(caster && caster.stat != DEAD)
                    GA.Restore(GA.myshape)
                    caster.Stun(15)
                    caster.do_jitter_animation(30)
//                    if(caster.dna)
                    caster.playsound_local(caster, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//                        caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//                        caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//                        caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-20
//                        caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-20
//                        caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean3)
//                        caster.remove_overlay(PROTEAN_LAYER)
        if(4 to 5)
            caster.drop_all_held_items()
            if(level_casting == 4)
                GA.shapeshift_type = /mob/living/simple_animal/hostile/gangrel/better
            if(level_casting == 5)
                GA.shapeshift_type = /mob/living/simple_animal/hostile/gangrel/best
            GA.Shapeshift(caster)
//            caster.dna.species.attack_verb = "slash"
//            caster.dna.species.attack_sound = 'sound/weapons/slash.ogg'
//            caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow+25
//            caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagelow+25
//            if(level_casting == 5)
//                caster.add_movespeed_modifier(/datum/movespeed_modifier/protean5)
//            else
//                caster.add_movespeed_modifier(/datum/movespeed_modifier/protean4)
//            caster.remove_overlay(PROTEAN_LAYER)
//            caster.overlays_standing[PROTEAN_LAYER] = protean_overlay
//            caster.apply_overlay(PROTEAN_LAYER)
            spawn(delay+caster.discipline_time_plus)
                if(caster && caster.stat != DEAD)
                    GA.Restore(GA.myshape)
                    caster.Stun(1 SECONDS)
                    caster.do_jitter_animation(1.5 SECONDS)
//                    if(caster.dna)
                    caster.playsound_local(caster, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
//                        caster.dna.species.attack_verb = initial(caster.dna.species.attack_verb)
//                        caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
//                        caster.dna.species.punchdamagelow = caster.dna.species.punchdamagelow-25
//                        caster.dna.species.punchdamagehigh = caster.dna.species.punchdamagehigh-25
//                        if(level_casting == 5)
//                            caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean5)
//                        else
//                            caster.remove_movespeed_modifier(/datum/movespeed_modifier/protean4)
//                        caster.remove_overlay(PROTEAN_LAYER)

/mob/living/proc/tremere_gib()
    Stun(5 SECONDS)
    new /obj/effect/temp_visual/tremere(loc, "gib")
    animate(src, pixel_y = 16, color = "#ff0000", time = 50, loop = 1)

    spawn(5 SECONDS)
        if(stat != DEAD)
            death()
        var/list/items = list()
        items |= get_equipped_items(TRUE)
        for(var/obj/item/I in items)
            dropItemToGround(I)
        drop_all_held_items()
        spawn_gibs()
        spawn_gibs()
        spawn_gibs()
        qdel(src)
