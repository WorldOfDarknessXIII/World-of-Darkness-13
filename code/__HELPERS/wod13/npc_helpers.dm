#define WITNESS_CRIME(npc, perpetrator, crime) (SEND_SIGNAL(npc, COMSIG_WITNESS_CRIME, crime, perpetrator) & COMPONENT_REPORT_CRIME)

#define REPORT_CRIME(perpetrator, crime_type, crime_location...) {\
	if(!crime_location){\
		SShumannpcpool.report_crime(perpetrator, crime_type);}\
	else{\
		SShumannpcpool.report_crime(perpetrator, crime_type, crime_location);}\
}
