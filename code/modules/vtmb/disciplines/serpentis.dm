/datum/discipline/serpentis
    name = "Serpentis"
    desc = "Act like a cobra, get the powers to stun targets with your gaze and your tongue, praise the mummy traditions and spread them to your childe. Violates Masquerade."
    icon_state = "serpentis"
    cost = 1
    ranged = TRUE
    delay = 5
//    range_sh = 2
    violates_masquerade = TRUE
    clane_restricted = TRUE
    dead_restricted = FALSE

/datum/discipline/serpentis/post_gain(mob/living/carbon/human/H)
	if(level >= 3)
		var/datum/action/mummyfy/mummy = new()
		mummy.Grant(H)
	if(level >= 4)
		var/datum/action/urn/U = new()
		U.Grant(H)
	if(level >= 5)
		var/datum/action/cobra/C = new()
		C.Grant(H)

/datum/discipline/serpentis/activate(mob/living/target, mob/living/carbon/human/caster)
    . = ..()
    if(level_casting == 1)
        var/antidir = NORTH
        switch(caster.dir)
            if(NORTH)
                antidir = SOUTH
            if(SOUTH)
                antidir = NORTH
            if(WEST)
                antidir = EAST
            if(EAST)
                antidir = WEST
        if(target.dir == antidir)
            target.Immobilize(10)
            target.visible_message("<span class='warning'><b>[caster] hypnotizes [target] with his eyes!</b></span>", "<span class='warning'><b>[caster] hypnotizes you like a cobra!</b></span>")
            caster.playsound_local(target.loc, 'code/modules/wod13/sounds/serpentis.ogg', 50, TRUE)
            if(ishuman(target))
                var/mob/living/carbon/human/H = target
                H.remove_overlay(MUTATIONS_LAYER)
                var/mutable_appearance/serpentis_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "serpentis", -MUTATIONS_LAYER)
                H.overlays_standing[MUTATIONS_LAYER] = serpentis_overlay
                H.apply_overlay(MUTATIONS_LAYER)
                spawn(5)
                    H.remove_overlay(MUTATIONS_LAYER)
    if(level_casting >= 2)
//        var/turf/start = get_turf(caster)
//        var/obj/projectile/tentacle/H = new(start)
//        H.hitsound = 'code/modules/wod13/sounds/tongue.ogg'
        var/bloodpoints_to_suck = max(0, min(target.bloodpool, level_casting-1))
        if(bloodpoints_to_suck)
            caster.bloodpool = min(caster.maxbloodpool, caster.bloodpool+bloodpoints_to_suck)
            target.bloodpool = max(0, target.bloodpool-bloodpoints_to_suck)
        var/obj/item/ammo_casing/magic/tentacle/casing = new (caster.loc)
        playsound(caster.loc, 'code/modules/wod13/sounds/tongue.ogg', 100, TRUE)
        casing.fire_casing(target, caster, null, null, null, ran_zone(), 0,  caster)
        caster.playsound_local(target.loc, 'code/modules/wod13/sounds/serpentis.ogg', 50, TRUE)
        qdel(casing)
