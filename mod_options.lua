local module = ... or D:module("environment_selector")

-- module:add_config_option("ss_selected_character", "default")

local levels = {
	"bank",
	"heat_street",
	"apartment",
	"bridge",
	"diamond_heist",
	"slaughter_house",
	"suburbia",
	"secret_stash",
	"hospital",
}

-- menu nodes
for _, level in pairs(levels) do
	module:add_config_option("environment_selector_" .. level, "default")

	module:add_menu_option("environment_selector_" .. level, {
		type = "multi_choice",
		text_id = "debug_" .. level:gsub("heat_", ""),
		choices = {
			{ "default", "es_loc_default_environment" },
			{ "random", "es_loc_random_environment" },
			{ "bank", "es_loc_bank_environment" },
			{ "heat_street", "es_loc_heat_street_environment" },
			{ "apartment", "es_loc_apartment_environment" },
			{ "bridge", "es_loc_bridge_environment" },
			{ "diamond_heist", "es_loc_diamond_heist_environment" },
			{ "slaughter_house", "es_loc_slaughter_house_environment" },
			{ "suburbia", "es_loc_suburbia_environment" },
			{ "secret_stash", "es_loc_secret_stash_environment" },
			{ "hospital", "es_loc_hospital_environment" },
		},
		default_value = "default",
	})
end
