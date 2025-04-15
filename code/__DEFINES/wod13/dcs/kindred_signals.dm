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
	#define CANCEL_EMBRACE (1<<0)
/// from /datum/splat/vampire/kindred/embrace(): (mob/living/vampire)
#define COMSIG_MOB_EMBRACED "mob_embraced"
	// CANCEL_EMBRACE also applies here
