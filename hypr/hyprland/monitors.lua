local h = require("helpers")

local monitors = {
    {
        output = "eDP-1",
        mode = "2880x1800@120",
        position = "auto",
        scale = 1.6
    },
    {
        output = "HDMI-A-1",
        mirror = "eDP-1",
        mode = "preferred",
        position = "auto",
        scale = 1
    }
}

h.monitors(monitors)

function setRefreshRate(output, hz)
    local monitor = h.find(monitors, function(m) return m.output == output end)
    if monitor == nil then return end
    monitor.mode = string.match(monitor.mode, ".*@") .. tostring(hz)
    hl.monitor(monitor)
end
