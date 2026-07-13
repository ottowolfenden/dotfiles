pragma Singleton
import QtQuick
import Quickshell.Io
import "../.."

QtObject {
    id: fileSearchService

    property list<var> dirs: [
        {
            path: "/home/otto/wallpapers",
            created: new Date(),
            modified: new Date(),
            accessed: new Date(),
            byteSize: null,
            isRootOwned: false,
            numFiles: 20,
            numDirs: 4,
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
            path: "/home/otto/t\\\\\\\\est",
            created: new Date(),
            modified: new Date(),
            accessed: new Date(),
            byteSize: null,
            isRootOwned: false,
            numFiles: 20,
            numDirs: 4,
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

    function getName(dir: var): string {
        let parts = dir.path.split("/");
        return parts[parts.length - 1];
    }
    function getFormat(file: var): string {
        let parts = getName(file).split(".");
        if (parts.length <= 1)
            return "";
        return parts[parts.length - 1].toLowerCase();
    }
    function getIcon(dir: var): string {
        return IconsConf.dirs[dir.isRootOwned ? "rootOwned" : "default"];
    }

    function search(text: string, mode: string, results: var): var {
        if (!text || text.length < SearchConf.modes.find(m => m.name == "dirs").minChars)
            return;
        if (!results) {
            searchProcess.running = false;
            searchProcess.text = text;
            searchProcess.mode = mode;
            searchProcess.command = ["sh", "-c", `find ~ -name ".*" -type d -prune -o -iname "${text}*" -print 2>/dev/null`];
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
                if (!line || line == "\n" || searchProcess.count > MiscService.getMaxSearchResults("dirs", searchProcess.mode))
                    return;
                searchProcess.results.push(line);
                fileSearchService.search(searchProcess.dir, searchProcess.mode, searchProcess.results);
                searchProcess.count++;
            }
        }
    }

    function open(dir: var, inNewWs: bool): void {
        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            openTimer.dirToOpen = dir;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(`thunar '${dir.path}'`);
    }

    property Timer openTimer: Timer {
        property var dirToOpen: null
        interval: 100
        onTriggered: {
            if (dirToOpen) {
                parent.open(dirToOpen, false);
                dirToOpen = null;
            }
        }
    }
}
