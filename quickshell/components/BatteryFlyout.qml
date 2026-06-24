import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: batteryFlyout
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    focusable: true
    visible: false

    mask: Region {
        item: popupRect
    }

    property bool hovering: false

    Rectangle {
        id: popupRect
        width: 300
        height: 200
        color: "#00ff00"
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: batteryFlyout.hovering = true
            onExited: batteryFlyout.hovering = false
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
