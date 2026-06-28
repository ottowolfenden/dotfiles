import QtQuick
import QtQuick.Shapes
import Quickshell
import ".."

PanelWindow {
    id: flyout
    default property alias content: contentContainer.children
    required property int parentX
    required property int rectWidth
    required property int rectHeight

    property string pos: rect.x == 0 ? "left" : (rect.x + rect.width == flyout.width ? "right" : "middle")
    property bool isOpen: false
    property bool hovering: false

    color: "transparent"
    focusable: true
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    mask: Region {
        item: rect
    }
    visible: isOpen || rect.y > -rect.height
    onIsOpenChanged: {
        if (isOpen)
            QsState.flyoutsHandler.hideAllExcept(flyout);
    }

    Shape {
        id: rect
        width: flyout.rectWidth
        height: flyout.rectHeight
        x: Helpers.clamp(flyout.parentX - rect.width / 2, 0, flyout.width - rect.width)
        y: flyout.isOpen ? 0 : -height

        ShapePath {
            fillColor: Config.colours.bg1
            strokeWidth: 0

            startX: 0
            startY: 0

            PathLine {
                x: rect.width
                y: 0
            }
            PathLine {
                x: rect.width
                y: rect.height - Config.radius
            }
            PathArc {
                x: rect.width - Config.radius
                y: rect.height
                radiusX: Config.radius
                radiusY: Config.radius
            }
            PathLine {
                x: Config.radius
                y: rect.height
            }
            PathArc {
                x: 0
                y: rect.height - Config.radius
                radiusX: Config.radius
                radiusY: Config.radius
            }
            PathLine {
                x: 0
                y: 0
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: Config.animationDuration
                easing: Easing.OutQuart
            }
        }

        HoverHandler {
            onHoveredChanged: flyout.hovering = this.hovered
        }

        Item {
            id: contentContainer
            anchors.fill: parent
        }
    }

    Shape {
        id: middleInvRounding
        property int scaledHeight: Math.min(rect.height + rect.y - Config.radius, Config.radius)

        ShapePath {
            fillColor: Config.colours.bg1
            strokeWidth: 0

            startX: rect.x
            startY: 0

            PathLine {
                x: rect.x - Config.radius
                y: 0
            }
            PathArc {
                x: rect.x
                y: middleInvRounding.scaledHeight
                radiusX: Config.radius
                radiusY: Config.radius
            }
            PathLine {
                x: rect.x
                y: 0
            }
        }
        ShapePath {
            fillColor: Config.colours.bg1
            strokeWidth: 0

            startX: rect.x + rect.width
            startY: 0

            PathLine {
                x: rect.x + rect.width + Config.radius
                y: 0
            }
            PathArc {
                x: rect.x + rect.width
                y: middleInvRounding.scaledHeight
                radiusX: Config.radius
                radiusY: Config.radius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: rect.x + rect.width
                y: 0
            }
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
