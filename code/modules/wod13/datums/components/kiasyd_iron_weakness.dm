/datum/component/kiasyd_iron_weakness
	COOLDOWN_DECLARE(cold_iron_frenzy)

/datum/component/kiasyd_iron_weakness/RegisterWithParent()
	if (!ishuman(parent) || !iskindred(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_MOB_ATTACKED_BY_MELEE, PROC_REF(handle_attacked))
	// TODO: [Lucia] what's the signal for a mob picking an item up????

/datum/component/kiasyd_iron_weakness/proc/handle_attacked(mob/living/carbon/human/source, mob/living/attacker, obj/item/weapon)
	SIGNAL_HANDLER

	// Weakness only triggers for iron weapons
	if (!weapon.is_iron)
		return

	// Handle 10 second cooldown between triggered frenzies
	if (!COOLDOWN_FINISHED(src, cold_iron_frenzy))
		return
	COOLDOWN_START(src, cold_iron_frenzy, 10 SECONDS)

	// Make sure the parent is a vampire and can thus frenzy
	if (!iskindred(parent))
		qdel(src)
		return

	to_chat(parent, span_danger("<b>COLD IRON!</b>"))
	source.rollfrenzy()

/datum/component/kiasyd_iron_weakness/proc/handle_pickup()
	return


