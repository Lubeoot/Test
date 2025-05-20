/datum/techweb_node/data_disks
	id = "computer_data_disks"
	display_name = "Computer Data Disks"
	description = "Data disks used for storing modular computer stuff."
	prereq_ids = list("comptech")
	design_ids = list(
		"portadrive_advanced",
		"portadrive_basic",
		"portadrive_super",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)

/datum/techweb_node/bluespace_basic //Bluespace-memery
	id = "bluespace_basic"
	display_name = "Basic Bluespace Theory"
	description = "Basic studies into the mysterious alternate dimension known as bluespace."
	prereq_ids = list("base")
	design_ids = list(
		"beacon",
		"bluespace_crystal",
		"telesci_gps",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/practical_bluespace
	id = "practical_bluespace"
	display_name = "Applied Bluespace Research"
	description = "Using bluespace to make things faster and better."
	prereq_ids = list("bluespace_basic", "engineering")
	design_ids = list(
		"bluespacebeaker",
		"bluespacesyringe",
		"bluespace_coffeepot",
		"bs_rped",
		"minerbag_holding",
		"ore_silo",
		"plumbing_receiver",
		"roastingstick",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_scanmodules = 3500)

/datum/techweb_node/bluespace_travel
	id = "bluespace_travel"
	display_name = "Bluespace Travel"
	description = "Application of Bluespace for static teleportation technology."
	prereq_ids = list("practical_bluespace")
	design_ids = list(
		"bluespace_pod",
		"launchpad",
		"launchpad_console",
		"quantumpad",
		"tele_hub",
		"tele_station",
		"teleconsole",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	discount_experiments = list(/datum/experiment/scanning/points/machinery_tiered_scan/tier3_bluespacemachines = 4000)

/datum/techweb_node/micro_bluespace
	id = "micro_bluespace"
	display_name = "Miniaturized Bluespace Research"
	description = "Extreme reduction in space required for bluespace engines, leading to portable bluespace technology."
	prereq_ids = list("bluespace_travel", "practical_bluespace", "high_efficiency")
	design_ids = list(
		"bluespacebodybag",
		"medicalbed_emergency",
		"quantum_keycard",
		"swapper",
		"wormholeprojector",
		"advanced_gps", // monkestation edit: advanced gps
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
		/* /datum/experiment/exploration_scan/random/condition) this should have a point cost but im not even sure the experiment works properly lmao*/

/datum/techweb_node/regulated_bluespace
	id = "regulated_bluespace"
	display_name = "Regulated Bluespace Research"
	description = "Bluespace technology using stable and balanced procedures. Required by galactic convention for public use."
	prereq_ids = list("base")
	design_ids = list(
		"spaceship_navigation_beacon",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)


/datum/techweb_node/anomaly
	id = "anomaly_research"
	display_name = "Anomaly Research"
	description = "Unlock the potential of the mysterious anomalies that appear on station."
	prereq_ids = list("adv_engi", "practical_bluespace")
	design_ids = list(
		"anomaly_neutralizer",
		"reactive_armour",
		//"artifact_heater", //MONKESTATION EDIT REMOVAL
		//"artifact_xray",	//MONKESTATION EDIT REMOVAL
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/artifact
	id = "artifact_research"
	display_name = "Artifact Research"
	description = "Properly concuct research on the various artifacts found around."
	prereq_ids = list("base")
	design_ids = list(
		"artifact_heater",
		"artifact_xray",
		"disk_artifact",
		"artifact_wand"
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/gravity_gun
	id = "gravity_gun"
	display_name = "One-point Bluespace-gravitational Manipulator"
	description = "Fancy wording for gravity gun."
	prereq_ids = list("adv_weaponry", "bluespace_travel")
	design_ids = list(
		"gravitygun",
		"mech_gravcatapult",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)

/datum/techweb_node/advanced_bluespace
	id = "bluespace_storage"
	display_name = "Advanced Bluespace Storage"
	description = "With the use of bluespace we can create even more advanced storage devices than we could have ever done"
	prereq_ids = list("micro_bluespace", "janitor")
	design_ids = list(
		"bag_holding",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/tier_three
	id = "tier_three"
	display_name = "Tier Three Parts"
	description = "We can rebuild it. We have the technology. We have the capability to make the station's first useful machine. Better than it was before, Better... Stronger... Faster."
	prereq_ids = list("emp_basic", "engineering", "datatheory")
	design_ids = list(
		"phasic_scanning",
		"ultra_micro_laser",
		"pico_mani",
		"super_matter_bin",
		"hyper_cell",
		"super_capacitor",
		"super_cell",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 12500)
	discount_experiments = list(
		/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_microlaser = 2500,
		/datum/experiment/scanning/points/machinery_tiered_scan/tier2_lathes = 5000,
	)

/datum/techweb_node/tier_four
	id = "tier_four"
	display_name = "Tier Four Parts"
	description = "The problem's plain to see, too much technology."
	prereq_ids = list("tier_three", "adv_power", "practical_bluespace")
	design_ids = list(
	"bluespace_matter_bin",
	"femto_mani",
	"triphasic_scanning",
	"bluespace_cell",
	"quadratic_capacitor",
	"quadultra_micro_laser",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 15000)
	discount_experiments = list(
		/datum/experiment/scanning/points/machinery_tiered_scan/tier3_variety = 5000,
		/datum/experiment/ordnance/gaseous/noblium = 7500,
	)
