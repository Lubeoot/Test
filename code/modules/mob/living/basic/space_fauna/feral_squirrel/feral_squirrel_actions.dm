/**
 *Increase the feral squirrel's domain
 */

/datum/action/cooldown/mob_cooldown/domain
	name = "Dig up"
	desc = "Digs up valuables such as gemeralds and nuts."
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED|AB_CHECK_OPEN_TURF // monkestation edit: add AB_CHECK_OPEN_TURF // shartystation edit : it was like three words bro
	cooldown_time = 6 SECONDS
	melee_cooldown_time = 0 SECONDS
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_clock"
	overlay_icon_state = "bg_clock_border"
	button_icon_state = "coffer"
	shared_cooldown = NONE

/datum/action/cooldown/mob_cooldown/domain/proc/domain()
	var/turf/location = get_turf(owner)
	playsound(get_turf(owner), 'sound/creatures/squirrel_search.ogg', 75, TRUE, vary = FALSE)
	switch (rand(1,10))
		if (8)
			new /obj/item/stack/sheet/mineral/diamond(location)
		if (9)
			new /obj/item/food/grown/peanut(location)
		if (10)
			new /obj/effect/decal/cleanable/oil/slippery(location)
		else
			new /obj/effect/decal/cleanable/dirt(location)
	StartCooldown()

/datum/action/cooldown/mob_cooldown/domain/Activate(atom/target)
	StartCooldown(10 SECONDS)
	domain()
	StartCooldown()

/**
 * This action checks some nearby maintenance animals and makes them your minions.
 * If none are nearby, creates a new mouse.
 */
/datum/action/cooldown/mob_cooldown/riot
	name = "Sing Nutwave"
	desc = "Sing Nutwave, attracting the creatures of the station and rallying them to your cause."
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_INCAPACITATED
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "riot"
	background_icon_state = "bg_clock"
	overlay_icon_state = "bg_clock_border"
	cooldown_time = 8 SECONDS
	melee_cooldown_time = 0 SECONDS
	shared_cooldown = NONE
	/// How close does something need to be for us to recruit it?
	var/range = 5
	/// Commands you can give to your terrible mouse army
	var/static/list/mouse_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/protect_owner,
		/datum/pet_command/follow,
		/datum/pet_command/point_targeting/attack/mouse
	)
	/// Commands you can give to glockroaches
	var/static/list/glockroach_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/protect_owner/glockroach,
		/datum/pet_command/follow,
		/datum/pet_command/point_targeting/attack/glockroach
	)

/datum/action/cooldown/mob_cooldown/riot/Activate(atom/target)
	StartCooldown(10 SECONDS)
	riot()
	StartCooldown()

/**
 * Attempts to, in order and ending at any successful step:
 * * Convert nearby mice into terrible mice.
 * * Convert nearby roaches into aggressive roaches.
 * * Convert nearby frogs into aggressive frogs.
 * * Spawn a single mouse if below the mouse cap.
 */
/datum/action/cooldown/mob_cooldown/riot/proc/riot()
	var/uplifted_mice = FALSE
	for (var/mob/living/basic/mouse/nearby_mouse in oview(owner, range))
		uplifted_mice = convert_mouse(nearby_mouse) || uplifted_mice
	if (uplifted_mice)
		owner.visible_message(span_warning("[owner] sings nutwave, making the mice terrible!"))
		playsound(get_turf(owner), 'sound/creatures/squirrel_summon.ogg', 75, TRUE, vary = FALSE)
		return

	var/static/list/converted_check_list = list(FACTION_RAT)
	var/uplifted_roach = FALSE
	for (var/mob/living/basic/cockroach/nearby_roach in oview(owner, range))
		uplifted_roach = convert_roach(nearby_roach, converted_check_list) || uplifted_roach
	if (uplifted_roach)
		owner.visible_message(span_warning("[owner] sings nutwave, making the roach feel nostalgic!"))
		playsound(get_turf(owner), 'sound/creatures/squirrel_summon.ogg', 75, TRUE, vary = FALSE)
		return

	var/uplifted_frog = FALSE
	for (var/mob/living/basic/frog/nearby_frog in oview(owner, range))
		uplifted_frog = convert_frog(nearby_frog, converted_check_list) || uplifted_frog
	if (uplifted_frog)
		owner.visible_message(span_warning("[owner] sings nutwave, turning the frog into a ribbit rally!"))
		playsound(get_turf(owner), 'sound/creatures/squirrel_summon.ogg', 75, TRUE, vary = FALSE)
		return

	var/rat_cap = CONFIG_GET(number/ratcap)
	if (LAZYLEN(SSmobs.cheeserats) >= rat_cap)
		to_chat(owner,span_warning("There's too many terrible mice on the booru to force a new one! Delete some first!"))
		return
	new /mob/living/basic/mouse/terrible(owner.loc)
	owner.visible_message(span_warning("[owner] sings nutwave, turning the mouse terrible!"))

/// Makes a passed mob into our minion
/datum/action/cooldown/mob_cooldown/riot/proc/make_minion(mob/living/new_minion, minion_desc, list/command_list = mouse_commands)
	if (isbasicmob(new_minion))
		new_minion.AddComponent(/datum/component/obeys_commands, command_list)
		qdel(new_minion.GetComponent(/datum/component/tameable)) // Squirrels don't share, so much for solidarity
	new_minion.befriend(owner)
	new_minion.faction = owner.faction.Copy()
	// Give a hint in description too
	new_minion.desc += minion_desc
	new_minion.balloon_alert_to_viewers("squeak")

/// Turns a mouse into an angry mouse
/datum/action/cooldown/mob_cooldown/riot/proc/convert_mouse(mob/living/basic/mouse/nearby_mouse)
	// This mouse is already squirrel controlled, let's not bother with it.
	if (istype(nearby_mouse.ai_controller, /datum/ai_controller/basic_controller/mouse/rat))
		return FALSE

	var/mob/living/basic/mouse/rat/squirrel_path = /mob/living/basic/mouse/rat
	// Change name
	if (nearby_mouse.name == "Terrible Mouse")
		nearby_mouse.name = initial(squirrel_path.name)
	// Buffs our combat stats to that of a squirrel
	nearby_mouse.melee_damage_lower = initial(squirrel_path.melee_damage_lower)
	nearby_mouse.melee_damage_upper = initial(squirrel_path.melee_damage_upper)
	nearby_mouse.obj_damage = initial(squirrel_path.obj_damage)
	nearby_mouse.maxHealth = initial(squirrel_path.maxHealth)
	nearby_mouse.health = initial(squirrel_path.health)
	nearby_mouse.icon_state += "_terrible"
	nearby_mouse.icon_living += "_terrible"
	// Replace our AI with a squirrel one
	nearby_mouse.ai_controller = new /datum/ai_controller/basic_controller/mouse/rat(nearby_mouse)
	make_minion(nearby_mouse, " ...is what it used to be, it's been warped by nutwave into a terrible version of its natural form, rumored to know how to perform surgical operations.")
	return TRUE

/// Turns a roach into an angry roach
/datum/action/cooldown/mob_cooldown/riot/proc/convert_roach(mob/living/basic/cockroach/nearby_roach, list/converted_check_list)
	// No need to convert when not on the same team.
	if (faction_check(nearby_roach.faction, converted_check_list))
		return FALSE

	var/list/minion_commands = mouse_commands
	if (!findtext(nearby_roach.name, "sewer"))
		nearby_roach.name = "sewer [nearby_roach.name]"

	if (istype(nearby_roach, /mob/living/basic/cockroach/glockroach) || istype(nearby_roach, /mob/living/basic/cockroach/hauberoach))
		if (istype(nearby_roach, /mob/living/basic/cockroach/glockroach))
			minion_commands = glockroach_commands
		nearby_roach.melee_damage_lower += 0.5
		nearby_roach.melee_damage_upper += 2
	else
		nearby_roach.melee_damage_lower += 2
		nearby_roach.melee_damage_upper += 4
		nearby_roach.obj_damage += 5
		nearby_roach.ai_controller = new /datum/ai_controller/basic_controller/cockroach/sewer(nearby_roach)
		nearby_roach.melee_attack_cooldown = 0.8 SECONDS

	nearby_roach.icon_state += "_sewer"
	nearby_roach.maxHealth += 1
	nearby_roach.health += 1
	make_minion(nearby_roach, " <br>This one looks extra robust.", minion_commands)
	return TRUE

/// Turns a frog into a crazy frog. This doesn't do anything interesting and should when it becomes a basic mob.
/datum/action/cooldown/mob_cooldown/riot/proc/convert_frog(mob/living/basic/frog/nearby_frog, list/converted_check_list)
	// No need to convert when not on the same team.
	if(faction_check(nearby_frog.faction, converted_check_list) || nearby_frog.stat == DEAD)
		return FALSE

	var/list/minion_commands = mouse_commands
	if (!findtext(nearby_frog.name, "trash"))
		nearby_frog.name = replacetext(nearby_frog.name, "frog", "trash frog")

	nearby_frog.icon_state += "_trash"
	nearby_frog.icon_living += "_trash"
	nearby_frog.icon_dead = nearby_frog.icon_state + "_dead"
	nearby_frog.maxHealth += 10
	nearby_frog.health += 10
	nearby_frog.melee_damage_lower += 1
	nearby_frog.melee_damage_upper += 5
	nearby_frog.obj_damage += 10
	nearby_frog.ai_controller = new /datum/ai_controller/basic_controller/frog/trash(nearby_frog)
	var/crazy_frog_desc = " ...[findtext(nearby_frog.name, "rare") ? "even though" : "perhaps because"] they live in a trash bag."
	make_minion(nearby_frog, crazy_frog_desc, minion_commands)
	return TRUE

// Command you can give to a mouse to make it kill someone
/datum/pet_command/point_targeting/attack/mouse
	speech_commands = list("attack", "sic", "kill", "cheese em")
	command_feedback = "squeak!" // Frogs and roaches can squeak too it's fine
	pointed_reaction = "and squeaks aggressively"
	refuse_reaction = "quivers"
	attack_behaviour = /datum/ai_behavior/basic_melee_attack

// Command you can give to a mouse to make it kill someone
/datum/pet_command/point_targeting/attack/glockroach
	speech_commands = list("attack", "sic", "kill", "cheese em")
	command_feedback = "squeak!"
	pointed_reaction = "and cocks its gun"
	refuse_reaction = "quivers"
	attack_behaviour = /datum/ai_behavior/basic_ranged_attack/glockroach

/**
 *Spittle; harmless reagent that is added by feral rat, and makes you disgusted.
 */

/datum/reagent/squirrel_spit
	name = "Squirrel Spit"
	description = "Something coming from a squirrel. Capable of making you go nuts."
	reagent_state = LIQUID
	color = "#C8C8C8"
	metabolization_rate = 0.03 * REAGENTS_METABOLISM
	taste_description = "something nutty"
	overdose_threshold = 20

/datum/reagent/squirrel_spit/on_mob_metabolize(mob/living/L)
	..()
	if(HAS_TRAIT(L, TRAIT_AGEUSIA))
		return
	to_chat(L, span_notice("This food has a funny taste!"))

/datum/reagent/squirrel_spit/overdose_start(mob/living/M)
	..()
	var/mob/living/carbon/victim = M
	if (istype(victim) && !(FACTION_RAT in victim.faction))
		to_chat(victim, span_userdanger("With this last sip, you feel your body convulsing horribly from the contents you've ingested. As you contemplate your actions, you sense an awakened kinship with squirrel-kind and their newly risen leader!"))
		victim.faction |= FACTION_RAT
		victim.vomit()
	metabolization_rate = 10 * REAGENTS_METABOLISM

/datum/reagent/squirrel_spit/on_mob_life(mob/living/carbon/C)
	if(prob(15))
		to_chat(C, span_notice("You feel queasy!"))
		C.adjust_disgust(3)
	else if(prob(10))
		to_chat(C, span_warning("That food does not sit up well!"))
		C.adjust_disgust(5)
	else if(prob(5))
		C.vomit()
	return ..()

/datum/pet_command/protect_owner/glockroach
	protect_behavior = /datum/ai_behavior/basic_ranged_attack/glockroach
