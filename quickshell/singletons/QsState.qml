pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell

QtObject {
    id: qsState

    property bool darkMode: true
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
            Qt.callLater(function () {
                for (const flyout of qsState.flyouts)
                    if (!flyout.hovering)
                        flyout.isOpen = false;
            });
        }
    }
}
