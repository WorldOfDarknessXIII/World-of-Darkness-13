/datum/action/gift
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	var/rage_req = 0
	var/gnosis_req = 0
	COOLDOWN_DECLARE(activate)

	var/allowed_to_proceed = FALSE

/datum/action/gift/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	button_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	. = ..()

/datum/action/gift/Trigger()
	. = ..()

	if (!iscarbon(owner))
		return

	var/mob/living/carbon/caster = owner
	if(caster.stat == DEAD)
		allowed_to_proceed = FALSE
		return

	var/datum/splat/werewolf/werewolf = is_wta(caster)
	if (!werewolf)
		return

	if (rage_req)
		if (!werewolf.remove_rage(rage_req))
			to_chat(owner, span_warning("You don't have enough <b>RAGE</b> to do that!"))
			SEND_SOUND(owner, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
			allowed_to_proceed = FALSE
			return

	if (gnosis_req)
		if(!werewolf.remove_gnosis(gnosis_req))
			to_chat(owner, span_warning("You don't have enough <b>GNOSIS</b> to do that!"))
			SEND_SOUND(owner, sound('code/modules/wod13/sounds/werewolf_cast_failed.ogg', 0, 0, 75))
			allowed_to_proceed = FALSE
			return

	if (!COOLDOWN_FINISHED(src, activate))
		allowed_to_proceed = FALSE
		return
	COOLDOWN_START(src, activate, 15 SECONDS)

	allowed_to_proceed = TRUE
	to_chat(owner, span_notice("You activate [name]."))

/datum/action/gift/falling_touch
	name = "Falling Touch"
	desc = "This Gift allows the Garou to send her foe sprawling with but a touch."
	button_icon_state = "falling_touch"
	rage_req = 1

/datum/action/gift/falling_touch/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/falling_touch.ogg', 75, FALSE)
		H.put_in_active_hand(new /obj/item/melee/touch_attack/werewolf(H))

/datum/action/gift/inspiration
	name = "Inspiration"
	desc = "The Garou with this Gift lends new resolve and righteous anger to his brethren."
	button_icon_state = "inspiration"
	rage_req = 1

/mob/living/carbon/Life()
	. = ..()
	if(inspired)
		if(stat != DEAD)
			adjustBruteLoss(-10, TRUE)
			var/obj/effect/celerity/C = new(get_turf(src))
			C.appearance = appearance
			C.dir = dir
			var/matrix/ntransform = matrix(C.transform)
			ntransform.Scale(2, 2)
			animate(C, transform = ntransform, alpha = 0, time = 3)

/mob/living/carbon/proc/inspired()
	inspired = TRUE
	to_chat(src, "<span class='notice'>You feel inspired...</span>")
	spawn(150)
		to_chat(src, "<span class='warning'>You no longer feel inspired...</span>")
		inspired = FALSE

/datum/action/gift/inspiration/Trigger()
	. = ..()
	if (!allowed_to_proceed)
		return

	var/mob/living/carbon/H = owner
	playsound(get_turf(owner), 'code/modules/wod13/sounds/inspiration.ogg', 75, FALSE)
	H.emote("scream")
	var/datum/splat/werewolf/garou/lycanthropy = is_garou(owner)

	for(var/mob/living/carbon/C in range(5, owner))
		var/datum/splat/werewolf/garou/target_lycanthropy = is_garou(C)
		if (!target_lycanthropy)
			continue

		if (target_lycanthropy.tribe != lycanthropy.tribe)
			continue

		C.inspired()

/datum/action/gift/razor_claws
	name = "Razor Claws"
	desc = "By raking his claws over stone, steel, or another hard surface, the Ahroun hones them to razor sharpness."
	button_icon_state = "razor_claws"
	rage_req = 1

/datum/action/gift/razor_claws/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/razor_claws.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.dna.species.attack_verb = "slash"
			H.dna.species.attack_sound = 'sound/weapons/slash.ogg'
			H.dna.species.miss_sound = 'sound/weapons/slashmiss.ogg'
			H.dna.species.punchdamagelow = 20
			H.dna.species.punchdamagehigh = 20
			H.agg_damage_plus = 5
			to_chat(owner, "<span class='notice'>You feel your claws sharpening...</span>")
			spawn(150)
				H.dna.species.attack_verb = initial(H.dna.species.attack_verb)
				H.dna.species.attack_sound = initial(H.dna.species.attack_sound)
				H.dna.species.miss_sound = initial(H.dna.species.miss_sound)
				H.dna.species.punchdamagelow = initial(H.dna.species.punchdamagelow)
				H.dna.species.punchdamagehigh = initial(H.dna.species.punchdamagehigh)
				H.agg_damage_plus = 0
				to_chat(owner, "<span class='warning'>Your claws are not sharp anymore...</span>")
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/razor_claws.ogg', 75, FALSE)
			var/mob/living/carbon/H = owner
			H.melee_damage_lower = H.melee_damage_lower+15
			H.melee_damage_upper = H.melee_damage_upper+15
			H.agg_damage_plus = 3
			to_chat(owner, "<span class='notice'>You feel your claws sharpening...</span>")
			spawn(150)
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				H.tox_damage_plus = 0
				to_chat(owner, "<span class='warning'>Your claws are not sharp anymore...</span>")

/datum/action/gift/beast_speech
	name = "Beast Speech"
	desc = "The werewolf with this Gift may communicate with any animals from fish to mammals."
	button_icon_state = "beast_speech"
	rage_req = 1
	//gnosis_req = 1

/datum/action/gift/beast_speech/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if(length(C.beastmaster) > 3)
			var/mob/living/simple_animal/hostile/beastmaster/B = pick(C.beastmaster)
			qdel(B)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/wolves.ogg', 75, FALSE)
		if(!length(C.beastmaster))
			var/datum/action/beastmaster_stay/E1 = new()
			E1.Grant(C)
			var/datum/action/beastmaster_deaggro/E2 = new()
			E2.Grant(C)
		var/mob/living/simple_animal/hostile/beastmaster/D = new(get_turf(C))
		D.my_creator = C
		C.beastmaster |= D
		D.beastmaster = C

/datum/action/gift/call_of_the_wyld
	name = "Call Of The Wyld"
	desc = "The werewolf may send her howl far beyond the normal range of hearing and imbue it with great emotion, stirring the hearts of fellow Garou and chilling the bones of all others."
	button_icon_state = "call_of_the_wyld"
	rage_req = 1

/datum/action/gift/call_of_the_wyld/Trigger()
	. = ..()
	if (!allowed_to_proceed)
		return

	var/mob/living/carbon/C = owner
	C.emote("howl")
	playsound(get_turf(C), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
	for (var/mob/living/carbon/A in orange(6, owner))
		var/datum/splat/werewolf/garou/lycanthropy = is_garou(A)
		if (!lycanthropy)
			continue

		A.emote("howl")
		playsound(get_turf(A), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
		lycanthropy.add_gnosis(1, TRUE)

/datum/action/gift/mindspeak
	name = "Mindspeak"
	desc = "By invoking the power of waking dreams, the Garou can place any chosen characters into silent communion."
	button_icon_state = "mindspeak"

/datum/action/gift/mindspeak/Trigger()
	. = ..()
	if (allowed_to_proceed)
		return

	var/new_thought = tgui_input_text(owner, "What do you want to tell to your Tribe?", "Mindspeak")
	if (!new_thought)
		return

	var/datum/splat/werewolf/garou/lycanthropy = is_garou(owner)
	to_chat(owner, "You transfer this message to your tribe members nearby: <b>[sanitize_text(new_thought)]</b>")
	for (var/mob/living/carbon/A in orange(9, owner))
		var/datum/splat/werewolf/garou/target_lycanthropy = is_garou(A)
		if (!target_lycanthropy)
			return

		if (target_lycanthropy.tribe != lycanthropy.tribe)
			return

		to_chat(A, "You hear a message in your head... <b>[sanitize_text(new_thought)]</b>")

/datum/action/gift/resist_pain
	name = "Resist Pain"
	desc = "Through force of will, the Philodox is able to ignore the pain of his wounds and continue acting normally."
	button_icon_state = "resist_pain"
	rage_req = 2

/datum/action/gift/resist_pain/Trigger()
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.physiology.armor.melee = 40
			H.physiology.armor.bullet = 25
			to_chat(owner, "<span class='notice'>You feel your skin thickering...</span>")
			spawn(15 SECONDS)
				H.physiology.armor.melee = initial(H.physiology.armor.melee)
				H.physiology.armor.bullet = initial(H.physiology.armor.bullet)
				to_chat(owner, "<span class='warning'>Your skin is thin again...</span>")
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
			var/mob/living/carbon/werewolf/H = owner
			H.werewolf_armor = 40
			to_chat(owner, "<span class='notice'>You feel your skin thickering...</span>")
			spawn(15 SECONDS)
				H.werewolf_armor = initial(H.werewolf_armor)
				to_chat(owner, "<span class='warning'>Your skin is thin again...</span>")

/datum/action/gift/scent_of_the_true_form
	name = "Scent Of The True Form"
	desc = "This Gift allows the Garou to determine the true nature of a person."
	button_icon_state = "scent_of_the_true_form"
	rage_req = 1

/datum/action/gift/scent_of_the_true_form/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
		abductor_hud.add_hud_to(owner)
		spawn(20 SECONDS)
			abductor_hud.remove_hud_from(owner)

/datum/action/gift/truth_of_gaia
	name = "Truth Of Gaia"
	desc = "As judges of the Litany, Philodox have the ability to sense whether others have spoken truth or falsehood."
	button_icon_state = "truth_of_gaia"

/datum/action/gift/mothers_touch
	name = "Mother's Touch"
	desc = "The Garou is able to heal the wounds of any living creature, aggravated or otherwise, simply by laying hands over the afflicted area."
	button_icon_state = "mothers_touch"
	rage_req = 2

/datum/action/gift/mothers_touch/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		H.put_in_active_hand(new /obj/item/melee/touch_attack/mothers_touch(H))

/datum/action/gift/sense_wyrm
	name = "Sense Wyrm"
	desc = "This Gift allows the werewolf to sense the presence of Wyrm."
	button_icon_state = "sense_wyrm"
	rage_req = 1

/datum/action/gift/sense_wyrm/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.sight = SEE_MOBS|SEE_OBJS
		playsound(get_turf(owner), 'code/modules/wod13/sounds/sense_wyrm.ogg', 75, FALSE)
		to_chat(owner, "<span class='notice'>You feel your sense sharpening...</span>")
		spawn(20 SECONDS)
			C.sight = initial(C.sight)
			to_chat(owner, "<span class='warning'>You no longer sense anything more than normal...</span>")

/datum/action/gift/spirit_speech
	name = "Spirit Speech"
	desc = "This Gift allows the Garou to communicate with encountered spirits."
	button_icon_state = "spirit_speech"
	//gnosis_req = 1

/datum/action/gift/spirit_speech/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.see_invisible = SEE_INVISIBLE_OBSERVER
		spawn(20 SECONDS)
			C.see_invisible = initial(C.see_invisible)

/datum/action/gift/blur_of_the_milky_eye
	name = "Blur Of The Milky Eye"
	desc = "The Garou's form becomes a shimmering blur, allowing him to pass unnoticed among others."
	button_icon_state = "blur_of_the_milky_eye"
	rage_req = 2
	//gnosis_req = 1

/datum/action/gift/blur_of_the_milky_eye/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.alpha = 36
		playsound(get_turf(owner), 'code/modules/wod13/sounds/milky_blur.ogg', 75, FALSE)
		spawn(20 SECONDS)
			C.alpha = 255

/datum/action/gift/open_seal
	name = "Open Seal"
	desc = "With this Gift, the Garou can open nearly any sort of closed or locked physical device."
	button_icon_state = "open_seal"

/datum/action/gift/open_seal/Trigger()
	. = ..()
	if(allowed_to_proceed)
		for(var/obj/structure/vampdoor/V in range(5, owner))
			if(V.closed)
				if(V.lockpick_difficulty < 10)
					V.locked = FALSE
					playsound(V, V.open_sound, 75, TRUE)
					V.icon_state = "[V.baseicon]-0"
					V.density = FALSE
					V.opacity = FALSE
					V.layer = OPEN_DOOR_LAYER
					to_chat(owner, "<span class='notice'>You open [V].</span>")
					V.closed = FALSE

/datum/action/gift/infectious_laughter
	name = "Infectious Laughter"
	desc = "When the Ragabash laughs, those around her are compelled to follow along, forgetting their grievances."
	button_icon_state = "infectious_laughter"
	rage_req = 1

/datum/action/gift/infectious_laughter/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		C.emote("laugh")
		C.Stun(10)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/infectious_laughter.ogg', 100, FALSE)
		for(var/mob/living/L in oviewers(4, owner))
			L.emote("laugh")
			L.Stun(20)

/datum/action/gift/rage_heal
	name = "Rage Heal"
	desc = "This Gift allows the Garou to heal severe injuries with rage."
	button_icon_state = "rage_heal"
	rage_req = 1
	check_flags = null

/datum/action/gift/rage_heal/Trigger()
	. = ..()
	if (!allowed_to_proceed)
		return

	var/mob/living/carbon/C = owner
	if(C.stat == DEAD)
		return

	var/datum/splat/werewolf/garou/lycanthropy = is_garou(owner)
	if (!lycanthropy)
		return

	SEND_SOUND(owner, sound('code/modules/wod13/sounds/rage_heal.ogg', 0, 0, 75))
	C.adjustBruteLoss(-40 * lycanthropy.level, TRUE)
	C.adjustFireLoss(-30 * lycanthropy.level, TRUE)
	C.adjustCloneLoss(-10 * lycanthropy.level, TRUE)
	C.adjustToxLoss(-10 * lycanthropy.level, TRUE)
	C.adjustOxyLoss(-20 * lycanthropy.level, TRUE)
	C.bloodpool = min(C.bloodpool + lycanthropy.level, C.maxbloodpool)
	C.blood_volume = min(C.blood_volume + 56 * lycanthropy.level, BLOOD_VOLUME_NORMAL)

	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/BD = owner

	for (var/i in 1 to length(BD.all_wounds))
		var/datum/wound/W = pick(BD.all_wounds)
		W.remove_wound()

/datum/action/change_apparel
	name = "Change Apparel"
	desc = "Choose the clothes of your Crinos form."
	button_icon_state = "choose_apparel"
	icon_icon = 'code/modules/wod13/werewolf_abilities.dmi'
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS

/datum/action/change_apparel/Trigger()
	. = ..()
	var/mob/living/carbon/werewolf/crinos/C = owner
	if(C.stat == CONSCIOUS)
		if(C.sprite_apparel == 4)
			C.sprite_apparel = 0
		else
			C.sprite_apparel = min(4, C.sprite_apparel+1)

/datum/action/gift/hispo
	name = "Hispo Form"
	desc = "Change your Lupus form into Hispo and backwards."
	button_icon_state = "hispo"

/datum/action/gift/hispo/Trigger()
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/werewolf/lupus/H = owner
		playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
		if(H.hispo)
			H.icon = 'code/modules/wod13/werewolf_lupus.dmi'
			H.pixel_w = 0
			H.pixel_z = 0
			H.melee_damage_lower = initial(H.melee_damage_lower)
			H.melee_damage_upper = initial(H.melee_damage_upper)
			H.hispo = FALSE
			H.update_icons()
			H.remove_movespeed_modifier(/datum/movespeed_modifier/crinosform)
			H.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)
		else
			H.icon = 'code/modules/wod13/hispo.dmi'
			H.pixel_w = -16
			H.pixel_z = -16
			H.melee_damage_lower = 35
			H.melee_damage_upper = 55
			H.hispo = TRUE
			H.update_icons()
			H.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
			H.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)

/datum/action/gift/glabro
	name = "Glabro Form"
	desc = "Change your Homid form into Glabro and backwards."
	button_icon_state = "glabro"

/datum/action/gift/glabro/Trigger()
	. = ..()
	if (!allowed_to_proceed)
		return

	var/mob/living/carbon/human/H = owner
	var/datum/splat/werewolf/garou/lycanthropy = is_garou(owner)
	playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
	if (lycanthropy.glabro)
		H.remove_overlay(PROTEAN_LAYER)
		H.dna.species.punchdamagelow -= 15
		H.dna.species.punchdamagehigh -= 15
		H.physique -= 2
		H.physiology.armor.melee -= 15
		H.physiology.armor.bullet -= 15
		var/matrix/M = matrix()
		M.Scale(1)
		animate(H, transform = M, time = 1 SECONDS)
		lycanthropy.glabro = FALSE
		H.update_icons()
	else
		H.remove_overlay(PROTEAN_LAYER)
		var/mutable_appearance/glabro_overlay = mutable_appearance('code/modules/wod13/werewolf_abilities.dmi', lycanthropy.transformator.crinos_form?.sprite_color, -PROTEAN_LAYER)
		H.overlays_standing[PROTEAN_LAYER] = glabro_overlay
		H.apply_overlay(PROTEAN_LAYER)
		H.dna.species.punchdamagelow += 15
		H.dna.species.punchdamagehigh += 15
		H.physique += 2
		H.physiology.armor.melee += 15
		H.physiology.armor.bullet += 15
		var/matrix/M = matrix()
		M.Scale(1.23)
		animate(H, transform = M, time = 1 SECONDS)
		lycanthropy.glabro = TRUE
		H.update_icons()
