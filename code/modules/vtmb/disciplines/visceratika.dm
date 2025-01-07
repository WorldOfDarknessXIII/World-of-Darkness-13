
//datum/discipline/visceratika/post_gain(mob/living/carbon/human/H)
//    var/obj/effect/proc_holder/spell/voice_of_god/S = new(H)
//    H.mind.AddSpell(S)

/datum/discipline/visceratika
    name = "Visceratika"
    desc = "The Discipline of Visceratika is the exclusive possession of the Gargoyle bloodline and is an extension of their natural affinity for stone, earth, and things made thereof."
    icon_state = "visceratika"
    cost = 1
    ranged = FALSE
    delay = 15 SECONDS
    activate_sound = 'code/modules/wod13/sounds/visceratika.ogg'
    leveldelay = FALSE
    fearless = TRUE
    clane_restricted = TRUE

/datum/discipline/visceratika/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    switch(level_casting)
        if(1)
            for(var/mob/living/L in GLOB.player_list)
                if(L)
                    if(get_area(L) == get_area(caster))
                        var/their_name = L.name
                        if(ishuman(L))
                            var/mob/living/carbon/human/H = L
                            their_name = H.true_real_name
                        to_chat(caster, "[their_name]")
        if(2)
            ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
            spawn(delay+caster.discipline_time_plus)
                REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
        if(3)
            caster.alpha = 10
            caster.obfuscate_level = 3
            ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
            spawn(delay+caster.discipline_time_plus)
                caster.obfuscate_level = 0
                caster.alpha = 255
                REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
        if(4)
            caster.Stun(delay+caster.discipline_time_plus)
            caster.petrify(delay+caster.discipline_time_plus, "Visceratika")
            ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
            spawn(delay+caster.discipline_time_plus)
                REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
        if(5)
            caster.gargoyle_pass = TRUE
            caster.alpha = 10
            caster.obfuscate_level = 3
            ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
            spawn(delay+caster.discipline_time_plus)
                caster.obfuscate_level = 0
                caster.alpha = 255
                caster.gargoyle_pass = FALSE
                REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)

/turf/closed/Enter(atom/movable/mover, atom/oldloc)
    if(isliving(mover))
        var/mob/living/L = mover
        if(L.gargoyle_pass)
            if(get_area(L) == get_area(src))
                return TRUE
    return ..()
