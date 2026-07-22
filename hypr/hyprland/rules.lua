local h = require("helpers")

h.window_rules({
    {
        match = {
            class = "^$",
            title = "^$",
            xwayland = true,
            float = true,
            fullscreen = false,
            pin = false
        },
        no_focus = true
    },
    {
        match = { class = "^anki$", title = "^Edit.*" },
        float = true,
        center = true
    },
    {
        match = { class = "[Tt]hunar", title = "Rename.*" },
        float = true
    }
})

hl.layer_rule({
    match = { namespace = "quickshell" },
    no_anim = true
})
