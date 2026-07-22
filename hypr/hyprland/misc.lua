local h = require("helpers")

h.binds({
    ["XF86AudioNext"] = { hl.dsp.exec_cmd("playerctl next"), { locked = true } },
    [{ "XF86AudioPause", "XF86AudioPlay" }] = { hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
    ["XF86AudioPrev"] = { hl.dsp.exec_cmd("playerctl previous"), { locked = true } },
    ["SUPER + space"] = { hl.dsp.exec_cmd("~/dotfiles/scripts/keyboard-backlight.sh"), { locked = true } },
    ["XF86AudioMicMute"] = { hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true } },
})


h.gestures((function()
    local t = {}
    for _, d in ipairs { "pinchin", "pinchout" } do
        t[#t + 1] = {
            fingers = 2,
            direction = d,
            mods = "SUPER",
            action = "cursorZoom",
            mode = "live"
        }
    end
    return t
end)())


hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        focus_on_activate = true
    }
})
