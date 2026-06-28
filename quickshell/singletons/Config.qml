pragma Singleton
import QtQuick
import ".."

QtObject {
    property real spacing: 8
    property int iconTextSpacing: 4
    property int componentHeight: 30
    property int barHeight: componentHeight + spacing * 2
    property int fontSize: 15
    property int radius: 7
    property int blurRadius: 70
    property string fontFamily: "Google Sans Flex"
    property var colours: QsState.darkMode ? {
        bg1: "#000000",
        bg2: "#30202020",
        fg1: "#d8ffffff",
        fg2: "#55ffffff",
        fg3: "#15ffffff",
        invfg: "#000000",
        red: "#f07178",
        orange: "#f78c6c",
        yellow: "#ffcb6b",
        green: "#c3e88d",
        lightblue: "#89ddff",
        darkblue: "#82aaff",
        purple: "#c792ea",
        pink: "#ff9cac"
    } : {
        bg1: "#ffffff",
        bg2: "#d8ffffff",
        fg1: '#d8030202',
        fg2: "#55000000",
        fg3: "#15000000",
        invfg: "#ffffff",
        red: "#ea4335",
        orange: "#fd6132",
        yellow: "#f1b911",
        green: "#34a853",
        lightblue: "#4285f4",
        darkblue: "#0057ca",
        purple: "#7248b9",
        pink: "#ff80ab"
    }
    property var vpnIdentifiers: ["vpn", "wireguard", "proton"]
    property var devicesToAutoconnect: ["B0:F0:0C:07:BC:07", "AC:3E:B1:62:43:27"]
}
