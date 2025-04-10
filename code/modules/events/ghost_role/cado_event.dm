/datum/round_event_control/cado
	name = "Spawn Cado"
	typepath = /datum/round_event/ghost_role/cado
	weight = 5 //monke edit: 0 to 5
	max_occurrences = 1
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawns a cado to mukbang challenge the station."
	min_wizard_trigger_potency = 4
	max_wizard_trigger_potency = 7

/datum/round_event/ghost_role/cado
	minimum_required = 1
	role_name = "cado"

/datum/round_event/ghost_role/cado/spawn_role()
	var/list/candidates = SSpolling.poll_ghost_candidates(check_jobban = ROLE_CADO, alert_pic = /mob/living/basic/cado, role_name_text = "cado")
	if(!length(candidates))
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	var/turf/spawn_loc = find_maintenance_spawn(atmos_sensitive = TRUE, require_darkness = FALSE)
	if(isnull(spawn_loc))
		return MAP_ERROR

	var/mob/living/basic/cado/mukbanger = new(spawn_loc)
	player_mind.transfer_to(mukbanger)
	player_mind.set_assigned_role(SSjob.GetJobType(/datum/job/cado))
	player_mind.special_role = ROLE_CADO
	player_mind.add_antag_datum(/datum/antagonist/cado)
	SEND_SOUND(mukbanger, sound('sound/magic/mutate.ogg'))
	message_admins("[ADMIN_LOOKUPFLW(mukbanger)] has been made into a cado by an event.")
	mukbanger.log_message("was spawned as a cado by an event.", LOG_GAME)
	spawned_mobs += mukbanger
	return SUCCESSFUL_SPAWN
