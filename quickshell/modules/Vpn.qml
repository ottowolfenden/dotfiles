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
            running: setVpnProcess.running

            PropertyAnimation {
                to: 0.3
                duration: DesignConf.pulseAnimationDuration
            }
            PropertyAnimation {
                to: 1
                duration: DesignConf.pulseAnimationDuration
            }
        }

        PropertyAnimation on opacity {
            id: resetVpnOpacity
            running: false
            to: 1
            duration: DesignConf.pulseAnimationDuration
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
        onExited: exitCode => {
            resetVpnOpacity.running = true;
            root.isVpnConnected = action == "connect";
        }
    }
}
