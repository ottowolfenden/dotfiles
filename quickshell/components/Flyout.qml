pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
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
        item: Rectangle {
            width: root.rectWidth
            height: root.rectHeight
            x: Helpers.clamp(root.parentX - width / 2, Config.spacing, root.width - width - Config.spacing)
            y: Config.spacing
        }
    }

    property bool isOpen: false
    property bool isFirst: true
    visible: isOpen || rectangle.y > -rectangle.height
    onIsOpenChanged: {
        rectangle.y = isOpen ? Config.spacing : -rectangle.height;
        rectangle.width = isOpen ? root.rectWidth : root.parentWidth;
        isFirst = false;
        Qt.callLater(() => {
            Quickshell.execDetached(["hyprctl", "eval", "hl.config({input = { follow_mouse = " + (isOpen ? "0" : "1") + " }})"]);
        });
    }

    property bool hovering: false
    Rectangle {
        id: rectangle
        width: root.parentWidth
        height: root.rectHeight
        color: Config.colours.bg2
        radius: Config.radius
        x: Helpers.clamp(root.parentX - width / 2, Config.spacing, root.width - width - Config.spacing)
        y: -height

        Behavior on y {
            SequentialAnimation {
                PauseAnimation {
                    duration: root.isOpen && !root.isFirst ? 100 : 0
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
                    duration: root.isOpen && !root.isFirst ? 0 : 100
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

    Component.onCompleted: QsState.flyouts.push(this)
}
