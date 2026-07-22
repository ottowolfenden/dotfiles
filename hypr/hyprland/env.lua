local h = require("helpers")

h.envs({
    ["XCURSOR_SIZE"] = "24",
    ["HYPRCURSOR_SIZE"] = "24",
    ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "0.8",
    ["QT_QPA_PLATFORM"] = "wayland;xcb",
    ["QT_QPA_PLATFORMTHEME"] = "qt6ct",
    ["GDK_BACKEND"] = "wayland,x11,*",
    ["HYPRLAND_TRACE"] = "1",
})
