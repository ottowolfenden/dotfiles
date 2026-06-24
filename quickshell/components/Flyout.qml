import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: root
    default property alias content: contentContainer.children
    required property int rectWidth
    required property int rectHeight
    property int parentX

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
        y: Config.spacing
        x: Helpers.clamp(root.parentX - width / 2, Config.spacing, root.width - width - Config.spacing)

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hovering = true
            onExited: root.hovering = false
        }

        Item {
            id: contentContainer
            anchors.fill: parent
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
