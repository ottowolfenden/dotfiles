import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import ".."
import "../components"

Rectangle {
    id: battery
    color: "transparent"
    radius: Design.radius
    implicitWidth: container.implicitWidth + (Design.spacing * 2)
    Layout.preferredHeight: Design.componentHeight

    Cutout {}

    property bool isCharging: false
    property int percent: Math.round(UPower.displayDevice.percentage * 100)
    property bool danger: battery.percent <= 10 && !battery.isCharging

    RowLayout {
        id: container
        spacing: Design.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: Design.spacing
        anchors.rightMargin: Design.spacing

        Icon {
            colour: battery.danger ? Colours.red : Colours.fg1
            property var icons: Icons.battery.find(i => battery.percent <= i.max)
            iconName: battery.isCharging ? icons.charging : icons.discharging
            fill: icons.fill ?? false
            horizontalMargin: -5
        }

        Text {
            text: battery.percent + "%"
            color: battery.danger ? Colours.red : Colours.fg1
            font.family: Design.fontFamily
            font.pixelSize: Design.fontSize
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

    onIsChargingChanged: {
        if (battery.isCharging)
            Quickshell.execDetached(["tlpctl", "performance"]);
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
            padding: Design.spacing
            background: null

            ColumnLayout {
                spacing: Design.spacing

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
                    implicitWidth: Math.max(220, grid.implicitWidth + Design.spacing * 2)
                    implicitHeight: grid.implicitHeight + Design.spacing * 2
                    color: Colours.bg2
                    radius: Design.radius

                    GridLayout {
                        id: grid
                        anchors.fill: parent
                        anchors.margins: Design.spacing
                        columns: 4
                        rowSpacing: Design.spacing
                        columnSpacing: Design.spacing

                        property bool fullAndCharging: battery.percent == 100 && battery.isCharging

                        // row 1
                        Text {
                            font.pixelSize: Design.smallFontSize
                            color: Colours.fg2
                            font.family: Design.fontFamily
                            Layout.fillHeight: true
                            text: "Power profile"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            font.pixelSize: Design.smallFontSize
                            color: Colours.fg1
                            font.family: Design.fontFamily
                            Layout.fillHeight: true
                            text: ["Power saver", "Balanced", "Performance"][powerProfiletoggleGroup.activeIndex] ?? "Unknown"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }

                        // row 2
                        Text {
                            visible: !grid.fullAndCharging
                            font.pixelSize: Design.smallFontSize
                            color: Colours.fg2
                            font.family: Design.fontFamily
                            Layout.fillHeight: true
                            text: battery.isCharging ? "Time until full" : "Time until empty"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            visible: !grid.fullAndCharging
                            Layout.fillWidth: true
                        }
                        Text {
                            visible: !grid.fullAndCharging
                            font.pixelSize: Design.smallFontSize
                            color: Colours.fg1
                            font.family: Design.fontFamily
                            text: {
                                let secsLeft = battery.isCharging ? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty;
                                return secsLeft == 0 ? "Loading..." : MiscService.secsToHrsMins(secsLeft);
                            }
                            Layout.fillHeight: true
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            visible: !grid.fullAndCharging
                            Layout.fillWidth: true
                        }

                        // row 3
                        Text {
                            font.pixelSize: Design.smallFontSize
                            color: Colours.fg2
                            font.family: Design.fontFamily
                            Layout.fillHeight: true
                            text: battery.isCharging ? "Charge rate" : "Discharge rate"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            font.pixelSize: Design.smallFontSize
                            color: Colours.fg1
                            font.family: Design.fontFamily
                            text: {
                                if (UPower.displayDevice.changeRate == 0 && !grid.fullAndCharging)
                                    return "Loading...";
                                return UPower.displayDevice.changeRate.toPrecision(2) + " W";
                            }
                            Layout.fillHeight: true
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }
}
