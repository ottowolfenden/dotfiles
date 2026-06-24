import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: powerFlyout
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
        width: 400
        height: 500
        color: "#ff0000"
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: powerFlyout.hovering = true
            onExited: powerFlyout.hovering = false
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
