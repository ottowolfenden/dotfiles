import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import ".."

PanelWindow {
    id: baf
    default property alias content: contentContainer.children
    required property string type
    property bool hovering: false
    property bool isOpen: false
    property Timer autoHideTimer: Timer {
        interval: Design.bafMsDelay
        repeat: false
        onTriggered: FlyoutsService.hideBaf(baf)
    }

    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    mask: Region {
        item: rect
    }
    WlrLayershell.namespace: "quickshell-baf"
    WlrLayershell.layer: WlrLayer.Overlay
    visible: isOpen || rect.y < height

    Shape {
        id: rect
        width: pane.implicitWidth
        height: pane.implicitHeight
        x: baf.width / 2 - width / 2
        y: {
            if (baf.height <= 0)
                return Screen.height;
            return baf.isOpen ? (baf.height - height) : baf.height;
        }

        ShapePath {
            fillColor: Colours.bg1
            strokeWidth: 0

            startX: 0
            startY: rect.height

            PathLine {
                x: 0
                y: Design.radius
            }
            PathArc {
                x: Design.radius
                y: 0
                radiusX: Design.radius
                radiusY: Design.radius
            }
            PathLine {
                x: rect.width - Design.radius
                y: 0
            }
            PathArc {
                x: rect.width
                y: Design.radius
                radiusX: Design.radius
                radiusY: Design.radius
            }
            PathLine {
                x: rect.width
                y: rect.height
            }
            PathLine {
                x: 0
                y: rect.height
            }
        }

        Behavior on y {
            enabled: baf.height > 0
            NumberAnimation {
                duration: Design.animationDuration
                easing: Design.easing
            }
        }

        HoverHandler {
            onHoveredChanged: baf.hovering = this.hovered
        }

        Pane {
            id: pane
            verticalPadding: Design.spacing
            horizontalPadding: contentContainer.children.every(c => c.toString().includes("Slider")) ? Design.sliderHandleOffset : Design.spacing
            background: null
            anchors.fill: parent

            ColumnLayout {
                id: contentContainer
                anchors.fill: parent
            }
        }
    }

    Shape {
        id: middleInvRounding
        property int scaledHeight: Math.max(rect.y + Design.radius, baf.height - Design.radius)
        layer.enabled: true
        layer.samples: 20

        ShapePath {
            fillColor: Colours.bg1
            strokeWidth: 0

            startX: rect.x
            startY: baf.height

            PathLine {
                x: rect.x - Design.radius
                y: baf.height
            }
            PathArc {
                x: rect.x
                y: middleInvRounding.scaledHeight
                radiusX: Design.radius
                radiusY: Design.radius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: rect.x
                y: baf.height
            }
        }
        ShapePath {
            fillColor: Colours.bg1
            strokeWidth: 0

            startX: rect.x + rect.width
            startY: baf.height

            PathLine {
                x: rect.x + rect.width + Design.radius
                y: baf.height
            }
            PathArc {
                x: rect.x + rect.width
                y: middleInvRounding.scaledHeight
                radiusX: Design.radius
                radiusY: Design.radius
            }
            PathLine {
                x: rect.x + rect.width
                y: baf.height
            }
        }
    }

    Component.onCompleted: FlyoutsService.bafs.push(this)
}
