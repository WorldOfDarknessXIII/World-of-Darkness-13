/datum/discipline/daimonion
    name = "Daimonion"
    desc = "Get a help from the Hell creatures, resist THE FIRE, transform into an imp. Violates Masquerade."
    icon_state = "daimonion"
    cost = 1
    ranged = FALSE
    delay = 150
    violates_masquerade = TRUE
    activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
    clane_restricted = TRUE
    var/obj/effect/proc_holder/spell/targeted/shapeshift/bat/BAT
/datum/discipline/daimonion/post_gain(mob/living/carbon/human/H)
	if(level >= 3)
		var/obj/effect/proc_holder/spell/aimed/fireball/baali/S = new(H)
		H.mind.AddSpell(S)
	if(level >= 5)
		var/datum/action/antifrenzy/A = new()
		A.Grant(H)

/datum/action/antifrenzy
	name = "Resist Beast"
	desc = "Resist Frenzy and Rotshreck by signing a contract with Demons."
	button_icon_state = "resist"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/used = FALSE

/datum/action/antifrenzy/Trigger()
	var/mob/living/carbon/human/NG = owner
	if(NG.stat > 1 || NG.IsSleeping() || NG.IsUnconscious() || NG.IsParalyzed() || NG.IsKnockdown() || NG.IsStun() || HAS_TRAIT(NG, TRAIT_RESTRAINED) || !isturf(NG.loc))
		return
	if(used)
		to_chat(owner, "<span class='warning'>You've already signed this contract!</span>")
		return
	used = TRUE
	var/mob/living/carbon/human/H = owner
	H.antifrenzy = TRUE
	SEND_SOUND(owner, sound('sound/magic/curse.ogg', 0, 0, 50))
	to_chat(owner, "<span class='warning'>You feel control over your Beast, but at what cost...</span>")

/datum/discipline/daimonion/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    var/mod = min(4, level_casting)
//    var/mutable_appearance/protean_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "protean[mod]", -PROTEAN_LAYER)
    if(!BAT)
        BAT = new(caster)
    switch(mod)
        if(1)
            caster.physiology.burn_mod *= 1/100
            caster.color = "#884200"
            spawn(delay+caster.discipline_time_plus)
                if(caster)
                    caster.color = initial(caster.color)
                    caster.physiology.burn_mod *= 100
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
        if(2)
            caster.dna.species.GiveSpeciesFlight(caster)
            spawn(delay+caster.discipline_time_plus)
                if(caster)
                    caster.dna.species.RemoveSpeciesFlight(caster)
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
        if(3)
            caster.drop_all_held_items()
            caster.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
            caster.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(caster))
            spawn(delay+caster.discipline_time_plus)
                if(caster)
                    for(var/obj/item/melee/vampirearms/knife/gangrel/G in caster)
                        if(G)
                            qdel(G)
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
        if(4 to 5)
            caster.drop_all_held_items()
            BAT.Shapeshift(caster)
            spawn(delay+caster.discipline_time_plus)
                if(caster && caster.stat != DEAD)
                    BAT.Restore(BAT.myshape)
                    caster.Stun(15)
                    caster.do_jitter_animation(30)
                    caster.playsound_local(caster.loc, 'code/modules/wod13/sounds/protean_deactivate.ogg', 50, FALSE)
