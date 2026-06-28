import QtQuick
import QtQuick.Shapes
import Quickshell
import ".."

PanelWindow {
    id: flyout
    default property alias content: contentContainer.children
    property int parentX

    property int rectX: Helpers.clamp(flyout.parentX - rect.width / 2, 0, flyout.width - rect.width)
    property string pos: rectX == 0 ? "left" : (rectX + rect.width == flyout.width ? "right" : "middle")

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
    property int runs: 0
    visible: isOpen || rect.y > -rect.height
    onIsOpenChanged: {
        runs += 1;
        Qt.callLater(() => Quickshell.execDetached(isOpen ? ["hyprctl", "eval", Config.flyoutOpenHyprlandConfig] : ["hyprctl", "reload"]));
    }

    property bool hovering: false

    Rectangle {
        id: rect
        width: 200
        height: 100
        color: Config.colours.green
        // radius: Config.radius
        x: flyout.rectX
        y: flyout.isOpen ? 0 : -height

        Behavior on y {
            NumberAnimation {
                duration: 2500
                easing: Easing.InOutQuart
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

        property int scaledHeight: Math.min(rect.height + rect.y, Config.radius)

        ShapePath {
            fillColor: Config.colours.green
            strokeWidth: 0

            startX: flyout.rectX
            startY: 0

            PathLine {
                x: flyout.rectX - Config.radius
                y: 0
            }
            PathArc {
                x: flyout.rectX
                y: middleInvRounding.scaledHeight
                radiusX: Config.radius
                radiusY: Config.radius
            }
            PathLine {
                x: flyout.rectX
                y: 0
            }
        }
        ShapePath {
            fillColor: Config.colours.green
            strokeWidth: 0

            startX: flyout.rectX + rect.width
            startY: 0

            PathLine {
                x: flyout.rectX + rect.width + Config.radius
                y: 0
            }
            PathArc {
                x: flyout.rectX + rect.width
                y: middleInvRounding.scaledHeight
                radiusX: Config.radius
                radiusY: Config.radius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: flyout.rectX + rect.width
                y: 0
            }
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
