local h = {}

function h.t(cond, t, f)
    if cond then return t else return f end
end

function h.notif(val)
    hl.notification.create({ text = tostring(val), timeout = 5000 })
end

function h.get_emptyn_id()
    local active = hl.get_active_workspace()
    if not active then return 1 end

    local occupied = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        occupied[ws.id] = true
    end

    local id = active.id + 1
    while occupied[id] do
        id = id + 1
    end

    return id
end

return h
