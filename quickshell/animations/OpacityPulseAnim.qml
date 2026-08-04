import QtQuick
import ".."

Item {
    id: root
    property Item target: root.parent
    property bool running: false

    SequentialAnimation {
        loops: Animation.Infinite
        running: root.running

        NumberAnimation {
            target: root.target
            property: "opacity"
            to: 0.3
            duration: DesignConf.pulseAnimationDuration
        }
        NumberAnimation {
            target: root.target
            property: "opacity"
            to: 1
            duration: DesignConf.pulseAnimationDuration
        }
    }

    PropertyAnimation {
        running: !root.running
        target: root.target
        property: "opacity"
        to: 1
        duration: DesignConf.pulseAnimationDuration
    }
}
