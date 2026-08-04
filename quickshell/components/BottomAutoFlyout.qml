import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import ".."
import "../shapes"

PanelWindow {
    id: root
    default property alias content: contentContainer.children
    required property string type
    property bool hovering: hoverHandler.hovered
    property bool isOpen: false
    property Timer autoHideTimer: Timer {
        interval: DesignConf.bafMsDelay
        repeat: false
        onTriggered: FlyoutsService.hideBaf(root)
    }

    color: "transparent"
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    WlrLayershell.layer: WlrLayer.Overlay
    mask: Region {
        item: bafContainer
    }

    BafContainerShape {
        id: bafContainer
        width: pane.implicitWidth
        height: pane.implicitHeight
        isOpen: root.isOpen

        HoverHandler {
            id: hoverHandler
        }

        Pane {
            id: pane
            verticalPadding: DesignConf.spacing
            horizontalPadding: {
                let isSlider = contentContainer.children.every(c => c.toString().includes("Slider"));
                return isSlider ? DesignConf.sliderHandleOffset : DesignConf.spacing;
            }
            background: null
            anchors.fill: parent

            ColumnLayout {
                id: contentContainer
                anchors.fill: parent
            }
        }
    }

    BafInvRoundingShape {
        bafContainer: bafContainer
        isOpen: root.isOpen
    }

    Component.onCompleted: FlyoutsService.bafs.push(this)
}
