local mod = get_mod("friend_zone")
local settings_cache = {}
local settings = {}

settings.get = function(setting)
    -- Cache settings for quick checks
    local val = settings_cache[setting]
    if val == nil then
        settings_cache[setting] = mod:get(setting)
        val = settings_cache[setting]
    end
    return val
end

settings.get_zone_rgba = function(group_id)
    return settings.get(group_id .. "_colour_red") / 100,
        settings.get(group_id .. "_colour_green") / 100,
        settings.get(group_id .. "_colour_blue") / 100,
        settings.get(group_id .. "_colour_alpha") / 100
end

settings.is_enabled = function(group_id)
    --return settings.get(group_id .. "_outline_enabled")
    return true
end

settings.clear_cache = function()
    for key, _ in pairs(settings_cache) do
        settings_cache[key] = nil
    end
end

return settings
