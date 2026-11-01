pragma Singleton
import QtQuick
import ".."

QtObject {
    readonly property var vpnCommands: ({
            connect: ["protonvpn", "connect"],
            disconnect: ["protonvpn", "disconnect"]
        })
}
