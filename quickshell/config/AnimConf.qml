pragma Singleton
import QtQuick

QtObject {
    readonly property var durations: ({
            default: 200,
            short: 150,
            buttonState: 100,
            pulse: 350,
            maxLoadingBar: 3000
        })
    readonly property int easing: Easing.OutCubic

    readonly property int durationScale: 1
    Component.onCompleted: Object.keys(durations).forEach(k => durations[k] = durations[k] * durationScale)
}
