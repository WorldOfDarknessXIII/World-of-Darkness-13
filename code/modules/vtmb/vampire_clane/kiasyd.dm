/datum/vampireclane/kiasyd
	name = "Kiasyd"
	desc = "The Kiasyd are a bloodline of the Lasombra founded after a mysterious \"accident\" involving the Lasombra Marconius of Strasbourg. The \"accident\", involving faeries and the blood of \"Zeernebooch, a god of the Underworld\", resulted in Marconius gaining several feet in height, turning chalky white and developing large, elongated black eyes."
	curse = "At a glance they look unsettling or perturbing to most, their appearance closely resembles fae from old folklore. Kiasyd are also in some way connected with changelings and they are vulnerable to cold iron."
	clane_disciplines = list(
		/datum/discipline/dominate = 1,
		/datum/discipline/obtenebration = 2,
		/datum/discipline/mytherceria = 3
	)
	alt_sprite = "kiasyd"
	no_facial = TRUE
	male_clothes = /obj/item/clothing/under/vampire/archivist
	female_clothes = /obj/item/clothing/under/vampire/archivist
	whitelisted = TRUE
	violating_appearance = TRUE
	current_accessory = "none"
	accessories = list("fae_ears", "none")
	accessories_layers = list("fae_ears" = UPPER_EARS_LAYER, "none" = UPPER_EARS_LAYER)

	COOLDOWN_DECLARE(cold_iron_frenzy)

/datum/vampireclane/kiasyd/on_gain(mob/living/carbon/human/H)
	..()
	//This was messing with the visualiser in the character setup menu somehow
	if (H.clane?.type != /datum/vampireclane/kiasyd)
		return
	if(H.isdwarfy)
		H.RemoveElement(/datum/element/dwarfism, COMSIG_PARENT_PREQDELETED, src)
		H.isdwarfy = FALSE
	if(!H.istower)
		H.AddElement(/datum/element/giantism, COMSIG_PARENT_PREQDELETED, src)
		H.istower = TRUE
	var/obj/item/organ/eyes/night_vision/kiasyd/NV = new()
	NV.Insert(H, TRUE, FALSE)
	if(H.base_body_mod == "f")
		H.base_body_mod = ""
	H.update_body()

/datum/vampireclane/kiasyd/post_gain(mob/living/carbon/human/H)
	. = ..()

	//give them sunglasses to hide their freakish eyes
	var/obj/item/clothing/glasses/vampire/sun/new_glasses = new(H.loc)
	H.equip_to_appropriate_slot(new_glasses, TRUE)

/datum/movespeed_modifier/riddle
	multiplicative_slowdown = 5

/obj/item/clothing/mask/facehugger/kiasyd
	name = "goblin"
	desc = "A green changeling creature."
	worn_icon = 'code/modules/wod13/worn.dmi'
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "goblin"
	sterile = TRUE

/obj/item/clothing/mask/facehugger/kiasyd/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.adjustBruteLoss(5)
		to_chat(user, "<span class='warning'>[src] bites!</span>")
		return
	. = ..()

/obj/item/clothing/mask/facehugger/kiasyd/Die()
	qdel(src)

/obj/item/clothing/mask/facehugger/kiasyd/Leap(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/target = M
		if(target.wear_mask && istype(target.wear_mask, /obj/item/clothing/mask/facehugger/kiasyd))
			return FALSE
	M.visible_message("<span class='danger'>[src] leaps at [M]'s face!</span>", \
		"<span class='userdanger'>[src] leaps at your face!</span>")
	if(iscarbon(M))
		var/mob/living/carbon/target = M

		if(target.head)
			var/obj/item/clothing/W = target.head
			target.dropItemToGround(W, TRUE)

		if(target.wear_mask)
			var/obj/item/clothing/W = target.wear_mask
			if(target.dropItemToGround(W, TRUE))
				target.visible_message(
					"<span class='danger'>[src] tears [W] off of [target]'s face!</span>", \
					"<span class='userdanger'>[src] tears [W] off of your face!</span>")
		target.equip_to_slot_if_possible(src, ITEM_SLOT_MASK, 0, 1, 1)
		var/datum/cb = CALLBACK(src,/obj/item/clothing/mask/facehugger/kiasyd/proc/eat_head)
		for(var/i in 1 to 10)
			addtimer(cb, (i - 1) * 1.5 SECONDS)
		spawn(16 SECONDS)
			qdel(src)
	return TRUE

/obj/item/clothing/mask/facehugger/kiasyd/proc/eat_head()
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		to_chat(C, "<span class='warning'>[src] is eating your face!</span>")
		C.apply_damage(5, BRUTE)

/obj/item/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(iskindred(target) && is_iron)
		var/mob/living/carbon/human/L = target
		if(L.clane?.name == "Kiasyd")
			var/datum/vampireclane/kiasyd/kiasyd = L.clane
			if (COOLDOWN_FINISHED(kiasyd, cold_iron_frenzy))
				COOLDOWN_START(kiasyd, cold_iron_frenzy, 10 SECONDS)
				to_chat(L, "<span class='danger'><b>COLD IRON!</b></span>")
				L.rollfrenzy()
	..()
