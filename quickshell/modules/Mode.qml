import QtQuick
import Quickshell
import ".."
import "../components"

Rectangle {
    id: mode
    color: "transparent"
    radius: Config.radius
    implicitWidth: Config.componentHeight
    implicitHeight: Config.componentHeight

    Cutout {}

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: QsState.darkMode ? Icons.mode.dark : Icons.mode.light
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            QsState.darkMode = !QsState.darkMode;
            Quickshell.execDetached([Config.scriptsDir + "set-theme.sh", QsState.darkMode ? "dark" : "light"]);
        }
    }
}
