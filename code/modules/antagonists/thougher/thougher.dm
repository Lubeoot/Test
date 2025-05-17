/datum/antagonist/thougher
	name = "\improper Thougher"
	antagpanel_category = ANTAG_GROUP_ABOMINATIONS
	job_rank = ROLE_THOUGHER
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	ui_name = "AntagInfoThougher"
	suicide_cry = "KEEP DIMMING LIGHTZZZ ON MI!!"
	preview_outfit = /datum/outfit/thougher

/datum/antagonist/thougher/greet()
	. = ..()
	owner.announce_objectives()

/datum/antagonist/thougher/on_gain()
	forge_objectives()
	. = ..()

/datum/outfit/thougher
	name = "Thougher (Preview only)"

/datum/outfit/thougher/post_equip(mob/living/carbon/human/human, visualsOnly)
	human.set_species(/datum/species/though/thougher)

/datum/objective/thougher_fluff

/datum/objective/thougher_fluff/New()
	var/list/explanation_texts = list(
		"Eradicate the glowies.",
		"Thoughquote the non-cursed.",
		"Shut their eyes and cameras.",
		"Reveal the truth about the darkness before the glowies shut you down.",
		"You're just here to kill people, though.",
		"Bring Eternal Night.",
		"Run the rivers dry with sproke."
	)
	explanation_text = pick(explanation_texts)
	..()

/datum/objective/thougher_fluff/check_completion()
	return owner.current.stat != DEAD

/datum/antagonist/thougher/forge_objectives()
	var/datum/objective/thougher_fluff/objective = new
	objective.owner = owner
	objectives += objective
