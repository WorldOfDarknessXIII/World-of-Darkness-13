/datum/discipline/obfuscate
    name = "Obfuscate"
    desc = "Makes you less noticable for living and un-living beings."
    icon_state = "obfuscate"
    cost = 1
    ranged = FALSE
    delay = 10 SECONDS
    activate_sound = 'code/modules/wod13/sounds/obfuscate_activate.ogg'
    leveldelay = TRUE

/datum/discipline/obfuscate/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
        if(NPC)
            if(NPC.danger_source == caster)
                NPC.danger_source = null
    caster.alpha = 10
    caster.obfuscate_level = level_casting
    spawn((delay*level_casting)+caster.discipline_time_plus)
        if(caster)
            if(caster.alpha != 255)
                caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/obfuscate_deactivate.ogg', 50, FALSE)
                caster.alpha = 255
