import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: textContainer.width + (textContainer.anchors.leftMargin * 2)
    Layout.fillHeight: true

    RowLayout {
        id: textContainer
        spacing: Config.spacing * 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Config.spacing
        Item {
            implicitHeight: time.height
            implicitWidth: 43
            Text {
                id: time
                color: Config.colours.fg1
                font.family: Config.font
                font.pixelSize: Config.fontSize
            }
        }
        Text {
            id: date
            color: Config.colours.fg1
            font.family: Config.font
            font.pixelSize: Config.fontSize
        }
    }

    Process {
        id: timeProc
        command: ["date", "+%I:%M-%a %d %b"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var a = text.trim().split("-");
                time.text = a[0];
                date.text = a[1];
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeProc.running = true;
        }
    }
}
