local module = ... or D:module("environment_selector")

local GameSetup = module:hook_class("GameSetup")
module:post_hook(50, GameSetup, "init_finalize", function(self)
	local level_id = Global.game_settings.level_id or "bank"
	local env_conf = D:conf("environment_selector_" .. level_id) or "bank"
	if env_conf == "default" then
		return
	end

	local level_list = {
		"bank",
		"street",
		"apartment",
		"bridge",
		"diamond_heist",
		"slaughter_house",
		"suburbia",
		"secret_stash",
		"hospital",
	}

	if env_conf == "random" then
		env_conf = level_list[math.random(1, #level_list)] or "bank"
	end

	local packages = {
		["bank"] = "levels/bank/world",
		["apartment"] = "levels/apartment/world",
		["street"] = "levels/street/world",
		["bridge"] = "levels/bridge/world",
		["diamond_heist"] = "levels/diamondheist/world",
		["slaughter_house"] = "levels/slaughterhouse/world",
		["suburbia"] = "levels/suburbia/world",
		["secret_stash"] = "levels/secret_stash/world",
		["hospital"] = "levels/l4d/world",
	}

	local selected_package = packages[env_conf] or packages["bank"]

	if not PackageManager:loaded(selected_package) then
		PackageManager:load(selected_package)
	end

	local environments = {
		["bank"] = "environments/env_bank/env_bank",
		["street"] = "environments/env_street/env_street",
		["apartment"] = "environments/env_apartment/env_apartment",
		["bridge"] = "environments/env_bridge2/env_bridge2",
		["diamond_heist"] = "environments/env_diamond2/env_diamond2",
		["slaughter_house"] = "environments/env_slaughterhouse/env_slaughterhouse",
		["suburbia"] = "environments/env_suburbia/env_suburbia",
		["secret_stash"] = "environments/env_undercover/env_undercover",
		["hospital"] = "environments/env_l4d/env_l4d",
	}

	local env_name = environments[env_conf]
	managers.viewport:preload_environment(env_name)
	managers.environment_area:set_default_environment(env_name, nil, nil)
end)
