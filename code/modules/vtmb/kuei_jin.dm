/mob/living/carbon/human/proc/check_kuei_jin_alive()
	if(iscathayan(src))
		if(mind?.dharma)
			if(mind.dharma.animated == "Yang")
				if(yin_chi < yang_chi+2)
					return TRUE
				else
					return FALSE
			else
				if(yang_chi > yin_chi+2)
					return TRUE
				else
					return FALSE
		else
			return FALSE
	return TRUE

/mob/living/Life()
	. = ..()

	if(!iscathayan(src))
		if((yang_chi == 0 && max_yang_chi != 0) && (yang_chi == 0 && max_yang_chi != 0))
			to_chat(src, "<span clas='warning'>Your vital energies seem to disappear...</span>")
			adjustCloneLoss(5, TRUE)
		else if(yang_chi == 0 && max_yang_chi != 0)
			if(max_yin_chi != 0)
				to_chat(src, "<span clas='warning'>You lack dynamic part of life...</span>")
				adjust_bodytemperature(-15)
				adjustFireLoss(5, TRUE)
			else
				to_chat(src, "<span clas='warning'>Your vital energies seem to disappear...</span>")
				adjustCloneLoss(5, TRUE)
		else if(yin_chi == 0 && max_yin_chi != 0)
			if(max_yang_chi != 0)
				to_chat(src, "<span clas='warning'>You lack static part of life...</span>")
				adjust_bodytemperature(15)
				adjustFireLoss(5, TRUE)
			else
				to_chat(src, "<span clas='warning'>Your vital energies seem to disappear...</span>")
				adjustCloneLoss(5, TRUE)

	if(!iscathayan(src))
		if (COOLDOWN_FINISHED(src, chi_restore))
			COOLDOWN_START(src, chi_restore, 30 SECONDS)
			if(yang_chi < max_yang_chi)
				yang_chi = min(yang_chi+1, max_yang_chi)
			else if(yin_chi < max_yin_chi)
				yin_chi = min(yin_chi+1, max_yin_chi)

/datum/species/kuei_jin
	name = "Kuei-Jin"
	id = "kuei-jin"
	default_color = "FFFFFF"
	mutant_bodyparts = list("wings" = "None")
	disliked_food = GROSS | RAW
	liked_food = JUNKFOOD | FRIED
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_VIRUSIMMUNE, TRAIT_PERFECT_ATTACKER, TRAIT_NOBREATH)
	use_skintones = TRUE
	limbs_id = "human"
	wings_icon = "None"
	mutant_bodyparts = list("tail_human" = "None", "ears" = "None", "wings" = "None")
	brutemod = 1
	heatmod = 1
	burnmod = 1
	dust_anim = "dust-k"
	whitelisted = TRUE
	selectable = TRUE
	var/turf/fool_turf
	var/fool_fails = 0

/atom/breathing_overlay
	icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	icon_state = "drain"
	alpha = 64
	density = FALSE

/mob/living/proc/update_chi_hud()
	if(!client || !hud_used)
		return
	if(iscathayan(src))
		hud_used.yin_chi_icon.icon_state = "yin-[round((yin_chi/max_yin_chi)*12)]"
		hud_used.yang_chi_icon.icon_state = "yang-[round((yang_chi/max_yang_chi)*12)]"
		hud_used.demon_chi_icon.icon_state = "demon-[round((demon_chi/max_demon_chi)*12)]"
		if(yin_chi > yang_chi+2)
			hud_used.imbalance_chi_icon.icon_state = "yin_imbalance"
		else if(yang_chi > yin_chi+2)
			hud_used.imbalance_chi_icon.icon_state = "yang_imbalance"
		else
			hud_used.imbalance_chi_icon.icon_state = "base"

/atom/movable/screen/chi_pool
	name = "Chi Pool"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "base"
	layer = HUD_LAYER
	plane = HUD_PLANE
	var/image/upper_layer

/atom/movable/screen/yang_chi
	name = "Yang Chi"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "yang-0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/yin_chi
	name = "Yin Chi"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "yin-0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/imbalance_chi
	name = "Chi Imbalance"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "base"
	layer = HUD_LAYER-1
	plane = HUD_PLANE

/atom/movable/screen/demon_chi
	name = "Demon Chi"
	icon = 'code/modules/wod13/UI/chi.dmi'
	icon_state = "base"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/chi_pool/Initialize()
	. = ..()
	upper_layer = image(icon = 'code/modules/wod13/UI/chi.dmi', icon_state = "add", layer = HUD_LAYER+1)
	add_overlay(upper_layer)

/atom/movable/screen/chi_pool/Click()
	var/mob/living/C = usr
	to_chat(usr, "Yin Chi: [C.yin_chi]/[C.max_yin_chi], Yang Chi: [C.yang_chi]/[C.max_yang_chi], Demon Chi: [C.demon_chi]/[C.max_demon_chi]")

/datum/species/kuei_jin/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	C.update_body(0)
	C.last_experience = world.time + 5 MINUTES
	var/datum/action/aboutme/infor = new()
	infor.host = C
	infor.Grant(C)
	var/datum/action/reanimate_yang/YG = new()
	YG.Grant(C)
	var/datum/action/reanimate_yin/YN = new()
	YN.Grant(C)
	var/datum/action/rebalance/R = new()
	R.Grant(C)

/datum/species/kuei_jin/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	for(var/datum/action/aboutme/VI in C.actions)
		if(VI)
			VI.Remove(C)
	for(var/datum/action/breathe_chi/QI in C.actions)
		if(QI)
			QI.Remove(C)
	for(var/datum/action/area_chi/AI in C.actions)
		if(AI)
			AI.Remove(C)
	for(var/datum/action/reanimate_yang/YG in C.actions)
		if(YG)
			YG.Remove(C)
	for(var/datum/action/reanimate_yin/YN in C.actions)
		if(YN)
			YN.Remove(C)
	for(var/datum/action/rebalance/R in C.actions)
		if(R)
			R.Remove(C)
	for(var/datum/action/chi_discipline/A in C.actions)
		if(A)
			A.Remove(C)

/datum/action/breathe_chi
	name = "Inhale Chi"
	desc = "Get chi from a target by inhaling their breathe."
	button_icon_state = "breathe"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/cooldown = 10 SECONDS
	COOLDOWN_DECLARE(use)

/datum/action/breathe_chi/Trigger()
	if(!COOLDOWN_FINISHED(src, use))
		to_chat(usr, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, use))] to Inhale Chi again!</span>")
		return
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	COOLDOWN_START(src, use, cooldown)

	var/list/mob/living/victims_list = list()
	for (var/mob/living/adding_victim in oviewers(3, kueijin))
		victims_list += adding_victim
	if(!length(victims_list))
		to_chat(owner, "<span class='warning'>There's no one with <b>Chi</b> around...</span>")
		return

	var/mob/living/victim
	if (length(victims_list) == 1)
		victim = victims_list[1]
	else
		victim = input(owner, "Choose whose breath to inhale", "Inhale Chi") as null|anything in victims_list
	if(!victim)
		return

	drain_breath(kueijin, victim)

	button.color = "#970000"
	animate(button, color = "#ffffff", time = cooldown)

/datum/action/breathe_chi/proc/drain_breath(mob/living/carbon/human/kueijin, mob/living/victim)
	//this one is on carbon instead of living which means it needs some annoying extra code
	var/has_gnosis = FALSE
	if (iscarbon(victim))
		var/mob/living/carbon/werewolf_victim = victim
		if (werewolf_victim.auspice?.gnosis > 0)
			has_gnosis = TRUE

	//this method of feeding targets splat-specific Quintessence sources first
	if ((iskindred(victim) || isghoul(victim)) && (victim.bloodpool > 0)) //drain vitae bloodpool
		victim.bloodpool = max(0, victim.bloodpool - 1)
		kueijin.yin_chi = min(kueijin.yin_chi + 1, kueijin.max_yin_chi)
		to_chat(kueijin, "<span class='engradio'>Some bitter <b>Yin</b> Chi enters you...</span>")
	else if ((isgarou(victim) || iswerewolf(victim)) && has_gnosis) //drain gnosis
		adjust_gnosis(-1, victim, sound = TRUE)
		kueijin.yang_chi = min(kueijin.yang_chi + 1, kueijin.max_yang_chi)
		to_chat(kueijin, "<span class='engradio'>Some fiery <b>Yang</b> Chi enters you...</span>")
	else if ((victim.yin_chi > 0) || (victim.yang_chi > 0)) //normally drain chi from humans and simplemobs and kuei-jin
		if ((prob(50) || victim.yang_chi == 0) && (victim.yin_chi > 0))
			victim.yin_chi = max(0, victim.yin_chi - 1)
			kueijin.yin_chi = min(kueijin.yin_chi + 1, kueijin.max_yin_chi)
			to_chat(kueijin, "<span class='engradio'>Some <b>Yin</b> Chi enters you...</span>")
		else if ((victim.yang_chi > 0))
			victim.yang_chi = max(0, victim.yang_chi - 1)
			kueijin.yang_chi = min(kueijin.yang_chi + 1, kueijin.max_yang_chi)
			to_chat(kueijin, "<span class='engradio'>Some <b>Yang</b> Chi enters you...</span>")
	else
		return

	//it would be nice for this to be invisible at a SEE_INVISIBLE_QUINTESSENCE or SEE_INVISIBLE_SPIRITUAL level, but that can come later...
	var/atom/movable/chi_particle = new (get_turf(victim))
	chi_particle.density = FALSE
	chi_particle.anchored = TRUE
	chi_particle.icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	chi_particle.icon_state = "drain"
	var/matrix/face_kueijin = matrix()
	face_kueijin.Turn(get_angle_raw(victim.x, victim.y, 0, 0, owner.x, owner.y, 0, 0))
	chi_particle.transform = face_kueijin

	kueijin.update_chi_hud()

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), chi_particle), 3 SECONDS)

/datum/action/area_chi
	name = "Area Chi"
	desc = "Get chi from an area by injecting the tides."
	button_icon_state = "area"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/cooldown = 30 SECONDS
	COOLDOWN_DECLARE(use)

/datum/action/area_chi/Trigger()
	if(!COOLDOWN_FINISHED(src, use))
		to_chat(usr, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, use))] to gather Chi again!</span>")
		return
	if(!istype(owner, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/kueijin = usr

	to_chat(usr, "<span class='notify'>You begin to gather <b>Chi</b> from your environment...</span>")
	if (do_after(kueijin, 15 SECONDS))
		COOLDOWN_START(src, use, cooldown)
		var/area/draining_area = get_area(kueijin)
		if(draining_area.yang_chi)
			kueijin.yang_chi = min(kueijin.yang_chi + draining_area.yang_chi, kueijin.max_yang_chi)
			to_chat(kueijin, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
		if(draining_area.yin_chi)
			kueijin.yin_chi = min(kueijin.yin_chi + draining_area.yin_chi, kueijin.max_yin_chi)
			to_chat(kueijin, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")

		button.color = "#970000"
		animate(button, color = "#ffffff", time = cooldown)

/datum/action/reanimate_yin
	name = "Yin Reanimate"
	desc = "Reanimate your body with Yin Chi energy."
	button_icon_state = "yin"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/cooldown = 3 SECONDS

/datum/action/reanimate_yin/Trigger()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	if(HAS_TRAIT(owner, TRAIT_TORPOR))
		return
	if (!kueijin.yin_chi > 0)
		return
	if (!kueijin.mind?.dharma)
		return
	if (!COOLDOWN_FINISHED(kueijin.mind.dharma, chi_heal))
		to_chat(kueijin, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(kueijin.mind.dharma, chi_heal))] before you can heal again!</span>")
		return
	COOLDOWN_START(kueijin.mind.dharma, chi_heal, cooldown)

	SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
	kueijin.visible_message("<span class='warning'>Some of [kueijin]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
	kueijin.mind.dharma?.animated = "Yin"
	kueijin.skin_tone = get_vamp_skin_color(kueijin.skin_tone)
	kueijin.update_body()

	for (var/i in 1 to 5)
		if(length(kueijin.all_wounds))
			var/datum/wound/wound = pick(kueijin.all_wounds)
			wound.remove_wound()

	var/obj/item/organ/eyes/eyes = kueijin.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		kueijin.adjust_blindness(-2)
		kueijin.adjust_blurriness(-2)
		eyes.applyOrganDamage(-5)

	var/obj/item/organ/brain/brain = kueijin.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.applyOrganDamage(-100)

	kueijin.heal_ordered_damage(20, list(OXY, STAMINA, BRUTE, TOX))
	kueijin.heal_ordered_damage(10, list(BURN, CLONE))
	kueijin.blood_volume = min(kueijin.blood_volume + 56, 560)
	kueijin.yin_chi = max(0, kueijin.yin_chi - 1)

	button.color = "#970000"
	animate(button, color = "#ffffff", time = cooldown)

/datum/action/reanimate_yang
	name = "Yang Reanimate"
	desc = "Reanimate your body with Yang Chi energy."
	button_icon_state = "yang"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/cooldown = 3 SECONDS

/datum/action/reanimate_yang/Trigger()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	if(HAS_TRAIT(owner, TRAIT_TORPOR))
		return
	if (!kueijin.yin_chi > 0)
		return
	if (!kueijin.mind?.dharma)
		return
	if (!COOLDOWN_FINISHED(kueijin.mind.dharma, chi_heal))
		to_chat(kueijin, "<span class='warning'>You need to wait [DisplayTimeText(COOLDOWN_TIMELEFT(kueijin.mind.dharma, chi_heal))] before you can heal again!</span>")
		return
	COOLDOWN_START(kueijin.mind.dharma, chi_heal, cooldown)

	SEND_SOUND(usr, sound('code/modules/wod13/sounds/chi_use.ogg', 0, 0, 75))
	kueijin.visible_message("<span class='warning'>Some of [kueijin]'s visible injuries disappear!</span>", "<span class='warning'>Some of your injuries disappear!</span>")
	kueijin.mind.dharma?.animated = "Yang"
	kueijin.skin_tone = kueijin.mind.dharma?.initial_skin_color
	kueijin.update_body()

	for (var/i in 1 to 5)
		if(length(kueijin.all_wounds))
			var/datum/wound/wound = pick(kueijin.all_wounds)
			wound.remove_wound()

	var/obj/item/organ/eyes/eyes = kueijin.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		kueijin.adjust_blindness(-2)
		kueijin.adjust_blurriness(-2)
		eyes.applyOrganDamage(-5)

	var/obj/item/organ/brain/brain = kueijin.getorganslot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.applyOrganDamage(-100)

	kueijin.heal_ordered_damage(20, list(OXY, STAMINA, BRUTE, TOX))
	kueijin.heal_ordered_damage(10, list(BURN, CLONE))
	kueijin.blood_volume = min(kueijin.blood_volume + 28, 560)
	kueijin.yang_chi = max(0, kueijin.yang_chi - 1)

	button.color = "#970000"
	animate(button, color = "#ffffff", time = cooldown)

/datum/action/rebalance
	name = "Rebalance"
	desc = "Rebalance Dharma virtues."
	button_icon_state = "assign"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/rebalance/Trigger()
	if(!istype(owner, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/kueijin = usr
	if(!kueijin.mind?.dharma)
		return

	var/max_limit = max(10, kueijin.mind.dharma.level * 2)
	var/max_yin = input(kueijin, "Enter the maximum of Yin your character has (from 1 to [max_limit - 1]):", "Yin/Yang") as num|null
	if(max_yin)
		max_yin = clamp(max_yin, 1, max_limit - 1)
		kueijin.max_yin_chi = max_yin
		kueijin.max_yang_chi = max_limit - max_yin
		kueijin.yin_chi = min(kueijin.yin_chi, kueijin.max_yin_chi)
		kueijin.yang_chi = min(kueijin.yang_chi, kueijin.max_yang_chi)
	var/max_hun = input(kueijin, "Enter the maximum of Hun your character has (from 1 to [max_limit-1]):", "Hun/P'o") as num|null
	if(max_hun)
		max_hun = clamp(max_hun, 1, max_limit - 1)
		kueijin.mind.dharma.Hun = max_hun
		kueijin.max_demon_chi = max_limit - max_hun
		kueijin.demon_chi = min(kueijin.demon_chi, kueijin.max_demon_chi)
		var/datum/preferences/P = GLOB.preferences_datums[ckey(kueijin.key)]
		if(P)
			if(P.hun != kueijin.mind.dharma.Hun)
				P.hun = kueijin.mind.dharma.Hun
				P.save_preferences()
				P.save_character()
			if(P.po != kueijin.max_demon_chi)
				P.po = kueijin.max_demon_chi
				P.save_preferences()
				P.save_character()
			if(P.yin != kueijin.max_yin_chi)
				P.yin = kueijin.max_yin_chi
				P.save_preferences()
				P.save_character()
			if(P.yang != kueijin.max_yang_chi)
				P.yang = kueijin.max_yang_chi
				P.save_preferences()
				P.save_character()
