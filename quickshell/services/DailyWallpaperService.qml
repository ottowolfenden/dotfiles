pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."

QtObject {
    id: root

    property string path

    property Process dailyWallpaperProcess: Process {
        command: [PathsConf.scripts + "daily-wallpaper.sh", ModeService.mode]
        running: ModeService.mode != null
        stdout: StdioCollector {
            onStreamFinished: {
                root.path = text.trim();
                Quickshell.execDetached(["awww", "img", text.trim(), "--transition-type", "none"]);
            }
        }
    }

    property Timer dailyWallpaperTimer: Timer {
        running: true
        interval: new Date(new Date().setHours(24, 0, 0, 0)) - new Date()
        onTriggered: {
            root.dailyWallpaperProcess.running = true;
            interval = 24 * 60 * 60 * 1000;
            restart();
        }
    }

    property IpcHandler dailyWallpaperHandler: IpcHandler {
        target: "dailyWallpaperHandler"
        function refresh() {
            root.dailyWallpaperProcess.running = true;
        }
    }
}
