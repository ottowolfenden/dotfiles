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
                Quickshell.execDetached(["awww", "img", text.trim(), "-t", "grow", "--transition-pos=2320,0", "--invert-y", "--transition-fps=120", "--transition-duration=1.5"]);
            }
        }
    }

    property Timer dailyWallpaperTimer: Timer {
        running: true
        repeat: true
        interval: 10000

        property int lastDay: -1

        onTriggered: {
            let now = new Date();
            let hr = now.getHours();
            let min = now.getMinutes();
            let day = now.getDate();

            if (hr == 0 && min == 0 && lastDay != day) {
                lastDay = day;
                root.dailyWallpaperProcess.running = true;
            }
        }
    }

    property IpcHandler dailyWallpaperHandler: IpcHandler {
        target: "dailyWallpaperHandler"
        function refresh() {
            root.dailyWallpaperProcess.running = true;
        }
    }
}
