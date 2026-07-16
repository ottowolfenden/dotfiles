hl.on("hyprland.start", function()
    hl.exec_cmd("qs")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("swaync")
    hl.exec_cmd("clipse -listen")
end)

hl.bind("SUPER + B", hl.dsp.exec_cmd("helium-browser"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("code"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill clipse || kitty --class clipse -e clipse", { float = true }))
hl.bind("SUPER + equal", hl.dsp.exec_cmd("kitty qalc", { float = true }))
hl.bind("XF86Calculator", hl.dsp.exec_cmd("kitty qalc", { float = true }))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("thunar"))
hl.bind("CTRL + SHIFT + escape", hl.dsp.exec_cmd("kitty --class btop -e btop"))
hl.bind("SUPER + Q", function()
    local w = hl.get_active_window()
    if not w or w.class ~= "code" then
        hl.dispatch(hl.dsp.exec_cmd("kitty"))
    else
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL + SHIFT", key = "Q", state = "down" }))
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL + SHIFT", key = "Q", state = "up" }))
    end
end)
