local mod = get_mod("friend_zone")

local function get_colour_widgets(group_id, default_colour)
	local widgets = {
		{
			setting_id = group_id .. "_colour_red",
			type = "numeric",
			default_value = default_colour[1],
			range = {0, 100},
		},
		{
			setting_id = group_id .. "_colour_green",
			type = "numeric",
			default_value = default_colour[2],
			range = {0, 100},
		},
		{
			setting_id = group_id .. "_colour_blue",
			type = "numeric",
			default_value = default_colour[3],
			range = {0, 100},
		},
		{
			setting_id = group_id .. "_colour_alpha",
			type = "numeric",
			default_value = default_colour[4],
			range = {1, 100},
		},
	}
	return widgets
end

local function add_setting(group, group_id, default_colour, default_enabled, colour_groups)
	if default_enabled == nil then
		default_enabled = true
	end

	local colour_widgets = get_colour_widgets(group_id, default_colour)
	if colour_groups then
		for _, v in ipairs(colour_groups) do
			for _, w in ipairs(get_colour_widgets(v[1], v[2])) do
				table.insert(colour_widgets, w)
			end
		end
	end

	local sub_widgets_group = group.sub_widgets
	table.insert(sub_widgets_group, {
		setting_id = group_id .. "_zone_enabled",
		type = "checkbox",
		default_value = default_enabled,
		tooltip = group_id .. "_zone_enabled_tooltip",
		sub_widgets = colour_widgets,
	})
end

local group_names = {
	"grenade_effects",
}
local groups = {}
for _, name in ipairs(group_names) do
	groups[name] = {
		setting_id = name .. "_group",
		type = "group",
		sub_widgets = {},
	}
end
add_setting(groups.grenade_effects, "grenade_aim_preview", {60, 0, 0, 30})
add_setting(groups.grenade_effects, "smoke_grenade_active", {0, 20, 40, 30})

local fz_widgets = {}
for _, val in ipairs(group_names) do
	-- Make sure to insert from top to bottom as listed in group_names
	table.insert(fz_widgets, groups[val])
end

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = fz_widgets,
	}
}
