import QtQuick
import QtQuick.Controls
import ".."

Button {
    id: button
    property string iconName
    property real radius: Infinity
    property int buttonPixelSize: DesignConf.circleButtonDiameter
    property int iconPixelSize: buttonPixelSize * 0.65
    property bool disabled: false

    contentItem: Icon {
        iconName: button.iconName
        pixelSize: button.iconPixelSize
        colour: button.disabled ? ColoursConf.fg3 : ColoursConf.fg1
    }

    background: Rectangle {
        implicitHeight: button.buttonPixelSize
        implicitWidth: button.buttonPixelSize
        radius: button.radius
        border.width: 0
        color: {
            if (button.disabled)
                return ColoursConf.buttonInactiveBg;
            if (button.pressed)
                return ColoursConf.buttonPressedBg;
            else if (button.hovered)
                return ColoursConf.buttonHoveredBg;
            return ColoursConf.buttonInactiveBg;
        }

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
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
