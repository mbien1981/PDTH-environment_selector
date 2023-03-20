local module = ... or D:module("environment_selector")

local LevelsTweakData = module:hook_class("LevelsTweakData")
module:post_hook(50, LevelsTweakData, "init", function(self, _)
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
