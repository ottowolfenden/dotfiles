import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.UPower
import ".."
import "../components"

Rectangle {
    id: battery
    color: "transparent"
    radius: Config.radius
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    Layout.preferredHeight: Config.componentHeight

    Cutout {}

    property bool isCharging: false
    property int percent: Math.round(UPower.displayDevice.percentage * 100)
    property bool danger: battery.percent <= 10 && !battery.isCharging

    RowLayout {
        id: container
        spacing: Config.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Icon {
            colour: battery.danger ? Config.colours.red : Config.colours.fg1
            property var icons: Icons.battery.find(i => battery.percent <= i.max)
            iconName: battery.isCharging ? icons.charging : icons.discharging
            fill: icons.fill ?? false
            horizontalMargin: -5
        }

        Text {
            text: battery.percent + "%"
            color: battery.danger ? Config.colours.red : Config.colours.fg1
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: 40
        }
    }

    Process {
        id: chargingStatus
        command: ["cat", "/sys/class/power_supply/BAT0/status"]

        stdout: StdioCollector {
            onStreamFinished: battery.isCharging = ["Charging", "Not charging", "Full"].includes(text.toString().trim())
        }
    }

    Timer {
        interval: 300
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: chargingStatus.running = true
    }

    FlyoutMouseArea {
        flyout: batteryFlyout
    }

    Flyout {
        id: batteryFlyout
        parentX: battery.x
        rectWidth: pane.implicitWidth
        rectHeight: pane.implicitHeight

        Pane {
            id: pane
            padding: Config.spacing
            background: null

            ColumnLayout {
                spacing: Config.spacing

                ToggleGroup {
                    id: powerProfiletoggleGroup
                    icons: Icons.powerProfiles
                    onClickedCommands: ["power-saver", "balanced", "performance"].map(p => ["tlpctl", p])
                    checkTimer: tlpctlTimer
                }

                Process {
                    id: tlpctlGetProcess
                    command: ["tlpctl", "get"]
                    running: true
                    stdout: StdioCollector {
                        onStreamFinished: {
                            if (powerProfiletoggleGroup.ignoreUpdates)
                                return;

                            if (text.trim() == "power-saver")
                                powerProfiletoggleGroup.activeIndex = 0;
                            else if (text.trim() == "balanced")
                                powerProfiletoggleGroup.activeIndex = 1;
                            else if (text.trim() == "performance")
                                powerProfiletoggleGroup.activeIndex = 2;
                        }
                    }
                }

                Timer {
                    id: tlpctlTimer
                    running: true
                    repeat: true
                    interval: 1500
                    onTriggered: tlpctlGetProcess.running = true
                }

                Rectangle {
                    implicitWidth: 160
                    implicitHeight: 100
                    color: Config.colours.bg2
                    radius: Config.radius
                }
            }
        }
    }
}
