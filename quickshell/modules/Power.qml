import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import ".."
import "../components"

Rectangle {
    id: power
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: DesignConf.componentHeight
    implicitHeight: DesignConf.componentHeight

    Cutout {}

    Icon {
        id: icon
        pixelSize: 17
        anchors.centerIn: parent
        iconName: IconsConf.power.onOff
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
            padding: DesignConf.spacing
            background: null

            ColumnLayout {
                spacing: DesignConf.spacing

                TextButton {
                    text: "Shut down"
                    iconName: IconsConf.power.shutDown
                    onClicked: {
                        FlyoutsService.flyoutsHandler.hideAllFlyouts();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Shutting down...", "--post-cmd", "systemctl poweroff"]);
                    }
                }
                TextButton {
                    text: "Restart"
                    iconName: IconsConf.power.restart
                    onClicked: {
                        FlyoutsService.flyoutsHandler.hideAllFlyouts();
                        Quickshell.execDetached(["hyprshutdown", "-t", "Restarting...", "--post-cmd", "systemctl reboot"]);
                    }
                }
                TextButton {
                    text: "Sleep"
                    iconName: IconsConf.power.sleep
                    onClicked: {
                        FlyoutsService.flyoutsHandler.hideAllFlyouts();
                        Quickshell.execDetached(["systemctl", "suspend"]);
                    }
                }
                TextButton {
                    text: "Lock"
                    iconName: IconsConf.power.lock
                    onClicked: {
                        FlyoutsService.flyoutsHandler.hideAllFlyouts();
                        lockTimer.start();
                    }
                    Timer {
                        id: lockTimer
                        interval: DesignConf.animationDuration
                        repeat: false
                        onTriggered: Quickshell.execDetached(["hyprlock"])
                    }
                }
            }
        }
    }
}
