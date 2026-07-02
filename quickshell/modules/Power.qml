import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import ".."
import "../components"

Rectangle {
    id: power
    color: "transparent"
    radius: Config.radius
    implicitWidth: Config.componentHeight
    implicitHeight: Config.componentHeight

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
            padding: Config.spacing
            background: null

            ColumnLayout {
                spacing: Config.spacing

                TextButton {
                    text: "Shut down"
                    iconName: Icons.power.shutDown
                    onClicked: {
                        QsState.hideAllFlyouts();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Shutting down...", "--post-cmd", "systemctl poweroff"]);
                    }
                }
                TextButton {
                    text: "Restart"
                    iconName: Icons.power.restart
                    onClicked: {
                        QsState.hideAllFlyouts();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Restarting...", "--post-cmd", "systemctl reboot"]);
                    }
                }
                TextButton {
                    text: "Sleep"
                    iconName: Icons.power.sleep
                    onClicked: {
                        QsState.hideAllFlyouts();
                        Quickshell.execDetached(["systemctl", "suspend"]);
                    }
                }
                TextButton {
                    text: "Lock"
                    iconName: Icons.power.lock
                    onClicked: {
                        QsState.hideAllFlyouts();
                        lockTimer.start();
                    }
                    Timer {
                        id: lockTimer
                        interval: Config.animationDuration
                        repeat: false
                        onTriggered: Quickshell.execDetached(["hyprlock"])
                    }
                }
            }
        }
    }
}
