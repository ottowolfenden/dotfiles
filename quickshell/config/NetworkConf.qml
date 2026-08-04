pragma Singleton
import QtQuick

QtObject {
    readonly property var vpnCommands: ({
            connect: ["protonvpn", "connect"],
            disconnect: ["protonvpn", "disconnect"]
        })
}
