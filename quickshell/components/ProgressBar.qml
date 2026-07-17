import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: progressBar
    property bool indeterminate: false
    property real value
    property bool loading: false
    property string bgColour: ColoursConf.green
    property string fgColour: ColoursConf.lightblue

    visible: loading
    Layout.preferredHeight: DesignConf.progressBarHeight
    Layout.preferredWidth: DesignConf.searchFlyoutWidth - DesignConf.spacing * 2

    Rectangle {
        id: leftTrack
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: activeTrack.left
        anchors.rightMargin: DesignConf.spacing / 2
        color: progressBar.bgColour
        radius: DesignConf.smallRadius
    }
    Rectangle {
        id: activeTrack
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: progressBar.fgColour
        radius: DesignConf.smallRadius
    }
    Rectangle {
        id: rightTrack
        anchors.top: parent.top
        anchors.left: activeTrack.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.leftMargin: DesignConf.spacing / 2
        color: progressBar.bgColour
        radius: DesignConf.smallRadius
    }

    ParallelAnimation {
        id: i
        loops: Animation.Infinite
        running: progressBar.loading

        property int trackWidth: 100
        property int duration: 2000
        property real distance: progressBar.width + trackWidth

        property int entryDuration: Math.max(0, (trackWidth / distance) * duration)
        property int midDuration: Math.max(0, ((progressBar.width - trackWidth) / distance) * duration)
        property int exitDuration: Math.max(0, (trackWidth / distance) * duration)

        Component.onCompleted: animations.forEach(seq => seq.animations.forEach(num => num.target = activeTrack))

        SequentialAnimation {
            Component.onCompleted: animations.forEach(num => num.property = "x")
            NumberAnimation {
                to: 0
                duration: 0
            }
            NumberAnimation {
                duration: i.entryDuration
            }
            NumberAnimation {
                to: progressBar.width - i.trackWidth
                duration: i.midDuration
            }
            NumberAnimation {
                to: progressBar.width
                duration: i.exitDuration
            }
        }

        SequentialAnimation {
            Component.onCompleted: animations.forEach(num => num.property = "width")
            NumberAnimation {
                to: 0
                duration: 0
            }
            NumberAnimation {
                to: i.trackWidth
                duration: i.entryDuration
            }

            NumberAnimation {
                duration: i.midDuration / 3
                to: i.trackWidth
            }
            NumberAnimation {
                duration: i.midDuration / 3
                to: i.trackWidth
            }
            NumberAnimation {
                duration: i.midDuration / 3
                to: i.trackWidth
            }

            NumberAnimation {
                to: 0
                duration: i.exitDuration
            }
        }
    }
}
