/datum/species/though
	// Jakkers quoted to a grim fate, they have lost in a though duel agaisnt an older thoughjak and now share the same curse. They regain health in shadow and die in light.
	name = "Thoughjak"
	plural_form = "Thoughjaks"
	id = SPECIES_THOUGH
	sexes = 0
	meat = /obj/item/food/meat/slab/human/mutant/shadow
	inherent_traits = list(
		TRAIT_NOBREATH,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBLOOD,
		TRAIT_NODISMEMBER,
		TRAIT_NEVER_WOUNDED
	)
	inherent_factions = list(FACTION_FAITHLESS)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC

	mutantbrain = /obj/item/organ/internal/brain/though
	mutanteyes = /obj/item/organ/internal/eyes/though
	mutantheart = null
	mutantlungs = null

	species_language_holder = /datum/language_holder/shadowpeople

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/though,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/though,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/though,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/though,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/though,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/though,
	)

/datum/species/shadow/check_roundstart_eligible()
	if(check_holidays(HALLOWEEN))
		return TRUE
	return ..()

/datum/species/shadow/get_species_description()
	return "Jakkers who were thoughquoted and \
		lost the insuing soyduel, they've been transformed into \
		creatures of the night, eternally bound to the shadow \
		where no glowie dares to hunt them."

/datum/species/shadow/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "moon",
			SPECIES_PERK_NAME = "Shadowborn",
			SPECIES_PERK_DESC = "Their skin blooms in the darkness. All kinds of damage, \
				no matter how extreme, will heal over time as long as there is no light.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "eye",
			SPECIES_PERK_NAME = "Nightvision",
			SPECIES_PERK_DESC = "Their eyes are adapted to the night, and can see in the dark with no problems.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "sun",
			SPECIES_PERK_NAME = "Lightburn",
			SPECIES_PERK_DESC = "Their flesh withers in the light. Any exposure to light is \
				incredibly painful for the thoughjak, charring their skin.",
		),
	)

	return to_add

/// the key to some of their powers
/obj/item/organ/internal/brain/though
	name = "though tumor"
	desc = "Something that was once a brain, before being remolded by a Thoughquoter. It has adapted to the dark, irreversibly."
	icon = 'icons/obj/medical/organs/shadow_organs.dmi'

/obj/item/organ/internal/brain/though/on_life(seconds_per_tick, times_fired)
	. = ..()
	var/turf/owner_turf = owner.loc
	if(!isturf(owner_turf))
		return
	var/light_amount = owner_turf.get_lumcount()

	if(light_amount >= THOUGH_SPECIES_LIGHT_THRESHOLD) //if there's enough light, start dying -minor monke edit
		owner.take_overall_damage(brute = 0.5 * seconds_per_tick, burn = 0.5 * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC)
	else //heal in the dark -minor monke edit
		owner.heal_overall_damage(brute = 0.5 * seconds_per_tick, burn = 0.5 * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC)

/obj/item/organ/internal/eyes/though
	name = "burning white eyes"
	desc = "How these work makes no sense though, doe."
	icon = 'icons/obj/medical/organs/shadow_organs.dmi'
	color_cutoffs = list(20, 10, 40)
	pepperspray_protect = TRUE
