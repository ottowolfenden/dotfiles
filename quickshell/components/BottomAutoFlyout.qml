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
        interval: DesignConf.bafMsDelay
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

    Shape {
        id: rect
        width: pane.implicitWidth
        height: pane.implicitHeight
        x: baf.width / 2 - width / 2
        opacity: baf.isOpen || rect.y < baf.height ? 1 : 0
        y: {
            if (baf.height <= 0)
                return Screen.height;
            return baf.isOpen ? (baf.height - height) : baf.height;
        }

        ShapePath {
            fillColor: ColoursConf.bg1
            strokeWidth: 0

            startX: 0
            startY: rect.height

            PathLine {
                x: 0
                y: DesignConf.radius
            }
            PathArc {
                x: DesignConf.radius
                y: 0
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
            }
            PathLine {
                x: rect.width - DesignConf.radius
                y: 0
            }
            PathArc {
                x: rect.width
                y: DesignConf.radius
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
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
                duration: DesignConf.animationDuration
                easing: DesignConf.easing
            }
        }

        HoverHandler {
            onHoveredChanged: baf.hovering = this.hovered
        }

        Pane {
            id: pane
            verticalPadding: DesignConf.spacing
            horizontalPadding: contentContainer.children.every(c => c.toString().includes("Slider")) ? DesignConf.sliderHandleOffset : DesignConf.spacing
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
        property int scaledHeight: Math.max(rect.y + DesignConf.radius, baf.height - DesignConf.radius)
        layer.enabled: true
        layer.samples: 20
        opacity: baf.isOpen || rect.y < baf.height ? 1 : 0

        ShapePath {
            fillColor: ColoursConf.bg1
            strokeWidth: 0

            startX: rect.x
            startY: baf.height

            PathLine {
                x: rect.x - DesignConf.radius
                y: baf.height
            }
            PathArc {
                x: rect.x
                y: middleInvRounding.scaledHeight
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: rect.x
                y: baf.height
            }
        }
        ShapePath {
            fillColor: ColoursConf.bg1
            strokeWidth: 0

            startX: rect.x + rect.width
            startY: baf.height

            PathLine {
                x: rect.x + rect.width + DesignConf.radius
                y: baf.height
            }
            PathArc {
                x: rect.x + rect.width
                y: middleInvRounding.scaledHeight
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
            }
            PathLine {
                x: rect.x + rect.width
                y: baf.height
            }
        }
    }

    Component.onCompleted: FlyoutsService.bafs.push(this)
}
