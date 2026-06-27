import QtQuick
import Quickshell
import ".."
import "../components"

Rectangle {
    id: mode
    color: Config.colours.bg2
    radius: Config.radius
    implicitWidth: Config.componentHeight
    implicitHeight: Config.componentHeight

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: QsState.darkMode ? Icons.mode.dark : Icons.mode.light
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            QsState.darkMode = !QsState.darkMode;
            Quickshell.execDetached([Quickshell.shellDir + "/scripts/set-theme.sh", QsState.darkMode ? "dark" : "light"]);
        }
    }
}
