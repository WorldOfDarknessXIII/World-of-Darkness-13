#define SPLAT_TRAIT "splat_trait"

#define is_splat(character, splat_type) (character.get_splat(splat_type))

#define is_innocent(character) (!is_splat(character, /datum/splat))

#define is_vtm(character) (is_splat(character, /datum/splat/vampire))
#define is_kindred(character) (is_splat(character, /datum/splat/vampire/kindred))
#define is_ghoul(character) (is_splat(character, /datum/splat/vampire/ghoul))

#define is_kote(character) (is_splat(character, /datum/splat/hungry_dead))
#define is_kuei_jin(character) (is_splat(character, /datum/splat/hungry_dead/kuei_jin))

#define is_wta(character) (is_splat(character, /datum/splat/werewolf))
#define is_garou(character) (is_splat(character, /datum/splat/werewolf/garou))
