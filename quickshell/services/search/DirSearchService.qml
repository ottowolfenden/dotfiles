pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

QtObject {
    id: fileSearchService

    property var results: []

    function search(text: string, mode: string): void {
        if (text.length < SearchConf.modes.find(m => m.name == "dirs").minChars || MiscService.getMaxSearchResults("dirs", mode) == 0) {
            results = [];
            return;
        }
        searchProcess.running = false;
        searchProcess.input = text;
        searchProcess.mode = mode;
        searchProcess.running = true;
    }

    property Process searchProcess: Process {
        id: searchProcess
        property var input: null
        property var mode: null
        readonly property var pattern: ["*", "?", "[", "]"].some(w => (input ?? "").includes(w)) ? input : `*${input}*`
        command: [PathsConf.scripts + "find-fsentries.sh", SearchConf.dirParentDir, pattern, "d", "--exclude", ...SearchConf.fsEntryExclusions]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() == "" || !text) {
                    results = [];
                    return;
                }

                results = JSON.parse(text.trim()).map(r => Object.assign({}, r, {
                        get name() {
                            let parts = r.path.split("/");
                            return parts[parts.length - 1];
                        },
                        get format() {
                            let parts = this.name.split(".");
                            if (parts.length <= 1)
                                return "";
                            return parts[parts.length - 1].toLowerCase();
                        },
                        get icon() {
                            if (r.hasGit)
                                return IconsConf.dirs.repo;
                            if (r.path == (Quickshell.env("HOME")))
                                return IconsConf.dirs.home;
                            if (r.isRootOwned)
                                return IconsConf.dirs.rootOwned;
                            if (r.path.includes("config"))
                                return IconsConf.dirs.conf;
                            return IconsConf.dirs.default;
                        },
                        get homeRelativePath() {
                            if (r.path.startsWith(Quickshell.env("HOME")))
                                return r.path.replace(Quickshell.env("HOME"), "~");
                            return r.path;
                        }
                    }));
                fileSearchService.sortResults(searchProcess.input);
            }
        }
    }

    function sortResults(input: string): void {
        let sort = array => [...array].sort((a, b) => b.accessed - a.accessed);
        let namePrefixMatches = sort(results.filter(r => r.name.toLowerCase().startsWith(input.toLowerCase())));
        let nameSubstringMatches = sort(results.filter(r => r.name.toLowerCase().includes(input.toLowerCase())));
        let otherMatches = sort(results);
        let sortedResults = MiscService.getDistinctNonNull([...namePrefixMatches, ...nameSubstringMatches, ...otherMatches]);
        results = sortedResults.slice(0, MiscService.getMaxSearchResults("dirs", searchProcess.mode));
    }

    function open(dir: var, inNewWs: bool): void {
        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            openTimer.dirToOpen = dir;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(`thunar '${dir.path}'`);
        Quickshell.execDetached(["touch", "-a", dir.path]);
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
