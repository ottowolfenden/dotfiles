hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swaync")
    hl.exec_cmd("clipse -listen")
end)

hl.on("window.open", function(w)
    if w.class == "anki" then
        hl.dispatch(hl.dsp.send_shortcut({ mods = "", key = "F11", window = w }))
    end
end)
