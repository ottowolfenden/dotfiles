import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: root
    required property int rectWidth
    required property int rectHeight

    color: "transparent"
    focusable: true
    visible: false
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    mask: Region {
        item: rectangle
    }

    property bool hovering: false
    Rectangle {
        id: rectangle
        width: root.rectWidth
        height: root.rectHeight
        color: Config.colours.bg
        radius: Config.radius
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hovering = true
            onExited: root.hovering = false
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
