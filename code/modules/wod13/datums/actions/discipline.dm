/datum/action/discipline
	check_flags = NONE
	button_icon = 'code/modules/wod13/UI/actions.dmi' //This is the file for the BACKGROUND icon
	background_icon_state = "discipline" //And this is the state for the background icon
	icon_icon = 'code/modules/wod13/UI/actions.dmi' //This is the file for the ACTION icon
	button_icon_state = "discipline" //And this is the state for the action icon

	vampiric = TRUE
	var/level_icon_state = "1" //And this is the state for the action icon
	var/datum/discipline/discipline
	var/targeting = FALSE

/datum/action/discipline/New(datum/discipline/discipline)
	. = ..()
	src.discipline = discipline

/datum/action/discipline/Grant(mob/M)
	. = ..()
	discipline.assign(M)

	register_to_availability_signals()

/datum/action/discipline/proc/register_to_availability_signals()
	//this should only go through if it's the first Discipline gained by the mob
	for (var/datum/action/action in owner.actions)
		if (action == src)
			continue
		if (istype(action, /datum/action/discipline))
			return

	//irrelevant for NPCs
	if (!owner.client)
		return

	var/list/relevant_signals = list(
		SIGNAL_ADDTRAIT(TRAIT_TORPOR),
		SIGNAL_REMOVETRAIT(TRAIT_TORPOR),
		SIGNAL_ADDTRAIT(TRAIT_KNOCKEDOUT),
		SIGNAL_REMOVETRAIT(TRAIT_KNOCKEDOUT),
		SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
		SIGNAL_REMOVETRAIT(TRAIT_INCAPACITATED),
		SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED),
		SIGNAL_REMOVETRAIT(TRAIT_IMMOBILIZED),
		SIGNAL_ADDTRAIT(TRAIT_FLOORED),
		SIGNAL_REMOVETRAIT(TRAIT_FLOORED),
		SIGNAL_ADDTRAIT(TRAIT_BLIND),
		SIGNAL_REMOVETRAIT(TRAIT_BLIND),
		SIGNAL_ADDTRAIT(TRAIT_MUTE),
		SIGNAL_REMOVETRAIT(TRAIT_MUTE),
		SIGNAL_ADDTRAIT(TRAIT_HANDS_BLOCKED),
		SIGNAL_REMOVETRAIT(TRAIT_HANDS_BLOCKED),
		SIGNAL_ADDTRAIT(TRAIT_PACIFISM),
		SIGNAL_REMOVETRAIT(TRAIT_PACIFISM),
	)

	RegisterSignal(owner, relevant_signals, TYPE_PROC_REF(/mob, update_action_buttons))

/datum/action/discipline/IsAvailable()
	return discipline.current_power.can_activate_untargeted()

/datum/action/discipline/Trigger()
	. = ..()

	UpdateButtonIcon()

	//easy de-targeting
	if (targeting)
		end_targeting()
		. = FALSE
		return .

	//cancel targeting of other Disciplines when one is activated
	for (var/datum/action/action in owner.actions)
		if (istype(action, /datum/action/discipline))
			var/datum/action/discipline/other_discipline = action
			other_discipline.end_targeting()

	//ensure it's actually possible to trigger this
	if (!discipline?.current_power || !isliving(owner))
		. = FALSE
		return .

	var/datum/discipline_power/power = discipline.current_power
	if (power.active) //deactivation logic
		if (power.cancelable || power.toggled)
			power.try_deactivate(direct = TRUE, alert = TRUE)
		else
			to_chat(owner, span_warning("[power] is already active!"))
	else //activate
		if (power.target_type == NONE) //self activation
			power.try_activate()
		else //ranged targeted activation
			begin_targeting()

	UpdateButtonIcon()

	return .

/datum/action/discipline/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	button_icon = 'code/modules/wod13/UI/actions.dmi'
	icon_icon = 'code/modules/wod13/UI/actions.dmi'
	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays(TRUE)
		if(discipline)
			current_button.name = discipline.current_power.name
			current_button.desc = discipline.current_power.desc
			current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.icon_state]"))
			current_button.button_icon_state = "[discipline.icon_state]"
			current_button.add_overlay(mutable_appearance(icon_icon, "[discipline.level_casting]"))
		else
			current_button.add_overlay(mutable_appearance(icon_icon, button_icon_state))
			current_button.button_icon_state = button_icon_state

/datum/action/discipline/proc/switch_level(to_advance = 1)
	SEND_SOUND(owner, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))

	if (discipline.level_casting + to_advance > length(discipline.known_powers))
		discipline.level_casting = 1
	else if (discipline.level_casting + to_advance < 1)
		discipline.level_casting = length(discipline.known_powers)
	else
		discipline.level_casting += to_advance

	if (targeting)
		end_targeting()

	discipline.current_power = discipline.known_powers[discipline.level_casting]
	if (button)
		ApplyIcon(button, TRUE)

	UpdateButtonIcon()

/datum/action/discipline/proc/end_targeting()
	var/client/client = owner?.client
	if (!client)
		return
	if (!targeting)
		return

	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	targeting = FALSE
	owner.discipline_targeting = FALSE
	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)

/datum/action/discipline/proc/handle_click(mob/source, atom/target, click_parameters)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(click_parameters)

	//ensure we actually need a target, or cancel on right click
	if (!targeting || modifiers["right"])
		SEND_SOUND(owner, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))
		end_targeting()
		return

	//actually try to use the Discipline on the target
	spawn()
		if (discipline.current_power.try_activate(target))
			end_targeting()

	return COMSIG_MOB_CANCEL_CLICKON

/datum/action/discipline/proc/begin_targeting()
	var/client/client = owner?.client
	if (!client)
		return
	if (targeting)
		return
	if (!discipline.current_power.can_activate_untargeted(TRUE))
		return
	SEND_SOUND(owner, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(handle_click))
	targeting = TRUE
	owner.discipline_targeting = TRUE
	client.mouse_pointer_icon = 'icons/effects/mouse_pointers/discipline.dmi'

/atom/movable/screen/movable/action_button/Click(location, control, params)
	if(istype(linked_action, /datum/action/discipline))
		var/list/modifiers = params2list(params)

		//increase on right click, decrease on shift right click
		if(LAZYACCESS(modifiers, "right"))
			var/datum/action/discipline/discipline = linked_action
			if (LAZYACCESS(modifiers, "alt"))
				discipline.switch_level(-1)
			else
				discipline.switch_level(1)
			return
		//TODO: middle click to swap loadout
	. = ..()
