// simple_animal signals
/// called when a simplemob is given sentience from a sentience potion (target = person who sentienced)
#define COMSIG_SIMPLEMOB_SENTIENCEPOTION "simplemob_sentiencepotion"
/// called when a simplemob is given sentience from a consciousness transference potion (target = person who sentienced)
#define COMSIG_SIMPLEMOB_TRANSFERPOTION "simplemob_transferpotion"

// /mob/living/simple_animal/hostile signals
///before attackingtarget has happened, source is the attacker and target is the attacked
#define COMSIG_HOSTILE_PRE_ATTACKINGTARGET "hostile_pre_attackingtarget"
	#define COMPONENT_HOSTILE_NO_ATTACK (1<<0) //cancel the attack, only works before attack happens
///after attackingtarget has happened, source is the attacker and target is the attacked, extra argument for if the attackingtarget was successful
#define COMSIG_HOSTILE_POST_ATTACKINGTARGET "hostile_post_attackingtarget"
///from base of mob/living/basic/feral_squirrel: (mob/living/basic/feral_squirrel/king)
#define COMSIG_SQUIRREL_INTERACT "squirrel_interaction"
	#define COMPONENT_SQUIRREL_INTERACTED (1<<0) //! If this is returned, cancel any further interactions.
///FROM mob/living/simple_animal/hostile/ooze/eat_atom(): (atom/target, edible_flags)
#define COMSIG_OOZE_EAT_ATOM "ooze_eat_atom"
	#define COMPONENT_ATOM_EATEN  (1<<0)


#define COMSIG_HOSTILE_ATTACKINGTARGET "hostile_attackingtarget"
