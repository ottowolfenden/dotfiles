hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swaync")
    hl.exec_cmd("clipse -listen")
end)

hl.on("window.open", function(w)
    if w.class == "anki" then
        hl.exec_cmd("sleep 0.5 && wtype -k F11 &")
    end
end)
