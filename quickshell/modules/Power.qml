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
        iconName: Icons.power
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

                Button {
                    text: "Shut down"
                    iconName: "power_settings_new"
                    onClicked: {
                        QsState.flyoutsHandler.hideAll();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Shutting down...", "--post-cmd", "systemctl poweroff"]);
                    }
                }
                Button {
                    text: "Restart"
                    iconName: "restart_alt"
                    onClicked: {
                        QsState.flyoutsHandler.hideAll();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Restarting...", "--post-cmd", "systemctl reboot"]);
                    }
                }
                Button {
                    text: "Sleep"
                    iconName: "bedtime"
                    onClicked: {
                        QsState.flyoutsHandler.hideAll();
                        Quickshell.execDetached(["systemctl", "suspend"]);
                    }
                }
                Button {
                    text: "Lock"
                    iconName: "lock"
                    onClicked: {
                        QsState.flyoutsHandler.hideAll();
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
