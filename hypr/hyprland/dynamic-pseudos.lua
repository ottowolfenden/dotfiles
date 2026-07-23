local h = require("helpers")
local qs = require("qs")

local dynamic_pseudos = {
    classes = {
        "kitty",
        "thunar",
        "com.github.th-ch.youtube-music"
    },
    initial_titles = { "overskride" }
}
local pseudo_size = { x = 1100, y = 700 }

local function is_dynamic_pseudo(window)
    return h.arr_includes(dynamic_pseudos.classes, window.class) or
        h.arr_includes(dynamic_pseudos.initial_titles, window.initial_title)
end

local function is_pseudo(window)
    return h.arr_includes(window.tags, "pseudo")
end

local function is_manually_disabled(window)
    return h.arr_includes(window.tags, "manually_disabled")
end

local function get_remaining_windows(window_to_exclude, ws)
    local windows = hl.get_workspace_windows(ws and ws.id or hl.get_active_workspace().id)
    local remaining_windows = {}
    for _, w in ipairs(windows) do
        if not w.floating and (not window_to_exclude or w.address ~= window_to_exclude.address) then
            table.insert(remaining_windows, w)
        end
    end
    return remaining_windows
end

local function pseudo(action, window)
    if not window then window = hl.get_active_window() end
    if not window then return end
    hl.dispatch(hl.dsp.window.pseudo({ window = window, action = action }))

    if action == "toggle" then
        hl.dispatch(hl.dsp.window.tag({ tag = "pseudo", window = window }))
        if is_pseudo(window) then
            hl.dispatch(hl.dsp.window.resize({ x = pseudo_size.x, y = pseudo_size.y, window = window }))
        end
    elseif action == "enable" then
        hl.dispatch(hl.dsp.window.resize({ x = pseudo_size.x, y = pseudo_size.y, window = window }))
        hl.dispatch(hl.dsp.window.tag({ tag = "+pseudo", window = window }))
    elseif action == "disable" and is_pseudo(window) then
        hl.dispatch(hl.dsp.window.tag({ tag = "-pseudo", window = window }))
    end
end


qs.bind("SUPER + O", function()
    if is_pseudo(hl.get_active_window()) then
        h.notif("PSEUDO = TRUE")
    else
        h.notif("PSEUDO = FALSE")
    end
end)

hl.on("window.open", function(opened_window)
    local wins = get_remaining_windows()
    if is_dynamic_pseudo(opened_window) and #wins == 1 then
        pseudo("enable", opened_window)
    elseif #wins > 1 then
        for _, w in ipairs(wins) do
            if is_dynamic_pseudo(w) then pseudo("disable", w) end
        end
    end
end)

hl.on("window.close", function(closed_window)
    hl.timer(function()
        local wins = get_remaining_windows(closed_window)
        if #wins ~= 1 then return end
        local remaining_window = wins[1]
        if is_dynamic_pseudo(remaining_window) then
            pseudo("enable", remaining_window)
        end
    end, { timeout = 10, type = "oneshot" })
end)

hl.on("window.move_to_workspace", function(moved_window, new_ws)
    hl.timer(function()
        local prev_ws_windows = get_remaining_windows(moved_window, hl.get_last_workspace())
        local new_ws_windows = get_remaining_windows(nil, new_ws)

        if #prev_ws_windows == 1 then
            local remaining_win = prev_ws_windows[1]
            if is_dynamic_pseudo(remaining_win) then pseudo("enable", remaining_win) end
        elseif #prev_ws_windows > 1 then
            for _, w in ipairs(prev_ws_windows) do
                if is_dynamic_pseudo(w) then pseudo("disable", w) end
            end
        end

        if #new_ws_windows == 1 then
            local remaining_win = new_ws_windows[1]
            if is_dynamic_pseudo(remaining_win) then pseudo("enable", remaining_win) end
        elseif #new_ws_windows > 1 then
            for _, w in ipairs(new_ws_windows) do
                if is_dynamic_pseudo(w) then pseudo("disable", w) end
            end
        end
    end, { timeout = 10, type = "oneshot" })
end)

local function toggle_float()
    local window = hl.get_active_window()
    if not window then return end
    hl.dispatch(hl.dsp.window.float({ window = window, action = "toggle" }))
    if window.floating then
        hl.dispatch(hl.dsp.window.tag({ tag = "-pseudo", window = window }))
        -- window.close
        local wins = get_remaining_windows(window)
        if #wins ~= 1 then return end
        local remaining_window = wins[1]
        if is_dynamic_pseudo(remaining_window) then
            pseudo("enable", remaining_window)
        end
    else
        -- window.open
        local wins = get_remaining_windows()
        if is_dynamic_pseudo(window) and #wins == 1 then
            pseudo("enable", window)
        elseif #wins > 1 then
            for _, w in ipairs(wins) do
                if is_dynamic_pseudo(w) then pseudo("disable", w) end
            end
        end
    end
end

qs.bind("SUPER + P", function() pseudo("toggle") end)
qs.bind("SUPER + F", function() toggle_float() end)
