import QtQuick
import Quickshell.Io
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: Config.barHeight
    implicitHeight: Config.barHeight

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: "power_settings_new"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: hyprshutdown.running = true
    }

    Process {
        id: hyprshutdown
        command: ["hyprctl", "dispatch", "hl.dsp.exit()"]
    }
}
