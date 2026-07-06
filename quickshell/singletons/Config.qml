pragma Singleton
import QtQuick
import ".."

QtObject {
    readonly property int spacing: 8
    readonly property int iconTextSpacing: 4
    readonly property int componentHeight: 30
    readonly property int barHeight: componentHeight + spacing * 2
    readonly property int fontSize: 15
    readonly property int smallFontSize: 13
    readonly property int radius: 7
    readonly property int blurRadius: 70
    readonly property string fontFamily: "Google Sans Flex"
    readonly property list<string> vpnIdentifiers: ["vpn", "wireguard", "proton"]
    readonly property list<string> devicesToAutoconnect: ["B0:F0:0C:07:BC:07", "AC:3E:B1:62:43:27"]
    readonly property int animationDuration: 200
    readonly property int listAnimationDuration: 150
    readonly property int circleButtonDiameter: 33
    readonly property int easing: Easing.OutQuart
    readonly property bool showHdmiSinks: false
    readonly property var colours: QsState.darkMode ? {
        bg1: "#000000",
        bg2: "#0fffffff",
        fg1: "#d8ffffff",
        fg2: "#55ffffff",
        fg3: "#15ffffff",
        invfg: "#000000",
        cutoutBg: "#10ffffff",
        buttonInactiveBg: "#0effffff",
        buttonHoveredBg: "#12ffffff",
        buttonPressedBg: "#1effffff",
        selectedBg: "#1889ddff",
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
        bg2: "#06000000",
        fg1: '#d8000000',
        fg2: "#55000000",
        fg3: "#15000000",
        invfg: "#ffffff",
        cutoutBg: "#c0f8f8f8",
        buttonInactiveBg: "#0a000000",
        buttonHoveredBg: "#12000000",
        buttonPressedBg: "#1e000000",
        selectedBg: "#184285f4",
        red: "#ea4335",
        orange: "#fd6132",
        yellow: "#f1b911",
        green: "#34a853",
        lightblue: "#4285f4",
        darkblue: "#0057ca",
        purple: "#7248b9",
        pink: "#ff80ab"
    }
    readonly property list<string> playerRequirements: ["canPlay", "canPause", "canControl", "canTogglePlaying"]
    readonly property var playerIdentityNames: {
        "com.github.th-ch.youtube-music": "YouTube Music"
    }
    readonly property list<string> earbudSubstrings: ["bud", "airpod", " ear", "tws"]
    readonly property string mainPwNodeName: "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
    readonly property string scriptsDir: "/home/otto/dotfiles/scripts/"
}
