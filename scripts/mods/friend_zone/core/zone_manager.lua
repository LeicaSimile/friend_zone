local mod = get_mod("friend_zone")
local Queue = mod:io_dofile("friend_zone/scripts/mods/friend_zone/core/queue")
local Settings = mod:io_dofile("friend_zone/scripts/mods/friend_zone/core/settings")
local Validators = mod:io_dofile("friend_zone/scripts/mods/friend_zone/validators")
local ZoneTemplates = mod:io_dofile("friend_zone/scripts/mods/friend_zone/zone_templates")

table.unpack = table.unpack or unpack
local zones = mod:persistent_table("fz_zones")
local decal_path = "content/levels/training_grounds/fx/decal_aoe_indicator"
local package_path = "content/levels/training_grounds/missions/mission_tg_basic_combat_01"
local loading_packages = {}
local manager = {}

manager.loaded_package = function(callback_func, ...)
    if Managers.package:has_loaded(package_path) then
        return true
    else
		mod:echo("Queueing callback")
		if callback_func ~= nil then
			Queue.add(package_path, callback_func, ...)
		end

		local loading = loading_packages[package_path]
		if not loading then
			mod:echo("Loading package...")
			loading_packages[package_path] = true
			Managers.package:load(package_path, "friend_zone", function()
				mod:echo("Loaded package! Running queue...")
				Queue.run(package_path)
				mod:echo("Queue finished.")
				loading_packages[package_path] = false
			end)
		end
		return false
	end
end

manager.get = function(template_id, parent, world, ...)
	if manager.loaded_package(manager.get, template_id, parent, world, ...) then
		local template = ZoneTemplates.templates[template_id]
		local validator = template.validator
		local setting_enabled = template.setting_enabled or template.setting_prefix
		local zone_enabled = Settings.is_enabled(setting_enabled)
		local zone_valid = validator == nil or Validators[validator](...)
		local should_show = zone_enabled and zone_valid

		if should_show and zones[parent] == nil then
			zones[parent] = {}
		end
		local parent_zones = zones[parent]
		local zone = parent_zones and parent_zones[template.zone_group]

		if should_show and (zone == nil or zone.object == nil) then
			local init_pos = POSITION_LOOKUP[parent]
			zone = {
				object = World.spawn_unit_ex(world, decal_path, nil, init_pos),
				parent = parent,
				world = world,
				template_id = template_id,
				setting_enabled = setting_enabled,
				show = should_show,
				valid = zone_valid,
				validator_args = ...,
				position = init_pos,
				radius = nil,
				active = false,
			}
			parent_zones[template.zone_group] = zone
		end

		if zone then
			zone.show = should_show
			zone.valid = zone_valid
			if zone.template_id ~= template_id then
				zone.active = false
			end
		end
		return zone
	end
end

manager.show = function(zone, template_id, radius, position)
	if not zone.active then
		local template = ZoneTemplates.templates[template_id]
		zone.template_id = template_id
		zone.setting_enabled = template.setting_enabled
		zone.active = true

		if template.link then
			World.link_unit(zone.world, zone.object, 1, zone.parent, 1)
		end

		-- Set colour
		local red, green, blue, alpha = Settings.get_zone_rgba(template.setting_colour or template.setting_prefix)
		local colour = Quaternion.identity()
		Quaternion.set_xyzw(colour, red, green, blue, 0)
		Unit.set_vector4_for_material(zone.object, "projector", "particle_color", colour, true)

		-- Set opacity
		Unit.set_scalar_for_material(zone.object, "projector", "color_multiplier", alpha)
	end

	if radius ~= nil then
		local diameter = radius * 2
		Unit.set_local_scale(zone.object, 1, Vector3(diameter, diameter, 1))
		zone.radius = radius
	end
	if position ~= nil then
		Unit.set_local_position(zone.object, 1, position)
		zone.position = position
	end
end

local function destroy_zone(parent_zones, zone_group, temporary)
	local zone = parent_zones[zone_group]
	zone.active = false
	if Unit.is_valid(zone.object) then
		World.destroy_unit(zone.world, zone.object)
		zone.unit = nil
	end
	if not temporary then
		parent_zones[zone_group] = nil
	end
end
manager.destroy = function(parent, zone_group, temporary)
	local parent_zones = zones[parent]
	if parent_zones then
		if zone_group == nil then
			for k, _ in pairs(parent_zones) do
				destroy_zone(parent_zones, k, temporary)
			end
		else
			destroy_zone(parent_zones, zone_group, temporary)
		end

		if not temporary and next(parent_zones) == nil then
			zones[parent] = nil
		end
	end
end

manager.destroy_all = function(temporary)
	for parent, _ in pairs(zones) do
		manager.destroy(parent, nil, temporary)
	end
end

return manager
