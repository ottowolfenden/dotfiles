import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

Button {
    id: button
    text: "Lorem ipsum"
    property string iconName
    property int radius: Design.radius

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
            font.pixelSize: Design.fontSize
            font.family: Design.fontFamily
            color: Colours.fg1
            rightPadding: Design.spacing
            leftPadding: button.iconName ? 0 : Design.spacing
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
            if (hovered)
                this.cursorShape = Qt.PointingHandCursor;
        }
    }
}
