import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Button {
    id: button
    text: "Lorem ipsum"
    property string iconName
    property int radius: DesignConf.radius

    Layout.fillWidth: true

    contentItem: RowLayout {
        Icon {
            iconName: button.iconName
            visible: button.iconName
            horizontalMargin: 4
            pixelSize: 16
        }
        Text {
            text: button.text
            font.pixelSize: FontsConf.pixelSize
            font.family: FontsConf.mainFamily
            color: ColoursConf.fg1.t
            rightPadding: DesignConf.spacing
            leftPadding: button.iconName ? 0 : DesignConf.spacing
        }
        Item {
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        implicitHeight: button.contentItem.implicitHeight
        radius: button.radius
        border.width: 0
        color: {
            if (button.pressed)
                return ColoursConf.pressedbg.t;
            else if (button.hovered)
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
