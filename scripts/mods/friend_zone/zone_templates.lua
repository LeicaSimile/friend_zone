local templates = {
    ogryn_frag_grenade_aim = {
        link = false,
        zone_group = "grenade_aim",
    },
    vet_frag_grenade_aim = {
        link = false,
        zone_group = "grenade_aim",
    },
    vet_krak_grenade_aim = {
        link = false,
        zone_group = "grenade_aim",
    },
    vet_smoke_grenade_active = {
        link = true,
        zone_group = "smoke_active",
    },
    zealot_stun_grenade_aim = {
        link = false,
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
        },
        smoke_active = "vet_smoke_grenade_active",
    },
}
