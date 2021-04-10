-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, pairs
    = minetest, nodecore, pairs
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()


minetest.register_node(modname.. ":ore", {
	description = ("Adamant Ore"),
--	drawtype = "liquid",
	tiles = {"nc_terrain_stone.png^(" .. modname .. "_ore.png^[mask:" .. modname .. "_mask_ore.png)"},
	groups = {
		adamanty = 1,
		cracky = 7,
		hard_stone = 6
	},
--	light_source = 24,
	drop_in_place = modname .. ":cobble",
	sounds = nodecore.sounds("nc_terrain_stony")
})

minetest.register_node(modname.. ":cobble", {
	description = ("Adamant Cobble"),
	tiles = {modname .. "_ore.png^nc_terrain_cobble.png"},
	groups = {
		adamant_cobble = 1,
		adamanty = 1,
		cracky = 6,
		cobbley = 1
	},
	alternate_loose = {
		repack_level = 2,
		groups = {
			cracky = 0,
			crumbly = 2,
			falling_repose = 2
		},
		sounds = nodecore.sounds("nc_terrain_chompy")
	}
})

minetest.register_node(modname.. ":cobble_hot", {
	description = "Glowing Adamant Cobble",
	tiles = {
		"nc_terrain_gravel.png^nc_terrain_cobble.png",
		modname .. "_hot.png^nc_terrain_cobble.png",
		"nc_terrain_gravel.png^(" .. modname .. "_hot.png^[mask:"
		.. modname .. "_mask_molten.png)^nc_terrain_cobble.png"
	},
	groups = {
		cracky = 0,
		lodey = 1,
		cobbley = 1,
		stack_as_node = 1,
		damage_touch = 1,
		damage_radiant = 1
	},
	stack_max = 1,
	light_source = 2
	})

minetest.register_ore({
	ore_type = "scatter",
	ore = modname.. ":ore",
	wherein = {"group:stone", "group:sand", "group:gravel", "group:water", "air"},
	clust_scarcity = 75*25*75,
	clust_num_ores = 11,
	clust_size = 24,
	y_min = -31000,
	y_max = -600,
})


