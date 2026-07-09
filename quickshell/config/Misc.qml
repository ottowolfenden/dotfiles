pragma Singleton
import QtQuick

QtObject {
    readonly property list<string> earbudSubstrings: ["bud", "airpod", " ear", "tws"]
    readonly property list<string> playerRequirements: ["canPlay", "canPause", "canControl", "canTogglePlaying"]
    readonly property var playerIdentityNames: {
        "com.github.th-ch.youtube-music": "YouTube Music"
    }

    readonly property var searchModes: [
        {
            name: "default",
            prefixes: ["d:", "default:", "none:"],
            placeholder: "Search"
        },
        {
            name: "apps",
            prefixes: ["a:", "apps:"],
            placeholder: "Search apps"
        },
        {
            name: "files",
            prefixes: ["f:", "files:"],
            placeholder: "Search files and folders"
        },
        {
            name: "web",
            prefixes: ["w:", "web:"],
            placeholder: "Search the web"
        },
        {
            name: "command",
            prefixes: [">", "exec:"],
            placeholder: "Execute"
        }
    ]
}
