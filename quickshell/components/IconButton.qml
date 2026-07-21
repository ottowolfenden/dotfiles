import QtQuick
import QtQuick.Controls
import ".."

Button {
    id: root
    property string iconName
    property real radius: Infinity
    property int buttonPixelSize: DesignConf.circleButtonDiameter
    property int iconPixelSize: buttonPixelSize * 0.65
    property bool disabled: false
    property bool hovering: false
    property bool isTransparentOnInactive: false

    contentItem: Icon {
        iconName: root.iconName
        pixelSize: root.iconPixelSize
        colour: root.disabled ? ColoursConf.fg4.t : ColoursConf.fg1.t
    }

    background: Rectangle {
        implicitHeight: root.buttonPixelSize
        implicitWidth: root.buttonPixelSize
        radius: root.radius
        border.width: 0
        color: {
            if (root.disabled)
                return root.isTransparentOnInactive ? "transparent" : ColoursConf.inactivebg.t;
            if (root.pressed)
                return ColoursConf.pressedbg.t;
            else if (root.hovered)
                return ColoursConf.hoveredbg.t;
            return root.isTransparentOnInactive ? "transparent" : ColoursConf.inactivebg.t;
        }

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
            }
        }
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered && !root.disabled) {
                this.cursorShape = Qt.PointingHandCursor;
                root.hovering = true;
            } else {
                this.cursorShape = Qt.ArrowCursor;
                root.hovering = false;
            }
        }
    }
}
