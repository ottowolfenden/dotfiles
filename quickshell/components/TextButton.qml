import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Button {
    id: button
    text: "Lorem ipsum"
    property string iconName
    property int radius: Config.radius

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
            font.pixelSize: Config.fontSize
            font.family: Config.fontFamily
            color: Config.colours.fg1
            rightPadding: Config.spacing
            leftPadding: button.iconName ? 0 : Config.spacing
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
                return Config.colours.buttonPressedBg;
            else if (button.hovered)
                return Config.colours.buttonHoveredBg;
            return Config.colours.buttonInactiveBg;
        }

        Behavior on color {
            ColorAnimation {
                duration: 100
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
