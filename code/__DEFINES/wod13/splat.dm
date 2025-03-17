#define SPLAT_TRAIT "splat_trait"

#define is_splat(character, splat_type) (character.get_splat(splat_type))

#define is_supernatural(character) (length(character.splats))
#define is_innocent(character) (!is_supernatural(character))

// VAMPIRE: THE MASQUERADE
#define is_vtm(character) (is_splat(character, /datum/splat/vampire))
#define is_kindred(character) (is_splat(character, /datum/splat/vampire/kindred))
#define is_ghoul(character) (is_splat(character, /datum/splat/vampire/ghoul))

#define has_vitae(character) (is_vtm(character))

// KINDRED OF THE EAST
#define is_kote(character) (is_splat(character, /datum/splat/hungry_dead))
#define is_kuei_jin(character) (is_splat(character, /datum/splat/hungry_dead/kuei_jin))

#define has_chi(character) (is_kote(character))
#define has_yang_chi(character) (is_kuei_jin(character))
#define has_yin_chi(character) (is_kuei_jin(character))

// WEREWOLF: THE APOCALYPSE
#define is_wta(character) (is_splat(character, /datum/splat/werewolf))
#define is_garou(character) (is_splat(character, /datum/splat/werewolf/garou))

#define has_gnosis(character) (is_wta(character))
#define has_rage(character) (is_garou(character))
