local module = DMod:new("environment_selector", {
	name = "Environment selector",
	author = "_atom",
	includes = {
		{ "mod_localization", { type = "localization" } },
		{ "mod_options", { type = "menu_options" } },
	},
})

module:hook_post_require("lib/setups/gamesetup", "lua/gamesetup")

return module
