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
    { match = { class = "[Tt]hunar", title = "Rename.*" },           float = true },
    { match = { title = "about:blank.*|MathJax Equation Source.*" }, size = { 1000, 700 }, float = true },
    { match = { class = "anki", title = "Choose Note Type" },        size = { 200, 300 }, center = true }
})

hl.layer_rule({
    match = { namespace = "quickshell|qs-flyout" },
    no_anim = true
})
