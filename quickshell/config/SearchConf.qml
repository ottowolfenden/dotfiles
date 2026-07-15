pragma Singleton
import QtQuick
import Quickshell
import "../modules/search"

QtObject {
    readonly property var modes: [
        {
            name: "default",
            prefixes: ["default:", "none:", "n:"],
            placeholder: "Search",
            minChars: 1
        },
        {
            name: "apps",
            prefixes: ["apps:", "app:", "a:"],
            placeholder: "Search apps",
            minChars: 1,
            maxResults: {
                all: 3,
                filtered: 6
            },
            displayName: "Apps"
        },
        {
            name: "dirs",
            prefixes: ["directories:", "folders:", "dir:", "dirs:", "d:"],
            placeholder: "Search directories",
            minChars: 2,
            maxResults: {
                all: 3,
                filtered: 15
            },
            displayName: "Folders"
        },
        {
            name: "files",
            prefixes: ["files:", "file:", "f:"],
            placeholder: "Search files",
            minChars: 3,
            maxResults: {
                all: 3,
                filtered: 10
            },
            displayName: "Files"
        },
        {
            name: "web",
            prefixes: ["web:", "browser:", "w:", "b:"],
            placeholder: "Search the web",
            minChars: 1,
            maxResults: {
                all: 2,
                filtered: 10
            },
            displayName: "Web"
        },
        {
            name: "command",
            prefixes: ["exec:", ">", "e:", "t:", "c:"],
            placeholder: "Execute",
            minChars: 1,
            maxResults: {
                all: 0,
                filtered: 10
            },
            displayName: "Commands"
        }
    ]
    readonly property list<string> appAttrPriority: ["name", "execString", "genericName", "comment", "categories", "keywords", "startupClass", "icon"]
    readonly property string fileParentDir: Quickshell.env("HOME")
    readonly property string dirParentDir: Quickshell.env("HOME")
    readonly property list<string> fsEntryExclusions: ["*/.*", Quickshell.env("HOME") + "/yay/*"]
}
