import QtQuick
import QtQuick.Shapes
import Quickshell
import ".."

PanelWindow {
    id: root
    default property alias content: contentContainer.children
    required property int parentX
    required property int rectWidth
    required property int rectHeight
    signal opened

    property string pos: rect.x == 0 ? "left" : (rect.x + rect.width == root.width ? "right" : "middle")
    property bool isOpen: false
    property bool hovering: false

    color: "transparent"
    focusable: true
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    visible: isOpen || rect.y > -rect.height
    mask: Region {
        item: rect
    }
    onIsOpenChanged: {
        if (isOpen) {
            FlyoutsService.hideAllFlyoutsExcept(root);
            opened();
        }
    }

    Shape {
        id: rect
        width: root.rectWidth
        height: root.rectHeight
        x: UtilsService.clamp(root.parentX - rect.width / 2, 0, root.width - rect.width)
        y: root.isOpen ? 0 : -height
        clip: true

        ShapePath {
            fillColor: ColoursConf.bg1
            strokeWidth: 0

            startX: 0
            startY: 0

            PathLine {
                x: rect.width
                y: 0
            }
            PathLine {
                x: rect.width
                y: rect.height - DesignConf.radius
            }
            PathArc {
                x: rect.width - DesignConf.radius
                y: rect.height
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
            }
            PathLine {
                x: DesignConf.radius
                y: rect.height
            }
            PathArc {
                x: 0
                y: rect.height - DesignConf.radius
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
            }
            PathLine {
                x: 0
                y: 0
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: DesignConf.animationDuration
                easing: DesignConf.easing
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: DesignConf.animationDuration
                easing: DesignConf.easing
            }
        }

        HoverHandler {
            onHoveredChanged: root.hovering = this.hovered
        }

        Item {
            id: contentContainer
            anchors.fill: parent
        }
    }

    Shape {
        id: middleInvRounding
        property int scaledHeight: Math.min(rect.height + rect.y - DesignConf.radius, DesignConf.radius)

        ShapePath {
            fillColor: ColoursConf.bg1
            strokeWidth: 0

            startX: rect.x
            startY: 0

            PathLine {
                x: rect.x - DesignConf.radius
                y: 0
            }
            PathArc {
                x: rect.x
                y: middleInvRounding.scaledHeight
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
            }
            PathLine {
                x: rect.x
                y: 0
            }
        }
        ShapePath {
            fillColor: ColoursConf.bg1
            strokeWidth: 0

            startX: rect.x + rect.width
            startY: 0

            PathLine {
                x: rect.x + rect.width + DesignConf.radius
                y: 0
            }
            PathArc {
                x: rect.x + rect.width
                y: middleInvRounding.scaledHeight
                radiusX: DesignConf.radius
                radiusY: DesignConf.radius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: rect.x + rect.width
                y: 0
            }
        }
    }

    Component.onCompleted: FlyoutsService.flyouts.push(this)
}
