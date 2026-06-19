pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    Layout.fillHeight: true

    RowLayout {
        id: container
        spacing: Config.spacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing
        property int smallSize: 16

        Repeater {
            model: [1, 2, 3, 4, 5, 6, 7, 8, 9]

            delegate: Rectangle {
                required property var modelData
                property bool isActive: modelData == Hyprland.focusedWorkspace.id
                property bool exists: Helpers.getWorkspaceExists(Hyprland.workspaces, modelData)
                width: container.smallSize
                height: container.smallSize
                radius: Infinity
                color: isActive ? Config.colours.fg1 : (exists ? Config.colours.fg3 : "transparent")

                Text {
                    text: parent.modelData
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: Config.fontFamily
                    font.pixelSize: 12
                    color: parent.isActive ? Config.colours.invfg : Config.colours.fg1
                }
            }
        }
    }
}
