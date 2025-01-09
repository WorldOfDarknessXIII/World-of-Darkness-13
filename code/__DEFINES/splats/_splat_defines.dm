
#define PURE_HUMAN_SPLAT (0<<0) // for things that will only apply to humans, they'll need to have no other splats
#define KINDRED_SPLAT (1<<0)
#define GHOUL_SPLAT (1<<1)
#define GAROU_SPLAT (1<<2)

DEFINE_BITFIELD(splat_flags, list(
	"PURE_HUMAN_SPLAT" = PURE_HUMAN_SPLAT,
	"KINDRED_SPLAT" = KINDRED_SPLAT,
	"GHOUL_SPLAT" = GHOUL_SPLAT,
	"GAROU_SPLAT" = GAROU_SPLAT,
))
//PSEUDO_M rework this to work off of processing a signal bitfield instead to save on list assignments?
//or maybe just to make people learn signals because they're very performant and we want to account for CAN_DO stuff

// what splat are you?
#define splatted_kindred(A) SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & KINDRED_SPLAT
#define is_kindred(A) splatted_kindred(A)
#define splatted_ghoul(A) SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & GHOUL_SPLAT
#define is_ghoul(A) splatted_ghoul(A)
#define splatted_garou(A) SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & GAROU_SPLAT
#define is_garou(A) splatted_garou(A)
// we wanna account for stuff only humans can do, and also account for things like ghouled pets
#define splatted_pure_human(A) SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & PURE_HUMAN_SPLAT

#define iswerewolf(A) (istype(A, /mob/living/carbon/werewolf))

#define iscrinos(A) (istype(A, /mob/living/carbon/werewolf/crinos))

#define islupus(A) (istype(A, /mob/living/carbon/werewolf/lupus))
