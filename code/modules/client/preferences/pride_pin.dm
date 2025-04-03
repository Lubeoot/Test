/datum/preference/choiced/award_pin
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "award_pin"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/award_pin/init_possible_values()
	return assoc_to_keys(GLOB.award_pin_reskins)

/datum/preference/choiced/award_pin/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return "Award Pin" in preferences.all_quirks

/datum/preference/choiced/award_pin/apply_to_human(mob/living/carbon/human/target, value)
	return
