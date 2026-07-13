pragma Singleton
import QtQuick
import Quickshell.Io
import "../.."

QtObject {
    id: fileSearchService

    property list<var> files: [
        {
            path: "/home/otto/wallpapers/test",
            created: new Date(),
            modified: new Date(),
            accessed: new Date(),
            byteSize: null,
            isRootOwned: false,
            get name() {
                return getName(this);
            },
            get format() {
                return getFormat(this);
            },
            get icon() {
                return getIcon(this);
            }
        },
        {
            path: "/home/otto/wallpapers/test\\test.jpg",
            created: new Date(),
            modified: new Date(),
            accessed: new Date(),
            byteSize: null,
            isRootOwned: false,
            get name() {
                return getName(this);
            },
            get format() {
                return getFormat(this);
            },
            get icon() {
                return getIcon(this);
            }
        }
    ]

    function getName(file: var): string {
        let parts = file.path.split("/");
        return parts[parts.length - 1];
    }
    function getFormat(file: var): string {
        let parts = getName(file).split(".");
        if (parts.length <= 1)
            return "";
        return parts[parts.length - 1].toLowerCase();
    }
    function getIcon(file: var): string {
        return IconsConf.fileFormats[getFormat(file)] ?? IconsConf.fileFormats.default;
    }

    function search(text: string, mode: string, results: var): var {
        if (!text || text.length < SearchConf.modes.find(m => m.name == "files").minChars)
            return [];
        if (!results) {
            searchProcess.text = text;
            searchProcess.mode = mode;
            searchProcess.command = ["sh", "-c", `find ~ -type f -name ".*" -prune -o -iname "${text}*" -print 2>/dev/null`];
            searchProcess.running = true;
            return;
        }

        console.log(JSON.stringify(results, null, 2));

        let max = MiscService.getMaxSearchResults("files", mode);
        // let searchResults = results;
        // return MiscService.getDistinctNonNull(searchResults).slice(0, max);
        return [];
    }

    property Process searchProcess: Process {
        id: searchProcess
        property var text: null
        property var mode: null

        property list<string> results: []
        property int count: 0

        onExited: () => {
            text = null;
            mode = null;
            results = [];
            count = 0;
        }
        stdout: SplitParser {
            onRead: line => {
                if (!line || line == "\n" || searchProcess.count > MiscService.getMaxSearchResults("files", searchProcess.mode))
                    return;
                searchProcess.results.push(line);
                fileSearchService.search(searchProcess.file, searchProcess.mode, searchProcess.results);
                searchProcess.count++;
            }
        }
    }

    function open(file: var, inNewWs: bool, checkStatus: var): void {
        if (!checkStatus) {
            checkCanOpenProcess.file = file;
            checkCanOpenProcess.inNewWs = inNewWs;
            checkCanOpenProcess.running = true;
        }

        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            openTimer.fileToOpen = file;
            openTimer.checkStatus = checkStatus;
            openTimer.running = true;
        } else {
            if (checkStatus == "success")
                HyprlandService.execWithQsTag(`xdg-open '${file.path}'`);
            else if (checkStatus == "fail")
                HyprlandService.execWithQsTag(`thunar '${file.path}'`);
        }
    }

    property Process checkCanOpenProcess: Process {
        id: checkCanOpenProcess
        property var file: null
        property var inNewWs: null
        command: file?.path ? ["sh", "-c", `xdg-mime query default $(xdg-mime query filetype '${file.path}')`] : []
        stdout: StdioCollector {
            onStreamFinished: {
                fileSearchService.open(checkCanOpenProcess.file, checkCanOpenProcess.inNewWs, text.trim() == "" ? "fail" : "success");
                checkCanOpenProcess.file = null;
                checkCanOpenProcess.inNewWs = null;
            }
        }
    }

    property Timer openTimer: Timer {
        property var fileToOpen: null
        property var checkStatus: null
        interval: 100
        onTriggered: {
            if (fileToOpen && checkStatus !== null) {
                parent.open(fileToOpen, false, checkStatus);
                fileToOpen = null;
                checkStatus = null;
            }
        }
    }
}
