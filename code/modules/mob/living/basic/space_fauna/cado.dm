/// Reskin of the Morph as 'Cado, the morph still exists but events/antag info/blessing has been changed to mention this file instead
/mob/living/basic/cado
	name = "cado"
	real_name = "cado"
	desc = "A galatic-famous mukbang youtuber, he dons his signature red shirt and black shorts, carrying around a camera to record himself eating several objects and people on the station."
	speak_emote = list("says")
	icon = 'icons/mob/simple/animal.dmi'
	icon_state = "cado"
	icon_living = "cado"
	icon_dead = "cado_dead"
	death_sound = 'sound/creatures/cado_death_scream.ogg'
	istate = ISTATE_HARM | ISTATE_BLOCKING

	mob_biotypes = MOB_BEAST
	pass_flags = PASSTABLE

	maxHealth = 225
	health = 225
	habitable_atmos = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	bodytemp_cold_damage_limit = TCMB

	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 20
	melee_attack_cooldown = CLICK_CD_MELEE

	attack_verb_continuous = "mukbangs"
	attack_verb_simple = "mukbang"
	attack_sound = 'sound/effects/blobattack.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE //nom nom nom
	butcher_results = list(/obj/item/food/meat/slab = 2)

	ai_controller = /datum/ai_controller/basic_controller/morph

	/// A weakref pointing to the form we are currently assumed as.
	var/datum/weakref/form_weakref = null
	/// A typepath pointing of the form we are currently assumed as. Remember, TYPEPATH!!!
	var/atom/movable/form_typepath = null
	/// The ability that allows us to disguise ourselves.
	var/datum/action/cooldown/mob_cooldown/assume_form/disguise_ability = null

	/// How much damage are we doing while disguised?
	var/melee_damage_disguised = 0
	/// Can we eat while disguised?
	var/eat_while_disguised = FALSE

/mob/living/basic/cado/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	RegisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, PROC_REF(pre_attack))
	RegisterSignal(src, COMSIG_CLICK_SHIFT, PROC_REF(trigger_ability))
	RegisterSignal(src, COMSIG_ACTION_DISGUISED_APPEARANCE, PROC_REF(on_disguise))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_DISGUISED), PROC_REF(on_undisguise))

	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/content_barfer)
	AddElement(/datum/element/prevent_attacking_of_types, GLOB.typecache_general_bad_hostile_attack_targets, "this tastes awful!") // MONKESTATION ADDITION

	disguise_ability = new(src)
	disguise_ability.Grant(src)

/mob/living/basic/cado/examine(mob/user)
	if(!HAS_TRAIT(src, TRAIT_DISGUISED))
		return ..()

	var/atom/movable/form_reference = form_weakref.resolve()
	if(!isnull(form_reference))
		. = form_reference.examine(user)

	if(get_dist(user, src) <= 3) // always add this because if the form_reference somehow nulls out we still want to have something look "weird" about an item when someone is close
		. += span_warning("It looks as if it's always been two steps ahead...")
/mob/living/basic/cado/med_hud_set_health()
	if(isliving(form_typepath))
		return ..()

	//we hide medical hud while in regular state or an item
	var/image/holder = hud_list[HEALTH_HUD]
	holder.icon_state = null

/mob/living/basic/cado/med_hud_set_status()
	if(isliving(form_typepath))
		return ..()

	//we hide medical hud while in regular state or an item
	var/image/holder = hud_list[STATUS_HUD]
	holder.icon_state = null

/mob/living/basic/cado/death(gibbed)
	if(HAS_TRAIT(src, TRAIT_DISGUISED))
		visible_message(
			span_warning("[src] reveals his true form, before collapsing dead and exploding!"),
			span_userdanger("Your skin ruptures! Your flesh breaks apart! No disguise can ward off de--"),
		)

	return ..()

/mob/living/basic/cado/can_track(mob/living/user)
	if(!HAS_TRAIT(src, TRAIT_DISGUISED))
		return FALSE
	return ..()

/// Do some more logic for the cado when we disguise through the action.
/mob/living/basic/cado/proc/on_disguise(mob/living/basic/user, atom/movable/target)
	SIGNAL_HANDLER
	playsound(get_turf(src), 'sound/creatures/cado_disguise_sound.ogg', 75, TRUE, vary = FALSE)
	// We are now weaker
	melee_damage_lower = melee_damage_disguised
	melee_damage_upper = melee_damage_disguised
	add_movespeed_modifier(/datum/movespeed_modifier/morph_disguised)

	med_hud_set_health()
	med_hud_set_status() //we're an object honest

	visible_message(
		span_warning("[src] suddenly twists and changes shape, he is always two steps ahead!"),
		span_notice("You reveal that you are always two steps ahead and assume the form of [target]."),
	)

	form_weakref = WEAKREF(target)
	form_typepath = target.type

///Makes cado play a custom audio file when he starts to vent crawl
/mob/living/basic/cado/move_into_vent(obj/machinery/atmospherics/components/ventcrawl_target)
	..()
	playsound(get_turf(src), 'sound/creatures/cado_ventcrawl.ogg', 75, TRUE, vary = FALSE)

/// Do some more logic for the morph when we undisguise through the action.
/mob/living/basic/cado/proc/on_undisguise()
	SIGNAL_HANDLER
	visible_message(
		span_warning("[src] suddenly reverts back to his true form, he was two steps ahead the entire time!"),
		span_notice("You reform to your normal body."),
	)

	//Baseline stats
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	remove_movespeed_modifier(/datum/movespeed_modifier/morph_disguised)

	med_hud_set_health()
	med_hud_set_status() //we are no longer an object

	form_weakref = null
	form_typepath = null

/// Alias for the disguise ability to be used as a keybind.
/mob/living/basic/cado/proc/trigger_ability(mob/living/basic/source, atom/target)
	SIGNAL_HANDLER

	// linters hate this if it's not async for some reason even though nothing blocks
	INVOKE_ASYNC(disguise_ability, TYPE_PROC_REF(/datum/action/cooldown, InterceptClickOn), user = source, target = target)
	return COMSIG_MOB_CANCEL_CLICKON

/// Handles the logic for attacking anything.
/mob/living/basic/cado/proc/pre_attack(mob/living/basic/source, atom/target)
	SIGNAL_HANDLER

	if(HAS_TRAIT(src, TRAIT_DISGUISED) && (melee_damage_disguised <= 0))
		balloon_alert(src, "can't attack while disguised!")
		return COMPONENT_HOSTILE_NO_ATTACK

	if(isliving(target)) //Eat Corpses to regen health
		var/mob/living/living_target = target
		if(living_target.stat != DEAD)
			return

		INVOKE_ASYNC(source, PROC_REF(eat), eatable = living_target, delay = 3 SECONDS, update_health = -50)
		return COMPONENT_HOSTILE_NO_ATTACK

	if(isitem(target)) //Eat items just to be annoying
		var/obj/item/item_target = target
		if(item_target.anchored)
			return

		INVOKE_ASYNC(source, PROC_REF(eat), eatable = item_target, delay = 2 SECONDS)
		return COMPONENT_HOSTILE_NO_ATTACK

/// Eat stuff. Delicious. Return TRUE if we ate something, FALSE otherwise.
/// Required: `eatable` is the thing (item or mob) that we are going to eat.
/// Optional: `delay` is the applicable time-based delay to pass into `do_after()` before the logic is ran.
/// Optional: `update_health` is an integer that will be added (or maybe subtracted if you're cruel) to our health after we eat something. Passed into `adjust_health()` so make sure what you pass in is accurate.
/mob/living/basic/cado/proc/eat(atom/movable/eatable, delay = 0 SECONDS, update_health = 0)
	if(QDELETED(eatable) || eatable.loc == src)
		return FALSE

	if(HAS_TRAIT(src, TRAIT_DISGUISED) && !eat_while_disguised)
		balloon_alert(src, "can't eat while disguised!")
		return FALSE

	balloon_alert(src, "eating...")
	if((delay > 0 SECONDS) && !do_after(src, delay, target = eatable))
		return FALSE

	visible_message(span_warning("[src] swallows [eatable] whole!"))
	eatable.forceMove(src)
	if(update_health != 0)
		adjust_health(update_health)

	return TRUE

/// No fleshed out AI implementation, just something that make these fellers seem lively if they're just dropped into a station.
/// Only real human-powered intelligence is capable of playing prop hunt in SS13 (until further notice).
/datum/ai_controller/basic_controller/morph
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)
