local h = require("helpers")

-- windows
hl.bind("SUPER + mouse:274", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + slash", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + M", hl.dsp.window.move({ monitor = "+1", follow = true }))
hl.bind("F11", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))
hl.bind("SUPER + F11", hl.dsp.window.fullscreen_state({ internal = 3, client = 3, action = "toggle" }))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh region"))
hl.bind("Print", hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh"))
hl.bind("SUPER + W", function()
    local w = hl.get_active_window()
    if not w then return end
    if w.title == "qalc" then
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "C", state = "down" }))
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "C", state = "up" }))
    end
    hl.dispatch(hl.dsp.window.close())
end)
hl.bind("SUPER + SHIFT + I", function()
    hl.notification.create({ text = hl.get_active_window().title, timeout = 5000 })
end)
hl.bind("SUPER + mouse_up", function()
    hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "minus", state = "down" }))
    hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "minus", state = "up" }))
end)
hl.bind("SUPER + mouse_down", function()
    hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "equal", state = "down" }))
    hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "equal", state = "up" }))
end)
hl.bind("SUPER + P", function()
    hl.dispatch(hl.dsp.window.pseudo())
    if hl.get_active_window() then
        hl.dispatch(hl.dsp.window.resize({ x = 1000, y = 625 }))
    end
end)


-- workspaces
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
        offset = "r-" .. tostring(math.abs(offset))
    elseif offset + hl.get_active_workspace().id <= max_ws then
        offset = "r+" .. tostring(offset)
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
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end


-- apps
hl.bind("SUPER + B", hl.dsp.exec_cmd("helium-browser"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill clipse || kitty --class clipse -e clipse", { float = true }))
hl.bind("SUPER + equal", hl.dsp.exec_cmd("pkill qalc || kitty qalc", { float = true }))
hl.bind("XF86Calculator", hl.dsp.exec_cmd("pkill qalc || kitty qalc", { float = true }))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("thunar"))
hl.bind("CTRL + SHIFT + escape", hl.dsp.exec_cmd("pkill btop || kitty --class btop -e btop"))
hl.bind("SUPER + Q", function()
    local w = hl.get_active_window()
    if not w or w.class ~= "code" then
        hl.dispatch(hl.dsp.exec_cmd("kitty"))
    else
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL + SHIFT", key = "Q", state = "down" }))
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL + SHIFT", key = "Q", state = "up" }))
    end
end)


-- quickshell
hl.bind("SUPER + SHIFT + F23", hl.dsp.exec_cmd("qs ipc call searchHandler toggle"))
local inputsToHideQsFlyouts = { "mouse:272", "mouse:273", "mouse:274" }
for _, input in ipairs(inputsToHideQsFlyouts) do
    local barHeight = 44
    hl.bind(input, function()
        if not hl.get_active_monitor() or not hl.get_active_monitor().position then return end
        if hl.get_cursor_pos().y - hl.get_active_monitor().position.y > barHeight then
            hl.dispatch(hl.dsp.exec_cmd("qs ipc call flyoutsHandler hideNonHoveredFlyouts"))
        end
        hl.dispatch(hl.dsp.exec_cmd("qs ipc call bafsHandler hideAllBafs"))
    end, { non_consuming = true })
end
hl.bind("XF86AudioRaiseVolume", function()
        hl.dispatch(hl.dsp.exec_cmd("qs ipc call bafsHandler showBaf volume"))
        hl.dispatch(hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
    end,
    { locked = true, repeating = true }
)
hl.bind("XF86AudioLowerVolume", function()
        hl.dispatch(hl.dsp.exec_cmd("qs ipc call bafsHandler showBaf volume"))
        hl.dispatch(hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
    end,
    { locked = true, repeating = true }
)
hl.bind("XF86AudioMute", function()
        hl.dispatch(hl.dsp.exec_cmd("qs ipc call bafsHandler showBaf volume"))
        hl.dispatch(hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
    end,
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("qs ipc call brightnessHandler change increase"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("qs ipc call brightnessHandler change decrease"),
    { locked = true, repeating = true }
)


-- other
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("SUPER + space", hl.dsp.exec_cmd("~/dotfiles/scripts/keyboard-backlight.sh"), { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
