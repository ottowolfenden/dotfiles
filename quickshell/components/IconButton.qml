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
    property bool hovering: false
    property bool isTransparentOnInactive: false

    contentItem: Icon {
        iconName: button.iconName
        pixelSize: button.iconPixelSize
        colour: button.disabled ? ColoursConf.fg4.t : ColoursConf.fg1.t
    }

    background: Rectangle {
        implicitHeight: button.buttonPixelSize
        implicitWidth: button.buttonPixelSize
        radius: button.radius
        border.width: 0
        color: {
            if (button.disabled)
                return button.isTransparentOnInactive ? "transparent" : ColoursConf.inactivebg.t;
            if (button.pressed)
                return ColoursConf.pressedbg.t;
            else if (button.hovered)
                return ColoursConf.hoveredbg.t;
            return button.isTransparentOnInactive ? "transparent" : ColoursConf.inactivebg.t;
        }

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
            }
        }
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered && !button.disabled) {
                this.cursorShape = Qt.PointingHandCursor;
                button.hovering = true;
            } else {
                this.cursorShape = Qt.ArrowCursor;
                button.hovering = false;
            }
        }
    }
}
