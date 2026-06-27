pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import ".."
import "../components"

Rectangle {
    id: time
    color: "transparent"
    radius: Config.radius
    implicitWidth: container.width + (Config.spacing * 2)
    implicitHeight: Config.componentHeight

    Cutout {}

    RowLayout {
        id: container
        spacing: Config.spacing * 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Config.spacing
        Item {
            implicitHeight: timeText.height
            implicitWidth: 35
            Text {
                id: timeText
                color: Config.colours.fg1
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }
        }
        Text {
            id: dateText
            color: Config.colours.fg1
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
        }
    }

    Process {
        id: timeProc
        command: ["date", "+%I:%M-%a %d %b"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var datetime = text.trim().split("-");
                timeText.text = datetime[0];
                dateText.text = datetime[1];
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeProc.running = true
    }
}
