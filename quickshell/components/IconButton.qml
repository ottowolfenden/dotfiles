import QtQuick
import QtQuick.Controls
import ".."

Button {
    id: button
    property string iconName
    property var radius: Infinity
    property int buttonPixelSize: Config.circleButtonDiameter
    property int iconPixelSize: buttonPixelSize * 0.65
    property bool disabled: false

    contentItem: Icon {
        iconName: button.iconName
        pixelSize: button.iconPixelSize
        colour: button.disabled ? Config.colours.fg3 : Config.colours.fg1
    }

    background: Rectangle {
        implicitHeight: button.buttonPixelSize
        implicitWidth: button.buttonPixelSize
        radius: button.radius
        border.width: 0
        color: {
            if (button.disabled)
                return Config.colours.buttonInactiveBg;
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
            if (hovered && !button.disabled)
                this.cursorShape = Qt.PointingHandCursor;
            else
                this.cursorShape = Qt.ArrowCursor;
        }
    }
}
