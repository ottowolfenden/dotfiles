import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import ".."
import "../components"

Rectangle {
    id: root
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: container.implicitWidth + (DesignConf.spacing * 2)
    Layout.preferredHeight: DesignConf.componentHeight

    Cutout {}

    property bool isCharging: false
    property int percent: Math.round(UPower.displayDevice.percentage * 100)
    property bool danger: root.percent <= 10 && !root.isCharging

    RowLayout {
        id: container
        spacing: DesignConf.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: DesignConf.spacing
        anchors.rightMargin: DesignConf.spacing

        Icon {
            colour: root.danger ? ColoursConf.red : ColoursConf.fg1.t
            iconName: {
                let icons = IconsConf.battery.find(i => root.percent <= i.max);
                return root.isCharging ? icons.charging : icons.discharging;
            }
            horizontalMargin: -5
        }

        Text {
            text: root.percent + "%"
            color: root.danger ? ColoursConf.red : ColoursConf.fg1.t
            font.family: FontsConf.mainFamily
            font.pixelSize: FontsConf.pixelSize
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: 40
        }
    }

    Process {
        id: chargingStatus
        command: ["cat", "/sys/class/power_supply/BAT0/status"]

        stdout: StdioCollector {
            onStreamFinished: root.isCharging = ["Charging", "Not charging", "Full"].includes(text.toString().trim())
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
        if (root.isCharging)
            Quickshell.execDetached(["tlpctl", "performance"]);
    }

    FlyoutMouseArea {
        flyout: batteryFlyout
    }

    Flyout {
        id: batteryFlyout
        parentX: root.x
        rectWidth: pane.implicitWidth
        rectHeight: pane.implicitHeight

        Pane {
            id: pane
            padding: DesignConf.spacing
            background: null

            ColumnLayout {
                spacing: DesignConf.spacing

                ToggleGroup {
                    id: powerProfiletoggleGroup
                    icons: IconsConf.powerProfiles
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
                    implicitWidth: Math.max(220, grid.implicitWidth + DesignConf.spacing * 2)
                    implicitHeight: grid.implicitHeight + DesignConf.spacing * 2
                    color: ColoursConf.bg3.t
                    radius: DesignConf.radius

                    GridLayout {
                        id: grid
                        anchors.fill: parent
                        anchors.margins: DesignConf.spacing
                        columns: 4
                        rowSpacing: DesignConf.spacing
                        columnSpacing: DesignConf.spacing

                        property bool fullAndCharging: root.percent == 100 && root.isCharging

                        // row 1
                        Text {
                            font.pixelSize: FontsConf.smallPixelSize
                            color: ColoursConf.fg3.t
                            font.family: FontsConf.mainFamily
                            Layout.fillHeight: true
                            text: "Power profile"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            font.pixelSize: FontsConf.smallPixelSize
                            color: ColoursConf.fg1.t
                            font.family: FontsConf.mainFamily
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
                            font.pixelSize: FontsConf.smallPixelSize
                            color: ColoursConf.fg3.t
                            font.family: FontsConf.mainFamily
                            Layout.fillHeight: true
                            text: root.isCharging ? "Time until full" : "Time until empty"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            visible: !grid.fullAndCharging
                            Layout.fillWidth: true
                        }
                        Text {
                            visible: !grid.fullAndCharging
                            font.pixelSize: FontsConf.smallPixelSize
                            color: ColoursConf.fg1.t
                            font.family: FontsConf.mainFamily
                            text: {
                                let secsLeft = root.isCharging ? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty;
                                return secsLeft == 0 ? "Loading..." : UtilsService.secsToHrsMins(secsLeft);
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
                            font.pixelSize: FontsConf.smallPixelSize
                            color: ColoursConf.fg3.t
                            font.family: FontsConf.mainFamily
                            Layout.fillHeight: true
                            text: root.isCharging ? "Charge rate" : "Discharge rate"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Text {
                            font.pixelSize: FontsConf.smallPixelSize
                            color: ColoursConf.fg1.t
                            font.family: FontsConf.mainFamily
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
