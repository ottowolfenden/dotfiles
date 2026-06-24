import QtQuick
import Quickshell
import ".."
import "../components"

Rectangle {
    id: mode
    color: Config.colours.bg
    radius: Config.radius
    implicitWidth: Config.barHeight
    implicitHeight: Config.barHeight

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: QsState.darkMode ? "dark_mode" : "light_mode"
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
