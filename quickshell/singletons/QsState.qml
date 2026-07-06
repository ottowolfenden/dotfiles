pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."
import "../components"

QtObject {
    id: qsState

    property var darkMode: null
    property Process darkModeProcess: Process {
        command: "gsettings get org.gnome.desktop.interface color-scheme".split(" ")
        running: true
        stdout: StdioCollector {
            onStreamFinished: qsState.darkMode = text.trim() == "'prefer-dark'"
        }
    }

    property list<Flyout> flyouts: []
    property IpcHandler flyoutsHandler: IpcHandler {
        target: "flyoutsHandler"
        function hideNonHoveredFlyouts() {
            for (const flyout of qsState.flyouts)
                if (!flyout.hovering)
                    flyout.isOpen = false;
            if (!qsState.flyouts.some(f => f.hovering))
                Quickshell.execDetached(["hyprctl", "reload"]);
        }
    }
    function hideAllFlyouts() {
        for (const flyout of qsState.flyouts)
            flyout.isOpen = false;
        Quickshell.execDetached(["hyprctl", "reload"]);
    }
    function hideAllFlyoutsExcept(openFlyout) {
        for (const flyout of qsState.flyouts)
            if (flyout != openFlyout)
                flyout.isOpen = false;

        if (qsState.flyouts.some(f => f.isOpen))
            Quickshell.execDetached(["hyprctl", "eval", `
                hl.config({
                    input = { follow_mouse = 0 },
                    decoration = {
                        active_opacity = 1.0 - 0.3,
                        inactive_opacity = 0.85 - 0.3
                    }
                })
            `]);
        else
            Quickshell.execDetached(["hyprctl", "reload"]);
    }

    property string dailyWallpaperPath
    property Process dailyWallpaperProcess: Process {
        command: [Config.scriptsDir + "daily-wallpaper.sh", qsState.darkMode ? "dark" : "light"]
        running: qsState.darkMode != null
        stdout: StdioCollector {
            onStreamFinished: {
                qsState.dailyWallpaperPath = text.trim();
                Quickshell.execDetached(["awww", "img", text.trim(), "--transition-type", "none"]);
            }
        }
    }
    property Timer dailyWallpaperTimer: Timer {
        running: true
        interval: new Date(new Date().setHours(24, 0, 0, 0)) - new Date()
        onTriggered: {
            qsState.dailyWallpaperProcess.running = true;
            interval = 24 * 60 * 60 * 1000;
            restart();
        }
    }
    property IpcHandler dailyWallpaperHandler: IpcHandler {
        target: "dailyWallpaperHandler"
        function refresh() {
            qsState.dailyWallpaperProcess.running = true;
        }
    }
}
