import QtQuick
import QtQuick.Shapes
import Quickshell
import ".."

PanelWindow {
    id: flyout
    default property alias content: contentContainer.children
    property int parentX

    property string pos: rect.x == 0 ? "left" : (rect.x + rect.width == flyout.width ? "right" : "middle")

    color: "transparent"
    focusable: true
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    mask: Region {
        // set item to a static rectangle of the max size if animation too laggy
        item: rect
    }

    property bool isOpen: false
    visible: isOpen || rect.y > -rect.height
    onIsOpenChanged: Qt.callLater(() => Quickshell.execDetached(isOpen ? ["hyprctl", "eval", Config.flyoutOpenHyprlandConfig] : ["hyprctl", "reload"]))

    property bool hovering: false

    Shape {
        id: rect
        width: 200
        height: 200
        x: Helpers.clamp(flyout.parentX - rect.width / 2, 0, flyout.width - rect.width)
        y: flyout.isOpen ? 0 : -height
        layer.enabled: true
        layer.samples: 20

        ShapePath {
            fillColor: Config.colours.green
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
                duration: 2000
                easing: Easing.OutQuart
            }
        }

        HoverHandler {
            onHoveredChanged: flyout.hovering = this.hovered
        }

        Item {
            id: contentContainer
            anchors.fill: parent
            clip: true
        }
    }

    Shape {
        id: middleInvRounding
        layer.enabled: true
        layer.samples: 20

        property int scaledHeight: Math.min(rect.height + rect.y - Config.radius, Config.radius)

        ShapePath {
            fillColor: Config.colours.green
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
            fillColor: Config.colours.green
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
