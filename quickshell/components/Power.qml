import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.borderRadius
    width: Config.barHeight
    Layout.fillHeight: true

    Icon {
        id: icon
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
