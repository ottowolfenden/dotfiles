pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: qsState

    property bool darkMode: false
    property var darkModeProcess: Process {
        id: getDarkMode
        command: ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: qsState.darkMode = text.trim() == "'prefer-dark'"
        }
    }

    property var flyouts: []
    property var flyoutsHandler: IpcHandler {
        target: "flyoutsHandler"

        function hide() {
            for (const flyout of qsState.flyouts)
                if (!flyout.hovering)
                    flyout.visible = false;
        }
    }
}
