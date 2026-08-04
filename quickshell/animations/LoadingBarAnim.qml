import QtQuick
import ".."

ParallelAnimation {
    id: root

    required property int width
    required property bool isPlaying
    required property Rectangle activeTrack

    property int trackWidth
    property int duration
    property int distance: width + trackWidth
    property int entryDuration: (trackWidth / distance) * duration
    property int midDuration: ((width - trackWidth) / distance) * duration
    property int exitDuration: (trackWidth / distance) * duration

    function setRandValues() {
        let r = UtilsService.getRandBetween(0.2, 1);
        trackWidth = r * width * 0.7;
        duration = r * AnimConf.durations.maxLoadingBar;
    }

    running: isPlaying
    onStarted: setRandValues()
    onFinished: {
        if (isPlaying) {
            setRandValues();
            Qt.callLater(root.start);
        }
    }

    Component.onCompleted: animations.forEach(seq => seq.animations.forEach(num => num.target = activeTrack))

    SequentialAnimation {
        Component.onCompleted: animations.forEach(a => a.property = "x")
        NumberAnimation {
            duration: root.entryDuration
            from: 0
            to: 0
        }
        NumberAnimation {
            to: root.width - root.trackWidth
            duration: root.midDuration
        }
        NumberAnimation {
            to: root.width
            duration: root.exitDuration
        }
    }

    SequentialAnimation {
        Component.onCompleted: animations.forEach(a => a.property = "width")
        NumberAnimation {
            from: 0
            to: root.trackWidth
            duration: root.entryDuration
        }
        NumberAnimation {
            duration: root.midDuration
            to: root.trackWidth
        }
        NumberAnimation {
            to: 0
            duration: root.exitDuration
        }
    }
}
