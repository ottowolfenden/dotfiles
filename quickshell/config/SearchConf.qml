pragma Singleton
import QtQuick

QtObject {
    readonly property var modes: [
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
