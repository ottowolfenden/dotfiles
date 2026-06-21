import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "./components"

Scope {
    PanelWindow {
        implicitHeight: Config.panelWindowHeight
        color: "transparent"
        anchors {
            top: true
            right: true
            left: true
        }

        Pane {
            anchors.fill: parent
            bottomPadding: 0
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
