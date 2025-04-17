/// from /datum/splat/vampire/kindred/give_vitae(): (mob/living/victim, amount)
#define COMSIG_MOB_GIVE_VITAE "mob_give_vitae"
	/// Cancels giving vitae including spending it
	#define VITAE_CANCEL_GIVE (1<<0)

/// from /datum/splat/vampire/kindred/give_vitae(): (mob/living/vampire, amount)
#define COMSIG_MOB_DRINK_VITAE "mob_drink_vitae"
	/// Cancels effects of vitae in main give_vitae() proc
	#define VITAE_NO_EFFECT (1<<0)

/// from /datum/splat/vampire/kindred/embrace(): (mob/living/victim)
#define COMSIG_MOB_EMBRACE "mob_embrace"
/// from /datum/splat/vampire/kindred/embrace(): (mob/living/sire)
#define COMSIG_MOB_EMBRACED "mob_embraced"
	#define CANCEL_EMBRACE (1<<0)

/// from /datum/splat/vampire/kindred/ghoul(): (mob/living/victim)
#define COMSIG_MOB_GHOUL "mob_ghoul"
/// from /datum/splat/vampire/kindred/ghoul(): (mob/living/regnant)
#define COMSIG_MOB_GHOULED "mob_ghouled"
	#define CANCEL_GHOUL (1<<0)

/// from /datum/splat/vampire/kindred/bloodbond(): (mob/living/victim)
#define COMSIG_MOB_BLOODBOND "mob_bloodbond"
/// from /datum/splat/vampire/kindred/bloodbond(): (mob/living/regnant)
#define COMSIG_MOB_BLOODBONDED "mob_bloodbonded"
	#define CANCEL_BLOODBOND (1<<0)

