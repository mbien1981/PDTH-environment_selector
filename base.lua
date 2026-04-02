local assets_directory = ModPath .. "assets/"

local EnvironmentLoader = {}
EnvironmentLoader.assets_dir = assets_directory
EnvironmentLoader.custom_assets_dir = "custom environments/"
EnvironmentLoader.rain_package = "packages/rain_effect"
EnvironmentLoader.choices = {}

function EnvironmentLoader:get_random_environment(m, excluded_key)
	local keys = {}

	for env in pairs(self.assets_paths) do
		if env ~= excluded_key and m:conf(excluded_key .. "_allow_" .. env) then
			table.insert(keys, env)
		end
	end

	if #keys == 0 then
		return nil
	end

	local random_key = keys[math.random(#keys)]

	m:log(5, "selected '" .. random_key .. "' as random environment.")
	return self.assets_paths[random_key]
end

function EnvironmentLoader:get_environment(m, level_id)
	local selected_environment = m:conf(level_id) or "default"
	if selected_environment == "default" then
		return self.assets_paths[level_id]
	end

	if selected_environment == "random" then
		return self:get_random_environment(m, level_id)
	end

	return self.assets_paths[selected_environment]
end

function EnvironmentLoader:get_weather(m, level_id)
	local selected_weather = m:conf(level_id .. "_rain_and_lightnings") or "none"

	local rain, lightnings = false, false
	if selected_weather == "rainy" then
		rain = true
	end

	if selected_weather == "thunderstorm" then
		rain = true
		lightnings = true
	end

	local rain_chance = math.random() > 0.5
	local lightning_chance = math.random() > 0.5
	if selected_weather == "random_rain" then
		rain = rain_chance

		self:debug_print_weather_roll(m, level_id, "rain", rain_chance, selected_weather)
	end

	if selected_weather == "random_thunderstorm" then
		rain = rain_chance
		lightnings = lightning_chance

		self:debug_print_weather_roll(m, level_id, "rain", rain_chance, selected_weather)
		self:debug_print_weather_roll(m, level_id, "lightning", lightning_chance, selected_weather)
	end

	return rain, lightnings
end

function EnvironmentLoader:on_config_changed(k, value)
	if not Util:is_in_state("any_ingame_playing") then
		return
	end

	local level_id = tablex.get(Global, "game_settings", "level_id")
	if level_id and k == "environment_selector_" .. level_id then
		local environment = self:get_environment(D:module("environment_selector"), level_id)

		managers.viewport:preload_environment(environment)
		managers.environment_area:set_default_environment(environment)
	end
end

function EnvironmentLoader:debug_print_weather_roll(m, level_id, effect, success, setting)
	local template = "failed roll for %s effect for level '%s' with setting %s"
	if success then
		template = "successfully rolled %s effect for level '%s' with setting %s"
	end

	m:log(5, template:format(effect, level_id, setting))
end

function EnvironmentLoader:build_choices(level_id)
	local choices = {
		{ "default", "loc_envsel_default_environment" },
		{ "random", "loc_envsel_random_environment" },
	}

	for _, level in ipairs(self.choices) do
		if level ~= level_id then
			table.insert(choices, { level, "loc_envsel_" .. level .. "_env" })
		end
	end

	return choices
end

function EnvironmentLoader:build_config()
	local output = {}

	local ordered_levels = {
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

	for _, level_id in ipairs(ordered_levels) do
		local setting = "environment_selector_" .. level_id
		local submenu = setting .. "_submenu"
		local random_submenu = setting .. "_random_submenu"

		table.insert(output, {
			"menu",
			submenu,
			{
				type = "node",
				name = submenu,
				text_id = "debug_" .. level_id:gsub("heat_", ""),
				topic_id = "debug_" .. level_id:gsub("heat_", ""),
				callback = false,
			},
		})

		-- main selector
		table.insert(output, {
			"menu",
			setting,
			{
				type = "multi_choice",
				node = submenu,
				text_id = "loc_envsel_environment",
				choices = self:build_choices(level_id),
				default_value = "default",
			},
		})

		-- weather selector
		table.insert(output, {
			"menu",
			setting .. "_rain_and_lightnings",
			{
				type = "multi_choice",
				node = submenu,
				text_id = "loc_envsel_rain_and_lightnings",
				choices = {
					{ "none", "loc_envsel_off" },
					{ "rainy", "loc_envsel_rainy" },
					{ "thunderstorm", "loc_envsel_thunderstorm" },
					{ "random_rain", "loc_envsel_random_rain" },
					{ "random_thunderstorm", "loc_envsel_random_thunderstorm" },
				},
				default_value = level_id == "bridge" and "thunderstorm" or "none",
			},
		})

		table.insert(
			output,
			{ "menu", setting .. "_divider", {
				type = "divider",
				node = submenu,
				size = 15,
			} }
		)

		-- nested submenu entry
		table.insert(output, {
			"menu",
			random_submenu,
			{
				type = "node",
				node = submenu,
				name = random_submenu,
				text_id = "loc_envsel_select_random_candidates",
				topic_id = "loc_envsel_select_random_candidates",
				help_id = "loc_envsel_select_random_candidates_help",
				callback = false,
			},
		})

		for _, env in ipairs(self.choices) do
			if env ~= level_id then
				table.insert(output, {
					"menu",
					setting .. "_allow_" .. env,
					{
						type = "boolean",
						node = random_submenu,
						text_id = "loc_envsel_" .. env .. "_env",
						default_value = true,
					},
				})
			end
		end
	end

	return output
end

function EnvironmentLoader:build_localization()
	local localization = {
		loc_envsel_environment = { english = "Level Environment", german = "Levelumgebung" },
		loc_envsel_default_environment = { english = "Default Environment", german = "Standardumgebung" },
		loc_envsel_random_environment = { english = "Random Environment", german = "Zufällige Umgebung" },
		loc_envsel_rain_and_lightnings = { english = "Rain and Lightnings", german = "Regen und Blitze" },
		loc_envsel_off = { english = "Off", german = "Aus" },
		loc_envsel_rainy = { english = "Rainy", german = "Regnerisch" },
		loc_envsel_thunderstorm = { english = "Thunderstorm", german = "Gewitter" },
		loc_envsel_random_rain = { english = "Random Rain", german = "Zufälliger Regen" },
		loc_envsel_random_thunderstorm = { english = "Random Thunderstorm", german = "Zufälliges Gewitter" },
		loc_envsel_select_random_candidates = {
			english = "Select random environment candidates",
			german = "Wähle zufällige Umgebungskandidaten aus",
		},
		loc_envsel_select_random_candidates_help = {
			english = "Select which environments can be chosen when environment is set to random for this heist",
			german = "Wähle Umgebungen aus, die angewendet werden, wenn für diesen Raub zufällige Umgebungen eingestellt wurde",
		},
	}

	if self._custom_localization then
		for id, data in pairs(self._custom_localization) do
			localization[id] = data
		end
	end

	return localization
end

function EnvironmentLoader:load_meta(meta_path)
	if not osx.file_exists(meta_path) then
		return
	end

	local file = io.open(meta_path, "r")
	local data = file and loadstring(file:read("*all"))

	if file then
		file:close()
	end

	return data and data()
end

function EnvironmentLoader:register_entry(entry_type, id, localization, physical_path, virtual_path)
	if not osx.file_exists(physical_path) then
		dlog("ERROR: ENVSEL - find file for environment " .. id)
		return
	end

	table.insert(self.pending_entries, {
		entry_type = entry_type,
		virtual_path = virtual_path,
		physical_path = physical_path,
	})

	if entry_type == "environment" then
		dlog("ENVSEL - create env entry " .. virtual_path)
		self.assets_paths[id] = virtual_path
		table.insert(self.choices, id)

		self._custom_localization["loc_envsel_" .. id .. "_env"] = localization
	end
end

function EnvironmentLoader:scan_main_assets()
	local package_path = self.assets_dir .. "environment_selector.package"
	if not osx.file_exists(package_path) then
		dlog("ERORR: ENVSEL - PACKAGE FOR ENVIRONMENT SELECTOR IS MISSING!")
		return
	end

	local meta = self:load_meta(self.assets_dir .. "meta.lua")
	if type(meta) ~= "table" then
		return
	end

	local entry_suffix = "environments/environment_selector/"
	for _, entry in ipairs(meta) do
		if type(entry) == "table" and entry.id and entry.environment then
			local locale = entry.localization or entry.name or entry.id
			self:register_entry(
				"environment",
				entry.id,
				locale,
				self.assets_dir .. entry.environment,
				entry_suffix .. entry.id
			)
		end
	end

	self:register_entry("package", nil, nil, package_path, "packages/environment_selector")
end

function EnvironmentLoader:scan_custom_assets()
	local entry_suffix = "environments/environment_selector/custom/"
	for folder in pairs(osx.get_directories(self.custom_assets_dir)) do
		local folder_id = folder:gsub("/$", "")
		local base_path = self.custom_assets_dir .. folder_id .. "/"
		local package_path = base_path .. folder_id .. ".package"

		if osx.file_exists(package_path) then
			local meta = self:load_meta(base_path .. "meta.lua")
			if type(meta) == "table" then
				for _, entry in ipairs(meta) do
					if type(entry) == "table" and entry.id and entry.environment then
						local locale = entry.localization or entry.name or entry.id
						self:register_entry(
							"environment",
							entry.id,
							locale,
							base_path .. entry.environment,
							entry_suffix .. entry.id
						)
					end
				end

				local package_entry = "packages/environment_selector/" .. folder_id
				self:register_entry("package", nil, nil, package_path, package_entry)

				table.insert(self.custom_packages, package_entry)
			end
		else
			dlog("ERROR: ENVSEL - Couldn't find a package for " .. folder)
		end
	end
end

function EnvironmentLoader:scan_for_assets()
	self.assets_paths = {}
	self.pending_entries = {}
	self.custom_packages = {}
	self._custom_localization = self._custom_localization or {}

	self:scan_main_assets()
	self:scan_custom_assets()
end

function EnvironmentLoader:create_db_entries()
	for _, entry in ipairs(self.pending_entries) do
		DB:create_entry(entry.entry_type, entry.virtual_path, entry.physical_path)
	end
end

function EnvironmentLoader:load_packages()
	if not DB:has("package", "packages/environment_selector") then
		return
	end

	if not PackageManager:loaded("packages/environment_selector") then
		PackageManager:load("packages/environment_selector")
	end

	for _, package in ipairs(self.custom_packages) do
		if DB:has("package", package) and not PackageManager:loaded(package) then
			PackageManager:load(package)
		end
	end
end

function EnvironmentLoader:unload_packages()
	if not DB:has("package", "packages/environment_selector") then
		return
	end

	if PackageManager:loaded("packages/environment_selector") then
		PackageManager:unload("packages/environment_selector")
	end

	for _, package in ipairs(self.custom_packages) do
		if DB:has("package", package) and PackageManager:loaded(package) then
			PackageManager:unload(package)
		end
	end
end

EnvironmentLoader:scan_for_assets()

return DMod:new("environment_selector", {
	name = "Environment Selector",
	version = "3.0",
	author = "Dr_Newbie, _atom",
	abbr = "ENVSEL",
	config_prefix = "environment_selector",
	config = EnvironmentLoader:build_config(),
	localization = EnvironmentLoader:build_localization(),
	hooks = {
		["lib/setups/setup"] = function(module)
			EnvironmentLoader:create_db_entries()
		end,
		["lib/setups/gamesetup"] = function(module)
			module:post_hook(50, GameSetup, "load_packages", function(self)
				EnvironmentLoader:load_packages()

				if not PackageManager:loaded(EnvironmentLoader.rain_package) then
					PackageManager:load(EnvironmentLoader.rain_package)
				end
			end)

			module:post_hook(50, GameSetup, "unload_packages", function(self)
				EnvironmentLoader:unload_packages()

				if PackageManager:loaded(EnvironmentLoader.rain_package) then
					PackageManager:unload(EnvironmentLoader.rain_package)
				end
			end)
		end,
		["lib/tweak_data/levelstweakdata"] = function(module)
			module:post_hook(module:hook_class("LevelsTweakData"), "init", function(self)
				for _, level_id in pairs(self._level_index) do
					local heist_effects = {}

					local rain, lightnings = EnvironmentLoader:get_weather(module, level_id)

					local effect_list = {
						["rain"] = rain,
						["raindrop_screen"] = rain,
						["lightning"] = lightnings,
					}

					for effect, enabled in pairs(effect_list) do
						if enabled then
							table.insert(heist_effects, effect)
						end
					end

					self[level_id].environment_effects = heist_effects
				end
			end)
		end,
		["core/lib/utils/dev/editor/coreworlddefinition"] = function(module)
			local WorldDefinition = module:hook_module_class("CoreWorldDefinition", "WorldDefinition")

			module:pre_hook(WorldDefinition, "_create_environment", function(self, data, offset)
				local selected_environment = EnvironmentLoader:get_environment(module, Global.game_settings.level_id)
				if not selected_environment then
					return
				end

				data.environment_values.environment = selected_environment
			end)
		end,
	},
	default_menu_option_callback = function(k, value, old_value, old_value_was_user_set, o, item)
		EnvironmentLoader:on_config_changed(k, value)
		return true
	end,
})
