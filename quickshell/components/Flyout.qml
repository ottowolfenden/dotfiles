import QtQuick
import Quickshell
import Quickshell.Wayland
import ".."
import "../shapes"

PanelWindow {
    id: root
    default property alias content: contentContainer.children
    required property int parentX
    required property int rectWidth
    required property int rectHeight
    signal opened

    property string pos: {
        if (flyoutContainer.x == 0)
            return "left";
        else
            return (flyoutContainer.x + flyoutContainer.width) == root.width ? "right" : "middle";
    }
    property bool isOpen: false
    property bool hovering: hoverHandler.hovered

    WlrLayershell.namespace: "qs-flyout"

    color: "transparent"
    focusable: true
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    visible: isOpen || flyoutContainer.y > -flyoutContainer.height
    mask: Region {
        item: flyoutContainer
    }
    onIsOpenChanged: {
        if (isOpen) {
            FlyoutsService.hideAllFlyoutsExcept(root);
            opened();
        }
    }

    FlyoutContainerShape {
        id: flyoutContainer
        width: root.rectWidth
        height: root.rectHeight
        isOpen: root.isOpen
        parentX: root.parentX

        HoverHandler {
            id: hoverHandler
        }

        Item {
            id: contentContainer
            anchors.fill: parent
        }
    }

    FlyoutInvRoundingShape {
        flyoutContainer: flyoutContainer
    }

    Component.onCompleted: FlyoutsService.flyouts.push(this)
}
