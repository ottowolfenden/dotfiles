import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import Quickshell.Io
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: container.width + (Config.spacing * 2)
    Layout.fillHeight: true

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
                property bool isCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
                property int batteryPercent: Math.round(UPower.displayDevice.percentage * 100)
                iconName: {
                    if (batteryPercent <= 5)
                        return isCharging ? "battery_charging_full" : "battery_0_bar";
                    if (batteryPercent <= 20)
                        return isCharging ? "battery_charging_20" : "battery_1_bar";
                    if (batteryPercent <= 35)
                        return isCharging ? "battery_charging_30" : "battery_2_bar";
                    if (batteryPercent <= 50)
                        return isCharging ? "battery_charging_50" : "battery_3_bar";
                    if (batteryPercent <= 65)
                        return isCharging ? "battery_charging_60" : "battery_4_bar";
                    if (batteryPercent <= 80)
                        return isCharging ? "battery_charging_80" : "battery_5_bar";
                    if (batteryPercent <= 95)
                        return isCharging ? "battery_charging_90" : "battery_6_bar";
                    if (batteryPercent > 95)
                        return "battery_full";
                    return "battery_unknown";
                }
            }
        }
        Item {
            implicitHeight: batteryPercentage.height
            implicitWidth: batteryPercentage.width
            Text {
                id: batteryPercentage
                text: icon.batteryPercent + "%"
                color: Config.colours.fg1
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
            if (icon.isCharging)
                return ["notify-send", Math.round(UPower.displayDevice.timeToFull / 60) + " min to full"];
            return ["notify-send", Math.round(UPower.displayDevice.timeToEmpty / 60) + " min to empty"];
        }
    }
}
