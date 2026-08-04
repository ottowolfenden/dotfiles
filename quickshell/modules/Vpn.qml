import QtQuick
import Quickshell.Io
import ".."
import "../components"

Rectangle {
    id: root
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: DesignConf.componentHeight
    implicitHeight: DesignConf.componentHeight

    property bool isVpnConnected: false

    Cutout {}

    Icon {
        anchors.centerIn: parent
        iconName: IconsConf.vpn[root.isVpnConnected ? "on" : "off"]

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

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            vpnPulse.running = true;
            if (root.isVpnConnected)
                disableVpn.running = true;
            else
                enableVpn.running = true;
        }
    }

    Process {
        id: vpnCheck
        command: ["nmcli", "connection", "show", "--active"]
        stdout: StdioCollector {
            onStreamFinished: root.isVpnConnected = SystemConf.vpnIdentifiers.some(i => text.toLowerCase().includes(i))
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
                resetVpnOpacity.running = root.isVpnConnected = true;
            }
        }
    }

    Process {
        id: disableVpn
        command: ["protonvpn", "disconnect"]
        onExited: exitCode => {
            if (exitCode == 0) {
                vpnPulse.running = root.isVpnConnected = false;
                resetVpnOpacity.running = true;
            }
        }
    }
}
