import QtQuick
import Quickshell.Networking
import ".."
import "../components"

Rectangle {
    id: root
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: DesignConf.componentHeight
    implicitHeight: DesignConf.componentHeight

    property WifiDevice wifiDevice: Networking.devices.values.find(d => d.type == DeviceType.Wifi) ?? null
    property WifiNetwork wifiNetwork: wifiDevice?.networks?.values.find(n => n.connected) ?? null
    property real wifiStrength: wifiNetwork?.signalStrength ?? 0
    property bool isWifiSecured: ![WifiSecurityType.Open, WifiSecurityType.Owe, WifiSecurityType.Unknown].includes(wifiNetwork?.security)

    Cutout {}

    Icon {
        anchors.centerIn: parent
        iconName: {
            let conn = Networking.connectivity ?? NetworkConnectivity.Unknown;
            let icons = IconsConf.wifi.find(i => i.connectivity == conn).icons.find(j => root.wifiStrength <= (j.max ?? 1));
            return root.isWifiSecured ? icons.secured : icons.open;
        }
    }
}
