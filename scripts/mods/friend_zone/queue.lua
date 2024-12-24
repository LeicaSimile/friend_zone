local queues = {}
local manager = {}

manager.add = function(key, func, ...)
    if queues[key] == nil then
        queues[key] = {}
    end
    table.insert(queues[key], {callback = func, args = ...})
end

manager.run = function(key)
    local selected_queue = queues[key]
    if selected_queue then
        for i, v in ipairs(selected_queue) do
            v.callback(v.args)
            selected_queue[i] = nil
        end
    end
end

return manager
