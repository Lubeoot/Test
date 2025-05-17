/**
 * Antagonistic thoughjaks, resprite of the nightmare from base SS13, kills people and spreads darkness with melee.
 */
/datum/species/though/thougher
	name = "Thougher"
	id = SPECIES_THOUGHER
	examine_limb_id = SPECIES_THOUGH
	burnmod = 1.5
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE
	no_equip_flags = ITEM_SLOT_MASK | ITEM_SLOT_OCLOTHING | ITEM_SLOT_GLOVES | ITEM_SLOT_FEET | ITEM_SLOT_ICLOTHING | ITEM_SLOT_SUITSTORE
	inherent_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_TRANSFORMATION_STING,
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_RESISTCOLD,
		TRAIT_NOBREATH,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_PIERCEIMMUNE,
		TRAIT_NODISMEMBER,
		TRAIT_NOHUNGER,
		TRAIT_NOBLOOD,
		// monkestation addition: pain system
		TRAIT_ABATES_SHOCK,
		TRAIT_ANALGESIA,
		TRAIT_NO_PAIN_EFFECTS,
		TRAIT_NO_SHOCK_BUILDUP,
		// monkestation end
	)

	mutantheart = /obj/item/organ/internal/heart/thougher
	mutantbrain = /obj/item/organ/internal/brain/though/thougher
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/though,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/though,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/though,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/though,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/though,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/though,
	)

/datum/species/though/thougher/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()

	C.fully_replace_character_name(null, pick(GLOB.thougher_names))
	C.set_safe_hunger_level()

/datum/species/though/thougher/check_roundstart_eligible()
	return FALSE
