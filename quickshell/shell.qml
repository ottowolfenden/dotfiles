import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import "modules"
import "modules/bafs"

Scope {
    PanelWindow {
        id: root
        implicitHeight: Design.barHeight + Design.radius
        color: "transparent"
        anchors {
            top: true
            right: true
            left: true
        }
        exclusiveZone: Design.barHeight - 1
        focusable: true
        WlrLayershell.keyboardFocus: search.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand

        Pane {
            id: pane
            anchors.fill: parent
            implicitHeight: Design.barHeight
            topPadding: 0
            bottomPadding: 0
            leftPadding: Design.spacing
            rightPadding: Design.spacing
            background: Shape {
                layer.enabled: true
                layer.samples: 4
                ShapePath {
                    fillColor: Colours.bg1
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
                        x: pane.width - Design.radius
                        y: pane.height - Design.radius
                        radiusX: Design.radius
                        radiusY: Design.radius
                        direction: PathArc.Counterclockwise
                    }
                    PathLine {
                        x: Design.radius
                        y: pane.height - Design.radius
                    }
                    PathArc {
                        x: 0
                        y: pane.height
                        radiusX: Design.radius
                        radiusY: Design.radius
                        direction: PathArc.Counterclockwise
                    }
                    PathLine {
                        x: 0
                        y: 0
                    }
                }
            }

            RowLayout {
                spacing: Design.spacing
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: Design.radius
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
                    bottomMargin: Design.radius
                }

                Search {
                    id: search
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            RowLayout {
                spacing: Design.spacing
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: Design.radius
                }

                Mode {}
                Network {}
                Audio {}
                Bluetooth {}
                Battery {}
                Power {}
            }
        }

        BrightnessBaf {}
        VolumeBaf {}
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
