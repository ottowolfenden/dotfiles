import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import ".."

PanelWindow {
    id: overlayPopup
    default property alias content: contentContainer.children
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

    Rectangle {
        id: rect
        width: pane.implicitWidth
        height: pane.implicitHeight
        x: overlayPopup.width / 2 - width / 2
        y: overlayPopup.height - height - Config.barHeight
        radius: Config.radius
        color: "transparent"
        // color: Config.colours.bg1
        Cutout {
            wallpaperWidth: Screen.width
            wallpaperHeight: Screen.height - Config.barHeight * 2
            colour: Config.colours.cutoutBg
        }

        HoverHandler {
            onHoveredChanged: overlayPopup.hovering = this.hovered
        }

        Pane {
            id: pane
            padding: Config.spacing
            leftPadding: 7 + Config.spacing
            rightPadding: Config.spacing + 3
            background: null
            anchors.fill: parent

            ColumnLayout {
                id: contentContainer
                anchors.fill: parent
            }
        }
    }
}
