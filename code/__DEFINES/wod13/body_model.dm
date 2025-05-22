/// Discards body model from limbs_id to find the mob's alternative sprite
#define GET_BODY_SPRITE(human) (copytext(human.dna.species.limbs_id, human.base_body_mod ? 2 : 1))
/// Checks if the given human has a normal human body sprite
#define NORMAL_BODY_SPRITE(human) (GET_BODY_SPRITE(human) == "human")

/// String prefixed to limbs_id for the slim body model
#define SLIM_BODY_MODEL "s"
/// String prefixed to limbs_id for the normal body model
#define NORMAL_BODY_MODEL ""
/// String prefixed to limbs_id for the fat body model
#define FAT_BODY_MODEL "f"

/// Numerical representation of the slim body model
#define SLIM_BODY_MODEL_NUMBER 1
/// Numerical representation of the normal body model
#define NORMAL_BODY_MODEL_NUMBER 2
/// Numerical representation of the fat body model
#define FAT_BODY_MODEL_NUMBER 3
