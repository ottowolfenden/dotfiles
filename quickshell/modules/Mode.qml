import QtQuick
import Quickshell
import ".."
import "../components"

Rectangle {
    id: mode
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: DesignConf.componentHeight
    implicitHeight: DesignConf.componentHeight

    Cutout {}

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: IconsConf.mode[ModeService.mode ?? "none"]
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            ModeService.swap();
            Quickshell.execDetached([PathsConf.scripts + "set-theme.sh", ModeService.mode]);
        }
    }
}
