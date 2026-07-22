local qs = require("qs")

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

function h.arr_includes(arr, val)
    for _, item in ipairs(arr) do
        if item == val then return true end
    end
    return false
end

function h.press_key(mods, key)
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
end

local function apply_binds(binds, binds_func)
    for keys, params in pairs(binds) do
        local func = type(params) == "table" and params[1] or params
        local opts = type(params) == "table" and params[2] or nil
        if type(keys) == "table" then
            for _, key in ipairs(keys) do binds_func(key, func, opts) end
        else
            binds_func(keys, func, opts)
        end
    end
end

local function apply_to_arr(arr, func)
    for _, el in ipairs(arr) do func(el) end
end

local function apply_to_tbl(tbl, func)
    for key, val in pairs(tbl) do func(key, val) end
end

function h.binds(binds) apply_binds(binds, hl.bind) end

function h.qs_binds(qs_binds) apply_binds(qs_binds, qs.bind) end

function h.exec_cmds(cmds) apply_to_arr(cmds, function(cmd) hl.dispatch(hl.dsp.exec_cmd(cmd)) end) end

function h.gestures(gestures) apply_to_arr(gestures, hl.gesture) end

function h.window_rules(window_rules) apply_to_arr(window_rules, hl.window_rule) end

function h.monitors(monitors) apply_to_arr(monitors, hl.monitor) end

function h.curves(curves) apply_to_tbl(curves, hl.curve) end

function h.animations(animations) apply_to_arr(animations, hl.animation) end

function h.envs(envs) apply_to_tbl(envs, hl.env) end

return h
