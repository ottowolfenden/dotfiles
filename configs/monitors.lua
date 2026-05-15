local function refresh_monitor_scale()
    local hdmi_connected = false
    for _, monitor in ipairs(hl.get_monitors() or {}) do
        if monitor.name and string.find(monitor.name, "HDMI") then
            hdmi_connected = true
            break
        end
    end

    -- laptop monitor
    hl.monitor({
        output = "eDP-1",
        mode = "2880x1800@120",
        position = "285x1080",
        scale = hdmi_connected and "2.25" or "1.8"
    })

    -- HDMI monitor
    hl.monitor({
        output = "HDMI-A-1",
        mode = "1920x1080@60",
        position = "0x0",
        scale = "1"
    })
end

refresh_monitor_scale()

hl.on("monitor.added", refresh_monitor_scale)
hl.on("monitor.removed", refresh_monitor_scale)
