/datum/brain_trauma/special/imaginary_friend/consumed_soul
	name = "Consumed Soul"
	desc = "Tormented by someone whose soul they consumed."
	random_gain = FALSE
	var/mob/living/old_body

/datum/brain_trauma/special/imaginary_friend/consumed_soul/New(mob/living/soul)
	old_body = soul

	. = ..()

/datum/brain_trauma/special/imaginary_friend/consumed_soul/make_friend()
	friend = new /mob/camera/imaginary_friend/consumed_soul(get_turf(owner), src)

/datum/brain_trauma/special/imaginary_friend/trapped_owner/reroll_friend()
	if (friend.client) //reconnected
		return
	friend_initialized = FALSE
	QDEL_NULL(friend)
	qdel(src)

/datum/brain_trauma/special/imaginary_friend/consumed_soul/get_ghost()
	return

/mob/camera/imaginary_friend/consumed_soul
	name = "consumed soul"
	real_name = "consumed soul"
	desc = "A passenger in your body."

/mob/camera/imaginary_friend/consumed_soul/setup_friend()
	var/datum/brain_trauma/special/imaginary_friend/consumed_soul/consumed_soul
	var/mob/living/old_body = consumed_soul.old_body

	gender = old_body.gender
	name = old_body.name
	real_name = old_body.real_name
	human_image = old_body.icon

	key = old_body.key

/mob/camera/imaginary_friend/consumed_soul/greet()
	to_chat(src, span_warning("[owner] has consumed your soul, and now you inhabit [owner.p_their()] body as a passenger."))


