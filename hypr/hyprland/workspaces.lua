local h = require("helpers")
local qs = require("qs")

local max_ws = 9

local function changeWorkspace(action, offset)
    if offset == "emptyn" then
        offset = h.get_emptyn_id()
        if offset > max_ws then return else goto dispatch end
    elseif type(offset) == "string" then
        goto dispatch
    elseif offset <= 0 then
        offset = "r-" .. math.abs(offset)
    elseif offset + hl.get_active_workspace().id <= max_ws then
        offset = "r+" .. offset
    else
        return
    end
    ::dispatch::
    if action == "move" then
        hl.dispatch(hl.dsp.window.move({ workspace = offset }))
    elseif action == "focus" then
        hl.dispatch(hl.dsp.focus({ workspace = offset, on_current_monitor = true }))
    end
end

local qs_binds = {}

for mod, action in pairs({ [""] = "focus", ["SHIFT + "] = "move" }) do
    qs_binds["SUPER + " .. mod .. "tab"] = function() changeWorkspace(action, "previous") end
    qs_binds["SUPER + " .. mod .. "N"] = function() changeWorkspace(action, "emptyn") end

    for offset, binds in pairs({
        [1] = { "mouse:276", "mouse_up", "CTRL + right" },
        [-1] = { "mouse:275", "mouse_down", "CTRL + left" }
    }) do
        for _, bind in ipairs(binds) do
            qs_binds["SUPER + " .. mod .. bind] = { function() changeWorkspace(action, offset) end, { repeating = true } }
        end
    end
end

for i = 1, max_ws do
    qs_binds["SUPER + " .. i] = hl.dsp.focus({ workspace = i })
    qs_binds["SUPER + SHIFT + " .. i] = hl.dsp.window.move({ workspace = i })
end

h.qs_binds(qs_binds)

local last_time = 0
local minDelta = 0.5
local delay = 150
local choice = nil

local function get_choice(delta)
    if delta < 0 then
        return "left"
    elseif delta > 0 then
        return "right"
    end
end

local function get_ws_gesture(action)
    return {
        fingers = 3,
        direction = "horizontal",
        mods = action == "move" and "SHIFT" or nil,
        action = {
            update = function(e)
                if
                    math.abs(e.delta.x) < minDelta
                    or get_choice(e.delta.x) == choice
                    or e.time_ms < last_time + delay
                then
                    return
                end

                last_time = e.time_ms
                choice = get_choice(e.delta.x)
                changeWorkspace(action, (e.delta.x > 0 and -1 or 1))
            end,
            finish = function()
                qs.dispatch()
                choice = nil
            end
        }
    }
end

h.gestures({ get_ws_gesture("move"), get_ws_gesture("focus") })
