/**
 * Kiasyd Iron Weakness Component
 *
 * Component to handle the Kiasyd vampire Clan's
 * curse of becoming frenzied whenever they touch
 * or are attacked with iron with a cooldown
 * of 10 seconds between every roll to resist
 * frenzy.
 *
 * Will trigger when attacked with an iron item,
 * picking up an iron item, and repeatedly if
 * an iron item is being held.
 */
/datum/component/kiasyd_iron_weakness
	/// List of items made of iron that the mob is holding or has equipped
	var/list/obj/item/holding_iron
	/// Cooldown for iron causing the parent to enter frenzy
	COOLDOWN_DECLARE(iron_frenzy)

/datum/component/kiasyd_iron_weakness/RegisterWithParent()
	if (!ishuman(parent) || !iskindred(parent))
		return COMPONENT_INCOMPATIBLE

	// Check for iron already held or equipped by the parent
	check_contents_for_iron(parent)

	// Register signals for iron being touched
	RegisterSignal(parent, COMSIG_MOB_ATTACKED_BY_MELEE, PROC_REF(handle_attacked))
	RegisterSignal(parent, COMSIG_LIVING_PICKED_UP_ITEM, PROC_REF(handle_pickup))
	// Register signal for iron items being dropped or put in storage
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(handle_item_exited))

/datum/component/kiasyd_iron_weakness/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_ATTACKED_BY_MELEE)
	UnregisterSignal(parent, COMSIG_LIVING_PICKED_UP_ITEM)
	UnregisterSignal(parent, COMSIG_ATOM_EXITED)

/**
 * Applies the iron weakness to all held or
 * equipped items.
 *
 * Checks the parent's direct contents for items
 * that are made of iron, registering them to
 * trigger the weakness on every process tick.
 * Does not account for items in subcontents as
 * these items are not directly touching the parent.
 *
 * Arguments:
 * * checking_mob - Mob whose contents are being checked for iron.
 */
/datum/component/kiasyd_iron_weakness/proc/check_contents_for_iron(mob/living/checking_mob)
	// Adds all items in the mob's direct contents to the list of held iron items
	// Backpack contents and whatnot don't matter because they're not touching the mob
	for (var/obj/item/item in checking_mob.contents)
		if (!item.is_iron)
			continue

		LAZYADD(holding_iron, item)

	// If no iron's been found, processing isn't necessary
	if (!length(holding_iron))
		return

	// Process repeated frenzy for holding iron items
	START_PROCESSING(SSdcs, src)

/**
 * Triggers the iron weakness whenever the parent
 * is attacked with an iron weapon.
 *
 * Signal handler on COMSIG_MOB_ATTACKED_BY_MELEE to
 * trigger frenzy on the parent whenever they're
 * attacked with a melee weapon made of iron.
 *
 * Arguments:
 * * source - Human being attacked
 * * attacker - Mob doing the attack, unused
 * * item - Weapon used to attack the source with
 */
/datum/component/kiasyd_iron_weakness/proc/handle_attacked(mob/living/carbon/human/source, mob/living/attacker, obj/item/item)
	SIGNAL_HANDLER

	if (!does_trigger_weakness(source, item))
		return

	// Trigger weakness
	to_chat(source, span_danger("<b>IRON!</b>"))
	source.rollfrenzy()

/**
 * Triggers the iron weakness when an iron
 * item is picked up.
 *
 * Signal handler on COMSIG_LIVING_PICKED_UP_ITEM
 * that will immediately trigger frenzy if parent
 * picks up an iron item, and then begins a process
 * to keep triggering frenzy if the item is not
 * dropped or put in a container.
 *
 * Arguments:
 * * source - Human picking the item up
 * * item - Item being picked up
 */
/datum/component/kiasyd_iron_weakness/proc/handle_pickup(mob/living/carbon/human/source, obj/item/item)
	SIGNAL_HANDLER

	if (!does_trigger_weakness(source, item))
		return

	// Trigger weakness
	to_chat(source, span_warning("\The [item] is <b>IRON!</b>"))
	source.rollfrenzy()

	// Start processing repeated weakness triggering if iron stays in inventory
	LAZYADD(holding_iron, item)
	START_PROCESSING(SSdcs, src)

/**
 * Checks if a mob and optionally an item can
 * have the weakness triggered right now.
 *
 * Checks for if the item is iron, checks
 * cooldown and starts it if finished, and
 * makes sure that the source can enter frenzy.
 * Returns FALSE if conditions unmet and TRUE
 * if met, and will delete the component if source
 * is somehow not a Kindred.
 *
 * Arguments:
 * * source - Human being checked for proper conditions to frenzy
 * * item - Item being checked for if it's iron, optional
 */
/datum/component/kiasyd_iron_weakness/proc/does_trigger_weakness(mob/living/carbon/human/source, obj/item/item)
	// Weakness only triggers for iron items
	if (item && !item.is_iron)
		return FALSE

	// Handle 10 second cooldown between triggered frenzies
	if (!COOLDOWN_FINISHED(src, iron_frenzy))
		return FALSE
	COOLDOWN_START(src, iron_frenzy, 10 SECONDS)

	// Make sure the parent is a vampire and can thus frenzy, component unnecessary if not
	if (!iskindred(source))
		qdel(src)
		return FALSE

	// All checks have passed, this item does trigger the weakness for the source
	return TRUE

/**
 * Stops tracking an iron item for triggering
 * the weakness when it's dropped or unequipped.
 *
 * Signal handler for COMSIG_ATOM_EXITED that removes
 * iron items from list of held or equipped items to
 * stop repeatedly triggering the iron weakness on them
 * when they're dropped or put into storage. Unregisters
 * its own signal. If list of iron items is empty, stops
 * processing.
 *
 * Arguments:
 * * source - Mob whose contents the item is exiting
 * * item - Item exiting the mob's contents
 * * newloc - Atom being entered by the item
 */
/datum/component/kiasyd_iron_weakness/proc/handle_item_exited(mob/living/carbon/human/source, obj/item/item, atom/newloc)
	SIGNAL_HANDLER

	if (!LAZYFIND(holding_iron, item))
		return

	// Remove unequipped/dropped/stored item from list of held iron items
	LAZYREMOVE(holding_iron, item)

	// If no more iron items are held, stop processing for repeated weakness triggering
	if (holding_iron)
		return
	STOP_PROCESSING(SSdcs, src)

/datum/component/kiasyd_iron_weakness/process(delta_time)
	// Check for cooldown and prerequisites
	if (!does_trigger_weakness(parent))
		return

	var/mob/living/carbon/human/kiasyd = parent

	// Warn the player of the iron item they're holding or have equipped
	for (var/obj/item/item in holding_iron)
		to_chat(kiasyd, span_warning("\The [item] is <b>IRON!</b>"))

	kiasyd.rollfrenzy()
