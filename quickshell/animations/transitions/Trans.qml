import QtQuick
import "../.."

Behavior {
    id: root
    required property int duration

    NumberAnimation {
        duration: root.duration
        easing: AnimConf.easing
    }
}
