/datum/discipline/auspex
    name = "Auspex"
    desc = "Allows to see entities, auras and their health through walls."
    icon_state = "auspex"
    cost = 1
    ranged = FALSE
    delay = 5 SECONDS
    leveldelay = TRUE

/datum/discipline/auspex/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    var/sound/auspexbeat = sound('code/modules/wod13/sounds/auspex.ogg', repeat = TRUE)
    caster.playsound_local(caster, auspexbeat, 75, 0, channel = CHANNEL_DISCIPLINES, use_reverb = FALSE)
    ADD_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
    var/loh = FALSE
    if(!HAS_TRAIT(caster, TRAIT_NIGHT_VISION))
        ADD_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
        loh = TRUE
    caster.update_sight()
    caster.add_client_colour(/datum/client_colour/glass_colour/lightblue)
    var/shitcasted = FALSE
    if(level_casting >= 2)
        var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
        abductor_hud.add_hud_to(caster)
    if(level_casting >= 3)
        var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
        health_hud.add_hud_to(caster)
    if(level_casting >= 4)
        caster.auspex_examine = TRUE
    if(level_casting >= 5)
        caster.ghostize(TRUE, FALSE, TRUE)
        caster.soul_state = SOUL_PROJECTING

    spawn((delay*level_casting)+caster.discipline_time_plus)
        if(caster)
            if(shitcasted)
                GLOB.auspex_list -= caster
            caster.auspex_examine = FALSE
            caster.see_invisible = initial(caster.see_invisible)
            var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
            abductor_hud.remove_hud_from(caster)
            var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
            health_hud.remove_hud_from(caster)
            caster.stop_sound_channel(CHANNEL_DISCIPLINES)
            caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/auspex_deactivate.ogg', 50, FALSE)
            REMOVE_TRAIT(caster, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
            if(loh)
                REMOVE_TRAIT(caster, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
            caster.remove_client_colour(/datum/client_colour/glass_colour/lightblue)
            caster.update_sight()
