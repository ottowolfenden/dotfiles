pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: state

    property bool darkMode: false
    property var darkModeProcess: Process {
        id: getDarkMode
        command: ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: state.darkMode = text.trim() == "'prefer-dark'"
        }
    }

    property var flyouts: []
    property var flyoutsHandler: IpcHandler {
        target: "flyoutsHandler"

        function hide() {
            for (const flyout of state.flyouts) {
                if (!flyout.hovering)
                    flyout.visible = false;
            }
        }
    }
}
