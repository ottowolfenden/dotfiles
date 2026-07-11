local function is_from_qs(tags)
    for _, tag in pairs(tags) do
        if string.find(tag, "qs") then
            return true
        end
    end
    return false
end

hl.on("window.open", function(w)
    -- hl.exec_scheduled_prop_refresh_immediately()
    if w.tags and is_from_qs(w.tags) then
        hl.dispatch(hl.dsp.focus({ window = w }))
    end
end)

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
