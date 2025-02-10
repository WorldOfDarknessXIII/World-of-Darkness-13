#define ADJUST_GNOSIS(num, M) SEND_SIGNAL(M, COMSIG_ADJUST_GNOSIS, num)

// what splat are you?
#define retrieve_splat_bitfield(A) ( SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) )
#define get_splats(A) retrieve_splat_bitfield(A)
#define splatted_kindred(A) (  SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & KINDRED_SPLAT )
#define iskindred(A) splatted_kindred(A)
#define splatted_ghoul(A) ( SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & GHOUL_SPLAT )
#define isghoul(A) splatted_ghoul(A)
#define splatted_garou(A) ( SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & GAROU_SPLAT )
#define isgarou(A) splatted_garou(A)
#define splatted_kuejin(A) ( SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & KUEJIN_SPLAT )
#define iskuejin(A) splatted_kuejin(A)
// we wanna account for stuff only humans can do, for hunters, and the like
#define splatted_pure_human(A) ( SEND_SIGNAL(A, COMSIG_SPLAT_SPLAT_CHECKED) & PURE_HUMAN_SPLAT )
#define is_pure_human(A) splatted_pure_human(A)
#define isknowledge(A) (istype(A, /datum/knowledge))
#define ismerit(A) (istype(A, /datum/merit))

#define HAS_MERIT(target, merit) {\
	var/merit_status = SEND_SIGNAL(target, CHECK_MERIT(merit));\
	if(merit_status == COMPONENT_HAS_MERIT){\
		return TRUE;\
	}\
	if(merit_status == COMPONENT_MERIT_INACTIVE){\
		return FALSE;\
	}\
	return FALSE;\
}

#define GET_MERIT_STATUS(target, merit) SEND_SIGNAL(target, CHECK_MERIT(merit))

#define get_knowledge_type(target, knowledge_type) {
	if(!isliving(user) && !istype(user, /datum/mind)){\
		return FALSE;\
	}\
	if(!is_text(knowledge_type)){\
		if(!is_path(knowledge_type, /datum/knowledge))
			if(!isknowledge(knowledge_type))
				CRASH("get_knowledge_type: Invalid knowledge type passed to function.");\
			var/knowledge = GLOB.knowledge_types[knowledge_type];\
		return FALSE;\
	}\
	if(istype(target, /datum/mind)){\
		var/datum/mind/target_mind = target;\
		return target_mind.knowledge[knowledge_type];\
	}
}
