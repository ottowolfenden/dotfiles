pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import ".."
import "../components"

Rectangle {
    id: time
    color: "transparent"
    radius: Design.radius
    implicitWidth: container.width + (Design.spacing * 2)
    implicitHeight: Design.componentHeight

    Cutout {}

    RowLayout {
        id: container
        spacing: Design.spacing * 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Design.spacing
        Item {
            implicitHeight: timeText.height
            implicitWidth: 35
            Text {
                id: timeText
                color: Colours.fg1
                font.family: Design.fontFamily
                font.pixelSize: Design.fontSize
            }
        }
        Text {
            id: dateText
            color: Colours.fg1
            font.family: Design.fontFamily
            font.pixelSize: Design.fontSize
        }
    }

    Process {
        id: timeProc
        command: ["date", "+%I:%M-%a %-d %b"]
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
