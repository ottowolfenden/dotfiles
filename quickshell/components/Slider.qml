import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import ".."

Item {
    id: slider
    required property real value

    property string bgColour: ColoursConf.bg3.t
    property string fgColour: ColoursConf.lightblue
    property string iconName

    readonly property int trackWidth: width - handle.Layout.preferredWidth
    readonly property int trackHeight: height - handle.extraHeight
    readonly property int smallRadius: 2
    readonly property bool iconOnActiveTrack: slider.trackWidth * (1 - slider.value) < activeTrackIcon.width + DesignConf.spacing * 2

    signal changed(real newValue)

    Layout.preferredWidth: DesignConf.sliderWidth
    Layout.preferredHeight: DesignConf.sliderHeight
    Layout.alignment: Qt.AlignHCenter

    RowLayout {
        id: row
        spacing: 0
        anchors.fill: parent

        Item {
            id: activeTrack
            property int smallRadius: slider.value > 0.02 ? 2 : 0

            Layout.preferredWidth: Math.round(slider.trackWidth * slider.value)
            Layout.preferredHeight: slider.trackHeight
            Layout.alignment: Qt.AlignVCenter

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 40
                }
            }

            Shape {
                layer.enabled: true
                layer.samples: 20
                anchors.fill: parent

                ShapePath {
                    fillColor: slider.fgColour
                    strokeWidth: 0

                    startX: DesignConf.radius
                    startY: 0

                    PathLine {
                        x: activeTrack.width - activeTrack.smallRadius
                        y: 0
                    }
                    PathArc {
                        x: activeTrack.width
                        y: activeTrack.smallRadius
                        radiusX: activeTrack.smallRadius
                        radiusY: activeTrack.smallRadius
                    }
                    PathLine {
                        x: activeTrack.width
                        y: activeTrack.height - activeTrack.smallRadius
                    }
                    PathArc {
                        x: activeTrack.width - activeTrack.smallRadius
                        y: activeTrack.height
                        radiusX: activeTrack.smallRadius
                        radiusY: activeTrack.smallRadius
                    }
                    PathLine {
                        x: DesignConf.radius
                        y: activeTrack.height
                    }
                    PathArc {
                        x: 0
                        y: activeTrack.height - DesignConf.radius
                        radiusX: DesignConf.radius
                        radiusY: DesignConf.radius
                    }
                    PathLine {
                        x: 0
                        y: DesignConf.radius
                    }
                    PathArc {
                        x: DesignConf.radius
                        y: 0
                        radiusX: DesignConf.radius
                        radiusY: DesignConf.radius
                    }
                }
            }
            Icon {
                id: activeTrackIcon
                iconName: slider.iconName
                colour: ColoursConf.invfg
                visible: slider.iconOnActiveTrack
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: DesignConf.spacing
            }
        }

        Item {
            id: handle
            property int extraHeight: 14
            property int margins: 4
            property bool clicked
            Layout.preferredWidth: handleRect.initialWidth + margins * 2
            Layout.preferredHeight: slider.trackHeight + extraHeight
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                id: handleRect
                property int initialWidth: 4
                property int clickedWidth: 2
                color: slider.fgColour
                width: handle.clicked ? clickedWidth : initialWidth
                height: handle.height
                radius: Infinity
                anchors.horizontalCenter: handle.horizontalCenter

                Behavior on width {
                    NumberAnimation {
                        duration: 25
                    }
                }
            }
        }

        Item {
            id: inactiveTrack
            property int smallRadius: slider.value < 0.98 ? slider.smallRadius : 0

            Layout.preferredHeight: slider.trackHeight
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            Shape {
                layer.enabled: true
                layer.samples: 20
                anchors.fill: parent

                ShapePath {
                    fillColor: slider.bgColour
                    strokeWidth: 0

                    startX: DesignConf.radius
                    startY: 0

                    PathLine {
                        x: inactiveTrack.width - DesignConf.radius
                        y: 0
                    }
                    PathArc {
                        x: inactiveTrack.width
                        y: DesignConf.radius
                        radiusX: DesignConf.radius
                        radiusY: DesignConf.radius
                    }
                    PathLine {
                        x: inactiveTrack.width
                        y: inactiveTrack.height - DesignConf.radius
                    }
                    PathArc {
                        x: inactiveTrack.width - DesignConf.radius
                        y: inactiveTrack.height
                        radiusX: DesignConf.radius
                        radiusY: DesignConf.radius
                    }
                    PathLine {
                        x: inactiveTrack.smallRadius
                        y: inactiveTrack.height
                    }
                    PathArc {
                        x: 0
                        y: inactiveTrack.height - inactiveTrack.smallRadius
                        radiusX: inactiveTrack.smallRadius
                        radiusY: inactiveTrack.smallRadius
                    }
                    PathLine {
                        x: 0
                        y: inactiveTrack.smallRadius
                    }
                    PathArc {
                        x: inactiveTrack.smallRadius
                        y: 0
                        radiusX: inactiveTrack.smallRadius
                        radiusY: inactiveTrack.smallRadius
                    }
                }
            }

            Icon {
                id: inactiveTrackIcon
                iconName: slider.iconName
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: DesignConf.spacing
                colour: ColoursConf.fg1.t
                visible: !slider.iconOnActiveTrack
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
                slider.changed(MiscService.clamp(mouseX / slider.width, 0, 1));
        }
        onPressed: listening = handle.clicked = true
        onReleased: listening = handle.clicked = false

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                slider.changed(MiscService.clamp(slider.value + 0.02, 0, 1));
            else if (wheel.angleDelta.y < 0)
                slider.changed(MiscService.clamp(slider.value - 0.02, 0, 1));

            handle.clicked = true;
            if (wheelTimer.running)
                wheelTimer.restart();
            else
                wheelTimer.start();
        }

        Timer {
            id: wheelTimer
            interval: 200
            onTriggered: handle.clicked = false
        }
    }
}
