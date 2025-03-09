/* 												Merits
 * In many cases it'll be better for us to use traits to determine things like damage resistance,
 * status effects, etc etc, but merits in the tabletop often have accompanying abilities, special effects
 * not covered under having a trait, or instances where it would be wasteful or bad code hygiene to define
 * generics on abstract classes: special attacks, psychic powers, and so on. We'll usually be triggering
 * merits with signals that the merits will register when the person gains them.
 * 		Name: The name of the merit, for players who check their merits
 * 		Desc: A description of the merit, telling a player what it does
 * 		Dots: An associated list of merit holders to bitfield components signifying how many dots
 * they have in the merit. If merits have escalating/varying effects, we should utilize a proc on the
 * merit to indicate that information for each dot.
 * 		Generic: If this is set to 1, the merit will not be generated during startup as a singleton; this
 * is so we don't have to throw merits onto dozens to hundreds of players, dozens to hundreds of NPCs, dozens
 * to hundreds of other datums, and so on. Just signal something to see if it has the merit and keep on balling.
 * 		Merit_ID: This should be the define we use to refer to this merit, not it's name; so, MERIT_SIXTH_SENSE,
 * MERIT_BRAWLING, and so on.
 * 		dot_names: When a merit has different names for each dot (DOT_1 Uppercut, DOT_2 Low blow) we use this list
 * to reflect that to the user. It's a normal list, not an associative one. Otherwise, it's null.
 * 		Gain/Lose: Respectively, called when the merit is going to be gained or lost. This is where we'll handle
 * restrictions and/or requirements: some merits can only be had by vampires, some can be had by vampires and ghouls,
 * while others stipulate you CANNOT be a thing or have a particular condition if you want to possess that
 * merit.
 * 		on_gain/on_loss: These are called when the merit is gained or lost. Where we actually implement the
 * effects of the merit; this will always be called to at least register the signal used to track who has this
 * merit.
 * 		merit_checked: This is the signal handler for the merit being checked. Merits are usually always active
 * but there are some instances where merits are rendered inert, so we have some logic to account for that.
 * 		merit_active_for: This is a proc that returns TRUE if the merit is active, and FALSE if it is not. Usually
 * going to be true but if you're unconscious, your quick footwork merit probably isn't doing you any good.
 * 												Supernatural Merits
 * 		restricted_to: A bitfield of splats that can have this merit. If you don't have one of these splats
 * you can't have this merit. Use the SPLAT_DEFINE bit defines to make this.
 * 			IE: SPLAT_KINDRED | SPLAT_GHOUL | SPLAT KUEJIN
 * 		exclusive_with: A bitfield of splats that cannot have this merit. If you have one of these splats, you CANNOT
 * have this merit, and if you gain one of these splats, you lose this merit.
 * 												Human merits
 * 		These are merits exclusive to humans, which is to say, they cannot have any supernatural splats.
 *		Whatever it is in the World of Darkness that uniquely defines humanity -- whether it's some aspect
 *		of the human soul, the integral nature of the human condition, or maybe just something as simple as
 *		the slight genetic differences that make us human -- it's what makes these merits exclusive to humans.
 *		These are usually going to be things like a sixth sense for the supernatural, an ability to resist
 *		supernatural powers despite having no power stat of their own, or a simple grit and determination that
 *		lets them face down the horrors of the night when another person would die screaming.
 *		Gain(): Checks to make sure they're actually already a pure human before granting it
 *		on_gain(): Also registers a signal for gaining splats; any supernatural splat being gained will remove
 *		this merit.
 *
 * 												Merit activation
 * 		Some merits have more active or reactive effects, such as granting special moves, actions, abilities, or
 * 		emitting some effect in some circumstance. In almost all of these cases we'll want to invoke that by
 * 		sending an appropriate SIGNAL with the relevant arguments to the merit holder, or in the case of things like
 * 		psychic abilities, knowledge of rituals, or fighting moves, granting an action to the merit holder when
 * 		the merit is gained.
*/


// If you create a new merit, make sure you set its generic to 0, otherwise it won't be generated during
// startup
/datum/merit
	var/name
	var/desc
	// An associative list of merit holders to components signifying how many dots they have in the merit
	// holder : COMPONENT_ONE_DOT_MERIT
	// other_holder : COMPONENT_TWO_DOT_MERIT
	var/list/dots
	var/generic = 1
	/// This should be the define we use to refer to this merit, not it's name; the name is for players,
	/// and the ID is what we use in the code
	var/merit_id
	var/dot_names = null

/// This is called when the merit is gained
/// merit_receiver is the mob that gained the merit
/datum/merit/proc/Gain(atom/merit_receiver)
	on_gain(merit_receiver)

///Take three guesses what this is for and what it does
/datum/merit/proc/Lose(atom/merit_receiver)
	on_loss(merit_receiver)

/// This will almost in all cases be a living mob, but it's not absolutely unheard of for a car, building, or weapon
/// to have merits
/datum/merit/proc/on_gain(atom/merit_receiver)
	RegisterSignal(merit_receiver, MERIT_CHECK(merit_id), PROC_REF(merit_checked))

/datum/merit/proc/on_loss(atom/merit_receiver)
	UnregisterSignal(merit_receiver, MERIT_CHECK(merit_id))

/datum/merit/proc/merit_checked(datum/source, atom/merit_holder)
	SIGNAL_HANDLER

	if(merit_active_for(source))
		return dots[merit_holder]
	return COMPONENT_MERIT_INACTIVE

/datum/merit/proc/merit_active_for(atom/merit_holder)
	return TRUE

/datum/merit/supernatural
	// You need one of these splats to have this merit
	// Use the SPLAT_DEFINE bitfield to define this
	// IE: SPLAT_KINDRED | SPLAT_GHOUL | SPLAT KUEJIN
	var/restricted_to = NONE
	// You CANNOT have one of this splats if you want this merit
	// The same as above
	var/exclusive_with = NONE

/// Merits exclusive to humans, which is to say, they cannot have any supernatural splats
/datum/merit/human
