local h = require("helpers")

hl.on("hyprland.start", function()
    hl.exec_cmd("qs")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("swaync")
    hl.exec_cmd("clipse -listen")
end)

hl.bind("SUPER + B", h.qs_exec("helium-browser"))
hl.bind("SUPER + C", h.qs_exec("code"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill clipse || kitty --class clipse -e clipse", { float = true }))
hl.bind("SUPER + equal", h.qs_exec("kitty qalc", { float = true }))
hl.bind("XF86Calculator", h.qs_exec("kitty qalc", { float = true }))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + T", h.qs_exec("thunar"))
hl.bind("CTRL + SHIFT + escape", h.qs_exec("kitty --class btop -e btop"))
hl.bind("SUPER + Q", function()
    local w = hl.get_active_window()
    if not w or w.class ~= "code" then
        hl.dispatch(h.qs_exec("kitty"))
    else
        hl.dispatch(hl.dsp.exec_cmd("qs ipc call flyoutsHandler hideAllFlyouts"))
        hl.dispatch(hl.dsp.focus({ window = w }))
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL + SHIFT", key = "Q", state = "down" }))
        hl.dispatch(hl.dsp.send_key_state({ mods = "CTRL + SHIFT", key = "Q", state = "up" }))
    end
end)
