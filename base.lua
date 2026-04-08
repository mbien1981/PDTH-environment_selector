local assets_directory = ModPath .. "assets/"

local EnvironmentLoader = {}
EnvironmentLoader.assets_dir = assets_directory
EnvironmentLoader.custom_assets_dir = "custom environments/"
EnvironmentLoader.packages = {
	environment_selector = "packages/environment_selector",
	rain = "packages/rain_effect",
}
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
	local setting = m:conf(level_id .. "_rain_and_lightnings") or "none"

	local rain = setting == "rainy" or setting == "thunderstorm"
	local lightning = setting == "thunderstorm"
	local snow = setting == "snowy"

	if setting == "random_rain" or setting == "random_thunderstorm" then
		rain = math.random() > 0.5
		self:debug_print_weather_roll(m, level_id, "rain", rain, setting)
	end

	if setting == "random_thunderstorm" then
		lightning = math.random() > 0.5
		self:debug_print_weather_roll(m, level_id, "lightning", lightning, setting)
	end

	if setting == "random_snow" then
		snow = math.random() > 0.5
		self:debug_print_weather_roll(m, level_id, "snow", snow, setting)
	end

	return rain, lightning, snow
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
		return
	end

	if level_id and k == "environment_selector_" .. level_id .. "_rain_and_lightnings" then
		for _, effect in ipairs({ "rain", "raindrop_screen", "lightning", "snow" }) do
			managers.environment_effects:stop(effect)
		end

		local rain, lightnings, snow = EnvironmentLoader:get_weather(D:module("environment_selector"), level_id)
		for effect, enabled in pairs({
			["rain"] = rain,
			["raindrop_screen"] = rain,
			["lightning"] = lightnings,
			["snow"] = snow,
		}) do
			if enabled then
				managers.environment_effects:use(effect)
			end
		end

		return
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
					{ "snowy", "loc_envsel_snowy" },
					{ "random_rain", "loc_envsel_random_rain" },
					{ "random_thunderstorm", "loc_envsel_random_thunderstorm" },
					{ "random_snow", "loc_envsel_random_snow" },
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
		loc_envsel_rain_and_lightnings = { english = "Weather", german = "Wetter" },
		loc_envsel_off = { english = "Off", german = "Aus" },
		loc_envsel_rainy = { english = "Rainy", german = "Regnerisch" },
		loc_envsel_thunderstorm = { english = "Thunderstorm", german = "Gewitter" },
		loc_envsel_snowy = { english = "Snowy", german = "Verschneit" },
		loc_envsel_random_rain = { english = "Random Rain", german = "Zufälliger Regen" },
		loc_envsel_random_thunderstorm = { english = "Random Thunderstorm", german = "Zufälliges Gewitter" },
		loc_envsel_random_snow = { english = "Random Snow", german = "Zufälliger Schnee" },
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

function EnvironmentLoader:register_entry(ext, id, localization, file_path, entry_path)
	if not osx.file_exists(file_path) then
		dlog("ERROR: ENVSEL - find " .. ext .. " file for " .. entry_path)
		return
	end

	table.insert(self.pending_entries, {
		ext = ext,
		entry_path = entry_path,
		file_path = file_path,
	})

	if ext == "environment" then
		self.assets_paths[id] = entry_path
		table.insert(self.choices, id)

		self._custom_localization["loc_envsel_" .. id .. "_env"] = localization
	end
end

function EnvironmentLoader:_register_environment_entries(meta, base_path, entry_suffix)
	if type(meta) ~= "table" then
		return
	end

	for _, entry in ipairs(meta) do
		if type(entry) == "table" and entry.id and entry.environment then
			local ext = "environment"
			local locale = entry.localization or entry.name or entry.id
			local asset_path = base_path .. entry.environment
			local entry_path = entry_suffix .. entry.id

			self:register_entry(ext, entry.id, locale, asset_path, entry_path)
		end
	end
end

function EnvironmentLoader:scan_included_environments()
	local entry_suffix = "environments/environment_selector/"
	local meta = self:load_meta(self.assets_dir .. "meta.lua")

	self:_register_environment_entries(meta, self.assets_dir, entry_suffix)
end

function EnvironmentLoader:scan_custom_environments()
	local entry_suffix = "environments/environment_selector/custom/"

	for folder in pairs(osx.get_directories(self.custom_assets_dir)) do
		local folder_id = folder:gsub("/$", "")
		local base_path = self.custom_assets_dir .. folder_id .. "/"
		local meta = self:load_meta(base_path .. "meta.lua")

		self:_register_environment_entries(meta, base_path, entry_suffix)
	end
end

function EnvironmentLoader:load_snow_assets()
	local assets = {
		{ "texture", "effects/textures/debris/e_snow_flakes_2x2", "snow/e_snow_flakes_2x2" },
		{ "texture", "effects/textures/debris/e_snow_flakes_2x2_blur", "snow/e_snow_flakes_2x2_blur" },
		{ "texture", "effects/textures/debris/e_snow_flakes_2x2_less_blur", "snow/e_snow_flakes_2x2_less_blur" },
		{ "texture", "effects/textures/effects_atlas", "snow/effects_atlas" },
		{ "effect", "effects/particles/snow/snow_01", "snow/snow_01" },
	}

	for _, asset in ipairs(assets) do
		local file_path = self.assets_dir .. asset[3] .. "." .. asset[1]
		self:register_entry(asset[1], nil, nil, file_path, asset[2])
	end
end

local package_extensions = { environment = true, effect = true }
function EnvironmentLoader:build_package_xml()
	local lines = { "<package>", "\t<resources>" }

	for _, entry in ipairs(self.pending_entries) do
		local ext = entry.ext
		local path = entry.entry_path

		if package_extensions[ext] and DB:has(ext, path) then
			table.insert(lines, string.format('\t\t<%s name="%s" />', ext, path))
		end
	end

	table.insert(lines, "\t</resources>")
	table.insert(lines, "</package>")

	return table.concat(lines, "\n")
end

function EnvironmentLoader:create_package()
	local file_path = self.assets_dir .. "environment_selector.package"
	local file = io.open(file_path, "w")
	if not file then
		return
	end

	file:write(self:build_package_xml())
	file:close()

	self:register_entry("package", nil, nil, file_path, self.packages.environment_selector)
end

function EnvironmentLoader:scan_for_assets()
	self.assets_paths = {}
	self.pending_entries = {}
	self.custom_packages = {}
	self._custom_localization = self._custom_localization or {}

	self:load_snow_assets()
	self:scan_included_environments()
	self:scan_custom_environments()
	self:create_package()
end

function EnvironmentLoader:create_db_entries()
	for _, entry in ipairs(self.pending_entries) do
		DB:create_entry(entry.ext, entry.entry_path, entry.file_path)
	end
end

function EnvironmentLoader:load_packages()
	local env_package = self.packages.environment_selector
	if DB:has("package", env_package) and not PackageManager:loaded(env_package) then
		PackageManager:load(env_package)
	end

	if not PackageManager:loaded(self.packages.rain) then
		PackageManager:load(self.packages.rain)
	end
end

function EnvironmentLoader:unload_packages()
	local env_package = self.packages.environment_selector
	if DB:has("package", env_package) and PackageManager:loaded(env_package) then
		PackageManager:unload(env_package)
	end

	if PackageManager:loaded(self.packages.rain) then
		PackageManager:unload(self.packages.rain)
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
	default_menu_option_callback = function(k, value, old_value, old_value_was_user_set, o, item)
		EnvironmentLoader:on_config_changed(k, value)
		return true
	end,
	localization = EnvironmentLoader:build_localization(),
	hooks = {
		["lib/setups/setup"] = function(module)
			EnvironmentLoader:create_db_entries()
		end,
		["lib/setups/gamesetup"] = function(module)
			module:post_hook(50, GameSetup, "load_packages", function(self)
				EnvironmentLoader:load_packages()
			end)

			module:post_hook(50, GameSetup, "unload_packages", function(self)
				EnvironmentLoader:unload_packages()
			end)
		end,
		["lib/tweak_data/levelstweakdata"] = function(module)
			module:post_hook(module:hook_class("LevelsTweakData"), "init", function(self)
				for _, level_id in pairs(self._level_index) do
					local heist_effects = {}

					local rain, lightnings, snow = EnvironmentLoader:get_weather(module, level_id)

					local effect_list = {
						["rain"] = rain,
						["raindrop_screen"] = rain,
						["lightning"] = lightnings,
						["snow"] = snow,
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
		["core/lib/utils/dev/tools/particle_editor/coreparticleeditorinitializers"] = function(module)
			local CoreParticleEditorInitializers = module:hook_module_class("CoreParticleEditorInitializers")
			module:hook(CoreParticleEditorInitializers, "create_boxevenposition", function(self)
				local initializer = CoreEffectStackMember:new("boxevenposition", "initializer", "")

				local p = CoreEffectProperty:new("relative", "value_list", "effect", "")

				p:add_value("effect")
				p:add_value("world")
				initializer:add_property(p)

				p = CoreEffectProperty:new("box", "box", "", "")
				p:set_min_max(Vector3(-1, -1, -1), Vector3(1, 1, 1))
				initializer:add_property(p)

				return initializer
			end)
		end,
		["lib/managers/environmenteffectsmanager"] = function(module)
			local EnvironmentEffectsManager = module:hook_class("EnvironmentEffectsManager")
			module:post_hook(EnvironmentEffectsManager, "init", function(self)
				self:add_effect("snow", RainEffect:new(Idstring("effects/particles/snow/snow_01")))
			end)

			local EnvironmentEffect = module:hook_class("EnvironmentEffect")
			local RainEffect = module:hook_class("RainEffect")
			module:hook(RainEffect, "init", function(self, effect_name)
				EnvironmentEffect.init(self)
				self._effect_name = effect_name or Idstring("effects/particles/rain/rain_01_a")
			end)
		end,
	},
})
