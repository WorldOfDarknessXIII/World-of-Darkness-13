/// Tests to ensure humans, plasmamen, and ashwalkers can breath in normal situations.
/// Ensures algorithmic correctness of the "breathe()" and "toggle_internals()" procs.
/// Built to prevent regression on an issue surrounding QUANTIZE() and BREATH_VOLUME.
/// See the comment on BREATH_VOLUME for more details.
/datum/unit_test/breath
	abstract_type = /datum/unit_test/breath

/// Equips the given Human with a new instance of the given tank type and a breathing mask.
/// Returns the new equipped tank.
/datum/unit_test/breath/proc/equip_labrat_internals(mob/living/carbon/human/lab_rat, tank_type)
	var/obj/item/clothing/mask/breath/mask = allocate(/obj/item/clothing/mask/breath)
	var/obj/item/tank/internals/source = allocate(tank_type)
	lab_rat.equip_to_slot_if_possible(mask, ITEM_SLOT_MASK)
	lab_rat.equip_to_slot_if_possible(source, ITEM_SLOT_HANDS)
	return source

/datum/unit_test/breath/breath_sanity/Run()
	// Breathing from turf.
	var/mob/living/carbon/human/lab_rat = allocate(/mob/living/carbon/human/consistent)
	lab_rat.forceMove(run_loc_floor_bottom_left)
	var/turf/open/to_fill = run_loc_floor_bottom_left
	to_fill.initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	lab_rat.breathe()

	// Breathing from standard internals tank.
	lab_rat = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/tank/internals/source = equip_labrat_internals(lab_rat, /obj/item/tank/internals/emergency_oxygen)
	lab_rat.breathe()
	if(!isnull(lab_rat.internal))
		TEST_ASSERT(source.toggle_internals(lab_rat) && isnull(lab_rat.internal), "toggle_internals() failed to close internals")

	// Empty internals suffocation.
	lab_rat = allocate(/mob/living/carbon/human/consistent)
	source = equip_labrat_internals(lab_rat, /obj/item/tank/internals/emergency_oxygen/empty)
	TEST_ASSERT(source.toggle_internals(lab_rat) && !isnull(lab_rat.internal), "Plasmaman toggle_internals() failed to toggle internals")
	lab_rat.breathe()

	// Nitrogen internals suffocation.
	lab_rat = allocate(/mob/living/carbon/human/consistent)
	source = equip_labrat_internals(lab_rat, /obj/item/tank/internals/emergency_oxygen/empty)
	source.air_contents.assert_gas(/datum/gas/nitrogen)
	source.air_contents.gases[/datum/gas/nitrogen][MOLES] = (10 * ONE_ATMOSPHERE) *  source.volume / (R_IDEAL_GAS_EQUATION * T20C)
	TEST_ASSERT(source.toggle_internals(lab_rat) && !isnull(lab_rat.internal), "Plasmaman toggle_internals() failed to toggle internals")
	lab_rat.breathe()

/datum/unit_test/breath/breath_sanity/Destroy()
	//Reset initial_gas_mix to avoid future issues on other tests
	var/turf/open/to_fill = run_loc_floor_bottom_left
	to_fill.initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	return ..()

