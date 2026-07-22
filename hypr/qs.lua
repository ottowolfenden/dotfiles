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
        if flags.repeating then hl.dispatch(func) else qs.dispatch(func) end
    end, flags)
end

return qs
