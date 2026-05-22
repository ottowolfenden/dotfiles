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
    match = { class = "negative:qimgv" },
    fullscreen_state = "0 1"
})

hl.window_rule({
    name = "smaller-yt-music-window",
    match = { class = "com.github.th_ch.youtube_music" },
    pseudo = true
})

hl.window_rule({
    name = "fix-thunar-rename-dialog",
    match = { class = "(?i)thunar", title = "Rename.*" },
    float = true
})

hl.window_rule({
    name = "fullscreen-web-app-windows",
    match = { class = "^chrome-.*$" },
    fullscreen_state = "0 2"
})

-- apps that are pseudo when they are the only app open in the workspace,
local dynamic_pseudo_classes = { "kitty", "thunar", "blueman-manager" }
local default_pseudo_size = { 1000, 625 }

local function contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then return true end
    end
    return false
end

local function non_floating(windows)
    local result = {}
    for _, win in ipairs(windows) do
        if not win.floating then
            table.insert(result, win)
        end
    end
    return result
end

hl.on("window.open", function(w)
    local windows = non_floating(hl.get_workspace_windows(hl.get_active_workspace().id))
    if #windows == 1 and contains(dynamic_pseudo_classes, w.class) then
        hl.dispatch(hl.dsp.window.pseudo({ action = "enable", window = w }))
        hl.dispatch(hl.dsp.window.resize({ x = default_pseudo_size[1], y = default_pseudo_size[2], window = w }))
    elseif #windows > 1 then
        for _, win in ipairs(windows) do
            if contains(dynamic_pseudo_classes, win.class) then
                hl.dispatch(hl.dsp.window.pseudo({ action = "disable", window = win }))
            end
        end
    end
end)

hl.on("window.close", function(w)
    local windows = hl.get_workspace_windows(hl.get_active_workspace().id)
    local remaining = #windows - 1
    if remaining == 1 then
        for _, win in ipairs(windows) do
            if win.address ~= w.address and contains(dynamic_pseudo_classes, win.class) then
                hl.dispatch(hl.dsp.window.pseudo({ action = "enable", window = win }))
                hl.dispatch(hl.dsp.window.resize({ x = default_pseudo_size[1], y = default_pseudo_size[2], window = win }))
            end
        end
    end
end)
