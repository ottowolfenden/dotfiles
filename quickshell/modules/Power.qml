import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import ".."
import "../components"

Rectangle {
    id: root
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
        parentX: root.x
        rectWidth: pane.width
        rectHeight: pane.height

        Pane {
            id: pane
            padding: DesignConf.spacing
            background: null

            ColumnLayout {
                spacing: DesignConf.spacing
                property var exec: command => {
                    FlyoutsService.flyoutsHandler.hideAllFlyouts();
                    Quickshell.execDetached(command);
                }

                TextButton {
                    text: "Shut down"
                    iconName: IconsConf.power.shutDown
                    onClicked: parent.exec(["hyprshutdown", "-t", "Shutting down...", "--post-cmd", "systemctl poweroff"])
                }
                TextButton {
                    text: "Restart"
                    iconName: IconsConf.power.restart
                    onClicked: parent.exec(["hyprshutdown", "-t", "Restarting...", "--post-cmd", "systemctl reboot"])
                }
                TextButton {
                    text: "Log out"
                    iconName: IconsConf.power.logout
                    onClicked: parent.exec(["hyprshutdown", "-t", "Logging out..."])
                }
                TextButton {
                    text: "Sleep"
                    iconName: IconsConf.power.sleep
                    onClicked: parent.exec(["systemctl", "suspend"])
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
                        interval: AnimConf.durations.default
                        repeat: false
                        onTriggered: Quickshell.execDetached(["hyprlock"])
                    }
                }
            }
        }
    }
}
