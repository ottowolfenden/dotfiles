local qs = {}

function qs.dispatch(func)
    if func then hl.dispatch(func) end
    hl.dispatch(hl.dsp.exec_cmd("qs ipc call flyoutsHandler hideAllFlyouts"))
end

function qs.exec_cmd(cmd, rules)
    return function() qs.dispatch(hl.dsp.exec_cmd(cmd, rules)) end
end

function qs.bind(keys, func, flags)
    hl.bind(keys, function()
        if flags and flags.repeating then
            hl.dispatch(func)
        else
            qs.dispatch(func)
        end
    end, flags)
end

function qs.is_cursor_in_qs_bar()
    local barHeight = 44
    return hl.get_cursor_pos().y - hl.get_active_monitor().position.y < barHeight
end

function qs.is_cursor_in_qs()
    local barHeight = 44
    for _, layer in ipairs(hl.get_layers()) do
        if layer.namespace == "qs-flyout" then
            return true
        end
    end
    local m = hl.get_active_monitor()
    if not m or not m.position then return end
    return hl.get_cursor_pos().y - m.position.y <= barHeight
end

return qs
