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
    opacity: Hyprland.workspaces.values.length != 1 || (Hyprland.focusedWorkspace?.id ?? 1) != 1
    clip: true

    Behavior on opacity {
        NumberAnimation {
            duration: DesignConf.animationDuration
            easing: DesignConf.easing
        }
    }

    Cutout {}

    MouseArea {
        anchors.fill: parent
        onWheel: wheel => HyprlandService.focusWs(Hyprland.focusedWorkspace.id + (wheel.angleDelta.y > 0 ? 1 : -1))
    }

    RowLayout {
        id: container
        spacing: 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: DesignConf.spacing

        Repeater {
            model: UtilsService.getRangeArray(1, HyprlandService.maxWs)
            delegate: Rectangle {
                id: circle
                required property int modelData
                property bool isActive: modelData == (Hyprland.focusedWorkspace?.id ?? -1)
                property bool isEmpty: HyprlandService.getWsIsEmpty(modelData)
                property bool displayed: modelData <= Hyprland.focusedWorkspace?.id || HyprlandService.getLastWsId() >= modelData

                radius: Infinity
                color: {
                    if (mouseArea.containsPress)
                        return ColoursConf.pressedbg.t;
                    if (mouseArea.containsMouse && isEmpty)
                        return ColoursConf.hoveredbg.t;
                    if (mouseArea.containsMouse && !isEmpty)
                        return ColoursConf.bg7.t;
                    if (!isEmpty)
                        return ColoursConf.bg4.t;
                    return "transparent";
                }
                opacity: !isActive
                Layout.preferredWidth: displayed ? DesignConf.wsCircleDiameter : 0
                Layout.preferredHeight: displayed ? DesignConf.wsCircleDiameter : 0
                Layout.rightMargin: displayed ? DesignConf.spacing : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: circle.opacity ? DesignConf.listAnimationDuration : 0
                        easing: DesignConf.easing
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: DesignConf.buttonColourAnimationDuration
                    }
                }
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
                    color: parent.isEmpty ? ColoursConf.fg4.t : ColoursConf.fg1.t
                    opacity: !parent.isActive && parent.displayed
                    Behavior on opacity {
                        NumberAnimation {
                            duration: circle.opacity ? DesignConf.listAnimationDuration : 0
                            easing: DesignConf.easing
                        }
                    }
                }

                MouseArea {
                    id: mouseArea
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
        width: DesignConf.wsCircleDiameter
        height: DesignConf.wsCircleDiameter
        radius: Infinity
        x: DesignConf.spacing + (DesignConf.wsCircleDiameter + DesignConf.spacing) * (Hyprland.focusedWorkspace?.id - 1)
        y: (container.height - height) / 2

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
