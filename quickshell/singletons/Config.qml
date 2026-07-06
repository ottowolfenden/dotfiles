pragma Singleton
import QtQuick
import ".."

QtObject {
    property int spacing: 8
    property int iconTextSpacing: 4
    property int componentHeight: 30
    property int barHeight: componentHeight + spacing * 2
    property int fontSize: 15
    property int smallFontSize: 13
    property int radius: 7
    property int blurRadius: 70
    property string fontFamily: "Google Sans Flex"
    property var vpnIdentifiers: ["vpn", "wireguard", "proton"]
    property var devicesToAutoconnect: ["B0:F0:0C:07:BC:07", "AC:3E:B1:62:43:27"]
    property int animationDuration: 200
    property int listAnimationDuration: 150
    property int circleButtonDiameter: 33
    property var easing: Easing.OutQuart
    property bool showHdmiSinks: false
    property var colours: QsState.darkMode ? {
        bg1: "#000000",
        bg2: "#0fffffff",
        fg1: "#d8ffffff",
        fg2: "#55ffffff",
        fg3: "#15ffffff",
        invfg: "#000000",
        cutoutBg: "#30202020",
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
        cutoutBg: "#d8ffffff",
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
    property var playerRequirements: ["canPlay", "canPause", "canControl", "canTogglePlaying"]
    property var playerIdentityNames: {
        "com.github.th-ch.youtube-music": "YouTube Music"
    }
    property var earbudSubstrings: ["bud", "airpod", " ear", "tws"]
    property var mainPwNodeName: "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
    property string scriptsDir: "/home/otto/dotfiles/scripts/"
}
