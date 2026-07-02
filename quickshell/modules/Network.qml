import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import Quickshell.Io
import ".."
import "../components"

Rectangle {
    id: network
    color: "transparent"
    radius: Config.radius
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    Layout.preferredHeight: Config.componentHeight

    property WifiDevice wifiDevice: Networking.devices.values.find(d => d.type == DeviceType.Wifi) ?? null
    property WifiNetwork wifiNetwork: wifiDevice?.networks?.values.find(n => n.connected) ?? null
    property real wifiStrength: wifiNetwork?.signalStrength ?? 0
    property bool isWifiSecured: ![WifiSecurityType.Open, WifiSecurityType.Owe, WifiSecurityType.Unknown].includes(wifiNetwork?.security ?? WifiSecurityType.Unknown)
    property bool isVpnConnected: false

    Cutout {}

    RowLayout {
        id: container
        spacing: Config.spacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Icon {
            property var icons: Icons.wifi.find(i => i.connectivity == (Networking.connectivity ?? NetworkConnectivity.Unknown)).icons.find(j => network.wifiStrength <= (j.max ?? 1))
            iconName: (network.isWifiSecured ? icons.secured : icons.open)
            fill: icons.fill ?? false
        }

        Icon {
            iconName: network.isVpnConnected ? Icons.vpn.on : Icons.vpn.off
            opacity: 1

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    vpnPulse.running = true;
                    if (network.isVpnConnected)
                        disableVpn.running = true;
                    else
                        enableVpn.running = true;
                }
            }

            SequentialAnimation on opacity {
                id: vpnPulse
                loops: Animation.Infinite
                running: false

                PropertyAnimation {
                    to: 0.3
                    duration: 350
                    easing.type: Easing.Linear
                }
                PropertyAnimation {
                    to: 1
                    duration: 350
                    easing.type: Easing.Linear
                }
            }

            SequentialAnimation on opacity {
                id: resetVpnOpacity
                running: false

                PropertyAnimation {
                    to: 1
                    duration: 350
                    easing.type: Easing.Linear
                }
            }
        }
    }

    Process {
        id: vpnCheck
        command: ["nmcli", "connection", "show", "--active"]
        stdout: StdioCollector {
            onStreamFinished: network.isVpnConnected = Config.vpnIdentifiers.some(i => text.toLowerCase().includes(i))
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: vpnCheck.running = true
    }

    Process {
        id: enableVpn
        command: ["protonvpn", "connect"]
        onExited: exitCode => {
            if (exitCode == 0) {
                vpnPulse.running = false;
                resetVpnOpacity.running = true;
                network.isVpnConnected = true;
            }
        }
    }

    Process {
        id: disableVpn
        command: ["protonvpn", "disconnect"]
        onExited: exitCode => {
            if (exitCode == 0) {
                vpnPulse.running = false;
                resetVpnOpacity.running = true;
                network.isVpnConnected = false;
            }
        }
    }
}
