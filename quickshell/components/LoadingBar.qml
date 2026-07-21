import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    property string bgColour: ColoursConf.bg4.t
    property string fgColour: ColoursConf.lightblue

    Layout.preferredHeight: DesignConf.progressBarHeight
    Layout.fillWidth: true

    Rectangle {
        id: leftTrack
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: activeTrack.left
        anchors.rightMargin: DesignConf.spacing
        color: root.bgColour
        radius: Infinity
    }
    Rectangle {
        id: activeTrack
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: root.fgColour
        radius: Infinity
    }
    Rectangle {
        id: rightTrack
        anchors.top: parent.top
        anchors.left: activeTrack.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.leftMargin: DesignConf.spacing
        color: root.bgColour
        radius: Infinity
    }

    ParallelAnimation {
        id: anim

        property int trackWidth
        property int duration
        property int distance: root.width + trackWidth
        property int entryDuration: (trackWidth / distance) * duration
        property int midDuration: ((root.width - trackWidth) / distance) * duration
        property int exitDuration: (trackWidth / distance) * duration

        function setRandValues() {
            let r = UtilsService.getRandBetween(0.2, 1);
            trackWidth = r * root.width * 0.7;
            duration = r * DesignConf.indefProgressBarMaxDuration;
        }

        running: root.visible
        onStarted: setRandValues()
        onFinished: {
            if (root.visible) {
                setRandValues();
                Qt.callLater(anim.start);
            }
        }

        Component.onCompleted: animations.forEach(seq => seq.animations.forEach(num => num.target = activeTrack))

        SequentialAnimation {
            Component.onCompleted: animations.forEach(a => a.property = "x")
            NumberAnimation {
                duration: anim.entryDuration
                from: 0
                to: 0
            }
            NumberAnimation {
                to: root.width - anim.trackWidth
                duration: anim.midDuration
            }
            NumberAnimation {
                to: root.width
                duration: anim.exitDuration
            }
        }

        SequentialAnimation {
            Component.onCompleted: animations.forEach(a => a.property = "width")
            NumberAnimation {
                from: 0
                to: anim.trackWidth
                duration: anim.entryDuration
            }
            NumberAnimation {
                duration: anim.midDuration
                to: anim.trackWidth
            }
            NumberAnimation {
                to: 0
                duration: anim.exitDuration
            }
        }
    }
}
