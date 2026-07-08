import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import "modules"

Scope {
    PanelWindow {
        id: root
        implicitHeight: Config.barHeight + Config.radius
        color: "transparent"
        anchors {
            top: true
            right: true
            left: true
        }
        exclusiveZone: Config.barHeight - 1
        focusable: true
        WlrLayershell.keyboardFocus: search.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand

        Pane {
            id: pane
            anchors.fill: parent
            implicitHeight: Config.barHeight
            topPadding: 0
            bottomPadding: 0
            leftPadding: Config.spacing
            rightPadding: Config.spacing
            background: Shape {
                layer.enabled: true
                layer.samples: 4
                ShapePath {
                    fillColor: Config.colours.bg1
                    strokeWidth: 0

                    startX: 0
                    startY: 0

                    PathLine {
                        x: pane.width
                        y: 0
                    }
                    PathLine {
                        x: pane.width
                        y: pane.height
                    }
                    PathArc {
                        x: pane.width - Config.radius
                        y: pane.height - Config.radius
                        radiusX: Config.radius
                        radiusY: Config.radius
                        direction: PathArc.Counterclockwise
                    }
                    PathLine {
                        x: Config.radius
                        y: pane.height - Config.radius
                    }
                    PathArc {
                        x: 0
                        y: pane.height
                        radiusX: Config.radius
                        radiusY: Config.radius
                        direction: PathArc.Counterclockwise
                    }
                    PathLine {
                        x: 0
                        y: 0
                    }
                }
            }

            RowLayout {
                spacing: Config.spacing
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: Config.radius
                }

                Time {}
                Workspaces {}
            }

            Item {
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: Config.radius
                }

                Search {
                    id: search
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            RowLayout {
                spacing: Config.spacing
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: Config.radius
                }

                Mode {}
                Network {}
                Audio {}
                Bluetooth {}
                Battery {}
                Power {}
            }
        }

        BottomAutoFlyouts {}
    }

    ShellRoot {
        Connections {
            target: Quickshell
            function onReloadCompleted(): void {
                Quickshell.inhibitReloadPopup();
            }
            function onReloadFailed(error): void {
                Quickshell.inhibitReloadPopup();
            }
        }
    }
}
