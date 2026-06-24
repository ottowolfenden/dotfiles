import QtQuick
import ".."
import "../components"

Rectangle {
    color: Config.colours.bg
    radius: Config.radius
    implicitWidth: Config.barHeight
    implicitHeight: Config.barHeight

    Icon {
        id: icon
        pixelSize: 17
        anchors.centerIn: parent
        iconName: Icons.power
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: powerFlyout.visible = true
    }

    Flyout {
        id: powerFlyout
        rectHeight: 200
        rectWidth: 300
    }
}
