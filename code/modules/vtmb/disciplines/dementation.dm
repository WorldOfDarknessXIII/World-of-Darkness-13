/datum/discipline/dementation
    name = "Dementation"
    desc = "Makes all humans in radius mentally ill for a moment, supressing their defending ability."
    icon_state = "dementation"
    cost = 2
    ranged = TRUE
    delay = 10 SECONDS
    activate_sound = 'code/modules/wod13/sounds/insanity.ogg'
    clane_restricted = TRUE

/datum/discipline/dementation/post_gain(mob/living/carbon/human/H)
	..()
	H.add_quirk(/datum/quirk/insanity)

/proc/dancefirst(mob/living/M)
    if(M.dancing)
        return
    M.dancing = TRUE
    var/matrix/initial_matrix = matrix(M.transform)
    for (var/i in 1 to 75)
        if (!M)
            return
        switch(i)
            if (1 to 15)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(0,1)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (16 to 30)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(1,-1)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (31 to 45)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(-1,-1)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (46 to 60)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(-1,1)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (61 to 75)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(1,0)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
        M.setDir(turn(M.dir, 90))
        switch (M.dir)
            if (NORTH)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(0,3)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (SOUTH)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(0,-3)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (EAST)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(3,0)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (WEST)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(-3,0)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
        sleep(0.1 SECONDS)
    M.lying_fix()
    M.dancing = FALSE

/proc/dancesecond(mob/living/M)
    if(M.dancing)
        return
    M.dancing = TRUE
    animate(M, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
    var/matrix/initial_matrix = matrix(M.transform)
    for (var/i in 1 to 60)
        if (!M)
            return
        if (i<31)
            initial_matrix = matrix(M.transform)
            initial_matrix.Translate(0,1)
            animate(M, transform = initial_matrix, time = 1, loop = 0)
        if (i>30)
            initial_matrix = matrix(M.transform)
            initial_matrix.Translate(0,-1)
            animate(M, transform = initial_matrix, time = 1, loop = 0)
        M.setDir(turn(M.dir, 90))
        switch (M.dir)
            if (NORTH)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(0,3)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (SOUTH)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(0,-3)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (EAST)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(3,0)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
            if (WEST)
                initial_matrix = matrix(M.transform)
                initial_matrix.Translate(-3,0)
                animate(M, transform = initial_matrix, time = 1, loop = 0)
        sleep(0.1 SECONDS)
    M.lying_fix()
    M.dancing = FALSE

/datum/discipline/dementation/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    //1 - instant laugh
    //2 - hallucinations and less damage
    //3 - victim dances
    //4 - victim fake dies
    //5 - victim starts to attack themself
    if(target.spell_immunity)
        return
    var/mypower = caster.get_total_social()
    var/theirpower = target.get_total_mentality()
    if(theirpower >= mypower)
        to_chat(caster, "<span class='warning'>[target]'s mind is too powerful to corrupt!</span>")
        return
    if(!ishuman(target))
        to_chat(caster, "<span class='warning'>[target] doesn't have enough mind to get affected by this discipline!</span>")
        return
    var/mob/living/carbon/human/H = target
    H.remove_overlay(MUTATIONS_LAYER)
    var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
    dementation_overlay.pixel_z = 1
    H.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
    H.apply_overlay(MUTATIONS_LAYER)
    switch(level_casting)
        if(1)
            H.Stun(5)
            H.emote("laugh")
            to_chat(target, "<span class='userdanger'><b>HAHAHAHAHAHAHAHAHAHAHAHA!!</b></span>")
            caster.playsound_local(get_turf(H), pick('sound/items/SitcomLaugh1.ogg', 'sound/items/SitcomLaugh2.ogg', 'sound/items/SitcomLaugh3.ogg'), 100, FALSE)
            if(target.body_position == STANDING_UP)
                target.toggle_resting()
        if(2)
//            H.Immobilize(10)
            H.hallucination += 50
            new /datum/hallucination/oh_yeah(H, TRUE)
        if(3)
            H.Immobilize(20)
            if(H.stat <= HARD_CRIT && !H.IsSleeping() && !H.IsUnconscious() && !H.IsParalyzed() && !H.IsKnockdown() && !HAS_TRAIT(H, TRAIT_RESTRAINED))
                if(prob(50))
                    dancefirst(H)
                else
                    dancesecond(H)
        if(4)
//            H.Immobilize(20)
            new /datum/hallucination/death(H, TRUE)
        if(5)
            var/datum/cb = CALLBACK(H,/mob/living/carbon/human/proc/attack_myself_command)
            for(var/i in 1 to 20)
                addtimer(cb, (i - 1)*15)
    spawn(delay+caster.discipline_time_plus)
        if(H)
            H.remove_overlay(MUTATIONS_LAYER)
