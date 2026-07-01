import QtQuick
import QtQuick.Shapes
import ".."

Item {
    id: slider
    required property real value
    property string bgColour: Config.colours.bg2
    property string fgColour: Config.colours.lightblue
    readonly property int trackWidth: width - ([0, 1].includes(value) ? row.spacing : row.spacing * 2) - handle.initialWidth
    readonly property int trackHeight: height - handle.extraHeight
    signal changed(real newValue)

    Row {
        id: row
        spacing: 5
        Shape {
            id: activeTrack
            width: Math.round(slider.trackWidth * slider.value)
            height: slider.trackHeight
            layer.enabled: true
            layer.samples: 20
            anchors.verticalCenter: parent.verticalCenter

            Behavior on width {
                NumberAnimation {
                    duration: 35
                }
            }

            ShapePath {
                fillColor: slider.fgColour
                strokeWidth: 0

                startX: Config.radius
                startY: 0

                PathLine {
                    x: activeTrack.width - Config.smallRadius
                    y: 0
                }
                PathArc {
                    x: activeTrack.width
                    y: Config.smallRadius
                    radiusX: Config.smallRadius
                    radiusY: Config.smallRadius
                }
                PathLine {
                    x: activeTrack.width
                    y: activeTrack.height - Config.smallRadius
                }
                PathArc {
                    x: activeTrack.width - Config.smallRadius
                    y: activeTrack.height
                    radiusX: Config.smallRadius
                    radiusY: Config.smallRadius
                }
                PathLine {
                    x: Config.radius
                    y: activeTrack.height
                }
                PathArc {
                    x: 0
                    y: activeTrack.height - Config.radius
                    radiusX: Config.radius
                    radiusY: Config.radius
                }
                PathLine {
                    x: 0
                    y: Config.radius
                }
                PathArc {
                    x: Config.radius
                    y: 0
                    radiusX: Config.radius
                    radiusY: Config.radius
                }
            }
        }

        Rectangle {
            id: handle
            property int initialWidth: 3
            property int extraHeight: 16
            color: slider.fgColour
            width: initialWidth
            height: slider.trackHeight + extraHeight
            anchors.verticalCenter: parent.verticalCenter
            radius: Infinity
        }

        Shape {
            id: inactiveTrack
            width: Math.round(slider.trackWidth * (1 - slider.value))
            height: slider.trackHeight
            layer.enabled: true
            layer.samples: 20
            anchors.verticalCenter: parent.verticalCenter

            Behavior on width {
                NumberAnimation {
                    duration: 35
                }
            }

            ShapePath {
                fillColor: slider.bgColour
                strokeWidth: 0

                startX: Config.radius
                startY: 0

                PathLine {
                    x: inactiveTrack.width - Config.radius
                    y: 0
                }
                PathArc {
                    x: inactiveTrack.width
                    y: Config.radius
                    radiusX: Config.radius
                    radiusY: Config.radius
                }
                PathLine {
                    x: inactiveTrack.width
                    y: inactiveTrack.height - Config.radius
                }
                PathArc {
                    x: inactiveTrack.width - Config.radius
                    y: inactiveTrack.height
                    radiusX: Config.radius
                    radiusY: Config.radius
                }
                PathLine {
                    x: Config.smallRadius
                    y: inactiveTrack.height
                }
                PathArc {
                    x: 0
                    y: inactiveTrack.height - Config.smallRadius
                    radiusX: Config.smallRadius
                    radiusY: Config.smallRadius
                }
                PathLine {
                    x: 0
                    y: Config.smallRadius
                }
                PathArc {
                    x: Config.smallRadius
                    y: 0
                    radiusX: Config.smallRadius
                    radiusY: Config.smallRadius
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        cursorShape: Qt.SplitHCursor
        anchors.fill: parent

        property bool listening: false
        onMouseXChanged: {
            if (listening)
                slider.changed(Helpers.clamp(mouseX / slider.width, 0, 1));
        }
        onPressed: listening = true
        onReleased: listening = false
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                slider.changed(Helpers.clamp(slider.value + 0.02, 0, 1));
            else if (wheel.angleDelta.y < 0)
                slider.changed(Helpers.clamp(slider.value - 0.02, 0, 1));
        }
    }
}
