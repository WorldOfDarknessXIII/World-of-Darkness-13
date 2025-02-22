/datum/archetype
	var/name = "Archetype Example"
	var/specialization = "Nothing Special."
	var/start_physique = 1
	var/start_dexterity = 1
	var/start_social = 1
	var/start_mentality = 1
	var/start_blood = 1
	var/start_lockpicking = 0
	var/start_athletics = 0

	//Used in building the attribute score for the stats by also taking the archetype's stat boosts into consideration
	var/archetype_additional_physique = 0
	var/archetype_additional_dexterity = 0
	var/archetype_additional_social = 0
	var/archetype_additional_mentality = 0
	var/archetype_additional_blood = 0
	var/archetype_additional_lockpicking = 0
	var/archetype_additional_athletics = 0

/datum/archetype/proc/special_skill(var/mob/living/carbon/human/H)
	return

/datum/archetype/average
	name = "Average"
	specialization = "<i>Nothing special.</i><br>Physique, Social, Mentality and Cruelty are calculated as if they are 1 point higher than they are."
	start_physique = 2
	start_social = 2
	start_mentality = 2
	archetype_additional_physique = 1
	archetype_additional_social = 1
	archetype_additional_mentality = 1
	archetype_additional_blood = 1

/datum/archetype/warrior
	name = "Warrior"
	specialization = "<i>Better melee combat skills.</i><br>Melee attacks are twice as fast."
	start_physique = 2
	start_mentality = 2
	start_blood = 2

/datum/archetype/warrior/special_skill(var/mob/living/carbon/human/H)
	H.melee_professional = TRUE

/datum/archetype/gunfighter
	name = "Gunfighter"
	specialization = "<i>Better shooting technique.</i><br>Ranged attacks are twice as fast."
	start_physique = 2
	start_mentality = 2
	start_blood = 2

/datum/archetype/gunfighter/special_skill(var/mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_GUNFIGHTER, ROUNDSTART_TRAIT)

/datum/archetype/diplomatic
	name = "Diplomatic"
	specialization = "<i>More allies available.</i><br>Max Animalism companion limit is increased by 3."
	start_physique = 2
	start_social = 2
	start_mentality = 2

/datum/archetype/diplomatic/special_skill(var/mob/living/carbon/human/H)
	H.more_companions = 3

/datum/archetype/masochist
	name = "Masochist"
	specialization = "<i>Takes more blows before passage.</i><br>You can sustain 30 more damage before falling into a critical condition."
	start_physique = 3

/datum/archetype/masochist/special_skill(var/mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_NOSOFTCRIT, ROUNDSTART_TRAIT)

/datum/archetype/wiseman
	name = "Wiseman"
	specialization = "<i>A lot more mental than you can expect</i>.<br>Mentality is calculated as if it is 3 points higher than it is."
	start_mentality = 3
	archetype_additional_mentality = 3

/datum/archetype/beauty
	name = "Sharp Beauty"
	specialization = "<i>Charisma power.</i><br>Social is calculated as if it is 3 points higher than it is."
	start_social = 3
	start_blood = 2
	archetype_additional_social = 3

/datum/archetype/dude
	name = "Dude"
	specialization = "<i>Sadistic consequences.</i><br>Cruelty is calculated as if it is 3 points higher than it is."
	start_blood = 3
	archetype_additional_blood = 3

/datum/archetype/homebrew
	name = "Homebrew"
	specialization = "<i>Mommy's child.</i><br>No bonuses."
