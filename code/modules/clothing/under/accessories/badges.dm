// Badges, pins, and other very small items that slot onto a shirt.
/obj/item/clothing/accessory/lawyers_badge
	name = "attorney's badge"
	desc = "Fills you with the conviction of JUSTICE. Lawyers tend to want to show it to everyone they meet."
	icon_state = "lawyerbadge"

/obj/item/clothing/accessory/lawyers_badge/interact(mob/user)
	. = ..()
	if(prob(1))
		user.say("The testimony contradicts the evidence!", forced = "[src]")
	user.visible_message(span_notice("[user] shows [user.p_their()] attorney's badge."), span_notice("You show your attorney's badge."))

/obj/item/clothing/accessory/lawyers_badge/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_LIVING_SLAM_TABLE, PROC_REF(table_slam))
	user.bubble_icon = "lawyer"

/obj/item/clothing/accessory/lawyers_badge/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_LIVING_SLAM_TABLE)
	user.bubble_icon = initial(user.bubble_icon)

/obj/item/clothing/accessory/lawyers_badge/proc/table_slam(mob/living/source, obj/structure/table/the_table)
	SIGNAL_HANDLER

	ASYNC
		source.say("Objection!!", spans = list(SPAN_YELL), forced = "[src]")

/obj/item/clothing/accessory/clown_enjoyer_pin
	name = "\improper Clown Pin"
	desc = "A pin to show off your appreciation for clowns and clowning!"
	icon_state = "clown_enjoyer_pin"

/obj/item/clothing/accessory/clown_enjoyer_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/mime_fan_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, "can't pick both sides!")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/clown_enjoyer_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_CLOWN_ENJOYER))
		user.add_mood_event("clown_enjoyer_pin", /datum/mood_event/clown_enjoyer_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/clown_enjoyer_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("clown_enjoyer_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/mime_fan_pin
	name = "\improper Mime Pin"
	desc = "A pin to show off your appreciation for mimes and miming!"
	icon_state = "mime_fan_pin"

/obj/item/clothing/accessory/mime_fan_pin/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/clothing/accessory/clown_enjoyer_pin) in attach_to.attached_accessories)
		if(user)
			attach_to.balloon_alert(user, "can't pick both sides!")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/mime_fan_pin/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_MIME_FAN))
		user.add_mood_event("mime_fan_pin", /datum/mood_event/mime_fan_pin)
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/mime_fan_pin/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	user.clear_mood_event("mime_fan_pin")
	if(ishuman(user))
		var/mob/living/carbon/human/human_equipper = user
		human_equipper.fan_hud_set_fandom()

/obj/item/clothing/accessory/pocketprotector
	name = "pocket protector"
	desc = "Can protect your clothing from ink stains, but you'll look like a nerd if you're using one."
	icon_state = "pocketprotector"

/obj/item/clothing/accessory/pocketprotector/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/pocketprotector)

/obj/item/clothing/accessory/pocketprotector/can_attach_accessory(obj/item/clothing/under/attach_to, mob/living/user)
	. = ..()
	if(!.)
		return

	if(!isnull(attach_to.atom_storage))
		if(user)
			attach_to.balloon_alert(user, "not compatible!")
		return FALSE
	return TRUE

/obj/item/clothing/accessory/pocketprotector/full

/obj/item/clothing/accessory/pocketprotector/full/Initialize(mapload)
	. = ..()
	new /obj/item/pen/red(src)
	new /obj/item/pen(src)
	new /obj/item/pen/blue(src)

/obj/item/clothing/accessory/pocketprotector/cosmetology

/obj/item/clothing/accessory/pocketprotector/cosmetology/Initialize(mapload)
	. = ..()
	for(var/i in 1 to 3)
		new /obj/item/lipstick/random(src)

/obj/item/clothing/accessory/dogtag
	name = "Dogtag"
	desc = "Can't wear a collar, but this is fine?"
	icon_state = "allergy"
	attachment_slot = NONE // actually NECK but that doesn't make sense
	/// What message is displayed when our dogtags / its clothes / its wearer is examined
	var/display = "Nothing!"

/obj/item/clothing/accessory/dogtag/examine(mob/user)
	. = ..()
	. += display

// Examining the clothes will display the examine message of the dogtag
/obj/item/clothing/accessory/dogtag/attach(obj/item/clothing/under/attach_to, mob/living/attacher)
	. = ..()
	if(!.)
		return
	RegisterSignal(attach_to, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/obj/item/clothing/accessory/dogtag/detach(obj/item/clothing/under/detach_from)
	. = ..()
	UnregisterSignal(detach_from, COMSIG_ATOM_EXAMINE)

// Double examining the person wearing the clothes will display the examine message of the dogtag
/obj/item/clothing/accessory/dogtag/accessory_equipped(obj/item/clothing/under/clothes, mob/living/user)
	RegisterSignal(user, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine))

/obj/item/clothing/accessory/dogtag/accessory_dropped(obj/item/clothing/under/clothes, mob/living/user)
	UnregisterSignal(user, COMSIG_ATOM_EXAMINE_MORE)

/// Adds the examine message to the clothes and mob.
/obj/item/clothing/accessory/dogtag/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	// Only show the examine message if we're close (2 tiles)
	if(!IN_GIVEN_RANGE(get_turf(user), get_turf(src), 2))
		return

	if(ismob(source))
		// Examining a mob wearing the clothes, wearing the dogtag will also show the message
		examine_list += "A dogtag is hanging around [source.p_their()] neck: [display]"
	else
		examine_list += "A dogtag is attached to [source]: [display]"

/obj/item/clothing/accessory/dogtag/allergy
	name = "Allergy dogtag"
	desc = "A dogtag with a listing of allergies."

/obj/item/clothing/accessory/dogtag/allergy/Initialize(mapload, allergy_string)
	. = ..()
	if(allergy_string)
		display = span_notice("The dogtag has a listing of allergies: [allergy_string]")
	else
		display = span_notice("The dogtag is all scratched up.")

/*
/// Reskins for the pride pin accessory, mapped by display name to icon state
GLOBAL_LIST_INIT(pride_pin_reskins, list(
	"Rainbow Pride" = "pride",
	"Bisexual Pride" = "pride_bi",
	"Pansexual Pride" = "pride_pan",
	"Asexual Pride" = "pride_ace",
	"Non-binary Pride" = "pride_enby",
	"Transgender Pride" = "pride_trans",
	"Intersex Pride" = "pride_intersex",
	"Lesbian Pride" = "pride_lesbian",
))
*/

/obj/item/clothing/accessory/award
	name = "award pin"
	desc = "An award worn by an entity befitting its description, they could represent anything and be worn for any reason, often being worn as a status symbol of pride or manifested as a warning in relation to whatever the award states its for."
	icon_state = "default_award"
	obj_flags = UNIQUE_RENAME
	infinite_reskin = TRUE

/obj/item/clothing/accessory/award/Initialize(mapload)
	. = ..()
	unique_reskin = GLOB.award_pin_reskins

/obj/item/clothing/accessory/award/reskin_obj(mob/M)
	. = ..()
	post_reskin(M)

/obj/item/clothing/accessory/award/post_reskin(mob/our_mob)
	for(var/award_name as anything in GLOB.award_pin_reskins)
		if(GLOB.award_pin_reskins[award_name] == icon_state)
			name = "[lowertext(award_name)] pin"
			return

	name = initial(name) // If we somehow fail to find our award in the global list, just make us generic

///Awarded for being dutiful and extinguishing the debt from the "Indebted" quirk.
/obj/item/clothing/accessory/debt_payer_pin
	name = "debt payer pin"
	desc = "I've paid my debt and all I've got was this pin."
	icon_state = "debt_payer_pin"

/obj/item/clothing/accessory/deaf_pin
	name = "deaf personnel pin"
	desc = "Indicates that the wearer is deaf."
	icon_state = "deaf_pin"

/obj/item/clothing/accessory/press_badge
	name = "press badge"
	desc = "A blue press badge that clearly identifies the wearer as a member of the media. While it signifies press affiliation, it does not grant any special privileges or rights no matter how much the wearer yells about it."
	desc_controls = "Click person with it to show them it"
	icon_state = "press_badge"
	attachment_slot = NONE // actually NECK but that doesn't make sense
	/// The name of the person in the badge
	var/journalist_name
	/// The name of the press person is working for
	var/press_name

/obj/item/clothing/accessory/press_badge/examine(mob/user)
	. = ..()
	if(!journalist_name || !press_name)
		. += span_notice("Use it in hand to input information")
		return

	. += span_notice("It belongs to <b>[journalist_name]</b>, <b>[press_name]</b>")

/obj/item/clothing/accessory/press_badge/attack_self(mob/user, modifiers)
	. = ..()
	if(!journalist_name)
		journalist_name = tgui_input_text(user, "What is your name?", "Journalist Name", "[user.name]", MAX_NAME_LEN)
	if(!press_name)
		press_name = tgui_input_text(user, "For what organization you work?", "Press Name", "Nanotrasen", MAX_CHARTER_LEN)

/obj/item/clothing/accessory/press_badge/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isliving(target) || !proximity_flag)
		return

	var/mob/living/interacting_living = target
	if(user.istate & ISTATE_HARM)
		playsound(interacting_living, 'sound/weapons/throw.ogg', 30)
		examine(interacting_living)
		to_chat(interacting_living, span_userdanger("[user] shoves the [src] up your face!"))
		user.visible_message(span_warning("[user] have shoved a [src] into [interacting_living] face."))
	else
		playsound(interacting_living, 'sound/weapons/throwsoft.ogg', 20)
		examine(interacting_living)
		to_chat(interacting_living, span_boldwarning("[user] shows the [src] to you."))
		user.visible_message(span_notice("[user] shows a [src] to [interacting_living]."))
