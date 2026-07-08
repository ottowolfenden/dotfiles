import QtQuick
import QtQuick.Controls
import ".."

Button {
    id: button
    property string iconName
    property real radius: Infinity
    property int buttonPixelSize: Design.circleButtonDiameter
    property int iconPixelSize: buttonPixelSize * 0.65
    property bool disabled: false

    contentItem: Icon {
        iconName: button.iconName
        pixelSize: button.iconPixelSize
        colour: button.disabled ? Colours.fg3 : Colours.fg1
    }

    background: Rectangle {
        implicitHeight: button.buttonPixelSize
        implicitWidth: button.buttonPixelSize
        radius: button.radius
        border.width: 0
        color: {
            if (button.disabled)
                return Colours.buttonInactiveBg;
            if (button.pressed)
                return Colours.buttonPressedBg;
            else if (button.hovered)
                return Colours.buttonHoveredBg;
            return Colours.buttonInactiveBg;
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
