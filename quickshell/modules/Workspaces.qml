pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."
import "../components"

Rectangle {
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: container.implicitWidth + DesignConf.spacing
    implicitHeight: DesignConf.componentHeight
    visible: Hyprland.workspaces.values.length != 1 || (Hyprland.focusedWorkspace?.id ?? 1) != 1
    clip: true

    Cutout {}

    RowLayout {
        id: container
        spacing: 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: DesignConf.spacing

        Repeater {
            model: [...Array(9)].map((_, i) => i + 1)
            delegate: Rectangle {
                id: circle
                required property int modelData
                property bool isActive: modelData == (Hyprland.focusedWorkspace?.id ?? -1)
                property bool isEmpty: HyprlandService.getWsIsEmpty(modelData)
                property bool displayed: modelData <= Hyprland.focusedWorkspace?.id || HyprlandService.getMaxWsId() >= modelData

                radius: Infinity
                color: {
                    if (!isEmpty)
                        return ColoursConf.bg5.t;
                    return "transparent";
                }
                opacity: !isActive
                Behavior on opacity {
                    NumberAnimation {
                        duration: circle.opacity ? DesignConf.listAnimationDuration : 0
                        easing: DesignConf.easing
                    }
                }

                Layout.preferredWidth: displayed ? 16 : 0
                Layout.preferredHeight: displayed ? 16 : 0
                Layout.rightMargin: displayed ? DesignConf.spacing : 0

                Behavior on Layout.preferredWidth {
                    NumberAnimation {
                        duration: DesignConf.listAnimationDuration
                        easing: DesignConf.easing
                    }
                }
                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: DesignConf.listAnimationDuration
                        easing: DesignConf.easing
                    }
                }
                Behavior on Layout.rightMargin {
                    NumberAnimation {
                        duration: DesignConf.listAnimationDuration
                        easing: DesignConf.easing
                    }
                }

                Text {
                    text: parent.modelData
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: FontsConf.mainFamily
                    font.pixelSize: 12
                    color: {
                        if (!parent.isEmpty)
                            return ColoursConf.fg1.t;
                        return ColoursConf.fg4.t;
                    }
                    opacity: !parent.isActive && parent.displayed
                    scale: parent.displayed
                    Behavior on opacity {
                        NumberAnimation {
                            duration: circle.opacity ? DesignConf.listAnimationDuration : 0
                            easing: DesignConf.easing
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: DesignConf.listAnimationDuration
                            easing: DesignConf.easing
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    hoverEnabled: true
                    cursorShape: parent.isActive ? Qt.ArrowCursor : Qt.PointingHandCursor
                    onClicked: HyprlandService.focusWs(parent.modelData)
                }
            }
        }
    }

    Rectangle {
        color: ColoursConf.lightblue
        width: 16
        height: 16
        radius: Infinity
        x: DesignConf.spacing + (16 + DesignConf.spacing) * (Hyprland.focusedWorkspace?.id - 1)
        y: DesignConf.spacing - 1

        Behavior on x {
            NumberAnimation {
                duration: DesignConf.listAnimationDuration
                easing: DesignConf.easing
            }
        }

        Text {
            text: Hyprland.focusedWorkspace?.id ?? 1
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: FontsConf.mainFamily
            font.pixelSize: 12
            color: ColoursConf.invfg
        }
    }
}
