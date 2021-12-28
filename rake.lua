-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()

local loosevol = nodecore.rake_volume(2, 1)
local loosetest = nodecore.rake_index(function(def)
		return def.groups and def.groups.falling_node
		and def.groups.snappy == 1
	end)
local snapvol = nodecore.rake_volume(1, 1)
local crumbvol = nodecore.rake_volume(1, 0)
local function mkonrake(toolcaps)
	local snaptest = nodecore.rake_index(function(def)
			return def.groups and def.groups.snappy
			and def.groups.snappy <= toolcaps.opts.snappy
		end)
	local crumbtest = nodecore.rake_index(function(def)
			return def.groups and def.groups.crumbly
			and def.groups.crumbly <= toolcaps.opts.crumbly
		end)
	return function(pos, node)
		if loosetest(pos, node) then return loosevol, loosetest end
		if snaptest(pos, node) then return snapvol, snaptest end
		if crumbtest(pos, node) then return crumbvol, crumbtest end
	end
end
nodecore.lode_rake_function = mkonrake

nodecore.register_adamant("rake", {
		type = "tool",
		description = "## Adamant Rake",
		inventory_image = modname .. "_#.png^[mask:nc_lode_rake.png",
		stack_max = 1,
		light_source = 3,
		bytemper = function(t, d)
			local dlv = 0
			if t.name == "tempered" then
				dlv = 1
			elseif t.name == "hot" then
				dlv = -1
			end
			d.tool_capabilities = nodecore.toolcaps({
					snappy = 4,
					crumbly = 5 + dlv,
					uses = 40 + 25 * dlv
				})
			d.on_rake = mkonrake(d.tool_capabilities)
		end,
		tool_wears_to = modname .. ":prill_# 12"
	})

local adze = {name = modname .. ":adze_annealed", wear = 0.05}
nodecore.register_craft({
		label = "assemble adamant rake",
		action = "pummel",
		toolgroups = {thumpy = 4},
		norotate = true,
		priority = 1,
		indexkeys = {modname .. ":bar_annealed"},
		nodes = {
			{match = modname .. ":bar_annealed", replace = "air"},
			{y = -1, match = modname .. ":block_tempered"},
			{x = 0, z = -1, match = adze, replace = "air"},
			{x = 0, z = 1, match = adze, replace = "air"},
			{x = -1, z = 0, match = adze, replace = "air"},
			{x = 1, z = 0, match = adze, replace = "air"},
		},
		items = {
			modname .. ":rake_annealed"
		}
	})
nodecore.register_craft({
		label = "recycle adamant rake",
		action = "pummel",
		toolgroups = {choppy = 4},
		indexkeys = {modname .. ":rake_hot"},
		nodes = {
			{
				match = modname .. ":rake_hot",
				replace = "air"
			}
		},
		items = {
			{name = modname .. ":bar_hot", count = 5},
			{name = modname .. ":rod_hot", count = 4}
		}
	})
