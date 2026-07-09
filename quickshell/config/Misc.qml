pragma Singleton
import QtQuick

QtObject {
    readonly property list<string> earbudSubstrings: ["bud", "airpod", " ear", "tws"]
    readonly property list<string> playerRequirements: ["canPlay", "canPause", "canControl", "canTogglePlaying"]
    readonly property var playerIdentityNames: {
        "com.github.th-ch.youtube-music": "YouTube Music"
    }

    readonly property list<string> searchModes: ["default", "apps", "files", "web", "terminal"]
    readonly property var searchModePlaceholder: ({
            default: "Search",
            apps: "Search apps",
            files: "Search files and folders",
            web: "Search the web",
            terminal: "Execute"
        })
    readonly property var searchModeBinds: ({
            apps: [Qt.Key_A, Qt.Key_F1],
            files: [Qt.Key_T, Qt.Key_F2],
            web: [Qt.Key_B, Qt.Key_F3],
            terminal: [Qt.Key_Q, Qt.Key_F4]
        })
    readonly property var isCopilotKey: e => (e.modifiers & (Qt.MetaModifier | Qt.ShiftModifier)) == (Qt.MetaModifier | Qt.ShiftModifier)
    readonly property var isFunctionKey: e => e.key >= Qt.Key_F1 && e.key <= Qt.Key_F35
}
