import QtQuick
import QtQuick.Layouts
import ".."
import "../animations/transitions"
import "../shapes"

Item {
    id: root
    required property real value
    property string iconName
    readonly property int trackWidth: width - handle.Layout.preferredWidth
    readonly property int trackHeight: height - handle.extraHeight
    readonly property bool iconOnActiveTrack: root.trackWidth * (1 - root.value) < activeTrackIcon.width + DesignConf.spacing * 2

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
            property int smallRadius: root.value > 0.02 ? 2 : 0

            Layout.preferredWidth: Math.round(root.trackWidth * root.value)
            Layout.preferredHeight: root.trackHeight
            Layout.alignment: Qt.AlignVCenter

            Trans on Layout.preferredWidth {
                duration: 40
            }

            SliderTrackShape {
                isActiveTrack: true
                value: root.value
            }

            Icon {
                id: activeTrackIcon
                iconName: root.iconName
                colour: ColoursConf.invfg
                visible: root.iconOnActiveTrack
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
            Layout.preferredHeight: root.trackHeight + extraHeight
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                id: handleRect
                property int initialWidth: 4
                property int clickedWidth: 2
                color: ColoursConf.lightblue
                width: handle.clicked ? clickedWidth : initialWidth
                height: handle.height
                radius: Infinity
                anchors.horizontalCenter: handle.horizontalCenter

                Trans on width {
                    duration: 25
                }
            }
        }

        Item {
            id: inactiveTrack
            property int smallRadius: root.value < 0.98 ? 2 : 0

            Layout.preferredHeight: root.trackHeight
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            SliderTrackShape {
                isActiveTrack: false
                value: root.value
            }

            Icon {
                id: inactiveTrackIcon
                iconName: root.iconName
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: DesignConf.spacing
                colour: ColoursConf.fg1.t
                visible: !root.iconOnActiveTrack
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
                root.changed(UtilsService.clamp(mouseX / root.width, 0, 1));
        }
        onPressed: listening = handle.clicked = true
        onReleased: listening = handle.clicked = false

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                root.changed(UtilsService.clamp(root.value + 0.02, 0, 1));
            else if (wheel.angleDelta.y < 0)
                root.changed(UtilsService.clamp(root.value - 0.02, 0, 1));

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
