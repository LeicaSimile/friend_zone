-- Author: LeicaSimile
local mod = get_mod("friend_zone")
local ZoneManager = mod:io_dofile("friend_zone/scripts/mods/friend_zone/zone_manager")
local ZoneTemplates = mod:io_dofile("friend_zone/scripts/mods/friend_zone/zone_templates")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local MaterialQuery = require("scripts/utilities/material_query")

local MAX_GROUND_DISTANCE = 0.1

-- mod:hook_safe("HudElementPlayerPanelBase", "_update_player_features", function (self, _, _, player)
-- end)

mod.on_game_state_changed = function()
    ZoneManager.destroy_all()
end

local charge_level = 1
local function get_explosion_radius(attacker, explosion_template)
    local attacker_buff_extension = ScriptUnit.has_extension(attacker, "buff_system")
	local attacker_stat_buffs = attacker_buff_extension and attacker_buff_extension:stat_buffs()
	local attacker_unit_data_extension = ScriptUnit.has_extension(attacker, "unit_data_system")
	local attacker_breed_or_nil = attacker_unit_data_extension and attacker_unit_data_extension:breed()
	local lerp_values = Explosion.lerp_values(attacker, explosion_template.name)
    
    local radius, _ = Explosion.radii(explosion_template, charge_level, lerp_values, AttackSettings.attack_types.explosion, attacker_stat_buffs, attacker_breed_or_nil)
    return radius
end

---- ## Grenade aiming preview hooks ## ----
mod:hook_safe("AimProjectileEffects", "init", function(self, context)
    self._owner_unit = context.owner_unit
end)

mod:hook_safe("AimProjectileEffects", "_set_trajectory_positions_spline", function(self, aim_data, number_of_aim_data, _, total_distance, arc_distances)
    local weapon_template = self._weapon_template
    local weapon_name = weapon_template.name
    local template_id = ZoneTemplates.events.throw_aim[weapon_name]
    local template = ZoneTemplates.templates[template_id]
    if template then
        local player = self._owner_unit
        local world = self._world
        local zone = ZoneManager.get(template_id, player, world)
        if zone and zone.show then
            local pos = nil
            local arc_i = 0
            local num_arcs = #arc_distances
            for i=1, number_of_aim_data do
                local curr = aim_data[i]
                if curr.has_hit then
                    arc_i = arc_i + 1
                end
                if arc_i >= num_arcs then
                    pos = curr.new_position
                    break
                end
            end

            if pos then
                local radius = nil
                if not zone.active then
                    local explosion_template = weapon_template.projectile_template.damage.fuse.explosion_template
                    radius = get_explosion_radius(player, explosion_template)
                    mod:echo("Radius (%s): %s", weapon_name, radius)
                    mod:echo("Target pos: <%s, %s, %s>", pos[1], pos[2], pos[3])
                end

                -- Try to place zone close to the ground
                local hit, material, hit_pos, _, _, _ = MaterialQuery.query_material(self._physics_world, pos, pos + Vector3.down() * (radius or zone.radius))
                if hit and pos[3] - hit_pos[3] > MAX_GROUND_DISTANCE then
                    pos = hit_pos
                end
                if not zone.active then
                    mod:echo("Hit: %s, %s, <%s, %s, %s>", hit, material, hit_pos[1], hit_pos[2], hit_pos[3])
                end
                ZoneManager.show(zone, template_id, radius, pos)
            end
        else
            ZoneManager.destroy(player, template.zone_group)
        end
    end
end)

mod:hook_safe("AimProjectileEffects", "unwield", function(self)
    local weapon_template = self._weapon_template
    local weapon_name = weapon_template and weapon_template.name
    local template_id = ZoneTemplates.events.throw_aim[weapon_name]
    local template = ZoneTemplates.templates[template_id]
    if template then
        local player = self._owner_unit
        ZoneManager.destroy(player, template.zone_group)
    end
end)

---- ## Active grenade area hooks ## ----
mod:hook_safe("SmokeFogExtension", "init", function(self)
    mod:echo("Duration: %s", self._max_duration)
    local template_id = ZoneTemplates.events.smoke_active
    local template = ZoneTemplates.templates[template_id]
    if template then
        local unit = self._unit
        local world = self._world
        local zone = ZoneManager.get(template_id, unit, world)
        if zone and zone.show then
            local radius = self.outer_radius
            ZoneManager.show(zone, template_id, radius)
        end
    end
end)

mod:hook_safe("SmokeFogExtension", "on_unit_enter", function()
    mod:echo("Entered smoke")
end)

mod:hook_safe("SmokeFogExtension", "on_unit_exit", function()
    mod:echo("Exited smoke")
end)

mod:hook_safe("SmokeFogExtension", "remaining_duration", function(self)
    if self.is_expired then
        local template_id = ZoneTemplates.events.smoke_active
        local template = ZoneTemplates.templates[template_id]
        ZoneManager.destroy(self._unit, template.zone_group)
    end
end)
-- mod:hook_safe("PackageManager", "load", function(self, name)
--     mod:echo("Loading: %s", name)
-- end)
