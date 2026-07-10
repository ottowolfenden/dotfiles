local h = require("helpers")

local max_ws = 9

local function changeWorkspace(type, offset)
    if offset == "emptyn" then
        offset = h.get_emptyn_id()
        if offset > max_ws then
            return
        else
            goto dispatch
        end
    elseif offset <= 0 then
        offset = "r-" .. math.abs(offset)
    elseif offset + hl.get_active_workspace().id <= max_ws then
        offset = "r+" .. offset
    else
        return
    end
    ::dispatch::
    if type == "move" then
        hl.dispatch(hl.dsp.window.move({ workspace = offset }))
    elseif type == "focus" then
        hl.dispatch(hl.dsp.focus({ workspace = offset, on_current_monitor = true }))
    end
end

hl.bind("SUPER + tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind("SUPER + N", function() changeWorkspace("focus", "emptyn") end)
hl.bind("SUPER + SHIFT + N", function() changeWorkspace("move", "emptyn") end)
hl.bind("SUPER + mouse:275", function() changeWorkspace("focus", -1) end)
hl.bind("SUPER + mouse:276", function() changeWorkspace("focus", 1) end)
hl.bind("SUPER + SHIFT + mouse:275", function() changeWorkspace("move", -1) end)
hl.bind("SUPER + SHIFT + mouse:276", function() changeWorkspace("move", 1) end)
hl.bind("SUPER + CTRL + left", function() changeWorkspace("focus", -1) end, { repeating = true })
hl.bind("SUPER + CTRL + right", function() changeWorkspace("focus", 1) end, { repeating = true })
hl.bind("SUPER + CTRL + SHIFT + left", function() changeWorkspace("move", -1) end, { repeating = true })
hl.bind("SUPER + CTRL + SHIFT + right", function() changeWorkspace("move", 1) end, { repeating = true })
for i = 1, max_ws do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
