/datum/discipline/potence
    name = "Potence"
    desc = "Boosts melee and unarmed damage."
    icon_state = "potence"
    cost = 1
    ranged = FALSE
    delay = 10 SECONDS
    activate_sound = 'code/modules/wod13/sounds/potence_activate.ogg'
    var/datum/component/tackler

/datum/discipline/potence/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    var/mod = 8*level_casting
    var/armah = 0.4*level_casting
    caster.remove_overlay(POTENCE_LAYER)
    var/mutable_appearance/potence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "potence", -POTENCE_LAYER)
    caster.overlays_standing[POTENCE_LAYER] = potence_overlay
    caster.apply_overlay(POTENCE_LAYER)
    caster.dna.species.punchdamagelow += mod
    caster.dna.species.punchdamagehigh += mod
    caster.dna.species.meleemod += armah
    caster.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
    tackler = caster.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 2+level_casting, speed = 1, skill_mod = 0, min_distance = 0)
    caster.potential = level_casting
    spawn(delay+caster.discipline_time_plus)
        if(caster)
            if(caster.dna)
                if(caster.dna.species)
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/potence_deactivate.ogg', 50, FALSE)
                    caster.dna.species.punchdamagelow -= mod
                    caster.dna.species.punchdamagehigh -= mod
                    caster.dna.species.meleemod -= armah
                    caster.dna.species.attack_sound = initial(caster.dna.species.attack_sound)
                    caster.remove_overlay(POTENCE_LAYER)
                    caster.potential = 0
                    qdel(tackler)
