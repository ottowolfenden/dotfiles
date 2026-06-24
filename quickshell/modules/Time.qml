import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.radius
    implicitWidth: container.width + (Config.spacing * 2)
    implicitHeight: Config.barHeight

    RowLayout {
        id: container
        spacing: Config.spacing * 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Config.spacing
        Item {
            implicitHeight: time.height
            implicitWidth: 35
            Text {
                id: time
                color: Config.colours.fg1
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }
        }
        Text {
            id: date
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
                time.text = datetime[0];
                date.text = datetime[1];
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
