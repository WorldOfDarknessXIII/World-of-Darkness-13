/* VAMPIRE: THE MASQUERADE */
/proc/is_vtm(mob/living/character)
	RETURN_TYPE(/datum/splat/vampire)

	return character.get_splat(/datum/splat/vampire)

/proc/is_kindred(mob/living/character)
	RETURN_TYPE(/datum/splat/vampire/kindred)

	return character.get_splat(/datum/splat/vampire/kindred)

/proc/is_ghoul(mob/living/character)
	RETURN_TYPE(/datum/splat/vampire/ghoul)

	return character.get_splat(/datum/splat/vampire/ghoul)

/proc/has_vitae(mob/living/character)
	RETURN_TYPE(/datum/splat/vampire)

	return is_vtm(character)

/* WEREWOLF: THE APOCALYPSE */
/proc/is_wta(mob/living/character)
	RETURN_TYPE(/datum/splat/werewolf)

	return character.get_splat(/datum/splat/werewolf)

/proc/is_garou(mob/living/character)
	RETURN_TYPE(/datum/splat/werewolf/garou)

	return character.get_splat(/datum/splat/werewolf/garou)

/proc/has_gnosis(mob/living/character)
	RETURN_TYPE(/datum/splat/werewolf)

	return character.get_splat(/datum/splat/werewolf)

/proc/has_rage(mob/living/character)
	RETURN_TYPE(/datum/splat/werewolf)

	return character.get_splat(/datum/splat/werewolf)

/* KINDRED OF THE EAST */
/proc/is_kote(mob/living/character)
	RETURN_TYPE(/datum/splat/hungry_dead)

	return character.get_splat(/datum/splat/hungry_dead)

/proc/is_kuei_jin(mob/living/character)
	RETURN_TYPE(/datum/splat/hungry_dead/kuei_jin)

	return character.get_splat(/datum/splat/hungry_dead/kuei_jin)

/proc/has_chi(mob/living/character)
	RETURN_TYPE(/datum/splat/hungry_dead/kuei_jin)

	return character.get_splat(/datum/splat/hungry_dead/kuei_jin)

/proc/has_yin_chi(mob/living/character)
	RETURN_TYPE(/datum/splat/hungry_dead/kuei_jin)

	return character.get_splat(/datum/splat/hungry_dead/kuei_jin)

/proc/has_yang_chi(mob/living/character)
	RETURN_TYPE(/datum/splat/hungry_dead/kuei_jin)

	return character.get_splat(/datum/splat/hungry_dead/kuei_jin)

/proc/has_demon_chi(mob/living/character)
	RETURN_TYPE(/datum/splat/hungry_dead/kuei_jin)

	return character.get_splat(/datum/splat/hungry_dead/kuei_jin)
