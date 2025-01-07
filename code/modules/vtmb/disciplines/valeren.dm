
/datum/discipline/valeren
    name = "Valeren"
    desc = "Use your third eye in healing or protecting needs."
    icon_state = "valeren"
    cost = 1
    ranged = TRUE
    delay = 50
    violates_masquerade = FALSE
    activate_sound = 'code/modules/wod13/sounds/valeren.ogg'
    clane_restricted = TRUE
    dead_restricted = FALSE
    var/datum/beam/current_beam
    var/humanity_restored = 0

/datum/discipline/valeren/post_gain(mob/living/carbon/human/H)
	if(level >= 4)
		var/obj/effect/proc_holder/spell/targeted/forcewall/salubri/FW = new(H)
		H.mind.AddSpell(FW)

/datum/discipline/valeren/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    switch(level_casting)
        if(1)
            healthscan(caster, target, 1, FALSE)
            chemscan(caster, target)
//            woundscan(caster, target, src)
            to_chat(caster, "<b>[target]</b> has <b>[target.bloodpool]/[target.maxbloodpool]</b> blood points.")
            to_chat(caster, "<b>[target]</b> has a rating of <b>[target.humanity]</b> on their path.")
        if(2)
            if(get_dist(caster, target) <= 2)
                if(isgarou(target))
                    return
                if(iskindred(target))
                    target.add_confusion(5)
                    target.drowsyness += 4
                else if(ishuman(target))
                    target.SetSleeping(300)
            else
                to_chat(caster, "You need to be close to use this power.")
                return
        if(3)
            if(current_beam)
                qdel(current_beam)
            caster.Beam(target, icon_state="sm_arc", time = 50, maxdistance = 9, beam_type = /obj/effect/ebeam/medical)
            target.adjustBruteLoss(-50, TRUE)
            if(ishuman(target))
                var/mob/living/carbon/human/H = target
                if(length(H.all_wounds))
                    var/datum/wound/W = pick(H.all_wounds)
                    W.remove_wound()
            target.adjustFireLoss(-50, TRUE)
            target.update_damage_overlays()
            target.update_health_hud()
        if(4)
            if(current_beam)
                qdel(current_beam)
            caster.Beam(target, icon_state="sm_arc", time = 50, maxdistance = 9, beam_type = /obj/effect/ebeam/medical)
            target.adjustBruteLoss(-60, TRUE)
            if(ishuman(target))
                var/mob/living/carbon/human/H = target
                if(length(H.all_wounds))
                    var/datum/wound/W = pick(H.all_wounds)
                    W.remove_wound()
            target.adjustFireLoss(-60, TRUE)
            target.update_damage_overlays()
            target.update_health_hud()
        if(5)
            if(caster.grab_state > GRAB_PASSIVE)
                if(ishuman(caster.pulling))
                    var/mob/living/carbon/human/PB = caster.pulling
                    if(do_after(caster, 10 SECONDS) && iskindred(PB) && humanity_restored < 3)
                        to_chat(caster, "<span class='notice'>You healed [PB]'s soul slightly.</span>")
                        PB.AdjustHumanity(1, 10)
                        humanity_restored += 1
                    else if(humanity_restored >=3)
                        to_chat(caster, "<span class='warning'>You can't heal anymore souls this night.</span>")
                    else
                        to_chat(caster, "<span class='warning'>You need to grab a kindred and stay still to use this power.</span>")
                        return
            else
                to_chat(caster, "<span class='warning'>You need to hold your patient properly to heal their soul.</span>")
                return
