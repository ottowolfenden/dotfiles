local h = require("helpers")

local qs_binds = {
    ["SUPER + F"] = hl.dsp.window.float({ action = "toggle" }),
    ["SUPER + slash"] = hl.dsp.layout("togglesplit"),
    ["SUPER + mouse:272"] = { hl.dsp.window.drag(), { mouse = true } },
    ["SUPER + mouse:273"] = { hl.dsp.window.resize(), { mouse = true } },
    ["SUPER + SHIFT + mouse:272"] = { hl.dsp.window.resize(), { mouse = true } },
    ["SUPER + M"] = hl.dsp.window.move({ monitor = "+1", follow = true }),
    ["F11"] = hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle" }),
    ["SUPER + F11"] = hl.dsp.window.fullscreen_state({ internal = 3, client = 3, action = "toggle" }),
    [{ "SUPER + mouse:274", "SUPER + W" }] = function()
        local w = hl.get_active_window()
        if not w then return end
        if w.title == "qalc" then
            h.press_key("CTRL", "C")
        else
            hl.dispatch(hl.dsp.window.close())
        end
    end
}

for _, d in ipairs({ "right", "left", "up", "down" }) do
    qs_binds["SUPER + " .. d] = hl.dsp.focus({ direction = d })
    qs_binds["SUPER + SHIFT + " .. d] = hl.dsp.window.swap({ direction = d })
end

local binds = {
    ["SUPER + SHIFT + S"] = hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh region"),
    [{ "Print", "XF86SelectiveScreenshot" }] = hl.dsp.exec_cmd("~/dotfiles/scripts/screenshot.sh"),
    ["SUPER + SHIFT + I"] = function() hl.notification.create({ text = hl.get_active_window().title, timeout = 5000 }) end
}

for mouse, key in pairs({ ["mouse_up"] = "equal", ["mouse_down"] = "minus" }) do
    binds["CTRL + " .. mouse] = { function()
        local w = hl.get_active_window()
        if not w or w.class ~= "kitty" then return end
        h.press_key("CTRL", key)
    end, { non_consuming = true } }
end

h.qs_binds(qs_binds)
h.binds(binds)

local no_fullscreen_classes = { "helium" }

hl.on("window.open", function(w)
    hl.timer(function()
        local a_w = hl.get_active_window()
        if not a_w or w.address ~= a_w.address then
            hl.dispatch(hl.dsp.focus({ window = w }))
        end
        if not h.arr_includes(no_fullscreen_classes, w.class) then
            hl.dispatch(hl.dsp.window.fullscreen_state({
                internal = 0,
                client = 2,
                action = "set",
                window = w
            }))
        end
    end, { timeout = 1, type = "oneshot" })
end)
