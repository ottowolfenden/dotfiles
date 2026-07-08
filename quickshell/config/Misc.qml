pragma Singleton
import QtQuick

QtObject {
    readonly property list<string> earbudSubstrings: ["bud", "airpod", " ear", "tws"]
    readonly property list<string> playerRequirements: ["canPlay", "canPause", "canControl", "canTogglePlaying"]
    readonly property var playerIdentityNames: {
        "com.github.th-ch.youtube-music": "YouTube Music"
    }

    readonly property var searchModePlaceholder: ({
            default: "Search",
            apps: "Search apps",
            files: "Search files and folders",
            web: "Search the web",
            terminal: "Execute"
        })
}
