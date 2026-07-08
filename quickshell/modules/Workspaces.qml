pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."
import "../components"

Rectangle {
    color: "transparent"
    radius: Design.radius
    implicitWidth: container.implicitWidth + (Design.spacing * 2)
    implicitHeight: Design.componentHeight
    visible: Hyprland.workspaces.values.length != 1 || (Hyprland.focusedWorkspace?.id ?? 1) != 1

    Cutout {}

    RowLayout {
        id: container
        spacing: Design.spacing
        anchors.fill: parent
        anchors.leftMargin: Design.spacing
        anchors.rightMargin: Design.spacing

        Repeater {
            model: HyprlandService.getRelevantWorkspaceIds(Hyprland.workspaces)

            delegate: Rectangle {
                id: circle
                required property int modelData
                property bool isActive: modelData == (Hyprland.focusedWorkspace?.id ?? -1)
                property bool exists: HyprlandService.getWorkspaceExists(Hyprland.workspaces, modelData)

                width: 16
                height: 16
                radius: Infinity
                color: {
                    if (isActive)
                        return Colours.lightblue;
                    if (exists)
                        return Colours.fg3;
                    return "transparent";
                }

                Text {
                    text: parent.modelData
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: Design.fontFamily
                    font.pixelSize: 12
                    color: {
                        if (parent.isActive)
                            return Colours.invfg;
                        if (parent.exists)
                            return Colours.fg1;
                        return Colours.fg2;
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
