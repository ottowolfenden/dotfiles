import QtQuick
import Quickshell
import Quickshell.Bluetooth
import ".."
import "../components"

Rectangle {
    id: bluetooth
    color: "transparent"
    radius: Config.radius
    implicitWidth: Config.componentHeight
    implicitHeight: Config.componentHeight

    Cutout {}

    property int numConnected: Bluetooth.defaultAdapter.devices.values.filter(d => d.connected).length
    property bool on: Bluetooth.defaultAdapter.enabled

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: {
            if (bluetooth.on)
                return parent.numConnected <= 0 ? Icons.bluetooth.enabled : Icons.bluetooth.connected;
            return Icons.bluetooth.disabled;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button == Qt.LeftButton) {
                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                if (Bluetooth.defaultAdapter.enabled)
                    autoconnectTimer.restart();
            } else if (mouse.button == Qt.RightButton)
                Quickshell.execDetached(["overskride"]);
        }
    }

    Timer {
        id: autoconnectTimer
        running: true
        interval: 300
        onTriggered: {
            if (!Bluetooth.defaultAdapter.enabled)
                return;
            for (var address of Config.devicesToAutoconnect) {
                var device = Bluetooth.defaultAdapter.devices.values.find(d => d.address == address);
                if (!device.connected) {
                    device.connect();
                    console.log("connecting to " + device.address);
                }
            }
        }
    }
}
