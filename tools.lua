-- LUALOCALS < ---------------------------------------------------------
local ipairs, minetest, nodecore, pairs, type
    = ipairs, minetest, nodecore, pairs, type
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()

local function toolhead(name, groups, prills)
	local n = name:lower()

	if type(groups) == "string" then groups = {groups} end
	local function toolcap(nn)
		local t = {}
		for _, k in ipairs(groups) do t[k] = nn end
		return nodecore.toolcaps(t)
	end

	nodecore.register_lode("toolhead_" .. n, {
			type = "craft",
			description = "## Adamant " .. name .. " Head",
			inventory_image = modname .. "_#.png^[mask:nc_adamant_toolhead_" .. n .. ".png",
			stack_max = 1
		})

	nodecore.register_lode("tool_" .. n, {
			type = "tool",
			description = "## Adamant " .. name,
			inventory_image = ("nc_lode_tempered.png^[mask:nc_adamant_mask_tool_handle.png^(" ..
			modname .. "_#.png^[mask:nc_adamant_tool_" .. n .. ".png)"),
			stack_max = 1,
			tool_capabilities = toolcap(6),
			bytemper = function(t, d)
				if t.name == "tempered" then
					d.tool_capabilities = toolcap(100)
				end
				d.skip_register = (t.name == "hot") or nil
			end,
--			groups = {flammable = 4},
			metal_alt_hot = modname .. ":prill_hot " .. prills,
			tool_wears_to = prills > 1 and (modname .. ":prill_# " .. (prills - 1)) or nil,
--			on_ignite = modname .. ":prill_# " .. prills
		})

	for _, t in pairs({"annealed", "tempered"}) do
		nodecore.register_craft({
				label = "assemble adamant " .. n,
				normal = {y = 1},
				nodes = {
					{match = modname .. ":toolhead_" .. n .. "_" .. t,
						replace = "air"},
					{y = -1, match = "nc_lode:rod_tempered", replace = "air"},
				},
				items = {
					{y = -1, name = modname .. ":tool_" .. n .. "_" .. t},
				}
			})
	end
end

toolhead("Mallet", "thumpy", 3)
toolhead("Spade", "crumbly", 2)
toolhead("Hatchet", "choppy", 2)
toolhead("Pick", "cracky", 1)

local function forgecore(from, fromqty, to, prills, fromtemper, anviltemper)
	return nodecore.register_craft({
			label = anviltemper .. " anvil making " .. fromtemper .. " adamant " .. (to or "prills"),
			action = "pummel",
			toolgroups = {thumpy = 5},
			nodes = {
				{
					match = {name = modname .. ":" .. from .. "_" .. fromtemper,
						count = fromqty},
					replace = "air"
				},
				{
					y = -1,
					match = {
					metal_temper_cool = true,
					groups = {metal_cube = true}
				},
				}
			},
			items = {
				to and (modname .. ":" .. to .. "_" .. fromtemper) or nil,
				prills and {name = modname .. ":prill_" .. fromtemper, count = prills,
					scatter = 5} or nil
			}
		})
end

local function forge(from, fromqty, to, prills)
	forgecore(from, fromqty, to, prills, "hot", "annealed")
	forgecore(from, fromqty, to, prills, "hot", "tempered")
	return forgecore(from, fromqty, to, prills, "annealed", "tempered")
end

forge("prill", 3, "toolhead_mallet")
forge("toolhead_mallet", nil, "toolhead_spade", 1)
forge("toolhead_spade", nil, "toolhead_hatchet")
forge("toolhead_hatchet", nil, "toolhead_pick", 1)
forge("toolhead_pick", nil, nil, 1)

toolhead("Mattock", {"cracky", "crumbly"}, 3)
local function mattock(a, b)
	return nodecore.register_craft({
			label = "assemble adamant mattock head",
			action = "pummel",
			toolgroups = {thumpy = 5},
			normal = {y = 1},
			nodes = {
				{
					y = a,
					match = modname .. ":toolhead_pick_hot",
					replace = "air"
				},
				{
					y = b,
					match = modname .. ":toolhead_spade_hot",
					replace = "air"
				}
			},
			items = {
				modname .. ":toolhead_mattock_hot"
			}
		})
end
mattock(0, -1)
mattock(-1, 0)
