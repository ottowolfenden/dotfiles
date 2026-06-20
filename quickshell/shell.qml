import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "./components"

Scope {
    PanelWindow {
        implicitHeight: 40
        color: "transparent"
        anchors {
            top: true
            left: true
            right: true
        }

        Pane {
            anchors.fill: parent
            padding: Config.spacing
            bottomPadding: 0
            background: Rectangle {
                color: "transparent"
            }

            RowLayout {
                id: leftContainer
                spacing: Config.spacing
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Time {}
                Workspaces {}
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
