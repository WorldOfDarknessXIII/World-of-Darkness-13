/datum/discipline/daimonion
	name = "Daimonion"
	desc = "Get a help from the Hell creatures, resist THE FIRE, transform into an imp. Violates Masquerade."
	icon_state = "daimonion"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/daimonion

/datum/discipline_power/daimonion
	name = "Daimonion power name"
	desc = "Daimonion power description"

	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/protean_deactivate.ogg'

//SENSE THE SIN
/datum/discipline_power/daimonion/sense_the_sin
	name = "Sense the Sin"
	desc = "Become supernaturally resistant to fire."

	level = 1

	cancelable = TRUE
	duration_length = 20 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/daimonion/sense_the_sin/activate()
	. = ..()
	owner.physiology.burn_mod /= 100
	owner.color = "#884200"

/datum/discipline_power/daimonion/sense_the_sin/deactivate()
	. = ..()
	owner.color = initial(owner.color)
	owner.physiology.burn_mod *= 100

//FEAR OF THE VOID BELOW
/datum/discipline_power/daimonion/fear_of_the_void_below
	name = "Fear of the Void Below"
	desc = "Sprout wings and become able to fly."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 20 SECONDS

/datum/discipline_power/daimonion/fear_of_the_void_below/activate()
	. = ..()
	owner.dna.species.GiveSpeciesFlight(owner)

/datum/discipline_power/daimonion/fear_of_the_void_below/deactivate()
	. = ..()
	owner.dna.species.RemoveSpeciesFlight(owner)

//CONFLAGRATION
/datum/discipline_power/daimonion/conflagration
	name = "Conflagration"
	desc = "Turn your hands into deadly claws."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/daimonion/conflagration/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))
	owner.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))

/datum/discipline_power/daimonion/conflagration/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/knife/gangrel/claws in owner)
		qdel(claws)

/datum/discipline_power/daimonion/conflagration/post_gain()
	. = ..()
	var/obj/effect/proc_holder/spell/aimed/fireball/baali/balefire = new(owner)
	owner.mind.AddSpell(balefire)

/obj/effect/proc_holder/spell/aimed/fireball/baali
	name = "Infernal Fireball"
	desc = "This spell fires an explosive fireball at a target."
	school = "evocation"
	charge_max = 60
	clothes_req = FALSE
	invocation = "FR BRTH"
	invocation_type = INVOCATION_WHISPER
	range = 20
	cooldown_min = 20 //10 deciseconds reduction per rank
	projectile_type = /obj/projectile/magic/aoe/fireball/baali
	base_icon_state = "infernaball"
	action_icon_state = "infernaball0"
	sound = 'sound/magic/fireball.ogg'
	active_msg = "You prepare to cast your fireball spell!"
	deactive_msg = "You extinguish your fireball... for now."
	active = FALSE

//PSYCHOMACHIA
/datum/discipline_power/daimonion/psychomachia
	name = "Psychomachia"
	desc = "Become a bat."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	violates_masquerade = TRUE

	duration_length = 30 SECONDS
	cooldown_length = 10 SECONDS
	grouped_powers = list(/datum/discipline_power/daimonion/condemnation)

	var/obj/effect/proc_holder/spell/targeted/shapeshift/bat/bat_shapeshift

/datum/discipline_power/daimonion/psychomachia/activate()
	. = ..()
	if(!bat_shapeshift)
		bat_shapeshift = new(owner)

	owner.drop_all_held_items()
	bat_shapeshift.Shapeshift(owner)

/datum/discipline_power/daimonion/psychomachia/deactivate()
	. = ..()
	bat_shapeshift.Restore(bat_shapeshift.myshape)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(30)

//CONDEMNTATION
/datum/discipline_power/daimonion/condemnation
	name = "Condemnation"
	desc = "Become a bat."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	violates_masquerade = TRUE

	duration_length = 30 SECONDS
	cooldown_length = 10 SECONDS
	grouped_powers = list(/datum/discipline_power/daimonion/psychomachia)

	var/obj/effect/proc_holder/spell/targeted/shapeshift/bat/bat_shapeshift

/datum/discipline_power/daimonion/condemnation/activate()
	. = ..()
	if(!bat_shapeshift)
		bat_shapeshift = new(owner)

	owner.drop_all_held_items()
	bat_shapeshift.Shapeshift(owner)

/datum/discipline_power/daimonion/condemnation/deactivate()
	. = ..()
	bat_shapeshift.Restore(bat_shapeshift.myshape)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(30)

/datum/discipline_power/daimonion/condemnation/post_gain()
	. = ..()
	var/datum/action/antifrenzy/antifrenzy_contract = new()
	antifrenzy_contract.Grant(owner)

/datum/action/antifrenzy
	name = "Resist Beast"
	desc = "Resist Frenzy and Rotshreck by signing a contract with Demons."
	button_icon_state = "resist"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/used = FALSE

/datum/action/antifrenzy/Trigger()
	var/mob/living/carbon/human/user = owner
	if(user.stat >= UNCONSCIOUS || user.IsSleeping() || user.IsUnconscious() || user.IsParalyzed() || user.IsKnockdown() || user.IsStun() || HAS_TRAIT(user, TRAIT_RESTRAINED) || !isturf(user.loc))
		return
	if(used)
		to_chat(owner, span_warning("You've already signed this contract!"))
		return
	used = TRUE
	user.antifrenzy = TRUE
	SEND_SOUND(owner, sound('sound/magic/curse.ogg', 0, 0, 50))
	to_chat(owner, span_warning("You feel control over your Beast, but at what cost..."))
	qdel(src)
