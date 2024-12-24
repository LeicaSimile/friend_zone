return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`friend_zone` encountered an error loading the Darktide Mod Framework.")

		new_mod("friend_zone", {
			mod_script       = "friend_zone/scripts/mods/friend_zone/friend_zone",
			mod_data         = "friend_zone/scripts/mods/friend_zone/friend_zone_data",
			mod_localization = "friend_zone/scripts/mods/friend_zone/friend_zone_localization",
		})
	end,
	packages = {},
}
