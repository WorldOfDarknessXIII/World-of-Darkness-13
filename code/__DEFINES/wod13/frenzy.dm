/* TYPES OF FRENZY */
// In order of importance, where a lower frenzy type will be ignored to satisfy a higher type
// Importance is how essential it is to survival, so frenzy doesn't just get you killed

/// Frenzy caused by fear of something, seeking to flee
#define FEAR_FRENZY (1<<0)
/// Frenzy caused by starvation, seeking to feed on something or someone
#define HUNGER_FRENZY (1<<1)
/// Frenzy caused by rage at a target, seeking to kill/maim that target
#define RAGE_FRENZY (1<<2)
/// Frenzy caused by desire or impulse, seeking to fulfil that desire or impulse
#define IMPULSE_FRENZY (1<<3)

DEFINE_BITFIELD(frenzy_type, list(
	"FRENZY DUE TO FEAR" = FEAR_FRENZY,
	"FRENZY DUE TO HUNGER" = HUNGER_FRENZY,
	"FRENZY DUE TO RAGE" = RAGE_FRENZY,
	"FRENZY DUE TO IMPULSE" = IMPULSE_FRENZY
))

