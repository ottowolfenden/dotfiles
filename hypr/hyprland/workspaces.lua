local h = require("helpers")

local max_ws = 9

local function changeWorkspace(type, offset)
    if offset == "emptyn" then
        offset = h.get_emptyn_id()
        if offset > max_ws then return else goto dispatch end
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

h.qs_bind("SUPER + tab", hl.dsp.focus({ workspace = "previous" }))
h.qs_bind("SUPER + N", function() changeWorkspace("focus", "emptyn") end)
h.qs_bind("SUPER + SHIFT + N", function() changeWorkspace("move", "emptyn") end)
h.qs_bind("SUPER + mouse:275", function() changeWorkspace("focus", -1) end)
h.qs_bind("SUPER + mouse:276", function() changeWorkspace("focus", 1) end)
h.qs_bind("SUPER + SHIFT + mouse:275", function() changeWorkspace("move", -1) end)
h.qs_bind("SUPER + SHIFT + mouse:276", function() changeWorkspace("move", 1) end)
h.qs_bind("SUPER + CTRL + left", function() changeWorkspace("focus", -1) end, { repeating = true })
h.qs_bind("SUPER + CTRL + right", function() changeWorkspace("focus", 1) end, { repeating = true })
h.qs_bind("SUPER + CTRL + SHIFT + left", function() changeWorkspace("move", -1) end, { repeating = true })
h.qs_bind("SUPER + CTRL + SHIFT + right", function() changeWorkspace("move", 1) end, { repeating = true })
for i = 1, max_ws do
    h.qs_bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    h.qs_bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

local last_right = 0
local last_left = 0
local minDelta = 6
local delay = 230

local function getWorkspaceGesture(type)
    return {
        fingers = 3,
        direction = "horizontal",
        mods = type == "move" and "SHIFT" or nil,
        action = {
            update = function(e)
                if (math.abs(e.delta.x) < minDelta) then return end
                if e.delta.x < 0 then
                    if (e.time_ms < last_left + delay) then return end
                    last_left = e.time_ms
                elseif e.delta.x > 0 then
                    if (e.time_ms < last_right + delay) then return end
                    last_right = e.time_ms
                end
                changeWorkspace(type, (e.delta.x > 0 and -1 or 1))
            end
        }
    }
end

hl.gesture(getWorkspaceGesture("move"))
hl.gesture(getWorkspaceGesture("focus"))
