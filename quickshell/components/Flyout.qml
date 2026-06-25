import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: root

    default property alias content: contentContainer.children
    required property int rectWidth
    required property int rectHeight
    property int parentX
    property int parentWidth
    color: "transparent"
    focusable: true
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    mask: Region {
        item: rectangle
    }

    property bool isReady: false
    property bool isOpen: false
    property bool isFirst: true
    visible: isOpen || rectangle.y > -rectangle.height
    onIsOpenChanged: {
        rectangle.y = isOpen ? Config.spacing : -rectangle.height;
        rectangle.width = isOpen ? root.rectWidth : root.parentWidth;
        isFirst = false;
        Quickshell.execDetached(["hyprctl", "eval", "hl.config({input = { follow_mouse = " + (isOpen ? "0" : "1") + " }})"]);
    }

    property bool hovering: false
    Rectangle {
        id: rectangle
        width: root.parentWidth
        height: root.rectHeight
        color: Config.colours.bg
        radius: Config.radius
        x: Helpers.clamp(root.parentX - width / 2, Config.spacing, root.width - width - Config.spacing)
        y: -height

        Behavior on y {
            SequentialAnimation {
                PauseAnimation {
                    duration: root.isOpen && !root.isFirst ? 40 : 0
                }
                NumberAnimation {
                    duration: 150
                    easing: Easing.OutQuart
                }
            }
        }

        Behavior on width {
            SequentialAnimation {
                PauseAnimation {
                    duration: root.isOpen && !root.isFirst ? 0 : 40
                }
                NumberAnimation {
                    duration: 150
                    easing: Easing.OutQuart
                }
            }
        }

        HoverHandler {
            onHoveredChanged: root.hovering = this.hovered
        }

        Item {
            id: contentContainer
            anchors.fill: parent
            clip: true
        }
    }

    Cutout {
        xPos: rectangle.x - Config.spacing
        yPos: Config.spacing * 2 + Config.barHeight
        parentWidth: rectangle.width + Config.spacing * 2
        parentHeight: rectangle.height + Config.spacing
        visible: root.visible
    }

    Component.onCompleted: {
        QsState.flyouts.push(this);
        isReady = true;
    }
}
