-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()

nodecore.register_lode("Bar", {
		["type"] = "node",
		description = "## Adamant Bar",
		drawtype = "nodebox",
		node_box = nodecore.fixedbox(-1/16, -0.5, -1/16, 1/16, 0, 1/16),
		tiles = {modname .. "_#.png"},
		light_source = 1,
		crush_damage = 1,
		paramtype = "light",
		sunlight_propagates = true,
		groups = {
			falling_repose = 1,
			chisel = 1
		}
	})

nodecore.register_craft({
		label = "anvil making adamant bar",
		priority = -1,
		action = "pummel",
		toolgroups = {thumpy = 5},
		nodes = {
			{
				match = modname .. ":prill_annealed",
				replace = "air"
			},
			{
				y = -1,
				match = {
					metal_temper_cool = true,
					groups = {metal_block = true}
				},
			}
		},
		items = {
			modname .. ":bar_annealed"
		}
	})

nodecore.register_craft({
		label = "anvil recycle adamant bar",
		priority = -1,
		action = "pummel",
		toolgroups = {thumpy = 5},
		normal = {y = 1},
		nodes = {
			{
				match = modname .. ":bar_annealed",
				replace = "air"
			},
			{
				y = -1,
				match = {
					metal_temper_cool = true,
					groups = {metal_block = true}
				},
			}
		},
		items = {
			modname .. ":prill_annealed"
		}
	})

nodecore.register_lode("Rod", {
		["type"] = "node",
		description = "## Adamant Rod",
		drawtype = "nodebox",
		node_box = nodecore.fixedbox(-1/16, -0.5, -1/16, 1/16, 0.5, 1/16),
		tiles = {modname .. "_#.png"},
		light_source = 2,
		crush_damage = 2,
		paramtype = "light",
		sunlight_propagates = true,
		groups = {
			falling_repose = 2,
			chisel = 2
		}
	})

nodecore.register_craft({
		label = "anvil making adamant rod",
		action = "pummel",
		toolgroups = {thumpy = 5},
		nodes = {
			{
				match = {name = modname .. ":bar_annealed", count = 2},
				replace = "air"
			},
			{
				y = -1,
				match = {
					metal_temper_cool = true,
					groups = {metal_block = true}
				},
			}
		},
		items = {
			modname .. ":rod_annealed"
		}
	})

nodecore.register_craft({
		label = "recycle adamant rod",
		action = "pummel",
		toolgroups = {choppy = 5},
		nodes = {
			{
				match = modname .. ":rod_annealed",
				replace = "air"
			}
		},
		items = {
			{name = modname .. ":bar_annealed", count = 2}
		}
	})
