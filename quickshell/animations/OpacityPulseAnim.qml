import QtQuick
import ".."

Item {
    id: root
    property bool running: false

    Component.onCompleted: [minOpacityAnim, maxOpacityAnim, resetAnim].forEach(na => {
        na.target = parent;
        na.property = "opacity";
        na.duration = AnimConf.durations.pulse;
    })

    SequentialAnimation {
        loops: Animation.Infinite
        running: root.running

        NumberAnimation {
            id: minOpacityAnim
            to: 0.3
        }
        NumberAnimation {
            id: maxOpacityAnim
            to: 1
        }
    }

    NumberAnimation {
        id: resetAnim
        running: !root.running
        to: 1
    }
}
