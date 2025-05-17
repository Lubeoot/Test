/datum/round_event_control/thougher
	name = "Spawn Thougher"
	typepath = /datum/round_event/ghost_role/thougher
	max_occurrences = 1
	min_players = 20
	//dynamic_should_hijack = TRUE
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawns a thougher, aiming to slay the glowies."
	min_wizard_trigger_potency = 6
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/thougher
	minimum_required = 1
	role_name = "thougher"
	fakeable = FALSE

/datum/round_event/ghost_role/thougher/spawn_role()
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(
		"Do you want to play as a Thougher?",
		role = ROLE_THOUGHER,
		check_jobban = ROLE_THOUGHER,
		poll_time = 20 SECONDS,
		alert_pic = /datum/antagonist/thougher,
		role_name_text = "thougher"
	)
	if(!length(candidates))
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	var/turf/spawn_loc = find_maintenance_spawn(atmos_sensitive = TRUE, require_darkness = TRUE)
	if(isnull(spawn_loc))
		return MAP_ERROR

	var/mob/living/carbon/human/S = new (spawn_loc)
	player_mind.transfer_to(S)
	player_mind.set_assigned_role(SSjob.GetJobType(/datum/job/thougher))
	player_mind.special_role = ROLE_THOUGHER
	player_mind.add_antag_datum(/datum/antagonist/thougher)
	S.set_species(/datum/species/though/thougher)
	playsound(S, 'sound/magic/ethereal_exit.ogg', 50, TRUE, -1)
	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into a Thougher by an event.")
	S.log_message("was spawned as a Thougher by an event.", LOG_GAME)
	spawned_mobs += S
	return SUCCESSFUL_SPAWN
