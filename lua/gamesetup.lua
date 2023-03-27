local module = ... or D:module("environment_selector")

local GameSetup = module:hook_class("GameSetup")

module:post_hook(50, GameSetup, "load_packages", function(self)
	local level_id = Global.game_settings.level_id or "bank"
	if next(tweak_data.levels[level_id].environment_effects or {}) then
		if not PackageManager:loaded("packages/rain_effect") then
			PackageManager:load("packages/rain_effect")
		end
	end
end)

module:post_hook(50, GameSetup, "init_finalize", function(self)
	local level_id = Global.game_settings.level_id or "bank"
	local env_conf = D:conf("environment_selector_" .. level_id) or "bank"
	if env_conf == "default" then
		return
	end

	local level_list = {
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

	if env_conf == "random" then
		env_conf = level_list[math.random(1, #level_list)] or "bank"
	end

	if env_conf == level_id then
		return
	end

	local packages = {
		["bank"] = "levels/bank/world",
		["apartment"] = "levels/apartment/world",
		["heat_street"] = "levels/street/world",
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

	--* apply environment
	local environments = {
		["bank"] = "environments/env_bank/env_bank",
		["heat_street"] = "environments/env_street/env_street",
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

module:post_hook(50, GameSetup, "unload_packages", function(self)
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
		"packages/rain_effect",
	}) do
		if PackageManager:loaded(package) then
			PackageManager:unload(package)
		end
	end
end)
