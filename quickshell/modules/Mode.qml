import QtQuick
import Quickshell
import ".."
import "../components"

Rectangle {
    id: mode
    color: "transparent"
    radius: Design.radius
    implicitWidth: Design.componentHeight
    implicitHeight: Design.componentHeight

    Cutout {}

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: Icons.mode[ModeService.mode ?? "none"]
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            ModeService.swap();
            Quickshell.execDetached([Directories.scripts + "set-theme.sh", ModeService.mode]);
        }
    }
}
