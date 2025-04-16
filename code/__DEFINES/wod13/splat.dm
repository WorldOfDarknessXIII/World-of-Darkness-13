/* SPLAT DEFINES */
#define is_supernatural(character) (length(character.splats))
#define is_innocent(character) (!is_supernatural(character))

#define SPLAT_KINDRED /datum/splat/vampire/kindred
#define SPLAT_GHOUL /datum/splat/vampire/ghoul
#define SPLAT_GAROU /datum/splat/werewolf/garou
#define SPLAT_KUEI_JIN /datum/splat/hungry_dead/kuei_jin

/* RESOURCE DEFINES */
// annihilate these when refactored into Storyteller system traits
#define RESOURCE_VITAE "resource_vitae"
#define RESOURCE_HUMANITY "resource_humanity"
#define RESOURCE_RAGE "resource_rage"
#define RESOURCE_GNOSIS "resource_gnosis"
#define RESOURCE_YIN_CHI "resource_yin_chi"
#define RESOURCE_YANG_CHI "resource_yang_chi"
#define RESOURCE_DEMON_CHI "resource_demon_chi"
