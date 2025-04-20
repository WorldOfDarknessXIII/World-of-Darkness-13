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

	// Register relevant signals
	RegisterSignal(owner, COMSIG_MOB_DRINK_VITAE, PROC_REF(handle_drinking_vitae))
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(handle_death))

	//this needs to be adjusted to be more accurate for blood spending rates
	add_power(/datum/discipline/bloodheal, clamp(11 - generation, 1, 10))

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

	to_chat(victim, span_userdanger("You wake up. What happened? Why are you so hungry? Why is your heart not beating?"))

	log_game("[key_name(owner)] has Embraced [key_name(victim)].")
	message_admins("[ADMIN_LOOKUPFLW(owner)] has Embraced [ADMIN_LOOKUPFLW(victim)].")

	// Prompt the victim on if they want to stay a vampire in subsequent rounds
	INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living, save_embraced_character_prompt), owner)

	// If an NPC was Embraced, prompt ghosts to play as them
	if (isnpc(victim))
		var/mob/living/carbon/human/npc/npc_victim = victim
		INVOKE_ASYNC(npc_victim, TYPE_PROC_REF(/mob/living/carbon/human/npc, poll_ghosts_for_kindred), owner)

	// Create vampire splat for the childe
	var/childe_generation = generation + 1
	var/datum/vampireclan/childe_clan = clan
	// Thinbloods are counted as especially sucky Caitiff
	if (childe_generation > 13)
		childe_clan = /datum/vampireclan/caitiff

	var/datum/splat/vampire/kindred/childe_vampirism = new /datum/splat/vampire/kindred(childe_generation, childe_clan)
	childe_vampirism.assign(victim)

	//Gives the Childe the Sire's first three Disciplines
	var/list/disciplines_to_give = list()
	for (var/i in 1 to min(3, powers.len))
		childe_vampirism.add_power(powers[i].type, 1)

/mob/living/proc/save_embraced_character_prompt()
	if (!client)
		return

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
	preferences.splat = /datum/splat/vampire/kindred
	preferences.generation = 13

	// Save Clan
	if (vampirism.clan.whitelisted && !SSwhitelists.is_whitelisted(ckey, vampirism.clan.name))
		var/list/datum/vampireclan/available_clans = list()
		for (var/datum/vampireclan/checking_clan in GLOB.vampire_clans)
			if (checking_clan.whitelisted)
				if (!SSwhitelists.is_whitelisted(ckey, checking_clan.name))
					continue

			available_clans += checking_clan

		var/datum/vampireclan/choice = tgui_input_list(
			user = src,
			message = "You aren't whitelisted for your sire's Clan. Choose a Clan instead.",
			title = "Clan Selection",
			items = sortList(available_clans),
			default = /datum/vampireclan/caitiff
		)

		preferences.clan = choice
	else
		preferences.clan = vampirism.clan

	// Save Disciplines
	preferences.discipline_types = list(vampirism.powers[1].type, vampirism.powers[2].type, vampirism.powers[3].type)
	preferences.discipline_levels = list(1, 1, 1)

	// Finalise
	preferences.save_character()

/datum/splat/vampire/kindred/proc/ghoul(mob/living/carbon/victim)
	if (victim.is_splat_incompatible(/datum/splat/vampire/ghoul))
		return

	var/signal_return = SEND_SIGNAL(owner, COMSIG_MOB_GHOUL, victim) | SEND_SIGNAL(victim, COMSIG_MOB_GHOULED, owner)
	if (signal_return & CANCEL_GHOUL)
		return

	// Invite ghosts to play as the new ghoul
	if (isnpc(victim))
		var/mob/living/carbon/human/npc/npc_victim = victim
		INVOKE_ASYNC(npc_victim, TYPE_PROC_REF(/mob/living/carbon/human/npc, poll_ghosts_for_ghoul), owner)

	// Ask the ghouled player if they want to stay a ghoul on their save slot
	INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob/living, save_ghouled_character_prompt))

	// Apply the splat
	var/datum/splat/vampire/ghoul/ghoul = new(owner)
	ghoul.assign(victim)

/mob/living/proc/save_ghouled_character_prompt()
	if (!client)
		return

	var/datum/splat/vampire/ghoul/ghoul = is_ghoul(src)
	if (!ghoul)
		return

	// Prompt asking if they want to save this
	var/response = tgui_alert(
		user = src,
		message = "Do you wish to keep being a ghoul on your save slot? \
		(This will replace your saved supernatural type and reset supernatural stats!)",
		title = "Stay A Ghoul?",
		buttons = list("Yes", "No")
	)
	if (response != "Yes")
		return

	var/datum/preferences/preferences = client.prefs

	// Save splat
	preferences.splat = /datum/splat/vampire/ghoul

	// Finalise
	preferences.save_character()

/datum/splat/vampire/kindred/proc/bloodbond(mob/living/victim)
	if (!victim.mind)
		return
	if (victim.mind.enslaved_to == owner)
		return

	// Send signals on vampire and victim
	var/signal_return = SEND_SIGNAL(owner, COMSIG_MOB_BLOODBOND, victim) | SEND_SIGNAL(victim, COMSIG_MOB_BLOODBONDED, owner)
	if (signal_return & CANCEL_BLOODBOND)
		return

	if (victim.has_status_effect(STATUS_EFFECT_INLOVE))
		victim.remove_status_effect(STATUS_EFFECT_INLOVE)
	victim.apply_status_effect(STATUS_EFFECT_INLOVE, owner)

	victim.mind.enslave_mind_to_creator(owner)
	to_chat(victim, span_userdanger("<b>AS PRECIOUS VITAE ENTERS YOUR MOUTH, YOU ARE BLOODBOUND TO [owner]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b>"))

	message_admins("[ADMIN_LOOKUPFLW(owner)] has bloodbonded [ADMIN_LOOKUPFLW(victim)].")
	log_game("[key_name(owner)] has bloodbonded [key_name(victim)].")

	// Reassign Ghoul's regnant on being blood bonded by another Kindred
	var/datum/splat/vampire/ghoul/ghoul = is_ghoul(victim)
	if (ghoul)
		ghoul.regnant = owner

/datum/splat/vampire/kindred/proc/set_generation(generation = 13)
	src.generation = generation
	owner.maxbloodpool = HUMAN_MAXBLOODPOOL + ((13 - generation) * 3)

/datum/splat/vampire/kindred/proc/set_clan(datum/vampireclan/clan)
	if (src.clan && (src.clan != clan))
		src.clan.on_lose(owner)

	src.clan = clan
	clan.on_gain(owner)
	clan.post_gain(owner)

/datum/splat/vampire/kindred/proc/handle_drinking_vitae(mob/living/source, mob/living/vampire, amount)
	SIGNAL_HANDLER

	// If they can leave Torpor, drinking Vitae will force them out of it
	if (HAS_TRAIT(owner, TRAIT_TORPOR) && COOLDOWN_FINISHED(src, torpor_timer))
		owner.untorpor()

/datum/splat/vampire/kindred/proc/handle_death(mob/living/source, gibbed)
	SIGNAL_HANDLER

	ADD_TRAIT(source, TRAIT_CANNOT_BE_EMBRACED, VAMPIRE_TRAIT)

	SEND_SOUND(source, sound('code/modules/wod13/sounds/final_death.ogg', 0, 0, 50))

	source.ghostize(FALSE)

	if (!ishuman(source))
		return
	var/mob/living/carbon/human/vampire = source

	if (HAS_TRAIT(vampire, TRAIT_IN_FRENZY))
		vampire.exit_frenzymod()

	var/years_undead = vampire.chronological_age - vampire.age
	switch (years_undead)
		if (-INFINITY to 10) //normal corpse
			return
		if (10 to 50)
			vampire.rot_body(1) //skin takes on a weird colouration
			vampire.visible_message(span_notice("[src]'s skin loses some of its colour."))
			vampire.update_body()
		if (50 to 100)
			vampire.rot_body(2) //looks slightly decayed
			vampire.visible_message(span_notice("[src]'s skin rapidly decays."))
			vampire.update_body()
		if (100 to 150)
			vampire.rot_body(3) //looks very decayed
			vampire.visible_message(span_warning("[src]'s body rapidly decomposes!"))
			vampire.update_body()
		if (150 to 200)
			vampire.rot_body(4) //mummified skeletonised corpse
			vampire.visible_message(span_warning("[src]'s body rapidly skeletonises!"))
			vampire.update_body()
		if (200 to INFINITY)
			playsound(vampire, 'code/modules/wod13/sounds/burning_death.ogg', 80, TRUE)
			if (is_kuei_jin(vampire))
				playsound(vampire, 'code/modules/wod13/sounds/vicissitude.ogg', 80, TRUE)
			vampire.lying_fix()
			vampire.dir = SOUTH
			INVOKE_ASYNC(vampire, TYPE_PROC_REF(/mob/living/carbon/human, dust), TRUE, TRUE)

/mob/living/carbon/can_embrace()
	// Can only Embrace humans and shapeshifted Garou
	if (!istype(src, /mob/living/carbon/werewolf) && !ishuman(src))
		return FALSE

	if (HAS_TRAIT(src, TRAIT_CANNOT_BE_EMBRACED))
		return FALSE

	if (stat != DEAD)
		return FALSE

	// Cannot Embrace more than 5 minutes after death
	if (timeofdeath + 5 MINUTES <= world.time)
		return FALSE

	if (is_splat_incompatible(/datum/splat/vampire/kindred))
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
