/datum/discipline/melpominee
    name = "Melpominee"
    desc = "Named for the Greek Muse of Tragedy, Melpominee is a unique discipline of the Daughters of Cacophony. It explores the power of the voice, shaking the very soul of those nearby and allowing the vampire to perform sonic feats otherwise impossible."
    icon_state = "melpominee"
    cost = 1
    ranged = TRUE
    delay = 75
    violates_masquerade = FALSE
    activate_sound = 'code/modules/wod13/sounds/melpominee.ogg'
    clane_restricted = TRUE
    dead_restricted = FALSE

/mob/living/carbon/human/proc/create_walk_to(max)
    for(var/i in 1 to max)
        addtimer(CALLBACK(src, PROC_REF(walk_to_caster)), (i - 1) * total_multiplicative_slowdown(), TIMER_UNIQUE)

/datum/discipline/melpominee/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    switch(level_casting)
        if(1)
            if (target.stat == DEAD)
                //why? because of laziness, it sends messages to deadchat if you do that
                to_chat(caster, "<span class='notice'>You can't use this on corpses.</span>")
                return
            var/new_say = input(caster, "What will your target say?") as null|text
            if(new_say)
                //prevent forceful emoting and whatnot
                new_say = trim(copytext_char(sanitize(new_say), 1, MAX_MESSAGE_LEN))
                if (findtext(new_say, "*"))
                    to_chat(caster, "<span class='danger'>You can't force others to perform emotes!</span>")
                    return

                if(CHAT_FILTER_CHECK(new_say))
                    to_chat(caster, "<span class='warning'>That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[new_say]\"</span></span>")
                    SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
                    return
                target.say("[new_say]", forced = "melpominee 1")

                var/base_difficulty = 5
                var/difficulty_malus = 0
                var/masked = FALSE
                if (ishuman(target)) //apply a malus and different text if victim's mouth isn't visible, and a malus if they're already typing
                    var/mob/living/carbon/human/victim = target
                    if ((victim.wear_mask?.flags_inv & HIDEFACE) || (victim.head?.flags_inv & HIDEFACE))
                        masked = TRUE
                        base_difficulty += 2
                    if (victim.overlays_standing[SAY_LAYER]) //ugly way to check for if the victim is currently typing
                        base_difficulty += 2

                for (var/mob/living/hearer in (view(7, target) - caster - target))
                    if (!hearer.client)
                        continue
                    difficulty_malus = 0
                    if (get_dist(hearer, target) > 3)
                        difficulty_malus += 1
                    if (storyteller_roll(hearer.get_total_mentality(), base_difficulty + difficulty_malus) == ROLL_SUCCESS)
                        if (masked)
                            to_chat(hearer, "<span class='warning'>[target.name]'s jaw isn't moving to match [target.p_their()] words.</span>")
                        else
                            to_chat(hearer, "<span class='warning'>[target.name]'s lips aren't moving to match [target.p_their()] words.</span>")
        if(2)
            target = input(caster, "Who will you project your voice to?") as null|mob in (GLOB.player_list - caster)
            if(target)
                var/input_message = input(caster, "What message will you project to them?") as null|text
                if (input_message)
                    //sanitisation!
                    input_message = trim(copytext_char(sanitize(input_message), 1, MAX_MESSAGE_LEN))
                    if(CHAT_FILTER_CHECK(input_message))
                        to_chat(caster, "<span class='warning'>That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[input_message]\"</span></span>")
                        SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
                        return

                    var/language = caster.get_selected_language()
                    var/message = caster.compose_message(caster, language, input_message, , list())
                    to_chat(target, "<span class='purple'><i>You hear someone's voice in your head...</i></span>")
                    target.Hear(message, target, language, input_message, , , )
                    to_chat(caster, "<span class='notice'>You project your voice to [target]'s ears.</span>")
        if(3)
            for(var/mob/living/carbon/human/HU in oviewers(7, caster))
                if(HU)
                    HU.caster = caster
                    HU.create_walk_to(2 SECONDS)
                    HU.remove_overlay(MUTATIONS_LAYER)
                    var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
                    HU.overlays_standing[MUTATIONS_LAYER] = song_overlay
                    HU.apply_overlay(MUTATIONS_LAYER)
                    spawn(2 SECONDS)
                        if(HU)
                            HU.remove_overlay(MUTATIONS_LAYER)
        if(4)
            playsound(caster.loc, 'code/modules/wod13/sounds/killscream.ogg', 100, FALSE)
            for(var/mob/living/carbon/human/HU in oviewers(7, caster))
                if(HU)
                    HU.Stun(2 SECONDS)
                    HU.remove_overlay(MUTATIONS_LAYER)
                    var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
                    HU.overlays_standing[MUTATIONS_LAYER] = song_overlay
                    HU.apply_overlay(MUTATIONS_LAYER)
                    spawn(2 SECONDS)
                        if(HU)
                            HU.remove_overlay(MUTATIONS_LAYER)
        if(5)
            playsound(caster.loc, 'code/modules/wod13/sounds/killscream.ogg', 100, FALSE)
            for(var/mob/living/carbon/human/HU in oviewers(7, caster))
                if(HU)
                    HU.Stun(20)
                    HU.apply_damage(50, BRUTE, BODY_ZONE_HEAD)
                    HU.remove_overlay(MUTATIONS_LAYER)
                    var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
                    HU.overlays_standing[MUTATIONS_LAYER] = song_overlay
                    HU.apply_overlay(MUTATIONS_LAYER)
                    spawn(20)
                        if(HU)
                            HU.remove_overlay(MUTATIONS_LAYER)
