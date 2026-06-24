import QtQuick
import ".."
import "../components"

Rectangle {
    id: power
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
        onClicked: {
            powerFlyout.parentX = power.mapToItem(null, power.width / 2, 0).x;
            powerFlyout.visible = true;
        }
    }

    Flyout {
        id: powerFlyout
        rectHeight: 200
        rectWidth: 300

        Text {
            text: "test"
            color: Config.colours.fg1
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
        }
    }
}
