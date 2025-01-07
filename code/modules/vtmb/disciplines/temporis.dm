/datum/discipline/temporis
    name = "Temporis"
    desc = "Temporis is a Discipline unique to the True Brujah. Supposedly a refinement of Celerity, Temporis grants the Cainite the ability to manipulate the flow of time itself."
    icon_state = "temporis"
    cost = 1
    ranged = TRUE
    delay = 50
    violates_masquerade = FALSE
    activate_sound = 'code/modules/wod13/sounds/temporis.ogg'
    clane_restricted = TRUE
    dead_restricted = FALSE
    var/current_cycle = 0
    var/datum/component/temporis_target
    var/attack_speed_modifier = 0.25

/datum/discipline/temporis/post_gain(mob/living/carbon/human/H)
	if(level >= 1)
		var/datum/action/clock/clocke = new()
		clocke.Grant(H)
	if(level >= 4)
		var/datum/action/temporis_step/tstep = new()
		tstep.Grant(H)
	if(level >= 5)
		var/datum/action/clotho/clot = new()
		clot.Grant(H)

/obj/effect/temporis
    name = "Za Warudo"
    desc = "..."
    anchored = 1

/obj/effect/temporis/Initialize()
    . = ..()
    spawn(5)
        qdel(src)


/mob/living/carbon/human/Move(atom/newloc, direct, glide_size_override)
    ..()
    if(temporis_visual)
        var/obj/effect/temporis/T = new(loc)
        T.name = name
        T.appearance = appearance
        T.dir = dir
        animate(T, pixel_x = rand(-32,32), pixel_y = rand(-32,32), alpha = 255, time = 10)
        if(CheckEyewitness(src, src, 7, FALSE))
            AdjustMasquerade(-1)
    else if(temporis_blur)
        var/obj/effect/temporis/T = new(loc)
        T.name = name
        T.appearance = appearance
        T.dir = dir
        animate(T, pixel_x = rand(-32,32), pixel_y = rand(-32,32), alpha = 155, time = 5)
        if(CheckEyewitness(src, src, 7, FALSE))
            AdjustMasquerade(-1)

/datum/discipline/temporis/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    if (caster.celerity_visual) //no using two time powers at once
        to_chat(caster, "<span class='userdanger'>You try to manipulate your temporal field, but Celerity causes it to slip out of your grasp!</span>")
        caster.emote("scream")
        spawn(3 SECONDS)
            caster.gib()
        return
    switch(level_casting)
        if(1)
            to_chat(caster, "<b>[SScity_time.timeofnight]</b>")
            caster.bloodpool = caster.bloodpool+1
        if(2)
            target.AddComponent(/datum/component/dejavu, rewinds = 4, interval = 2 SECONDS)
        if(3)
            to_chat(target, "<span class='userdanger'><b>Slow down.</b></span>")
            target.add_movespeed_modifier(/datum/movespeed_modifier/temporis)
            spawn(10 SECONDS)
                if(target)
                    target.remove_movespeed_modifier(/datum/movespeed_modifier/temporis)
        if(4)
            to_chat(caster, "<b>Use the second Temporis button at the bottom of the screen to cast this level of Temporis.</b>")
            caster.bloodpool = caster.bloodpool+1
        if(5)
            to_chat(caster, "<b>Use the third Temporis button at the bottom of the screen to cast this level of Temporis.</b>")
            caster.bloodpool = caster.bloodpool+1
