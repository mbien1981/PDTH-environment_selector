local module = ... or D:module("environment_selector")

module:add_localization_string("es_loc_default_environment", {
	english = "Default Environment",
})

module:add_localization_string("es_loc_random_environment", {
	english = "Random Environment",
})


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
local level_names = {
	english = {
		["bank"] = "First World Bank",
		["heat_street"] = "Heat Street",
		["apartment"] = "Panic Room",
		["bridge"] = "Green Bridge",
		["diamond_heist"] = "Diamond Heist",
		["slaughter_house"] = "Slaughter House",
		["suburbia"] = "Counterfeit",
		["secret_stash"] = "Undercover",
		["hospital"] = "No Mercy",
	},
	french = {
		["bank"] = "First World Bank",
		["heat_street"] = "Heat Street",
		["apartment"] = "Panic Room",
		["bridge"] = "Green Bridge",
		["diamond_heist"] = "Diamond Heist",
		["slaughter_house"] = "Slaughter House",
		["suburbia"] = "Counterfeit",
		["secret_stash"] = "Undercover",
		["hospital"] = "No Mercy",
	},
}

for _, level in pairs(levels) do
	module:add_localization_string("es_loc_" .. level .. "_environment", {
		english = string.format("%s Environment", level_names["english"][level]),
	})

	module:add_localization_string("es_loc_rain_on_" .. level, {
		english = string.format("Rain on %s", level_names["english"][level]),
	})
	module:add_localization_string("es_loc_lightning_on_" .. level, {
		english = string.format("Lightnings on %s", level_names["english"][level]),
	})
end
