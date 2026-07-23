local h = require("helpers")
local qs = require("qs")

hl.on("hyprland.start", function()
    h.exec_cmds({ "qs", "awww-daemon", "swaync", "clipse -listen" })
end)

h.binds({
    ["SUPER + B"] = qs.exec_cmd("helium-browser"),
    ["SUPER + C"] = qs.exec_cmd("code"),
    ["SUPER + V"] = hl.dsp.exec_cmd("pkill clipse || kitty --class clipse -e clipse", { float = true }),
    [{ "SUPER + equal", "XF86Calculator" }] = qs.exec_cmd("kitty qalc", { float = true }),
    ["SUPER + SHIFT + C"] = hl.dsp.exec_cmd("hyprpicker -a"),
    ["SUPER + T"] = qs.exec_cmd("thunar"),
    ["CTRL + SHIFT + escape"] = qs.exec_cmd("kitty --class btop -e btop"),
    ["SUPER + Q"] = function()
        local w = hl.get_active_window()
        if w and w.class == "code" then
            if h.is_cursor_in_qs() then
                qs.dispatch(hl.dsp.focus({ window = w }))
            end
            h.press_key("CTRL + SHIFT", "Q")
        else
            hl.dispatch(qs.exec_cmd("kitty"))
        end
    end
})
