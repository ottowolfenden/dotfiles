pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property var mode: null
    readonly property list<string> modes: ["light", "dark"]

    function swap() {
        mode = modes[1 - modes.indexOf(mode)];
    }

    property Process startupProcess: Process {
        command: "gsettings get org.gnome.desktop.interface color-scheme".split(" ")
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.mode = text.trim() == "'prefer-light'" ? "light" : "dark"
        }
    }
}
