import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import Quickshell.Io
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

    property bool reopening: false
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if (batteryFlyout.isOpen) {
                batteryFlyout.isOpen = false;
                battery.reopening = true;
            } else
                battery.reopening = false;
        }
        onReleased: {
            batteryFlyout.parentX = battery.mapToItem(null, battery.width / 2, 0).x;
            batteryFlyout.isOpen = !batteryFlyout.isOpen && !battery.reopening;
        }
    }

    Flyout {
        id: batteryFlyout
        parentX: battery.x
    }

    Process {
        id: batteryStats
        command: {
            if (battery.isCharging)
                return ["notify-send", Math.round(UPower.displayDevice.timeToFull / 60) + " min to full"];
            return ["notify-send", Math.round(UPower.displayDevice.timeToEmpty / 60) + " min to empty"];
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
}
