local module = DMod:new("environment_selector", {
	name = "Environment selector",
	author = "_atom",
	includes = {
		{ "mod_localization", { type = "localization" } },
		{ "mod_options", { type = "menu_options" } },
	},
})

module:hook_post_require("lib/setups/gamesetup", "lua/gamesetup")

for _, package in pairs({
	"levels/apartment/world",
	"levels/bank/world",
	"levels/bridge/world",
	"levels/diamondheist/world",
	"levels/l4d/world",
	"levels/secret_stash/world",
	"levels/slaughterhouse/world",
	"levels/street/world",
	"levels/suburbia/world",
}) do
	if PackageManager:loaded(package) then
		PackageManager:unload(package)
	end
end

return module
