import QtQuick
import ".."
import "../components"

Rectangle {
    id: power
    color: Config.colours.bg2
    radius: Config.radius
    implicitWidth: Config.componentHeight
    implicitHeight: Config.componentHeight

    Icon {
        id: icon
        pixelSize: 17
        anchors.centerIn: parent
        iconName: Icons.power
    }

    property bool reopening: false
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if (powerFlyout.isOpen) {
                powerFlyout.isOpen = false;
                power.reopening = true;
            } else
                power.reopening = false;
        }
        onReleased: {
            powerFlyout.parentX = power.mapToItem(null, power.width / 2, 0).x;
            powerFlyout.isOpen = !powerFlyout.isOpen && !power.reopening;
        }
    }

    Flyout {
        id: powerFlyout
        rectHeight: 150
        rectWidth: 200
        parentX: power.x
        parentWidth: power.width
    }
}
