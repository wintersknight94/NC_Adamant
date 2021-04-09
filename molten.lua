-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()

----- ----- ----- ----- -----

local function anim(name, len)
	return {
		name = name,
		animation = {
			["type"] = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 16
		}
	}
end

local moltdef = {
	description = "Molten Adamant",
	drawtype = "liquid",
	tiles = {anim("nc_terrain_lava.png^[colorize:cyan:100", 8)},
	special_tiles = {
		anim("nc_terrain_lava_flow.png^[colorize:cyan:100", 8),
		anim("nc_terrain_lava_flow.png^[colorize:cyan:100", 8)
	},
	paramtype = "light",
	liquid_viscosity = 9,
	liquid_renewable = false,
	liquid_range = 2,
	light_source = 8,
	walkable = false,
	buildable_to = false,
	drowning = 2,
	damage_per_second = 3,
	drop = "",
	groups = {
		igniter = 1,
		adamanty = 1,
		adamant_molten = 1,
		stack_as_node = 1,
		damage_touch = 1,
		damage_radiant = 5
	},
	stack_max = 1,
--	post_effect_color = {a = 140, r = 0, g = 225, b = 255},
	liquid_alternative_flowing = modname .. ":adamant_hot_flowing",
	liquid_alternative_source = modname .. ":adamant_hot_source",
	sounds = nodecore.sounds("nc_terrain_bubbly")
}

minetest.register_node(modname .. ":adamant_hot_source",
	nodecore.underride({
			liquidtype = "source"
		}, moltdef))
minetest.register_node(modname .. ":adamant_hot_flowing",
	nodecore.underride({
			liquidtype = "flowing",
			drawtype = "flowingliquid",
			paramtype2 = "flowingliquid"
		}, moltdef))

nodecore.register_ambiance({
		label = "adamant source ambiance",
		nodenames = {modname .. ":adamant_hot_source"},
		neigbors = {"air"},
		interval = 1,
		chance = 10,
		sound_name = "nc_terrain_bubbly",
		sound_gain = 0.2
	})
nodecore.register_ambiance({
		label = "adamant flow ambiance",
		nodenames = {modname .. ":adamant_hot_flowing"},
		neigbors = {"air"},
		interval = 1,
		chance = 10,
		sound_name = "nc_terrain_bubbly",
		sound_gain = 0.2
	})
