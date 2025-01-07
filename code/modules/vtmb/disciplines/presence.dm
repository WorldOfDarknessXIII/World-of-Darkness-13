
/datum/discipline/presence
    name = "Presence"
    desc = "Makes targets in radius more vulnerable to damages."
    icon_state = "presence"
    cost = 1
    ranged = TRUE
    delay = 5 SECONDS
    activate_sound = 'code/modules/wod13/sounds/presence_activate.ogg'
    leveldelay = FALSE
    fearless = TRUE

/mob/living/carbon/human/proc/walk_to_caster()
    walk(src, 0)
    if(!CheckFrenzyMove())
        set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
        step_to(src,caster,0)
        face_atom(caster)

/mob/living/carbon/human/proc/step_away_caster()
    walk(src, 0)
    if(!CheckFrenzyMove())
        set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
        step_away(src,caster,99)
        face_atom(caster)

/mob/living/carbon/human/proc/attack_myself_command()
    if(!CheckFrenzyMove())
        a_intent = INTENT_HARM
        var/obj/item/I = get_active_held_item()
        if(I)
            if(I.force)
                ClickOn(src)
            else
                drop_all_held_items()
                ClickOn(src)
        else
            ClickOn(src)

/datum/discipline/presence/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    var/mypower = caster.get_total_social()
    var/theirpower = target.get_total_mentality()
    if((theirpower >= mypower) || ((caster.generation - 3) >= target.generation))
        to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to sway!</span>")
        return
    if(ishuman(target))
        var/mob/living/carbon/human/H = target
        H.remove_overlay(MUTATIONS_LAYER)
        var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
        presence_overlay.pixel_z = 1
        H.overlays_standing[MUTATIONS_LAYER] = presence_overlay
        H.apply_overlay(MUTATIONS_LAYER)
        H.caster = caster
        switch(level_casting)
            if(1)
                var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/walk_to_caster)
                for(var/i in 1 to 30)
                    addtimer(cb, (i - 1)*H.total_multiplicative_slowdown())
                to_chat(target, "<span class='userlove'><b>COME HERE</b></span>")
                caster.say("COME HERE!!")
            if(2)
                target.Stun(10)
                to_chat(target, "<span class='userlove'><b>REST</b></span>")
                caster.say("REST!!")
                if(target.body_position == STANDING_UP)
                    target.toggle_resting()
            if(3)
                var/obj/item/I1 = H.get_active_held_item()
                var/obj/item/I2 = H.get_inactive_held_item()
                to_chat(target, "<span class='userlove'><b>PLEASE ME</b></span>")
                caster.say("PLEASE ME!!")
                target.face_atom(caster)
                target.do_jitter_animation(30)
                target.Immobilize(10)
                target.drop_all_held_items()
                if(I1)
                    I1.throw_at(get_turf(caster), 3, 1, target)
                if(I2)
                    I2.throw_at(get_turf(caster), 3, 1, target)
            if(4)
                to_chat(target, "<span class='userlove'><b>FEAR ME</b></span>")
                caster.say("FEAR ME!!")
                var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/step_away_caster)
                for(var/i in 1 to 30)
                    addtimer(cb, (i - 1)*H.total_multiplicative_slowdown())
                target.emote("scream")
                target.do_jitter_animation(30)
            if(5)
                to_chat(target, "<span class='userlove'><b>UNDRESS YOURSELF</b></span>")
                caster.say("UNDRESS YOURSELF!!")
                target.Immobilize(10)
                for(var/obj/item/clothing/W in H.contents)
                    if(W)
                        H.dropItemToGround(W, TRUE)
        spawn(delay + caster.discipline_time_plus)
            if(H)
                H.remove_overlay(MUTATIONS_LAYER)
                if(caster)
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/presence_deactivate.ogg', 50, FALSE)
