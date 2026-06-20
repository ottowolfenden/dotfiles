import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import Quickshell.Io
import ".."

Rectangle {
    id: battery
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: container.width + (Config.spacing * 2)
    Layout.fillHeight: true

    property bool isCharging: false
    property int percent: Math.round(UPower.displayDevice.percentage * 100)
    property bool danger: battery.percent <= 10 && !battery.isCharging

    Process {
        id: statusReader
        command: ["cat", "/sys/class/power_supply/BAT0/status"]

        stdout: StdioCollector {
            onStreamFinished: battery.isCharging = ["Charging", "Not charging"].includes(text.toString().trim())
        }
    }

    Timer {
        interval: 300
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statusReader.running = true
    }

    RowLayout {
        id: container
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Config.spacing * 1.5

        Item {
            implicitHeight: icon.height
            implicitWidth: icon.width
            Icon {
                id: icon
                iconName: {
                    if (battery.percent <= 10)
                        return battery.isCharging ? "battery_charging_full" : "battery_alert";
                    if (battery.percent <= 20)
                        return battery.isCharging ? "battery_charging_20" : "battery_1_bar";
                    if (battery.percent <= 30)
                        return battery.isCharging ? "battery_charging_30" : "battery_2_bar";
                    if (battery.percent <= 50)
                        return battery.isCharging ? "battery_charging_50" : "battery_3_bar";
                    if (battery.percent <= 60)
                        return battery.isCharging ? "battery_charging_60" : "battery_4_bar";
                    if (battery.percent <= 80)
                        return battery.isCharging ? "battery_charging_80" : "battery_5_bar";
                    if (battery.percent <= 95)
                        return battery.isCharging ? "battery_charging_90" : "battery_6_bar";
                    if (battery.percent > 95)
                        return battery.isCharging ? "battery_charging_full" : "battery_full";
                    return "battery_unknown";
                }
                fill: battery.isCharging && battery.percent > 95
                colour: battery.danger ? Config.colours.red : Config.colours.fg1
            }
        }

        Item {
            implicitHeight: percent.height
            implicitWidth: percent.width
            Text {
                id: percent
                text: battery.percent + "%"
                color: battery.danger ? Config.colours.red : Config.colours.fg1
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
                width: 48
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            batteryStats.running = true;
        }
    }
    Process {
        id: batteryStats
        command: {
            if (battery.isCharging)
                return ["notify-send", Math.round(UPower.displayDevice.timeToFull / 60) + " min to full"];
            return ["notify-send", Math.round(UPower.displayDevice.timeToEmpty / 60) + " min to empty"];
        }
    }
}
