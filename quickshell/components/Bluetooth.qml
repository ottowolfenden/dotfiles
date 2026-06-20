import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import ".."

Rectangle {
    id: bluetooth
    color: Config.colours.bg
    radius: Config.borderRadius
    width: Config.barHeight
    Layout.fillHeight: true
    property int numConnected: Bluetooth.defaultAdapter.devices.values.filter(d => d.connected).length
    property bool on: Bluetooth.defaultAdapter.enabled

    Icon {
        id: icon
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
            if (mouse.button == Qt.LeftButton)
                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
            else if (mouse.button == Qt.RightButton)
                Quickshell.execDetached(["overskride"]);
        }
    }
}
