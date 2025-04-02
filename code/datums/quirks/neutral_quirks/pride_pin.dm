/datum/quirk/item_quirk/pride_pin
	name = "Award Wearer"
	desc = "Start off with an Award, for one reason or another. You can Alt-Click it to change its color and use a pen on it to give it a custom name and description!"
	icon = FA_ICON_RAINBOW
	value = 0
	//MONKESTATION EDIT START
	mob_trait = TRAIT_PRIDE_PIN
	quirk_flags = QUIRK_CHANGES_APPEARANCE
	gain_text = span_notice("You now wear an award, for one reason or another.")
	lose_text = span_danger("You can feel your very existence becoming less slop-like.")
	//MONKESTATION EDIT END

/datum/quirk/item_quirk/pride_pin/add_unique(client/client_source)
	var/obj/item/clothing/accessory/pride/pin = new(get_turf(quirk_holder))

	var/pride_choice = client_source?.prefs?.read_preference(/datum/preference/choiced/pride_pin) || assoc_to_keys(GLOB.pride_pin_reskins)[1]
	var/pride_reskin = GLOB.pride_pin_reskins[pride_choice]

	pin.current_skin = pride_choice
	pin.icon_state = pride_reskin
	pin.post_reskin()
	//MONKESTATION EDIT START
	var/mob/living/carbon/human/H = quirk_holder
	if (istype(H))
		var/obj/item/clothing/under/U = H.w_uniform
		if(U && U.attach_accessory(pin))
			return
	//MONKESTATION EDIT END
	give_item_to_holder(pin, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))
