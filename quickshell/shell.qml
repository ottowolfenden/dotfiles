import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: w
    implicitHeight: 40
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }

    property int fontSize: 15
    property int borderRadius: 5
    property var bgColour: Qt.rgba(255, 255, 255, 0.7)
    property int spacing: 9

    Pane {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        padding: w.spacing
        bottomPadding: 0
        background: Rectangle {
            color: "transparent"
        }

        RowLayout {
            spacing: w.spacing
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            Rectangle {
                color: w.bgColour
                radius: w.borderRadius
                implicitWidth: contentRow.width + (contentRow.anchors.leftMargin * 2)
                Layout.fillHeight: true
                RowLayout {
                    id: contentRow
                    spacing: w.spacing * 2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: w.spacing
                    Text {
                        id: time
                        text: "05:48"
                        color: "#000"
                        font.family: "Google Sans Flex"
                        font.pixelSize: w.fontSize
                    }
                    Text {
                        id: date
                        text: "Thu 21 Feb"
                        color: "#000"
                        font.family: "Google Sans Flex"
                        font.pixelSize: w.fontSize
                    }
                }
            }
        }
    }

    Process {
        id: timeProc
        command: ["date", "+%I:%M:%S"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                time.text = text.trim();
            }
        }
    }

    Process {
        id: dateProc
        command: ["date", "+%a %d %b"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                date.text = text.trim();
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeProc.running = true
    }
}
