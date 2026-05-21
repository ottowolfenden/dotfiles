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
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true
})

hl.window_rule({
    name = "float-anki-edit-window",
    match = { class = "^anki$", title = "^Edit.*" },
    float = true,
    center = true
})

hl.window_rule({
    name = "fake-fullscreen",
    match = { class = ".*" },
    fullscreen_state = "0 1"
})

hl.window_rule({
    name = "smaller-yt-music-window",
    match = { class = "com.github.th_ch.youtube_music" },
    pseudo = true
})

hl.window_rule({
    name = "fix-thunar-rename-dialog",
    match = { class = "thunar", title = "Rename.*" },
    float = true
})

hl.window_rule({
    "fullscreen-web-app-windows",
    match = { class = "^chrome-.*$" },
    fullscreen_state = "0 2"
})
