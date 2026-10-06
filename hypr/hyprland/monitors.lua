local h = require("helpers")

h.monitors({
    { output = "eDP-1",    mode = "2880x1800@120", position = "auto", scale = 1.6 },
    { output = "HDMI-A-1", mode = "preferred",     position = "auto", scale = 1.6, mirror = "eDP-1" },
    { output = "",         mode = "preferred",     position = "auto", scale = 1 }
})
