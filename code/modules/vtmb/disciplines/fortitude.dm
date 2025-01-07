
/datum/discipline/fortitude
    name = "Fortitude"
    desc = "Boosts armor."
    icon_state = "fortitude"
    cost = 1
    ranged = FALSE
    delay = 7.5 SECONDS
    activate_sound = 'code/modules/wod13/sounds/fortitude_activate.ogg'

/datum/discipline/fortitude/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    var/mod = min(3, level_casting)
    var/armah = 15*mod
//    caster.remove_overlay(FORTITUDE_LAYER)
//    var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "fortitude", -FORTITUDE_LAYER)
//    caster.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
//    caster.apply_overlay(FORTITUDE_LAYER)
    caster.physiology.armor.melee += armah
    caster.physiology.armor.bullet += armah
    spawn(delay+caster.discipline_time_plus)
        if(caster)
            caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/fortitude_deactivate.ogg', 50, FALSE)
            caster.physiology.armor.melee -= armah
            caster.physiology.armor.bullet -= armah
//            caster.remove_overlay(FORTITUDE_LAYER)
