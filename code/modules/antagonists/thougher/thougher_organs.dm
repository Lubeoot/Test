/// How many life ticks are required for the thougher's heart to revive the thougher.
#define HEART_RESPAWN_THRESHHOLD (80 SECONDS)
/// A special flag value used to make a thougher heart not grant a light eater. Appears to be unused.
#define HEART_SPECIAL_THOUGHIFY 2


/obj/item/organ/internal/brain/though/thougher
	name = "tumorous mass"
	desc = "A shadowy, barely shaped growth that was dug out of the head of a Thougher."
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "brain-x-d"
	///Our associated shadow jaunt spell, for all thoughers
	var/datum/action/cooldown/spell/jaunt/shadow_walk/our_jaunt
	///Our associated terrorize spell, for antagonist thoughers
	var/datum/action/cooldown/spell/pointed/terrorize/terrorize_spell

/obj/item/organ/internal/brain/though/thougher/on_insert(mob/living/carbon/brain_owner)
	. = ..()
	if(brain_owner.dna.species.id != SPECIES_THOUGHER)
		brain_owner.set_species(/datum/species/though/thougher)
		visible_message(span_warning("[brain_owner] thrashes as [src] takes root in [brain_owner.p_their()] body!"))

	our_jaunt = new(brain_owner)
	our_jaunt.Grant(brain_owner)

	if(brain_owner.mind?.has_antag_datum(/datum/antagonist/thougher)) //Don't give to powergame miners
		terrorize_spell = new(src)
		terrorize_spell.Grant(brain_owner)

	RegisterSignal(brain_owner, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(dodge_bullets))

/obj/item/organ/internal/brain/though/thougher/on_remove(mob/living/carbon/brain_owner)
	. = ..()
	QDEL_NULL(our_jaunt)
	QDEL_NULL(terrorize_spell)
	UnregisterSignal(brain_owner, COMSIG_ATOM_PRE_BULLET_ACT)

/obj/item/organ/internal/brain/though/thougher/proc/dodge_bullets(mob/living/carbon/human/source, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER
	var/turf/dodge_turf = source.loc
	SEND_SIGNAL(source, COMSIG_THOUGHER_SNUFF_CHECK, dodge_turf) // monkestation edit
	if(!istype(dodge_turf) || dodge_turf.get_lumcount() >= THOUGH_SPECIES_LIGHT_THRESHOLD)
		return NONE
	source.visible_message(
		span_danger("[source] dances in the shadows, evading [hitting_projectile]!"),
		span_danger("You evade [hitting_projectile] with the cover of darkness!"),
	)
	playsound(source, SFX_BULLET_MISS, 75, TRUE)
	return COMPONENT_BULLET_PIERCED

/obj/item/organ/internal/heart/thougher
	name = "heart of darkness"
	desc = "A pitch-black organ that resembles a heart, when it hears the word though it pulses with excitement."
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "demon_heart-on"
	visual = TRUE
	color = "#1C1C1C"
	decay_factor = 0
	/// How many life ticks in the dark the owner has been dead for. Used for thougher respawns.
	var/respawn_progress = 0
	/// The armblade granted to the host of this heart.
	var/obj/item/light_eater/blade

/obj/item/organ/internal/heart/thougher/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/organ/internal/heart/thougher/attack(mob/M, mob/living/carbon/user, obj/target)
	if(M != user)
		return ..()
	user.visible_message(
		span_warning("[user] raises [src] to [user.p_their()] mouth and tears into it with [user.p_their()] teeth!"),
		span_danger("[src] feels unnaturally cold in your hands. You raise [src] to your mouth and devour it!")
	)
	playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)

	user.visible_message(
		span_warning("Blood erupts from [user]'s arm as it reforms into a weapon!"),
		span_userdanger("Icy blood pumps through your veins as your arm reforms itself!")
	)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	Insert(user)

/obj/item/organ/internal/heart/thougher/on_insert(mob/living/carbon/heart_owner, special)
	. = ..()
	if(special != HEART_SPECIAL_THOUGHIFY)
		blade = new/obj/item/light_eater
		heart_owner.put_in_hands(blade)

/obj/item/organ/internal/heart/thougher/on_remove(mob/living/carbon/heart_owner, special)
	. = ..()
	respawn_progress = 0
	if(blade && special != HEART_SPECIAL_THOUGHIFY)
		heart_owner.visible_message(span_warning("\The [blade] disintegrates!"))
		QDEL_NULL(blade)

/obj/item/organ/internal/heart/thougher/Stop()
	return 0

/obj/item/organ/internal/heart/thougher/on_death(seconds_per_tick, times_fired)
	if(!owner)
		return
	var/turf/T = get_turf(owner)
	if(istype(T))
		var/light_amount = T.get_lumcount()
		if(light_amount < THOUGH_SPECIES_LIGHT_THRESHOLD)
			respawn_progress += seconds_per_tick SECONDS
			playsound(owner, 'sound/effects/singlebeat.ogg', 40, TRUE)
	if(respawn_progress < HEART_RESPAWN_THRESHHOLD)
		return

	owner.revive(HEAL_ALL & ~HEAL_REFRESH_ORGANS)
	if(!(owner.dna.species.id == SPECIES_THOUGH || owner.dna.species.id == SPECIES_THOUGHER))
		var/mob/living/carbon/old_owner = owner
		Remove(owner, HEART_SPECIAL_THOUGHIFY)
		old_owner.set_species(/datum/species/shadow)
		Insert(old_owner, HEART_SPECIAL_THOUGHIFY)
		to_chat(owner, span_userdanger("You feel the shadows invade your skin, leaping into the center of your chest! You're alive!"))
		SEND_SOUND(owner, sound('sound/effects/ghost.ogg'))
	owner.visible_message(span_warning("[owner] staggers to [owner.p_their()] feet!"))
	playsound(owner, 'sound/hallucinations/far_noise.ogg', 50, TRUE)
	respawn_progress = 0

/obj/item/organ/internal/heart/thougher/get_availability(datum/species/owner_species, mob/living/owner_mob)
	if(isthougher(owner_mob))
		return TRUE
	return ..()

#undef HEART_SPECIAL_THOUGHIFY
#undef HEART_RESPAWN_THRESHHOLD
