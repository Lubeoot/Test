/obj/structure/window
	var/glass_color
	var/glass_color_blend_to_color
	var/glass_color_blend_to_ratio
	var/uses_color = TRUE

/obj/structure/window/proc/change_color(new_color)
	if(glass_color_blend_to_color && glass_color_blend_to_ratio)
		glass_color = BlendRGB(new_color, glass_color_blend_to_color, glass_color_blend_to_ratio)
	else
		glass_color = new_color
	if(fulltile)
		color = glass_color
	update_appearance()

/obj/structure/grille/window_sill
	name = "window grille"
	desc = "A flimsy framework of iron rods. This one fits a window!"
	icon = 'monkestation/icons/obj/structures/window/grille.dmi'
	icon_state = "grille-0"
	layer = ABOVE_OBJ_LAYER - 0.01
	base_icon_state = "grille"
	canSmoothWith = SMOOTH_GROUP_GRILLE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_GRILLE

/obj/structure/grille/window_sill/atom_break()
	. = ..()
	qdel(src)

/obj/structure/grille/update_overlays(updates=ALL)
	. = ..()
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)

//windows that shouldnt be colored, whoever added this originally forgot to do this
/obj/structure/window/reinforced/plasma/plastitanium
	uses_color = FALSE

/obj/structure/window/reinforced/shuttle
	uses_color = FALSE

/obj/structure/window/fulltile/colony_fabricator
	uses_color = FALSE

/obj/structure/window/reinforced/fulltile/ice
	uses_color = FALSE
