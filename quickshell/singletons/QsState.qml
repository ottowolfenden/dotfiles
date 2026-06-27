pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: qsState

    property bool darkMode: true
    property var darkModeProcess: Process {
        command: "gsettings get org.gnome.desktop.interface color-scheme".split(" ")
        running: true
        stdout: StdioCollector {
            onStreamFinished: qsState.darkMode = text.trim() == "'prefer-dark'"
        }
    }

    property var flyouts: []
    property var flyoutsHander: IpcHandler {
        target: "flyoutsHandler"
        function hide() {
            Qt.callLater(function () {
                for (const flyout of qsState.flyouts)
                    if (!flyout.hovering)
                        flyout.isOpen = false;
            });
        }
    }

    property string dailyWallpaperPath
    property var dailyWallpaperProcess: Process {
        command: ["/home/otto/dotfiles/scripts/daily-wallpaper.sh", qsState.darkMode ? "dark" : "light"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                qsState.dailyWallpaperPath = text.trim();
                Quickshell.execDetached(["awww", "img", text.trim(), "--transition-type", "none"]);
                console.log(text);
            }
        }
    }
    property var dailyWallpaperTimer: Timer {
        running: true
        interval: new Date(new Date().setHours(24, 0, 0, 0)) - new Date()
        onTriggered: {
            qsState.dailyWallpaperProcess.running = true;
            interval = 24 * 60 * 60 * 1000;
            restart();
        }
    }
    property var dailyWallpaperHandler: IpcHandler {
        target: "dailyWallpaperHandler"
        function refresh() {
            qsState.dailyWallpaperProcess.running = true;
        }
    }
}
