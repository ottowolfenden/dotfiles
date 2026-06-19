-- windows
hl.bind("SUPER + W", function()
    if (hl.get_active_window().title == "qalc") then
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "C", state = "down" }))
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL", key = "C", state = "up" }))
    end
    hl.dispatch(hl.dsp.window.close())
end)
hl.bind("SUPER + mouse:274", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", function()
    hl.dispatch(hl.dsp.window.pseudo())
    if hl.get_active_window() then
        hl.dispatch(hl.dsp.window.resize({ x = 1000, y = 625 }))
    end
end)
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
local screenshot = hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh")
hl.bind("SUPER + SHIFT + S", screenshot)
hl.bind("Print", screenshot)
hl.bind("XF86SelectiveScreenshot", screenshot)
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

-- workspaces
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ workspace = "r+1", on_current_monitor = true }))
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ workspace = "r-1", on_current_monitor = true }))
hl.bind("SUPER + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + CTRL + SHIFT + left", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + N", hl.dsp.focus({ workspace = "emptynm" }))
hl.bind("SUPER + SHIFT + N", hl.dsp.window.move({ workspace = "emptynm" }))
hl.bind("SUPER + mouse:276", hl.dsp.focus({ workspace = "r+1", on_current_monitor = true }))
hl.bind("SUPER + mouse:275", hl.dsp.focus({ workspace = "r-1", on_current_monitor = true }))
for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- apps
hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + SHIFT + F23", hl.dsp.exec_cmd("pkill wofi || wofi --show drun"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("helium-browser"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill clipse || kitty --class clipse -e clipse", { float = true }))
hl.bind("SUPER + equal", hl.dsp.exec_cmd("pkill qalc || kitty qalc", { float = true }))
hl.bind("XF86Calculator", hl.dsp.exec_cmd("pkill qalc || kitty qalc", { float = true }))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("thunar", { float = true }))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("pkill btop || kitty --class btop -e btop"))

-- XF86 keys
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("SUPER + space", hl.dsp.exec_cmd("~/dotfiles/scripts/keyboard-backlight.sh"), { locked = true })
