
SUBSYSTEM_DEF(station_coloring)
	name = "Station Coloring"
	init_order = INIT_ORDER_ICON_COLORING // before SSicon_smooth
	flags = SS_NO_FIRE
	///do we bother with wall trims?
	var/wall_trims = FALSE
	//RED (Only sec stuff honestly)
	var/list/red = list("")
	//BAR
	var/list/bar = list("")
	//PURPLE (RnD + Research outpost)
	var/list/purple = list("")
	//BROWN (Mining + Cargo)
	var/list/brown = list("")
	//GREEN (Virology and Hydro areas)
	var/list/green = list("")
	//BLUE (Some of Medbay areas)
	var/list/blue = list("")
	//ORANGE (engineering)
	var/list/orange = list("")

/datum/controller/subsystem/station_coloring/Initialize()
	var/list/color_palette = list(
		pick(red)          = typesof(/area/station/security),
		pick(purple)       = typesof(/area/station/science),
		pick(green)        = list(/area/station/medical/virology) + typesof(/area/station/service) - /area/station/service/bar,
		pick(blue)         = typesof(/area/station/medical),
		pick(bar)          = list(/area/station/service/bar),
		pick(brown)		   = typesof(/area/station/cargo) + typesof(/area/mine),
		COLOR_WHITE        = typesof(/area/shuttle),
		COLOR_WHITE        = typesof(/area/centcom),
		pick(orange)	   = typesof(/area/station/engineering),
	)

	for(var/color in color_palette)
		color_area_objects(color_palette[color], color)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/station_coloring/proc/color_area_objects(list/possible_areas, color) // paint in areas
	for(var/type in possible_areas)
		for(var/obj/structure/window/W in GLOB.areas_by_type[type]) // for in area is slow by refs, but we have a time while in lobby so just to-do-sometime
			W.change_color(color)
		if(wall_trims)
			for(var/turf/closed/wall/wall in GLOB.areas_by_type[type])
				if(wall.wall_trim)
					wall.change_trim_color(color)

/datum/controller/subsystem/station_coloring/proc/get_default_color()
	var/static/default_color = pick(list(""))

	return default_color

/datum/controller/subsystem/station_coloring/proc/recolor_areas()
	var/list/color_palette = list(
		pick(red)          = typesof(/area/station/security),
		pick(purple)       = typesof(/area/station/science),
		pick(green)        = list(/area/station/medical/virology,
		                        /area/station/service/hydroponics),
		pick(blue)         = typesof(/area/station/medical),
		pick(bar)          = list(/area/station/service/bar),
		pick(brown)		   = typesof(/area/station/cargo) + typesof(/area/mine),
		COLOR_WHITE        = typesof(/area/shuttle),
		COLOR_WHITE        = typesof(/area/centcom),
	)

	for(var/color in color_palette)
		color_area_objects(color_palette[color], color)
