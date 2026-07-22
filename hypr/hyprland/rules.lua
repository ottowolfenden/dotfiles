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
    name = "fix-thunar-rename-dialog",
    match = { class = "[Tt]hunar", title = "Rename.*" },
    float = true
})

hl.layer_rule({
    match = { namespace = "quickshell" },
    no_anim = true
})
