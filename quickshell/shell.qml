import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import "./modules"

Scope {
    PanelWindow {
        implicitHeight: Config.barHeight + Config.radius
        color: "transparent"
        anchors {
            top: true
            right: true
            left: true
        }
        exclusiveZone: Config.barHeight

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
                    fillColor: Config.colours.green
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
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    bottomMargin: Config.radius
                }

                Power {}
                Time {}
                Workspaces {}
                Power {}

                Item {
                    Layout.fillWidth: true
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
