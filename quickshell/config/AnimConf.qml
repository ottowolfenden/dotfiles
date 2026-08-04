pragma Singleton
import QtQuick

QtObject {
    readonly property var durations: ({
            default: 200,
            buttonState: 100,
            short: 150,
            pulse: 350,
            indefProgress: 3000
        })
    readonly property int easing: Easing.OutCubic

    readonly property int durationScale: 1
    Component.onCompleted: Object.keys(durations).forEach(k => durations[k] = durations[k] * durationScale)
}
