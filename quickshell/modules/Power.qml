import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import ".."
import "../components"

Rectangle {
    id: power
    color: "transparent"
    radius: Design.radius
    implicitWidth: Design.componentHeight
    implicitHeight: Design.componentHeight

    Cutout {}

    Icon {
        id: icon
        pixelSize: 17
        anchors.centerIn: parent
        iconName: Icons.power.onOff
        verticalMargin: -2
    }

    FlyoutMouseArea {
        flyout: powerFlyout
    }

    Flyout {
        id: powerFlyout
        parentX: power.x
        rectWidth: pane.width
        rectHeight: pane.height

        Pane {
            id: pane
            padding: Design.spacing
            background: null

            ColumnLayout {
                spacing: Design.spacing

                TextButton {
                    text: "Shut down"
                    iconName: Icons.power.shutDown
                    onClicked: {
                        FlyoutsService.hideAllFlyouts();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Shutting down...", "--post-cmd", "systemctl poweroff"]);
                    }
                }
                TextButton {
                    text: "Restart"
                    iconName: Icons.power.restart
                    onClicked: {
                        FlyoutsService.hideAllFlyouts();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Restarting...", "--post-cmd", "systemctl reboot"]);
                    }
                }
                TextButton {
                    text: "Sleep"
                    iconName: Icons.power.sleep
                    onClicked: {
                        FlyoutsService.hideAllFlyouts();
                        Quickshell.execDetached(["systemctl", "suspend"]);
                    }
                }
                TextButton {
                    text: "Lock"
                    iconName: Icons.power.lock
                    onClicked: {
                        FlyoutsService.hideAllFlyouts();
                        lockTimer.start();
                    }
                    Timer {
                        id: lockTimer
                        interval: Design.animationDuration
                        repeat: false
                        onTriggered: Quickshell.execDetached(["hyprlock"])
                    }
                }
            }
        }
    }
}
