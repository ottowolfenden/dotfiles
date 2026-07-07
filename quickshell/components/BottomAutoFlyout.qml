import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import ".."

PanelWindow {
    id: baf
    default property alias content: contentContainer.children
    required property string type
    property bool hovering: false
    property bool isOpen: false
    property Timer autoHideTimer: Timer {
        interval: Config.bafMsDelay
        repeat: false
        onTriggered: QsState.hideBaf(baf)
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
    onHoveringChanged: {
        if (!hovering)
            QsState.hideBaf(this);
    }

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
            fillColor: Config.colours.bg1
            strokeWidth: 0

            startX: 0
            startY: rect.height

            PathLine {
                x: 0
                y: Config.radius
            }
            PathArc {
                x: Config.radius
                y: 0
                radiusX: Config.radius
                radiusY: Config.radius
            }
            PathLine {
                x: rect.width - Config.radius
                y: 0
            }
            PathArc {
                x: rect.width
                y: Config.radius
                radiusX: Config.radius
                radiusY: Config.radius
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
                duration: Config.animationDuration
                easing: Config.easing
            }
        }

        HoverHandler {
            onHoveredChanged: baf.hovering = this.hovered
        }

        Pane {
            id: pane
            padding: Config.spacing
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
        property int scaledHeight: Math.max(rect.y + Config.radius, baf.height - Config.radius)
        layer.enabled: true
        layer.samples: 20

        ShapePath {
            fillColor: Config.colours.bg1
            strokeWidth: 0

            startX: rect.x
            startY: baf.height

            PathLine {
                x: rect.x - Config.radius
                y: baf.height
            }
            PathArc {
                x: rect.x
                y: middleInvRounding.scaledHeight
                radiusX: Config.radius
                radiusY: Config.radius
                direction: PathArc.Counterclockwise
            }
            PathLine {
                x: rect.x
                y: baf.height
            }
        }
        ShapePath {
            fillColor: Config.colours.bg1
            strokeWidth: 0

            startX: rect.x + rect.width
            startY: baf.height

            PathLine {
                x: rect.x + rect.width + Config.radius
                y: baf.height
            }
            PathArc {
                x: rect.x + rect.width
                y: middleInvRounding.scaledHeight
                radiusX: Config.radius
                radiusY: Config.radius
            }
            PathLine {
                x: rect.x + rect.width
                y: baf.height
            }
        }
    }

    Component.onCompleted: QsState.bafs.push(this)
}
