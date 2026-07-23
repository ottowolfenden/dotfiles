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

local function is_dp_disabled(window)
    return h.arr_includes(window.tags, "dp_disabled")
end

local prefixes = {
    toggle = "",
    enable = "+",
    disable = "-"
}

local function tag(name, action, window)
    hl.dispatch(hl.dsp.window.tag({ tag = prefixes[action] .. name, window = window }))
end

local function resize(window)
    hl.dispatch(hl.dsp.window.resize({ x = pseudo_size.x, y = pseudo_size.y, window = window }))
end

local function get_dp_windows(opts)
    if not opts then opts = {} end
    local all_windows = hl.get_workspace_windows(opts.ws_id and opts.ws_id or hl.get_active_workspace().id)
    local windows = {}
    for _, w in ipairs(all_windows) do
        if
            not w.floating
            and (not opts.exclude_window or w.address ~= opts.exclude_window.address)
            and (not is_dp_disabled(w) or opts.include_disabled)
        then
            table.insert(windows, w)
        end
    end
    return windows
end

local function pseudo(action, window)
    if not action or not window then return end
    hl.dispatch(hl.dsp.window.pseudo({ window = window, action = action }))
    if action == "toggle" then
        tag("pseudo", "toggle", window)
        if is_pseudo(window) then resize(window) end
    elseif action == "enable" then
        resize(window)
        tag("pseudo", "enable", window)
    elseif action == "disable" then
        tag("pseudo", "disable", window)
    end
end

local function window_open(opened_window)
    local windows = get_dp_windows({ include_disabled = true })
    if is_dynamic_pseudo(opened_window) and #windows == 1 then
        pseudo("enable", opened_window)
    elseif #windows > 1 then
        for _, w in ipairs(windows) do
            if is_dynamic_pseudo(w) and not is_dp_disabled(w) then pseudo("disable", w) end
        end
    end
end

local function window_close(closed_window)
    local windows = get_dp_windows({ exclude_window = closed_window })
    if #windows == 1 then
        local remaining_window = windows[1]
        if is_dynamic_pseudo(remaining_window) then pseudo("enable", remaining_window) end
    end
end

hl.on("window.open", function(opened_window)
    window_open(opened_window)
end)

hl.on("window.close", function(closed_window)
    hl.timer(function()
        window_close(closed_window)
    end, { timeout = 10, type = "oneshot" })
end)

Previous_ws_id = nil
Current_ws_id = hl.get_active_workspace().id

hl.on("workspace.active", function(ws)
    if not Current_ws_id then
        Current_ws_id = ws.id
    else
        Previous_ws_id = Current_ws_id
        Current_ws_id = ws.id
    end
end)

hl.on("window.move_to_workspace", function(moved_window, new_ws)
    hl.timer(function()
        local prev_ws_windows = get_dp_windows({ ws_id = Previous_ws_id })
        local new_ws_windows = get_dp_windows({ ws_id = new_ws.id, include_disabled = true })

        if #new_ws_windows == 1 then
            local only_window = new_ws_windows[1]
            if is_dynamic_pseudo(only_window) and not is_dp_disabled(only_window) then pseudo("enable", only_window) end
        elseif #new_ws_windows > 1 then
            for _, w in ipairs(new_ws_windows) do
                if is_dynamic_pseudo(w) and not is_dp_disabled(w) then
                    pseudo("disable", w)
                end
            end
        end

        if #prev_ws_windows == 1 then
            local remaining_window = prev_ws_windows[1]
            if is_dynamic_pseudo(remaining_window) then pseudo("enable", remaining_window) end
        end
    end, { timeout = 10, type = "oneshot" })
end)

local function should_be_pseudo(window)
    if not window or not is_dynamic_pseudo(window) then return false end
    local other_windows = get_dp_windows({ exclude_window = window, include_disabled = true })
    return #other_windows == 0
end

qs.bind("SUPER + P", function()
    local window = hl.get_active_window()
    pseudo("toggle", window)
    if is_dynamic_pseudo(window) and (
            (is_pseudo(window) and not should_be_pseudo(window))
            or (not is_pseudo(window) and should_be_pseudo(window))
        )
    then
        tag("dp_disabled", "enable", window)
    else
        tag("dp_disabled", "disable", window)
    end
end)

qs.bind("SUPER + F", function()
    local window = hl.get_active_window()
    if not window then return end
    hl.dispatch(hl.dsp.window.float({ window = window, action = "toggle" }))
    if window.floating then
        tag("pseudo", "disable", window)
        window_close(window)
    else
        window_open(window)
    end
end)
