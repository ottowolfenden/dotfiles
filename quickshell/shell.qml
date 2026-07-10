import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import "modules"
import "modules/bafs"
import "services"

Scope {
    PanelWindow {
        id: root
        implicitHeight: DesignConf.barHeight + DesignConf.radius
        color: "transparent"
        anchors {
            top: true
            right: true
            left: true
        }
        exclusiveZone: DesignConf.barHeight - 1
        focusable: true

        Pane {
            id: pane
            anchors.fill: parent
            implicitHeight: DesignConf.barHeight
            topPadding: 0
            bottomPadding: 0
            leftPadding: DesignConf.spacing
            rightPadding: DesignConf.spacing
            background: Shape {
                layer.enabled: true
                layer.samples: 4
                ShapePath {
                    fillColor: ColoursConf.bg1
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
                        x: pane.width - DesignConf.radius
                        y: pane.height - DesignConf.radius
                        radiusX: DesignConf.radius
                        radiusY: DesignConf.radius
                        direction: PathArc.Counterclockwise
                    }
                    PathLine {
                        x: DesignConf.radius
                        y: pane.height - DesignConf.radius
                    }
                    PathArc {
                        x: 0
                        y: pane.height
                        radiusX: DesignConf.radius
                        radiusY: DesignConf.radius
                        direction: PathArc.Counterclockwise
                    }
                    PathLine {
                        x: 0
                        y: 0
                    }
                }
            }

            MouseArea {
                width: Screen.width
                x: -DesignConf.spacing
                height: pane.height - DesignConf.spacing + 1
                onClicked: FlyoutsService.hideAllFlyouts()
            }

            RowLayout {
                spacing: DesignConf.spacing
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: DesignConf.radius
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
                    bottomMargin: DesignConf.radius
                }

                Search {
                    id: search
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    onIsOpenChanged: {
                        if (isOpen) {
                            root.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
                            releaseFocusTimer.running = true;
                        } else
                            root.WlrLayershell.keyboardFocus = WlrKeyboardFocus.OnDemand;
                    }

                    Timer {
                        id: releaseFocusTimer
                        interval: 10
                        running: false
                        repeat: false
                        onTriggered: root.WlrLayershell.keyboardFocus = WlrKeyboardFocus.OnDemand
                    }
                }
            }

            RowLayout {
                spacing: DesignConf.spacing
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: DesignConf.radius
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
