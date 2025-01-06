local mod = get_mod("friend_zone")
local utils = mod:io_dofile("friend_zone/scripts/mods/friend_zone/core/utils")

local init_loc = {
	mod_name = {
		["en"] = "Friend Zone",
	},
	mod_description = {
		["en"] = "friend_zone description",
	},

	grenade_effects_group = {
		["en"] = "Grenade Zones",
	},
	grenade_aim_preview_zone_enabled = {
		["en"] = "Grenade Aiming Preview",
	},
	grenade_aim_preview_zone_enabled_tooltip = {
		["en"] = "While aiming a grenade, show approximate area your grenade will affect",
	},
	smoke_grenade_active_zone_enabled = {
		["en"] = "Veteran Smoke Grenade",
	},
	smoke_grenade_active_zone_enabled_tooltip = {
		["en"] = "Show Veteran smoke grenade radius when active",
	},
}

local function add_group_loc(group_id, table, subheader)
	-- Use nbsp ( ) instead of regular spaces between characters that should stay on the same line
	-- e.g. for displaying "indents"
	if subheader then
		table[group_id .. "_colour_red"] = {
			["en"] = subheader["en"] .. "\n    Red (%%)\n ",
			["zh-cn"] = subheader["zh-cn"] .. "\n    红色（%%）\n ",
			["ru"] = subheader["ru"] .. "\n    Красный (%%)\n ",
		}
		table[group_id .. "_colour_green"] = {
			["en"] = "    Green (%%)",
			["zh-cn"] = "    绿色（%%）",
			["ru"] = "    Зелёный (%%)",
		}
		table[group_id .. "_colour_blue"] = {
			["en"] = "    Blue (%%)",
			["zh-cn"] = "    蓝色（%%）",
			["ru"] = "    Синий (%%)",
		}
		table[group_id .. "_colour_alpha"] = {
			["en"] = "    Opacity (%%)",
			["zh-cn"] = "    不透明度（%%）",
			["ru"] = "    Прозрачность (%%)",
		}
	else
		table[group_id .. "_colour_red"] = {
			["en"] = "Red (%%)",
			["zh-cn"] = "红色（%%）",
			["ru"] = "Красный (%%)",
		}
		table[group_id .. "_colour_green"] = {
			["en"] = "Green (%%)",
			["zh-cn"] = "绿色（%%）",
			["ru"] = "Зелёный (%%)",
		}
		table[group_id .. "_colour_blue"] = {
			["en"] = "Blue (%%)",
			["zh-cn"] = "蓝色（%%）",
			["ru"] = "Синий (%%)",
		}
		table[group_id .. "_colour_alpha"] = {
			["en"] = "Opacity (%%)",
			["zh-cn"] = "不透明度（%%）",
			["ru"] = "Прозрачность (%%)",
		}
	end
end

local subheaders_loc = {}

local localizations = {}
for key, val in pairs(init_loc) do
	localizations[key] = val
	local match = "_zone_enabled"
	if utils.endswith(key, match) then
		local group_id = utils.strip_end(key, match)
		local subheaders = subheaders_loc[group_id]
		if subheaders then
			for _, v in ipairs(subheaders) do
				add_group_loc(v.group_id, localizations, v.loc)
			end
		else
			add_group_loc(group_id, localizations)
		end
	end
end

return localizations
