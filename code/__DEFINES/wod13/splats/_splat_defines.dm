#define PURE_HUMAN_SPLAT (1<<0)
#define KINDRED_SPLAT (1<<1)
#define GHOUL_SPLAT (1<<2)
#define GAROU_SPLAT (1<<3)
#define KUEJIN_SPLAT (1<<4)

#define iswerewolf(A) (istype(A, /mob/living/carbon/werewolf))

#define iscrinos(A) (istype(A, /mob/living/carbon/werewolf/crinos))

#define islupus(A) (istype(A, /mob/living/carbon/werewolf/lupus))

#define DEFAULT_DAMAGE_MODS list(\
	"brute" = 1, \
	"burn" = 1, \
	"tox" = 1, \
	"oxy" = 1, \
	"clone" = 1, \
	"stamina" = 1, \
	"brain" = 1, \
	"pressure" = 1, \
	"heat" = 1, \
	"cold" = 1, \
	"stun" = 1, \
	"bleed" = 1, \
	"hunger" = 1, \
)
