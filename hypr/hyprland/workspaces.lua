local h = require("helpers")

Max_ws = 9

local function changeWorkspace(action, offset)
    if offset == "emptyn" then
        offset = h.get_emptyn_id()
        if offset > Max_ws then return else goto dispatch end
    elseif type(offset) == "string" then
        goto dispatch
    elseif offset <= 0 then
        offset = "r-" .. math.abs(offset)
    elseif offset + hl.get_active_workspace().id <= Max_ws then
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
    qs_binds["SUPER + CTRL + " .. mod .. "right"] = { function() changeWorkspace(action, 1) end, { repeating = true } }
    qs_binds["SUPER + CTRL + " .. mod .. "left"] = { function() changeWorkspace(action, -1) end, { repeating = true } }

    for offset, binds in pairs({
        [1] = { "mouse:276", "mouse_up" },
        [-1] = { "mouse:275", "mouse_down" }
    }) do
        for _, bind in ipairs(binds) do
            qs_binds["SUPER + " .. mod .. bind] = function() changeWorkspace(action, offset) end
        end
    end
end

for i = 1, Max_ws do
    qs_binds["SUPER + " .. i] = hl.dsp.focus({ workspace = i })
    qs_binds["SUPER + SHIFT + " .. i] = hl.dsp.window.move({ workspace = i })
end

h.qs_binds(qs_binds)

hl.config({
    gestures = {
        workspace_swipe_use_r = true,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_distance = 800,
        workspace_swipe_cancel_ratio = 0.1
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.on("workspace.active", function(ws)
    hl.config({
        gestures = {
            workspace_swipe_create_new = ws.id ~= Max_ws
        }
    })
    if hl.get_active_workspace().id == Max_ws and #hl.get_workspace_windows(Max_ws - 1) == 0 then
        h.gestures({
            {
                fingers = 3,
                direction = "horizontal",
                action = "unset"
            },
            {
                fingers = 3,
                direction = "horizontal",
                action = {
                    start = function(e)
                        if e.delta.x > 0 and math.abs(e.delta.x) > 20 then
                            changeWorkspace("focus", -1)
                        end
                    end
                }
            }
        })
    else
        h.gestures({
            {
                fingers = 3,
                direction = "horizontal",
                action = "unset"
            },
            {
                fingers = 3,
                direction = "horizontal",
                action = "workspace"
            }
        })
    end
end)
