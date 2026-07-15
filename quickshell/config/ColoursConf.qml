pragma Singleton
import QtQuick
import ".."

QtObject {
    property var theme: ModeService.mode == "light" ? lightTheme : darkTheme

    readonly property var darkTheme: ({
            bg1: "#000000",
            bg2: "#10ffffff",
            bg3: "#0cffffff",
            fg1: "#d8ffffff",
            fg2: "#78ffffff",
            fg3: "#15ffffff",
            invfg: "#000000",
            cutoutBg: "#10ffffff",
            buttonInactiveBg: "#0effffff",
            buttonHoveredBg: "#12ffffff",
            buttonPressedBg: "#1effffff",
            selectedBg: "#1889ddff",
            textSelectionBg: "#28ffffff",
            red: "#f07178",
            orange: "#f78c6c",
            yellow: "#ffcb6b",
            green: "#c3e88d",
            lightblue: "#89ddff",
            darkblue: "#82aaff",
            purple: "#c792ea",
            pink: "#ff9cac"
        })

    readonly property var lightTheme: ({
            bg1: "#ffffff",
            bg2: "#09000000",
            bg3: "#07000000",
            fg1: "#d8000000",
            fg2: "#78000000",
            fg3: "#15000000",
            invfg: "#ffffff",
            cutoutBg: "#cff8f8f8",
            buttonInactiveBg: "#0a000000",
            buttonHoveredBg: "#12000000",
            buttonPressedBg: "#1e000000",
            selectedBg: "#184285f4",
            textSelectionBg: "#28000000",
            red: "#ea4335",
            orange: "#fd6132",
            yellow: "#f1b911",
            green: "#34a853",
            lightblue: "#4285f4",
            darkblue: "#0057ca",
            purple: "#7248b9",
            pink: "#ff80ab"
        })

    readonly property color bg1: theme.bg1
    readonly property color bg2: theme.bg2
    readonly property color bg3: theme.bg3
    readonly property color fg1: theme.fg1
    readonly property color fg2: theme.fg2
    readonly property color fg3: theme.fg3
    readonly property color invfg: theme.invfg
    readonly property color cutoutBg: theme.cutoutBg
    readonly property color buttonInactiveBg: theme.buttonInactiveBg
    readonly property color buttonHoveredBg: theme.buttonHoveredBg
    readonly property color buttonPressedBg: theme.buttonPressedBg
    readonly property color selectedBg: theme.selectedBg
    readonly property color textSelectionBg: theme.textSelectionBg
    readonly property color red: theme.red
    readonly property color orange: theme.orange
    readonly property color yellow: theme.yellow
    readonly property color green: theme.green
    readonly property color lightblue: theme.lightblue
    readonly property color darkblue: theme.darkblue
    readonly property color purple: theme.purple
    readonly property color pink: theme.pink
}
