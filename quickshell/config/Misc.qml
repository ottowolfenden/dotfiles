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
            prefixes: ["default:", "none:", "d:", "n:"],
            placeholder: "Search"
        },
        {
            name: "apps",
            prefixes: ["apps:", "a:"],
            placeholder: "Search apps"
        },
        {
            name: "files",
            prefixes: ["files:", "f:"],
            placeholder: "Search files and folders"
        },
        {
            name: "web",
            prefixes: ["web:", "browser:", "w:", "b:"],
            placeholder: "Search the web"
        },
        {
            name: "command",
            prefixes: ["exec:", ">", "e:", "t:", "c:"],
            placeholder: "Execute"
        }
    ]
}
