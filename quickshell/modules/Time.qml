pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import QtQuick.Layouts
import ".."
import "../components"

Rectangle {
    id: time
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: container.width + (DesignConf.spacing * 2)
    implicitHeight: DesignConf.componentHeight

    Cutout {}

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    RowLayout {
        id: container
        spacing: DesignConf.spacing
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: DesignConf.spacing

        Item {
            implicitHeight: timeText.height
            implicitWidth: Math.max(44, timeText.width)
            Text {
                id: timeText
                text: Qt.formatDateTime(clock.date, "hh:mm ap").slice(0, -3)
                color: ColoursConf.fg1.t
                font.family: FontsConf.mainFamily
                font.pixelSize: FontsConf.pixelSize
            }
        }

        Item {
            implicitHeight: dateText.height
            implicitWidth: dateText.width
            Text {
                id: dateText
                text: Qt.formatDateTime(clock.date, "ddd d MMM")
                color: ColoursConf.fg1.t
                font.family: FontsConf.mainFamily
                font.pixelSize: FontsConf.pixelSize
                anchors.right: parent.right
            }
        }
    }
}
