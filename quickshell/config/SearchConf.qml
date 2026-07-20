pragma Singleton
import QtQuick
import Quickshell

QtObject {
    readonly property var modes: [
        {
            name: "default",
            prefixes: ["default:", "none:", "n:", "N"],
            shiftKey: Qt.Key_N,
            placeholder: "Search",
            minChars: 1
        },
        {
            name: "apps",
            prefixes: ["apps:", "app:", "a:", "A"],
            shiftKey: Qt.Key_A,
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
            prefixes: ["directories:", "folders:", "dir:", "dirs:", "d:", "D"],
            shiftKey: Qt.Key_D,
            placeholder: "Search folders",
            minChars: 2,
            maxResults: {
                all: 3,
                filtered: 15
            },
            displayName: "Folders"
        },
        {
            name: "files",
            prefixes: ["files:", "file:", "f:", "F"],
            shiftKey: Qt.Key_F,
            placeholder: "Search files",
            minChars: 2,
            maxResults: {
                all: 3,
                filtered: 15
            },
            displayName: "Files"
        },
        {
            name: "web",
            prefixes: ["web:", "browser:", "w:", "b:", "W"],
            shiftKey: Qt.Key_W,
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
            prefixes: ["exec:", ">", "e:", "t:", "c:", "C"],
            shiftKey: Qt.Key_C,
            placeholder: "Search commands",
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
    readonly property var pathExclusions: ({
            dirs: {
                default: ["*/.*", Quickshell.env("HOME") + "/yay/*"],
                always: [Quickshell.env("HOME") + "/.local/share/Trash/*"]
            },
            files: {
                default: ["*/.*", Quickshell.env("HOME") + "/yay/*"],
                always: [Quickshell.env("HOME") + "/.local/share/Trash/*"]
            }
        })
    readonly property int msToSwitchHyprlandWs: 60
    readonly property var binds: ({
            inNewWs: {
                active: false,
                key: Qt.Key_Return,
                mod: Qt.ShiftModifier
            },
            inTerminal: {
                active: false,
                key: Qt.Key_Return,
                mod: Qt.ControlModifier
            },
            inVsCode: {
                active: false,
                key: Qt.Key_Return,
                mod: Qt.MetaModifier
            }
        })
    readonly property real maxFileNameWidthProportion: 0.6
    readonly property string searchEngineRegion: "uk-en"
    readonly property string browserCommand: "helium-browser"
}
