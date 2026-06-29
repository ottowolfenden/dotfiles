import QtQuick
import QtQuick.Controls
import ".."

Button {
    id: button
    property string iconName
    property var radius: Infinity
    property int buttonPixelSize: Config.circleButtonDiameter
    property int iconPixelSize: buttonPixelSize * 0.7

    contentItem: Icon {
        iconName: button.iconName
        pixelSize: button.iconPixelSize
    }

    background: Rectangle {
        implicitHeight: button.buttonPixelSize
        implicitWidth: button.buttonPixelSize
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
