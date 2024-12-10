-- values taken from Whurr's PD2 Trailer Bank environment for First World Bank mod
-- https://modworkshop.net/mod/34809

local global_texture = ...
return {
	[1] = {
		[1] = {
			["value"] = 0,
			["_meta"] = "param",
			["key"] = "rotation",
		},
		["_meta"] = "sky_orientation",
	},
	[2] = {
		[1] = {
			["value"] = Vector3(1, 0.882353, 0.443137),
			["_meta"] = "param",
			["key"] = "sun_ray_color",
		},
		[2] = {
			["value"] = 0.33100000023842,
			["_meta"] = "param",
			["key"] = "sun_anim_x",
		},
		[3] = {
			["value"] = 0.52600002288818,
			["_meta"] = "param",
			["key"] = "sun_anim",
		},
		[4] = {
			["value"] = 1.6119999885559,
			["_meta"] = "param",
			["key"] = "sun_ray_color_scale",
		},
		[5] = {
			["value"] = "core/environments/skies/default/default",
			["_meta"] = "param",
			["key"] = "underlay",
		},
		[6] = {
			["value"] = global_texture or "environments/cubemaps/cubemap_bank_01",
			["_meta"] = "param",
			["key"] = "global_texture",
		},
		["_meta"] = "others",
	},
	[3] = {
		[1] = {
			[1] = {
				[1] = {
					[1] = {
						["value"] = Vector3(1267, 3234, 0),
						["_meta"] = "param",
						["key"] = "slice1",
					},
					[2] = {
						["value"] = Vector3(49999, 50000, 0),
						["_meta"] = "param",
						["key"] = "shadow_fadeout",
					},
					[3] = {
						["value"] = Vector3(1, 1, 1),
						["_meta"] = "param",
						["key"] = "shadow_slice_overlap",
					},
					[4] = {
						["value"] = Vector3(1268, 3234, 10000),
						["_meta"] = "param",
						["key"] = "shadow_slice_depths",
					},
					[5] = {
						["value"] = Vector3(9999, 50000, 0),
						["_meta"] = "param",
						["key"] = "slice3",
					},
					[6] = {
						["value"] = Vector3(0, 1268, 0),
						["_meta"] = "param",
						["key"] = "slice0",
					},
					[7] = {
						["value"] = Vector3(3233, 10000, 0),
						["_meta"] = "param",
						["key"] = "slice2",
					},
					["_meta"] = "shadow_modifier",
				},
				["_meta"] = "shadow_rendering",
			},
			["_meta"] = "shadow_processor",
		},
		[2] = {
			[1] = {
				[1] = {
					[1] = {
						["value"] = 1,
						["_meta"] = "param",
						["key"] = "fadeout_blend",
					},
					["_meta"] = "shadow",
				},
				[2] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "environment_map_intensity",
					},
					[2] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "environment_map_intensity_shadow",
					},
					[3] = {
						["value"] = 1,
						["_meta"] = "param",
						["key"] = "ambient_falloff_scale",
					},
					[4] = {
						["value"] = 0.31999999284744,
						["_meta"] = "param",
						["key"] = "ambient_color_scale",
					},
					[5] = {
						["value"] = Vector3(0, 0, 0),
						["_meta"] = "param",
						["key"] = "sky_reflection_top_color",
					},
					[6] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "sky_reflection_top_color_scale",
					},
					[7] = {
						["value"] = Vector3(0.496063, 0.379342, 0.289856),
						["_meta"] = "param",
						["key"] = "sky_bottom_color",
					},
					[8] = {
						["value"] = 1.6849999427795,
						["_meta"] = "param",
						["key"] = "sky_top_color_scale",
					},
					[9] = {
						["value"] = Vector3(0, 0, 0),
						["_meta"] = "param",
						["key"] = "sun_specular_color",
					},
					[10] = {
						["value"] = Vector3(0, 0, 0),
						["_meta"] = "param",
						["key"] = "height_fade_intesity_clamp",
					},
					[11] = {
						["value"] = Vector3(0, 0, 0),
						["_meta"] = "param",
						["key"] = "sky_reflection_bottom_color",
					},
					[12] = {
						["value"] = 1.8639999628067,
						["_meta"] = "param",
						["key"] = "sky_bottom_color_scale",
					},
					[13] = {
						["value"] = Vector3(-25000, -25000, 0),
						["_meta"] = "param",
						["key"] = "height_fade",
					},
					[14] = {
						["value"] = 1.5,
						["_meta"] = "param",
						["key"] = "ambient_scale",
					},
					[15] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "sun_specular_color_scale",
					},
					[16] = {
						["value"] = 1,
						["_meta"] = "param",
						["key"] = "effect_light_scale",
					},
					[17] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "sky_reflection_bottom_color_scale",
					},
					[18] = {
						["value"] = Vector3(0.108013, 0.121599, 0.173228),
						["_meta"] = "param",
						["key"] = "sky_top_color",
					},
					[19] = {
						["value"] = Vector3(0.566929, 0.529134, 0.495785),
						["_meta"] = "param",
						["key"] = "ambient_color",
					},
					["_meta"] = "apply_ambient",
				},
				[3] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "intensity",
					},
					["_meta"] = "global_ssao",
				},
				[4] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "intensity",
					},
					["_meta"] = "local_ssao",
				},
				[5] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "intensity",
					},
					["_meta"] = "ssao",
				},
				["_meta"] = "deferred_lighting",
			},
			["_meta"] = "deferred",
		},
		[3] = {
			[1] = {
				[1] = {
					["_meta"] = "soften",
				},
				[2] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "near_focus_distance_min",
					},
					[2] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "near_focus_distance_max",
					},
					[3] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "far_focus_distance_min",
					},
					[4] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "far_focus_distance_max",
					},
					[5] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "clamp",
					},
					["_meta"] = "dof",
				},
				[3] = {
					["_meta"] = "depth_blur",
				},
				[4] = {
					["_meta"] = "z",
				},
				[5] = {
					[1] = {
						["value"] = Vector3(0, 0, 0),
						["_meta"] = "param",
						["key"] = "luminance_clamp",
					},
					[2] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "white_luminance",
					},
					[3] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "dark_to_bright_adaption_speed",
					},
					[4] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "bright_to_dark_adaption_speed",
					},
					[5] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "middle_grey",
					},
					[6] = {
						["value"] = "",
						["_meta"] = "param",
						["key"] = "$template_mix",
					},
					["_meta"] = "tone_mapping",
				},
				[6] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "disable_tone_mapping",
					},
					[2] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "middle_grey",
					},
					[3] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "white_luminance",
					},
					[4] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "threshold",
					},
					["_meta"] = "bloom_brightpass",
				},
				[7] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "opacity",
					},
					["_meta"] = "bloom_apply",
				},
				[8] = {
					[1] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "disable_tone_mapping",
					},
					["_meta"] = "exposure_sepia_levels",
				},
				["_meta"] = "default",
			},
			["_meta"] = "hdr_post_processor",
		},
		[4] = {
			[1] = {
				[1] = {
					[1] = {
						["value"] = 1,
						["_meta"] = "param",
						["key"] = "start_color_scale",
					},
					[2] = {
						["value"] = 0.43399998545647,
						["_meta"] = "param",
						["key"] = "end0",
					},
					[3] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "color2_scale",
					},
					[4] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "end2",
					},
					[5] = {
						["value"] = Vector3(1, 0, 0),
						["_meta"] = "param",
						["key"] = "color1",
					},
					[6] = {
						["value"] = Vector3(0.473769, 0.484113, 0.527559),
						["_meta"] = "param",
						["key"] = "start_color",
					},
					[7] = {
						["value"] = Vector3(1, 0, 0),
						["_meta"] = "param",
						["key"] = "color2",
					},
					[8] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "alpha0",
					},
					[9] = {
						["value"] = 0.84600001573563,
						["_meta"] = "param",
						["key"] = "alpha1",
					},
					[10] = {
						["value"] = 19.200000762939,
						["_meta"] = "param",
						["key"] = "color1_scale",
					},
					[11] = {
						["value"] = 0.0099999997764826,
						["_meta"] = "param",
						["key"] = "start",
					},
					[12] = {
						["value"] = 0.37200000882149,
						["_meta"] = "param",
						["key"] = "end1",
					},
					[13] = {
						["value"] = Vector3(1, 0, 0),
						["_meta"] = "param",
						["key"] = "color0",
					},
					[14] = {
						["value"] = 0,
						["_meta"] = "param",
						["key"] = "color0_scale",
					},
					["_meta"] = "fog",
				},
				["_meta"] = "fog",
			},
			["_meta"] = "fog_processor",
		},
		["_meta"] = "post_effect",
	},
	[4] = {
		[1] = {
			[1] = {
				["value"] = 0,
				["_meta"] = "param",
				["key"] = "sky_intensity",
			},
			["_meta"] = "sky_top",
		},
		[2] = {
			[1] = {
				["value"] = 10,
				["_meta"] = "param",
				["key"] = "sun_color_scale",
			},
			[2] = {
				["value"] = Vector3(1, 0.47451, 0.0666667),
				["_meta"] = "param",
				["key"] = "sun_color",
			},
			["_meta"] = "sun",
		},
		[3] = {
			[1] = {
				["value"] = Vector3(0.80315, 0.80315, 0.80315),
				["_meta"] = "param",
				["key"] = "color2",
			},
			[2] = {
				["value"] = 1.0390000343323,
				["_meta"] = "param",
				["key"] = "color1_scale",
			},
			[3] = {
				["value"] = 0.95999997854233,
				["_meta"] = "param",
				["key"] = "color2_scale",
			},
			[4] = {
				["value"] = Vector3(0.764706, 0.835294, 1),
				["_meta"] = "param",
				["key"] = "color1",
			},
			[5] = {
				["value"] = Vector3(0.419608, 0.596078, 1),
				["_meta"] = "param",
				["key"] = "color0",
			},
			[6] = {
				["value"] = 0.95999997854233,
				["_meta"] = "param",
				["key"] = "color0_scale",
			},
			["_meta"] = "sky",
		},
		[4] = {
			[1] = {
				["value"] = Vector3(0.813154, 0.869477, 0.897638),
				["_meta"] = "param",
				["key"] = "color_sun",
			},
			[2] = {
				["value"] = 1.442999958992,
				["_meta"] = "param",
				["key"] = "alpha_scale_opposite_sun",
			},
			[3] = {
				["value"] = 0.80000001192093,
				["_meta"] = "param",
				["key"] = "color_opposite_sun_scale",
			},
			[4] = {
				["value"] = Vector3(0.002, 0.002, 0),
				["_meta"] = "param",
				["key"] = "uv_velocity_b_mask",
			},
			[5] = {
				["value"] = 0,
				["_meta"] = "param",
				["key"] = "uv_scale_b_mask",
			},
			[6] = {
				["value"] = Vector3(0.907056, 0.945654, 0.984252),
				["_meta"] = "param",
				["key"] = "color_opposite_sun",
			},
			[7] = {
				["value"] = Vector3(0, 0, 0),
				["_meta"] = "param",
				["key"] = "uv_velocity_rg_mask",
			},
			[8] = {
				["value"] = 0.80000001192093,
				["_meta"] = "param",
				["key"] = "color_sun_scale",
			},
			[9] = {
				["value"] = 0.64499998092651,
				["_meta"] = "param",
				["key"] = "alpha_scale_sun",
			},
			["_meta"] = "cloud_overlay",
		},
		[5] = {
			[1] = {
				["value"] = 0,
				["_meta"] = "param",
				["key"] = "sky_intensity",
			},
			["_meta"] = "sky_bottom",
		},
		["_meta"] = "underlay_effect",
	},
	["_meta"] = "data",
}
