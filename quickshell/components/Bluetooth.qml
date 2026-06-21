import QtQuick
import Quickshell
import Quickshell.Bluetooth
import ".."

Rectangle {
    id: bluetooth
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: Config.barHeight
    implicitHeight: Config.barHeight

    property int numConnected: Bluetooth.defaultAdapter.devices.values.filter(d => d.connected).length
    property bool on: Bluetooth.defaultAdapter.enabled
    property var devicesToAutoconnect: ["B0:F0:0C:07:BC:07"]

    Icon {
        id: icon
        anchors.centerIn: parent
        iconName: {
            if (bluetooth.on)
                return parent.numConnected <= 0 ? "bluetooth" : "bluetooth_connected";
            return "bluetooth_disabled";
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
            var device = Bluetooth.defaultAdapter.devices.values.find(d => bluetooth.devicesToAutoconnect.includes(d.address));
            if (!device.connected)
                device.connect();
        }
    }
}
