import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "./modules"

Scope {
    PanelWindow {
        implicitHeight: Config.barHeight + Config.spacing
        color: "transparent"
        anchors {
            top: true
            right: true
            left: true
        }

        Pane {
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            implicitHeight: Config.barHeight
            padding: 0
            leftPadding: Config.spacing
            rightPadding: Config.spacing

            background: Rectangle {
                color: "transparent"
            }

            RowLayout {
                spacing: Config.spacing
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }

                Power {}
                Time {}
                Workspaces {}
            }

            RowLayout {
                spacing: Config.spacing
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                Power {}
                Mode {}
                Network {}
                Volume {}
                Bluetooth {}
                Battery {}
                Power {}
            }
        }
    }

    ShellRoot {
        Connections {
            target: Quickshell
            function onReloadCompleted() {
                Quickshell.inhibitReloadPopup();
            }
            function onReloadFailed(error) {
                Quickshell.inhibitReloadPopup();
            }
        }
    }
}
