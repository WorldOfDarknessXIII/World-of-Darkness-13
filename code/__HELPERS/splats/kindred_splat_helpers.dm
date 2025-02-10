 #define ADHERES_TO_MASQUERADE(target) {\
	if(!is_kindred(target) && !is_ghoul(target)){\
		return FALSE;}\
	if(is_sabbat(target)){\
		return FALSE;}\
	return TRUE;\
}

#define CAN_LEARN_DISCIPLINES(target) {\
	if(!iskindred(target) && !isghoul(target)){\
		return FALSE;}\
	return TRUE;\
}

#define MASQUERADE(target) ( SSmasquerade.scores[target] )
#define HAS_DISCIPLINE(target, discipline) {\
	if(!CAN_LEARN_DISCIPLINES(target)){\
		return FALSE;}\
	if(!isdiscipline(discipline)){\
		CRASH("HAS_DISCIPLINE: Invalid discipline passed to function.");\
		return FALSE;}\
	return discipline_knowledge.knows_discipline(discipline);\
}

#define GET_DISCIPLINE(owner, discipline) {\
	if(!HAS_DISCIPLINE(owner, discipline)){\
		return FALSE;}\
	var/datum/knowledge/discipline/discipline_knowledge = SSdisciplines.users[owner];\
	return discipline_knowledge.get_discipline(discipline);\
}
