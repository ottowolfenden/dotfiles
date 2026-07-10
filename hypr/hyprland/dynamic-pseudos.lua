local dynamic_pseudos = {
    classes = {
        "kitty",
        "[Tt]hunar",
        "blueman",
        "[Oo]verskride",
        "com%.github%.th%-ch%.youtube%-music"
    },
    initial_titles = {}
}

hl.bind("SUPER + P", function()
    hl.dispatch(hl.dsp.window.pseudo())
    if hl.get_active_window() then
        hl.dispatch(hl.dsp.window.resize({ x = 1000, y = 625 }))
    end
end)

local pseudo_size = { x = 1000, y = 625 }
local ms_before_resize = 50

local function is_dynamic_pseudo(window)
    for _, regex in ipairs(dynamic_pseudos.classes) do
        if string.match(window.class, regex) then return true end
    end
    for _, regex in ipairs(dynamic_pseudos.initial_titles) do
        if string.match(window.initial_title, regex) then return true end
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
    if #windows == 1 and is_dynamic_pseudo(window) then
        hl.dispatch(hl.dsp.window.pseudo({ action = "enable", window = window }))
        hl.dispatch(hl.dsp.window.resize({ x = pseudo_size.x, y = pseudo_size.y, window = window }))
    elseif #windows > 1 then
        for _, win in ipairs(windows) do
            if is_dynamic_pseudo(win) then
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
        if is_dynamic_pseudo(windows[1]) then
            hl.dispatch(hl.dsp.window.pseudo({ action = "enable", window = windows[1] }))
            hl.dispatch(hl.dsp.window.resize({ x = pseudo_size.x, y = pseudo_size.y, window = windows[1] }))
        end
    end, { timeout = ms_before_resize, type = "oneshot" })
end)

hl.on("window.move_to_workspace", function()
    hl.timer(function()
        local workspace = hl.get_last_workspace()
        if not workspace then return end
        local windows = hl.get_workspace_windows(workspace.id)
        if #windows ~= 1 then return end
        if is_dynamic_pseudo(windows[1]) then
            hl.dispatch(hl.dsp.window.pseudo({ action = "enable", window = windows[1] }))
            hl.dispatch(hl.dsp.window.resize({ x = pseudo_size.x, y = pseudo_size.y, window = windows[1] }))
        end
    end, { timeout = ms_before_resize, type = "oneshot" })
end)
