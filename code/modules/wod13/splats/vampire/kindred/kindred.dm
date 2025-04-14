/datum/splat/vampire/kindred
	name = "Kindred"
	desc = "Undead predators that have been feeding on humanity since stone was first turned into tools. They use the powers of their stolen blood to control human societies."

	splat_traits = list(
		TRAIT_LIMBATTACHMENT,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBLEED,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE,
		TRAIT_BURNS_IN_SUNLIGHT,
		TRAIT_CAN_TORPOR
	)
	splat_species_traits = list(
		DRINKSBLOOD
	)
	splat_actions = list(
		/datum/action/give_vitae,
		/datum/action/blood_power
	)

	power_type = /datum/discipline
	replace_splats = list(
		/datum/splat/vampire
	)
	incompatible_splats = list(
		/datum/splat/hungry_dead/kuei_jin
	)

	selectable = TRUE
	whitelisted = FALSE

	var/enlightenment = FALSE
	var/generation = 13
	var/datum/vampireclan/clan
	COOLDOWN_DECLARE(torpor_timer)

/datum/splat/vampire/kindred/New(generation = 13, clan = /datum/vampireclan/brujah)
	. = ..()
	src.generation = generation
	src.clan = new clan

/datum/splat/vampire/kindred/on_gain()
	. = ..()

	set_generation(generation)
	set_clan(clan)

	//this needs to be adjusted to be more accurate for blood spending rates
	var/datum/discipline/bloodheal/giving_bloodheal = new(clamp(11 - generation, 1, 10))
	owner.give_discipline(giving_bloodheal)

	add_verb(owner, TYPE_VERB_REF(/mob/living/carbon/human, teach_discipline))

/datum/splat/vampire/kindred/on_lose()
	. = ..()

	owner.maxbloodpool = HUMAN_MAXBLOODPOOL
	owner.bloodpool = clamp(owner.bloodpool, 0, owner.maxbloodpool)
	clan.on_lose(owner)

/datum/splat/vampire/kindred/proc/give_vitae(mob/living/victim, to_give = 1)

/datum/splat/vampire/kindred/proc/embrace(mob/living/victim)

/datum/splat/vampire/kindred/proc/ghoul(mob/living/victim)

/datum/splat/vampire/kindred/proc/bloodbond(mob/living/victim)

/datum/splat/vampire/kindred/proc/set_generation(generation = 13)
	src.generation = generation
	owner.maxbloodpool = HUMAN_MAXBLOODPOOL + ((13 - generation) * 3)

/datum/splat/vampire/kindred/proc/set_clan(datum/vampireclan/clan)
	if (src.clan != clan)
		src.clan.on_lose(owner)

	src.clan = clan
	clan.on_gain(owner)
	clan.post_gain(owner)

/mob/proc/can_embrace()
	if (HAS_TRAIT(src, TRAIT_CANNOT_BE_EMBRACED))
		return FALSE

	return TRUE

/mob/living/carbon/can_embrace()
	. = ..()
	if (!.)
		return .

	var/obj/item/organ/brain/brain = getorgan(/obj/item/organ/brain)
	if (!brain)
		return FALSE
	if (brain.organ_flags & ORGAN_FAILING)
		return FALSE

	return TRUE

/datum/action/give_vitae
	name = "Give Vitae"
	desc = "Give your vitae to someone, make the Blood Bond."
	button_icon_state = "vitae"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	spell_button = TRUE
	var/giving = FALSE

/datum/action/give_vitae/Trigger()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/vampire = owner

	var/datum/splat/vampire/kindred/vampirism = vampire.is_kindred()
	if (!vampirism)
		return

	if(vampirism.get_vitae() < 2)
		to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
		return

	if(!ishuman(vampire.pulling))
		return
	var/mob/living/carbon/human/victim = vampire.pulling

	if(is_kuei_jin(victim))
		to_chat(owner, "<span class='warning'>[victim] vomits the vitae back!</span>")
		return

	if(!victim.client && !istype(vampire.pulling, /mob/living/carbon/human/npc))
		to_chat(owner, "<span class='warning'>You need [victim]'s attention to do that!</span>")
		return

	if(victim.stat == DEAD)
		if(!victim.key)
			to_chat(owner, "<span class='warning'>You need [victim]'s mind to Embrace!</span>")
			return
		message_admins("[ADMIN_LOOKUPFLW(vampire)] is Embracing [ADMIN_LOOKUPFLW(victim)]!")

	if(giving)
		return
	giving = TRUE
	owner.visible_message("<span class='warning'>[owner] tries to feed [victim] with their own blood!</span>", "<span class='notice'>You started to feed [victim] with your own blood.</span>")
	if(!do_mob(owner, victim, 10 SECONDS))
		giving = FALSE
		return

	vampire.bloodpool = max(0, vampire.bloodpool-2)
	giving = FALSE

	var/new_master = FALSE
	victim.drunked_of |= "[vampire.dna.real_name]"

	if(victim.stat == DEAD && !is_kindred(victim))
		if (!HAS_TRAIT(victim, TRAIT_CANNOT_BE_EMBRACED) || !victim.can_be_revived())
			to_chat(vampire, "<span class='notice'>[victim.name] doesn't respond to your Vitae.</span>")
			return

		if((victim.timeofdeath + 5 MINUTES) > world.time)
			var/datum/splat/werewolf/garou/lycanthropy = is_garou(victim)
			if (lycanthropy) //here be Abominations
				if (HAS_TRAIT(victim, TRAIT_EMBRACE_ALWAYS_SUCCEEDS))
					to_chat(vampire, "<span class='danger'>Something terrible is happening.</span>")
					to_chat(victim, "<span class='userdanger'>Gaia has forsaken you.</span>")
					message_admins("[ADMIN_LOOKUPFLW(vampire)] has turned [ADMIN_LOOKUPFLW(victim)] into an Abomination through an admin setting the force_abomination var.")
					log_game("[key_name(vampire)] has turned [key_name(victim)] into an Abomination through an admin setting the force_abomination var.")
				else
					switch(storyteller_roll(lycanthropy.level))
						if (ROLL_BOTCH)
							to_chat(vampire, "<span class='danger'>Something terrible is happening.</span>")
							to_chat(victim, "<span class='userdanger'>Gaia has forsaken you.</span>")
							message_admins("[ADMIN_LOOKUPFLW(vampire)] has turned [ADMIN_LOOKUPFLW(victim)] into an Abomination.")
							log_game("[key_name(vampire)] has turned [key_name(victim)] into an Abomination.")
						if (ROLL_FAILURE)
							victim.visible_message("<span class='warning'>[victim.name] convulses in sheer agony!</span>")
							victim.Shake(15, 15, 5 SECONDS)
							playsound(victim.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE)
							ADD_TRAIT(victim, TRAIT_CANNOT_BE_EMBRACED, WEREWOLF_TRAIT)
							return
						if (ROLL_SUCCESS)
							to_chat(vampire, "<span class='notice'>[victim.name] does not respond to your Vitae...</span>")
							ADD_TRAIT(victim, TRAIT_CANNOT_BE_EMBRACED, WEREWOLF_TRAIT)
							return

			log_game("[key_name(vampire)] has Embraced [key_name(victim)].")
			message_admins("[ADMIN_LOOKUPFLW(vampire)] has Embraced [ADMIN_LOOKUPFLW(victim)].")
			giving = FALSE
			var/save_data_v = FALSE
			if(victim.revive(full_heal = TRUE, admin_revive = TRUE))
				victim.grab_ghost(force = TRUE)
				to_chat(victim, "<span class='userdanger'>You rise with a start, you're alive! Or not... You feel your soul going somewhere, as you realize you are embraced by a vampire...</span>")
				var/response_v = input(victim, "Do you wish to keep being a vampire on your save slot?(Yes will be a permanent choice and you can't go back!)") in list("Yes", "No")
				if(response_v == "Yes")
					save_data_v = TRUE
				else
					save_data_v = FALSE
			victim.roundstart_vampire = FALSE
			victim.set_species(/datum/species/kindred)
			victim.clan = null
			if(vampire.generation < 13)
				victim.generation = 13
				victim.skin_tone = get_vamp_skin_color(victim.skin_tone)
				victim.update_body()
				if (vampire.clan.whitelisted)
					if (!SSwhitelists.is_whitelisted(victim.ckey, vampire.clan.name))
						if(vampire.clan.name == "True Brujah")
							victim.clan = new /datum/vampireclan/brujah()
							to_chat(victim,"<span class='warning'> You don't got that whitelist! Changing to the non WL Brujah</span>")
						else if(vampire.clan.name == "Tzimisce")
							victim.clan = new /datum/vampireclan/old_clan_tzimisce()
							to_chat(victim,"<span class='warning'> You don't got that whitelist! Changing to the non WL Old Tzmisce</span>")
						else
							to_chat(victim,"<span class='warning'> You don't got that whitelist! Changing to a random non WL clan.</span>")
							var/list/non_whitelisted_clans = list(/datum/vampireclan/brujah,/datum/vampireclan/malkavian,/datum/vampireclan/nosferatu,/datum/vampireclan/gangrel,/datum/vampireclan/giovanni,/datum/vampireclan/ministry,/datum/vampireclan/salubri,/datum/vampireclan/toreador,/datum/vampireclan/tremere,/datum/vampireclan/ventrue)
							var/random_clan = pick(non_whitelisted_clans)
							victim.clan = new random_clan
					else
						victim.clan = new vampire.clan.type()
				else
					victim.clan = new vampire.clan.type()

				victim.clan.on_gain(victim)
				victim.clan.post_gain(victim)
				if(victim.clan.alt_sprite)
					victim.skin_tone = "albino"
					victim.update_body()

				//Gives the Childe the Sire's first three Disciplines

				var/list/disciplines_to_give = list()
				for (var/i in 1 to min(3, vampire.client.prefs.discipline_types.len))
					disciplines_to_give += vampire.client.prefs.discipline_types[i]
				victim.create_disciplines(FALSE, disciplines_to_give)

				victim.maxbloodpool = 10+((13-min(13, victim.generation))*3)
				victim.clan.enlightenment = vampire.clan.enlightenment
			else
				victim.maxbloodpool = 10+((13-min(13, victim.generation))*3)
				victim.generation = 14
				victim.clan = new /datum/vampireclan/caitiff()

			//Verify if they accepted to save being a vampire
			if (is_kindred(victim) && save_data_v)
				var/datum/preferences/BLOODBONDED_prefs_v = victim.client.prefs

				BLOODBONDED_prefs_v.pref_species.id = "kindred"
				BLOODBONDED_prefs_v.pref_species.name = "Vampire"
				if(vampire.generation < 13)

					BLOODBONDED_prefs_v.clan = victim.clan
					BLOODBONDED_prefs_v.generation = 13
					BLOODBONDED_prefs_v.skin_tone = get_vamp_skin_color(victim.skin_tone)
					BLOODBONDED_prefs_v.clan.enlightenment = vampire.clan.enlightenment


					//Rarely the new mid round vampires get the 3 brujah skil(it is default)
					//This will remove if it happens
					// Or if they are a ghoul with abunch of disciplines
					if(BLOODBONDED_prefs_v.discipline_types.len > 0)
						for (var/i in 1 to BLOODBONDED_prefs_v.discipline_types.len)
							var/removing_discipline = BLOODBONDED_prefs_v.discipline_types[1]
							if (removing_discipline)
								var/index = BLOODBONDED_prefs_v.discipline_types.Find(removing_discipline)
								BLOODBONDED_prefs_v.discipline_types.Cut(index, index + 1)
								BLOODBONDED_prefs_v.discipline_levels.Cut(index, index + 1)

					if(BLOODBONDED_prefs_v.discipline_types.len == 0)
						for (var/i in 1 to 3)
							BLOODBONDED_prefs_v.discipline_types += BLOODBONDED_prefs_v.clan.clan_disciplines[i]
							BLOODBONDED_prefs_v.discipline_levels += 1
					BLOODBONDED_prefs_v.save_character()

				else
					BLOODBONDED_prefs_v.generation = 13 // Game always set to 13 anyways, 14 is not possible.
					BLOODBONDED_prefs_v.clan = new /datum/vampireclan/caitiff()
					BLOODBONDED_prefs_v.save_character()

		else

			to_chat(owner, "<span class='notice'>[victim] is totally <b>DEAD</b>!</span>")
			giving = FALSE
			return
	else
		if(victim.has_status_effect(STATUS_EFFECT_INLOVE))
			victim.remove_status_effect(STATUS_EFFECT_INLOVE)
		victim.apply_status_effect(STATUS_EFFECT_INLOVE, owner)
		to_chat(owner, "<span class='notice'>You successfuly fed [victim] with vitae.</span>")
		to_chat(victim, "<span class='userlove'>You feel good when you drink this <b>BLOOD</b>...</span>")

		message_admins("[ADMIN_LOOKUPFLW(vampire)] has bloodbonded [ADMIN_LOOKUPFLW(victim)].")
		log_game("[key_name(vampire)] has bloodbonded [key_name(victim)].")

		if(vampire.reagents)
			if(length(vampire.reagents.reagent_list))
				vampire.reagents.trans_to(victim, min(10, vampire.reagents.total_volume), transfered_by = vampire, methods = VAMPIRE)
		victim.adjustBruteLoss(-25, TRUE)
		if(length(victim.all_wounds))
			var/datum/wound/W = pick(victim.all_wounds)
			W.remove_wound()
		victim.adjustFireLoss(-25, TRUE)
		victim.bloodpool = min(victim.maxbloodpool, victim.bloodpool+2)
		giving = FALSE

		if (is_kindred(victim))
			var/datum/species/kindred/species = victim.dna.species
			if (HAS_TRAIT(victim, TRAIT_TORPOR) && COOLDOWN_FINISHED(species, torpor_timer))
				victim.untorpor()

		if(!is_ghoul(victim) && istype(victim, /mob/living/carbon/human/npc))
			var/mob/living/carbon/human/npc/NPC = vampire.pulling
			if(NPC.ghoulificate(owner))
				new_master = TRUE
				NPC.roundstart_vampire = FALSE
		if(victim.mind)
			if(victim.mind.enslaved_to != owner)
				victim.mind.enslave_mind_to_creator(owner)
				to_chat(victim, "<span class='userdanger'><b>AS PRECIOUS VITAE ENTER YOUR MOUTH, YOU NOW ARE IN THE BLOODBOND OF [vampire]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b></span>")
				new_master = TRUE
		if(is_ghoul(victim))
			var/datum/species/ghoul/G = victim.dna.species
			G.master = owner
			G.last_vitae = world.time
			if(new_master)
				G.changed_master = TRUE
		else if(!is_kindred(victim) && !isnpc(victim))
			var/save_data_g = FALSE
			victim.set_species(/datum/species/ghoul)
			victim.clan = null
			var/response_g = input(victim, "Do you wish to keep being a ghoul on your save slot?(Yes will be a permanent choice and you can't go back)") in list("Yes", "No")
			victim.roundstart_vampire = FALSE
			var/datum/species/ghoul/G = victim.dna.species
			G.master = owner
			G.last_vitae = world.time
			if(new_master)
				G.changed_master = TRUE
			if(response_g == "Yes")
				save_data_g = TRUE
			else
				save_data_g = FALSE
			if(save_data_g)
				var/datum/preferences/BLOODBONDED_prefs_g = victim.client.prefs
				if(BLOODBONDED_prefs_g.discipline_types.len == 3)
					for (var/i in 1 to 3)
						var/removing_discipline = BLOODBONDED_prefs_g.discipline_types[1]
						if (removing_discipline)
							var/index = BLOODBONDED_prefs_g.discipline_types.Find(removing_discipline)
							BLOODBONDED_prefs_g.discipline_types.Cut(index, index + 1)
							BLOODBONDED_prefs_g.discipline_levels.Cut(index, index + 1)
				BLOODBONDED_prefs_g.pref_species.name = "Ghoul"
				BLOODBONDED_prefs_g.pref_species.id = "ghoul"
				BLOODBONDED_prefs_g.save_character()
