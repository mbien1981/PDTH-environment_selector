return DMod:new("environment_selector", {
	name = "Environment selector",
	version = "2.1",
	author = "Dr_Newbie, Whurr, _atom",
	includes = {
		{ "mod_localization", { type = "localization" } },
		{ "mod_options", { type = "menu_options" } },
	},
	hooks = {
		{
			"OnModuleRegistered",
			"OnModuleRegistered_ESCheckDAHMVersion",
			function(module)
				if D:version() >= "1.16.1.5" then
					return
				end

				module:set_state("disabled")
			end,
		},
		{
			"OnModuleLoading",
			"override_environment_data",
			function(module)
				local level_id = tablex.get(Global, "level_data", "level_id")
				if not level_id then
					return
				end

				local environments = {
					apartment = "environments/env_apartment/env_apartment",
					bank = "environments/env_bank/env_bank",
					bridge = "environments/env_bridge2/env_bridge2",
					diamond_heist = "environments/env_diamond2/env_diamond2",
					heat_street = "environments/env_street/env_street",
					hospital = "environments/env_l4d/env_l4d",
					secret_stash = "environments/env_undercover/env_undercover",
					slaughter_house = "environments/env_slaughterhouse/env_slaughterhouse",
					suburbia = "environments/env_suburbia/env_suburbia",
				}
				local cubemaps = {
					apartment = "environments/cubemaps/cubemap_apartment_01",
					bank = "environments/cubemaps/cubemap_bank_01",
					bridge = "environments/cubemaps/cubemap_bridge_01",
					diamond_heist = "environments/cubemaps/cubemap_diamond_01",
					heat_street = "environments/cubemaps/cubemap_street_01",
					hospital = "environments/cubemaps/cubemap_hospital_01",
					secret_stash = "environments/cubemaps/cubemap_secret_stash",
					slaughter_house = "environments/cubemaps/cubemap_slaughter_01",
					suburbia = "environments/cubemaps/cubemap_suburbia_01",
				}

				local environment = D:conf("environment_selector_" .. level_id) or "bank"
				if environment == "default" then
					return
				end

				local path = level_id and environments[level_id]
				if not path then
					return
				end

				local environment_list = {
					"bank",
					"pd2_bank_trailer",
					"heat_street",
					"heat_street_v1",
					"apartment",
					"apartment_v1",
					"bridge",
					"diamond_heist",
					"slaughter_house",
					"suburbia",
					"secret_stash",
					"hospital",
				}

				if environment == "random" then
					environment = environment_list[math.random(1, #environment_list)] or "bank"
				end

				if environment == level_id then
					return
				end

				local script_type = "environment"
				DPackageManager:register_processor(module, module:id(), script_type, path, function(_, _, data)
					local env_data = loadfile(module:path() .. "environments/" .. environment .. ".lua")
					if type(env_data) ~= "function" then
						return
					end
					
					env_data = env_data(cubemaps[level_id])
					
					-- Not the best way to achieve this but allows us to avoid loading level packages and gives us the possibility of adding custom environments without access to custom assets.
					-- Requires DAHM 1.16.1.5 or above.
					tablex.deep_merge(data[2], env_data)
				end)
			end,
		},
		{
			"lib/setups/gamesetup",
			function(module)
				local GameSetup = module:hook_class("GameSetup")

				local package_path = "packages/rain_effect"
				module:post_hook(GameSetup, "load_packages", function()
					local level_id = tablex.get(Global, "game_settings", "level_id") or "bank"
					if next(tweak_data.levels[level_id].environment_effects or {}) then
						if not PackageManager:loaded(package_path) then
							PackageManager:load(package_path)
						end
					end
				end)

				module:post_hook(GameSetup, "unload_packages", function()
					if PackageManager:loaded(package_path) then
						PackageManager:unload(package_path)
					end
				end)
			end,
		},
		{
			"lib/tweak_data/levelstweakdata",
			function(module)
				module:post_hook(module:hook_class("LevelsTweakData"), "init", function(self)
					for _, level in pairs(self._level_index) do
						local heist_effects = {}
						local effect_list = {
							["rain"] = D:conf("environment_selector_" .. level .. "_rain"),
							["raindrop_screen"] = D:conf("environment_selector_" .. level .. "_rain"),
							["lightning"] = D:conf("environment_selector_" .. level .. "_lightning"),
						}

						for effect, enabled in pairs(effect_list) do
							if enabled then
								table.insert(heist_effects, effect)
							end
						end

						self[level].environment_effects = heist_effects
					end
				end)
			end,
		},
	},
	update = { id = "env_selector", url = "https://raw.githubusercontent.com/mbien1981/dahm-modules/main/version.json" },
})
