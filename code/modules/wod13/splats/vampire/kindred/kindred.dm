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

/datum/splat/vampire/kindred/New(generation = 13, clan)
	. = ..()
	src.generation = generation
	src.clan = clan

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

/datum/splat/vampire/kindred/proc/give_vitae(mob/living/victim, amount = 1)
	if (!isliving(victim) || (amount <= 0))
		return

	// Send signal on owner for giving Vitae
	var/give_signal_return = SEND_SIGNAL(owner, COMSIG_MOB_GIVE_VITAE, victim, amount)
	if (give_signal_return & VITAE_CANCEL_GIVE)
		return

	// Spend Vitae
	if (!remove_vitae(amount))
		to_chat(owner, span_warning("You don't have enough Vitae to feed [victim]!"))
		return

	// Send signal on victim for drinking Vitae, cancel later if returned
	var/drink_signal_return = SEND_SIGNAL(victim, COMSIG_MOB_DRINK_VITAE, owner, amount)

	// Vomit Vitae back up and prevent effects if allergic to Vitae and alive
	if (HAS_TRAIT(victim, TRAIT_ALLERGIC_TO_VITAE) && (victim.stat != DEAD))
		victim.visible_message(
			span_danger("[victim] vomits the blood back up!"),
			span_userdanger("You vomit the blood back up!")
		)
		playsound(get_turf(victim), 'code/modules/wod13/sounds/vomit.ogg', 75, TRUE)
		owner.add_splatter_floor(get_turf(victim))
		return

	// Transfer vampire's reagents through blood
	if (owner.reagents)
		if (length(owner.reagents.reagent_list))
			// Percentage of reagents transferred equal to percentage of blood pool being given
			owner.reagents.trans_to(victim, (amount / (owner.bloodpool + amount)) * owner.reagents.total_volume, transfered_by = owner, methods = VAMPIRE)

	// Give blood as a resource
	victim.bloodpool = clamp(victim.bloodpool + amount, 0, victim.maxbloodpool)

	to_chat(owner, span_notice("You successfully fed [victim] your Vitae."))

	// Cancel using the results of the earlier signal return
	if (drink_signal_return & VITAE_NO_EFFECT)
		return

	to_chat(victim, span_userlove("You feel INCREDIBLE drinking [owner]'s blood..."))

	// Attempt to Embrace if dead, Ghoul if not, bloodbond either way
	if (victim.stat == DEAD)
		embrace(victim)
	else
		ghoul(victim)

	bloodbond(victim)

	if (is_kindred(victim))
		var/datum/species/kindred/species = victim.dna.species
		if (HAS_TRAIT(victim, TRAIT_TORPOR) && COOLDOWN_FINISHED(species, torpor_timer))
			victim.untorpor()

	if (victim.mind)
		if(victim.mind.enslaved_to != owner)
			victim.mind.enslave_mind_to_creator(owner)
			to_chat(victim, span_userdanger("<b>AS PRECIOUS VITAE ENTERS YOUR MOUTH, YOU ARE BLOODBOUND TO [vampire]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b>"))
	if (is_ghoul(victim))
		var/datum/species/ghoul/G = victim.dna.species
		G.master = owner
		G.last_vitae = world.time
	else if (!is_kindred(victim) && !isnpc(victim))
		var/save_data_g = FALSE
		victim.set_species(/datum/species/ghoul)
		victim.clan = null
		var/response_g = input(victim, "Do you wish to keep being a ghoul on your save slot?(Yes will be a permanent choice and you can't go back)") in list("Yes", "No")
		var/datum/species/ghoul/G = victim.dna.species
		G.master = owner
		G.last_vitae = world.time
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

/datum/splat/vampire/kindred/proc/embrace(mob/living/carbon/victim)
	// Check if the victim can be Embraced
	if (!victim.can_embrace())
		to_chat(owner, span_warning("[victim] doesn't respond to your Vitae."))
		return

	// Send signals on vampire and victim, cancel if CANCEL_EMBRACE returned
	var/embrace_signal_return = SEND_SIGNAL(owner, COMSIG_MOB_EMBRACE, victim)
	var/embraced_signal_return = SEND_SIGNAL(victim, COMSIG_MOB_EMBRACED, owner)
	if ((embrace_signal_return | embraced_signal_return) & CANCEL_EMBRACE)
		return

	// Attempt to revive the victim
	if (!victim.revive(full_heal = TRUE, admin_revive = TRUE))
		to_chat(owner, span_warning("[victim] doesn't respond to your Vitae."))
		return
	victim.grab_ghost(force = TRUE)

	log_game("[key_name(owner)] has Embraced [key_name(victim)].")
	message_admins("[ADMIN_LOOKUPFLW(owner)] has Embraced [ADMIN_LOOKUPFLW(victim)].")

	to_chat(victim, span_userdanger("You wake up. What happened? Why are you so hungry? Why is your heart not beating?"))

	// Prompt the victim on if they want to stay a vampire in subsequent rounds
	INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living, save_embraced_character_prompt), owner)

	var/childe_generation = generation + 1
	var/datum/vampireclan/childe_clan = clan
	// Thinbloods are counted as especially sucky Caitiff
	if (childe_generation > 13)
		childe_clan = GLOB.vampire_clans[/datum/vampireclan/caitiff]

	var/datum/splat/vampire/kindred/childe_vampirism = new SPLAT_KINDRED(childe_generation, childe_clan)
	childe_vampirism.assign(victim)

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

/mob/living/proc/save_embraced_character_prompt(mob/living/sire)
	var/datum/splat/vampire/kindred/vampirism = is_kindred(src)
	if (!vampirism)
		return

	// Prompt asking if they want to save this
	var/response = tgui_alert(
		user = src,
		message = "Do you wish to keep being a vampire on your save slot? \
		(This will replace your saved supernatural type and reset supernatural stats!)",
		title = "Stay A Vampire?",
		buttons = list("Yes", "No")
	)

	if (response != "Yes")
		return

	var/datum/preferences/preferences = client.prefs

	// Save splat

	// Save Clan
	if (vampirism.clan.whitelisted && !SSwhitelists.is_whitelisted(ckey, vampirism.clan.name))
		if (sire.clan.name == "True Brujah")
			victim.clan = new /datum/vampireclan/brujah()
			to_chat(victim, span_warning("You don't got that whitelist! Changing to the non WL Brujah"))
		else if (vampire.clan.name == "Tzimisce")
			victim.clan = new /datum/vampireclan/old_clan_tzimisce()
			to_chat(victim,span_warning("You don't got that whitelist! Changing to the non WL Old Tzmisce"))
		else
			to_chat(victim,span_warning("You don't got that whitelist! Changing to a random non WL clan."))
			var/list/non_whitelisted_clans = list(/datum/vampireclan/brujah,/datum/vampireclan/malkavian,/datum/vampireclan/nosferatu,/datum/vampireclan/gangrel,/datum/vampireclan/giovanni,/datum/vampireclan/ministry,/datum/vampireclan/salubri,/datum/vampireclan/toreador,/datum/vampireclan/tremere,/datum/vampireclan/ventrue)
			var/random_clan = pick(non_whitelisted_clans)
			victim.clan = new random_clan
	else
		preferences.clan = vampirism.clan

/datum/splat/vampire/kindred/proc/ghoul(mob/living/carbon/victim)
	if (!is_ghoul(victim) && istype(victim, /mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/NPC = owner.pulling
		NPC.ghoulificate(owner)

/datum/splat/vampire/kindred/proc/bloodbond(mob/living/carbon/victim)
	if (victim.has_status_effect(STATUS_EFFECT_INLOVE))
		victim.remove_status_effect(STATUS_EFFECT_INLOVE)
	victim.apply_status_effect(STATUS_EFFECT_INLOVE, owner)

	message_admins("[ADMIN_LOOKUPFLW(owner)] has bloodbonded [ADMIN_LOOKUPFLW(victim)].")
	log_game("[key_name(owner)] has bloodbonded [key_name(victim)].")

/datum/splat/vampire/kindred/proc/set_generation(generation = 13)
	src.generation = generation
	owner.maxbloodpool = HUMAN_MAXBLOODPOOL + ((13 - generation) * 3)

/datum/splat/vampire/kindred/proc/set_clan(datum/vampireclan/clan)
	if (src.clan && (src.clan != clan))
		src.clan.on_lose(owner)

	src.clan = clan
	clan.on_gain(owner)
	clan.post_gain(owner)

/mob/proc/can_embrace()
	if (HAS_TRAIT(src, TRAIT_CANNOT_BE_EMBRACED))
		return FALSE

	if (stat != DEAD)
		return FALSE

	return TRUE

/mob/living/can_embrace()
	. = ..()
	if (!.)
		return .

	if (timeofdeath + 5 MINUTES <= world.time)
		return FALSE

	if (is_splat_incompatible(SPLAT_KINDRED))
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
	if(!isliving(owner))
		return
	var/mob/living/vampire = owner

	var/datum/splat/vampire/kindred/vampirism = vampire.is_kindred()
	if (!vampirism)
		return

	if (vampirism.get_vitae() < 2)
		to_chat(owner, span_warning("You don't have enough <b>BLOOD</b> to do that!"))
		return

	if (!isliving(vampire.pulling))
		return
	var/mob/living/victim = vampire.pulling

	if (!victim.client && !istype(victim, /mob/living/carbon/human/npc))
		to_chat(owner, span_warning("You need [victim]'s attention to do that!"))
		return

	if (giving)
		return
	giving = TRUE

	owner.visible_message(
		span_warning("[owner] tries to feed [victim] [owner.p_their()] blood!"),
		span_notice("You begin feeding [victim] your Vitae.")
	)

	if(!do_mob(owner, victim, 10 SECONDS))
		giving = FALSE
		return
	giving = FALSE

	vampirism.give_vitae(victim, 2)
