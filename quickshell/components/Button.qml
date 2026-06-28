import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15 as Controls
import ".."

Controls.Button {
    id: button
    text: "Lorem ipsum"
    property string iconName
    property string colour
    property string radius

    Layout.fillWidth: true

    spacing: 20
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
        radius: Config.radius

        color: {
            if (button.pressed)
                return Config.colours.buttonPressedBg;
            else if (button.hovered)
                return Config.colours.buttonHoveredBg;
            return Config.colours.buttonInactiveBg;
        }

        border.width: 0

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }
}
