// Macros for obtaining stats specifically in storyteller rolls
#define attribute_mentality(T) T.get_total_mentality()
#define attribute_physique(T) T.get_total_physique()
#define attribute_social(T) T.get_total_social()
#define attribute_dexterity(T) T.get_total_dexterity()
#define attribute_lockpicking(T) T.get_total_lockpicking()
#define attribute_athletics(T)	T.get_total_athletics()

// Flat outcomes
#define ROLL_BOTCH -1
#define ROLL_FAILURE 0
#define ROLL_SUCCESS 1
