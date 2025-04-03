/datum/quirk/item_quirk/award
	name = "Award Wearer"
	desc = "Start off with an Award, for one reason or another. You can Alt-Click it to change its color and use a pen on it to give it a custom name and description!"
	icon = FA_ICON_RAINBOW
	value = 0
	//MONKESTATION EDIT START
	mob_trait = TRAIT_AWARD
	quirk_flags = QUIRK_CHANGES_APPEARANCE
	gain_text = span_notice("You now wear an award, for one reason or another.")
	lose_text = span_danger("You can feel your very existence becoming less slop-like.")
	//MONKESTATION EDIT END

/datum/quirk/item_quirk/award/add_unique(client/client_source)
	var/obj/item/clothing/accessory/award/pin = new(get_turf(quirk_holder))

	var/award_choice = client_source?.prefs?.read_preference(/datum/preference/choiced/award_pin) || assoc_to_keys(GLOB.award_pin_reskins)[1]
	var/award_reskin = GLOB.award_pin_reskins[award_choice]

	pin.current_skin = award_choice
	pin.icon_state = award_reskin
	pin.post_reskin()
	//MONKESTATION EDIT START
	var/mob/living/carbon/human/H = quirk_holder
	if (istype(H))
		var/obj/item/clothing/under/U = H.w_uniform
		if(U && U.attach_accessory(pin))
			return
	//MONKESTATION EDIT END
	give_item_to_holder(pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
