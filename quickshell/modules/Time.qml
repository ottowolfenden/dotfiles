pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
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

    RowLayout {
        id: container
        spacing: DesignConf.spacing * 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: DesignConf.spacing
        Item {
            implicitHeight: timeText.height
            implicitWidth: 35
            Text {
                id: timeText
                color: ColoursConf.fg1
                font.family: DesignConf.fontFamily
                font.pixelSize: DesignConf.fontSize
            }
        }
        Text {
            id: dateText
            color: ColoursConf.fg1
            font.family: DesignConf.fontFamily
            font.pixelSize: DesignConf.fontSize
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
