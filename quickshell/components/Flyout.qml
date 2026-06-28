import QtQuick
import QtQuick.Shapes
import Quickshell
import ".."

PanelWindow {
    id: root
    default property alias content: contentContainer.children
    property int parentX

    property int rectX: Helpers.clamp(root.parentX - rect.width / 2, 0, root.width - rect.width)
    property string pos: rectX == 0 ? "left" : (rectX + rect.width == root.width ? "right" : "middle")

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
    onIsOpenChanged: {
        // animation.running = true;
        Qt.callLater(() => Quickshell.execDetached(isOpen ? ["hyprctl", "eval", Config.flyoutOpenHyprlandConfig] : ["hyprctl", "reload"]));
    }

    property bool hovering: false

    ParallelAnimation {
        id: animation
        NumberAnimation {
            target: rect
            property: "y"
            duration: 2000
            easing: Easing.InOutQuart

            from: root.isOpen ? -rect.height : 0
            to: root.isOpen ? 0 : -rect.height
        }
    }

    Rectangle {
        id: rect
        width: 200
        height: 300
        color: Config.colours.green
        // radius: Config.radius
        x: root.rectX
        y: -height

        // Behavior on y {
        //     NumberAnimation {
        //         duration: 5000
        //         easing: Easing.InOutQuart
        //     }
        // }

        HoverHandler {
            onHoveredChanged: root.hovering = this.hovered
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

        property int scaledHeight: Config.radius

        ShapePath {
            fillColor: Config.colours.green
            strokeWidth: 0

            startX: root.rectX - Config.radius
            startY: 0

            PathLine {
                x: root.rectX
                y: 0
            }
            PathLine {
                x: root.rectX
                y: middleInvRounding.scaledHeight
            }
            PathArc {
                x: root.rectX - Config.radius
                y: 0
                radiusX: Config.radius
                radiusY: Config.radius
                direction: PathArc.Counterclockwise
            }
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
