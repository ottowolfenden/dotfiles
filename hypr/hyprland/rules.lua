hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
    },
    no_focus = true
})

hl.window_rule({
    name = "float-anki-edit-window",
    match = { class = "^anki$", title = "^Edit.*" },
    float = true,
    center = true
})

hl.window_rule({
    name = "fake-fullscreen",
    match = { class = "negative:qimgv" },
    fullscreen_state = "0 1"
})

hl.window_rule({
    name = "fix-thunar-rename-dialog",
    match = { class = "[Tt]hunar", title = "Rename.*" },
    float = true
})

hl.window_rule({
    name = "fullscreen-web-app-windows",
    match = { class = "^chrome-.*$" },
    fullscreen_state = "0 2"
})

hl.window_rule({
    name = "remove-redundant-vs-code-top-bar",
    match = { class = "code" },
    fullscreen_state = "0 2"
})

hl.layer_rule({
    match = { namespace = "quickshell" },
    no_anim = true
})
