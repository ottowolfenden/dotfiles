import QtQuick
import Quickshell.Io
import ".."
import "../components"
import "../animations"

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

        OpacityPulseAnim {
            running: setVpnProcess.running
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: setVpnProcess.running ? Qt.ArrowCursor : Qt.PointingHandCursor
        onClicked: {
            if (setVpnProcess.running)
                return;
            setVpnProcess.action = root.isVpnConnected ? "disconnect" : "connect";
            setVpnProcess.running = true;
        }
    }

    Process {
        id: vpnCheckProcess
        running: true
        command: ["nmcli", "connection", "show", "--active"]
        stdout: StdioCollector {
            onStreamFinished: root.isVpnConnected = SystemConf.vpnIdentifiers.some(i => text.toLowerCase().includes(i))
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: vpnCheckProcess.running = !setVpnProcess.running
    }

    Process {
        id: setVpnProcess
        property var action: null
        command: action ? NetworkConf.vpnCommands[action] : []
        onExited: exitCode => root.isVpnConnected = action == "connect" && exitCode == 0
    }
}
