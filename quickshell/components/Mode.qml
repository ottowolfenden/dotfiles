import QtQuick
import Quickshell
import ".."

Rectangle {
    id: mode
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: Config.barHeight
    implicitHeight: Config.barHeight

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: Config.darkMode ? "dark_mode" : "light_mode"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Config.darkMode = !Config.darkMode;
            Quickshell.execDetached(["set-theme.sh", Config.darkMode ? "dark" : "light"]);
        }
    }
}
