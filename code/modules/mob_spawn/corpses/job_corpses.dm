
//jobs from ss13 but DEAD.

/obj/effect/mob_spawn/corpse/human/plasmaman
	mob_species = /datum/species/plasmaman
	outfit = /datum/outfit/plasmaman

/obj/effect/mob_spawn/corpse/human/assistant
	name = JOB_CITIZEN
	outfit = /datum/outfit/job/assistant
	icon_state = "corpsegreytider"

/obj/effect/mob_spawn/corpse/human/assistant/beesease_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.ForceContractDisease(new /datum/disease/beesease)

/obj/effect/mob_spawn/corpse/human/assistant/brainrot_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.ForceContractDisease(new /datum/disease/brainrot)

/obj/effect/mob_spawn/corpse/human/assistant/spanishflu_infection/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.ForceContractDisease(new /datum/disease/fluspanish)

/obj/effect/mob_spawn/corpse/human/bartender
	name = JOB_BARTENDER
	outfit = /datum/outfit/spacebartender

