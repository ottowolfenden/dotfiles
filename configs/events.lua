hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swaync")
    hl.exec_cmd("clipse -listen")
end)

hl.on("window.open", function(w)
    if w.class == "anki" and w.title == "Otto Wolfenden - Anki" then
        hl.exec_cmd("sleep 2 && wtype -k F11 &")
    end
    if w.class == "com.github.th_ch.youtube_music" then
        hl.exec_cmd("sleep 0.5 && wtype -k F11 &")
    end
end)

-- apps that are pseudo when they are the only app open in the workspace,
local dynamic_pseudo_classes = { "kitty", "thunar", "blueman-manager" }
local pseudo_size = { 1000, 625 }
local ms_before_resize = 50

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

local function refresh_dynamic_pseudo_state(window, workspace)
    local windows = non_floating(hl.get_workspace_windows(workspace.id))
    if #windows == 1 and contains(dynamic_pseudo_classes, window.class) then
        hl.dispatch(hl.dsp.window.pseudo({ action = "enable", window = window }))
        hl.dispatch(hl.dsp.window.resize({ x = pseudo_size[1], y = pseudo_size[2], window = window }))
    elseif #windows > 1 then
        for _, win in ipairs(windows) do
            if contains(dynamic_pseudo_classes, win.class) then
                hl.dispatch(hl.dsp.window.pseudo({ action = "disable", window = win }))
            end
        end
    end
end

hl.on("window.open", function(window)
    refresh_dynamic_pseudo_state(window, hl.get_active_workspace())
end)
hl.on("window.move_to_workspace", function(window, workspace)
    hl.timer(function()
        refresh_dynamic_pseudo_state(window, workspace)
    end, { timeout = ms_before_resize, type = "oneshot" })
end)

hl.on("window.close", function()
    hl.timer(function()
        local windows = hl.get_workspace_windows(hl.get_active_workspace().id)
        if #windows ~= 1 then return end
        if contains(dynamic_pseudo_classes, windows[1].class) then
            hl.dispatch(hl.dsp.window.pseudo({ action = "enable", window = windows[1] }))
            hl.dispatch(hl.dsp.window.resize({ x = pseudo_size[1], y = pseudo_size[2], window = windows[1] }))
        end
    end, { timeout = ms_before_resize, type = "oneshot" })
end)
