import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Button {
    id: root
    property string iconName
    property int radius: DesignConf.radius

    Layout.fillWidth: true

    contentItem: RowLayout {
        Icon {
            iconName: root.iconName
            visible: root.iconName
            horizontalMargin: 4
            pixelSize: 16
        }
        Text {
            text: root.text
            font.pixelSize: FontsConf.pixelSize
            font.family: FontsConf.mainFamily
            color: ColoursConf.fg1.t
            rightPadding: DesignConf.spacing
            leftPadding: root.iconName ? 0 : DesignConf.spacing
        }
        Item {
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        implicitHeight: root.contentItem.implicitHeight
        radius: root.radius
        border.width: 0
        color: {
            if (root.pressed)
                return ColoursConf.pressedbg.t;
            else if (root.hovered)
                return ColoursConf.hoveredbg.t;
            return ColoursConf.inactivebg.t;
        }

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
            }
        }
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered)
                this.cursorShape = Qt.PointingHandCursor;
        }
    }
}
