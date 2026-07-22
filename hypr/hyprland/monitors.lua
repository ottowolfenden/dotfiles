local h = require("helpers")

h.monitors({
    {
        output = "eDP-1",
        mode = "2880x1800@120",
        position = "140x1080",
        scale = "1.6"
    },
    {
        output = "HDMI-A-1",
        mode = "1920x1080@60",
        position = "0x0",
        scale = "1"
    }
})
