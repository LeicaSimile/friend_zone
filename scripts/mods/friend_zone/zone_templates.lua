local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")

local templates = {
    ogryn_frag_grenade_aim = {
        link = false,
        setting_prefix = "grenade_aim_preview",
        zone_group = "grenade_aim",
    },
    vet_frag_grenade_aim = {
        link = false,
        setting_prefix = "grenade_aim_preview",
        zone_group = "grenade_aim",
    },
    vet_krak_grenade_aim = {
        link = false,
        setting_prefix = "grenade_aim_preview",
        zone_group = "grenade_aim",
    },
    vet_smoke_grenade_active = {
        link = true,
        setting_prefix = "smoke_grenade_active",
        zone_group = "smoke_active",
    },
    vet_smoke_grenade_aim = {
        link = false,
        radius = ProjectileTemplates.smoke_grenade.damage.fuse.spawn_unit.unit_template_parameters.outer_radius,
        setting_prefix = "grenade_aim_preview",
        zone_group = "grenade_aim",
    },
    zealot_stun_grenade_aim = {
        link = false,
        setting_prefix = "grenade_aim_preview",
        zone_group = "grenade_aim",
    },
}

return {
    templates = templates,
    events = {
        throw_aim = {
            frag_grenade = "vet_frag_grenade_aim",
            krak_grenade = "vet_krak_grenade_aim",
            ogryn_grenade_frag = "ogryn_frag_grenade_aim",
            shock_grenade = "zealot_stun_grenade_aim",
            smoke_grenade = "vet_smoke_grenade_aim",
        },
        smoke_active = "vet_smoke_grenade_active",
    },
}
