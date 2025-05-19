/datum/vampire_clan/kiasyd
	name = "Kiasyd"
	desc = "The Kiasyd are a bloodline of the Lasombra founded after a mysterious \"accident\" involving the Lasombra Marconius of Strasbourg. The \"accident\", involving faeries and the blood of \"Zeernebooch, a god of the Underworld\", resulted in Marconius gaining several feet in height, turning chalky white and developing large, elongated black eyes."
	curse = "At a glance they look unsettling or perturbing to most, their appearance closely resembles fae from old folklore. Kiasyd are also in some way connected with changelings and they are vulnerable to cold iron."
	clan_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/obtenebration,
		/datum/discipline/mytherceria
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

/datum/vampire_clan/kiasyd/on_gain(mob/living/carbon/human/H)
	..()
	//This was messing with the visualiser in the character setup menu somehow
	if (H.clan?.type != /datum/vampire_clan/kiasyd)
		return
	if(H.isdwarfy)
		H.RemoveElement(/datum/element/dwarfism, COMSIG_PARENT_PREQDELETED, src)
		H.isdwarfy = FALSE
	if(!H.istower)
		H.AddElement(/datum/element/giantism, COMSIG_PARENT_PREQDELETED, src)
		H.istower = TRUE
	var/obj/item/organ/eyes/night_vision/kiasyd/NV = new()
	NV.Insert(H, TRUE, FALSE)
	if(H.base_body_mod == FAT_BODY_MODEL)
		H.set_body_model(NORMAL_BODY_MODEL)
	H.update_body()

	// Add curse component
	H.AddComponent(/datum/component/kiasyd_iron_weakness)

/datum/vampire_clan/kiasyd/post_gain(mob/living/carbon/human/H)
	. = ..()

	//give them sunglasses to hide their freakish eyes
	var/obj/item/clothing/glasses/vampire/sun/new_glasses = new(H.loc)
	H.equip_to_appropriate_slot(new_glasses, TRUE)

// TODO: [Lucia] this needs to become a component and/or signals
/obj/item/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(iscathayan(target) && is_iron)
		var/mob/living/carbon/human/L = target
		if(L.max_yang_chi > L.max_yin_chi + 2)
			to_chat(L, "<span class='danger'><b>COLD METAL!</b></span>")
			L.adjustBruteLoss(15, TRUE)
	if(iscathayan(target) && is_wood)
		var/mob/living/carbon/human/L = target
		if(L.max_yin_chi > L.max_yang_chi + 2)
			to_chat(L, "<span class='danger'><b>WOOD!</b></span>")
			L.adjustBruteLoss(15, TRUE)
	..()
