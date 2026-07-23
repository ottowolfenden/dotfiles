local h = require("helpers")

local keys_to_hide_flyouts = { "mouse:272", "mouse:273", "mouse:274" }

for _, input in ipairs(keys_to_hide_flyouts) do
    hl.bind(input, function()
        if not h.is_cursor_in_qs() then
            hl.dispatch(hl.dsp.exec_cmd("qs ipc call flyoutsHandler hideNonHoveredFlyouts"))
        end
        hl.dispatch(hl.dsp.exec_cmd("qs ipc call bafsHandler hideAllBafs"))
    end, { non_consuming = true })
end

local binds = {
    ["SUPER + SHIFT + F23"] = hl.dsp.exec_cmd("qs ipc call searchHandler toggle"),
    ["XF86AudioMute"] = {
        function()
            hl.dispatch(hl.dsp.exec_cmd("qs ipc call bafsHandler showBaf volume"))
            hl.dispatch(hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
        end,
        { locked = true, repeating = true }
    }
}

for key, val in pairs { ["XF86AudioRaiseVolume"] = "+", ["XF86AudioLowerVolume"] = "-" } do
    binds[key] = {
        function()
            hl.dispatch(hl.dsp.exec_cmd("qs ipc call bafsHandler showBaf volume"))
            hl.dispatch(hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%" .. val))
        end,
        { locked = true, repeating = true }
    }
end

for key, val in pairs({ ["XF86MonBrightnessUp"] = "increase", ["XF86MonBrightnessDown"] = "decrease" }) do
    binds[key] = {
        hl.dsp.exec_cmd("qs ipc call brightnessHandler change " .. val),
        { locked = true, repeating = true }
    }
end

h.binds(binds)
