pragma Singleton
import QtQuick

QtObject {
    readonly property var modes: [
        {
            name: "default",
            prefixes: ["default:", "none:", "n:"],
            placeholder: "Search"
        },
        {
            name: "apps",
            prefixes: ["apps:", "app:", "a:"],
            placeholder: "Search apps",
            maxResults: {
                all: 3,
                filtered: 6
            }
        },
        {
            name: "dirs",
            prefixes: ["directories:", "folders:", "dir:", "dirs:", "d:"],
            placeholder: "Search directories",
            maxResults: {
                all: 3,
                filtered: 6
            }
        },
        {
            name: "files",
            prefixes: ["files:", "file:", "f:"],
            placeholder: "Search files",
            maxResults: {
                all: 3,
                filtered: 10
            }
        },
        {
            name: "web",
            prefixes: ["web:", "browser:", "w:", "b:"],
            placeholder: "Search the web",
            maxResults: {
                all: 2,
                filtered: 10
            }
        },
        {
            name: "command",
            prefixes: ["exec:", ">", "e:", "t:", "c:"],
            placeholder: "Execute",
            maxResults: {
                all: 0,
                filtered: 10
            }
        }
    ]

    readonly property list<string> appAttrPriority: ["name", "execString", "genericName", "comment", "categories", "keywords", "startupClass", "icon"]
}
