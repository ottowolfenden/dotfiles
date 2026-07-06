pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."
import "../components"

Rectangle {
    color: "transparent"
    radius: Config.radius
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    implicitHeight: Config.componentHeight
    visible: Hyprland.workspaces.values.length != 1 || (Hyprland.focusedWorkspace?.id ?? 1) != 1

    Cutout {}

    RowLayout {
        id: container
        spacing: Config.spacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Repeater {
            model: Helpers.getRelevantWorkspaceIds(Hyprland.workspaces)

            delegate: Rectangle {
                id: circle
                required property int modelData
                property bool isActive: modelData == (Hyprland.focusedWorkspace?.id ?? -1)
                property bool exists: Helpers.getWorkspaceExists(Hyprland.workspaces, modelData)

                width: 16
                height: 16
                radius: Infinity
                color: {
                    if (isActive)
                        return Config.colours.lightblue;
                    if (exists)
                        return Config.colours.fg3;
                    return "transparent";
                }

                Text {
                    text: parent.modelData
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: Config.fontFamily
                    font.pixelSize: 12
                    color: {
                        if (parent.isActive)
                            return Config.colours.invfg;
                        if (parent.exists)
                            return Config.colours.fg1;
                        return Config.colours.fg2;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${parent.modelData} })`)
                }
            }
        }
    }
}
