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
        command: {
            let c = [];
            let script = PathsConf.scripts + "find-fsentries.sh";
            let max = MiscService.getMaxSearchResults("dirs", mode);
            let exclusionsFlag = mode == "dirs" ? "--appendexclusions" : "--hideexclusions";
            return [script, SearchConf.dirParentDir, input, "d", max, exclusionsFlag, "--exclude", ...SearchConf.fsEntryExclusions];
        }
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
            }
        }
    }

    function open(dir: var, inNewWs: bool, inTerminal: bool): void {
        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            openTimer.dirToOpen = dir;
            openTimer.inTerminal = inTerminal;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(`${inTerminal ? "kitty" : "thunar"} '${dir.path}'`);
        Quickshell.execDetached(["touch", "-a", dir.path]);
    }

    property Timer openTimer: Timer {
        property var dirToOpen: null
        property var inTerminal: null
        interval: 100
        onTriggered: {
            if (dirToOpen) {
                parent.open(dirToOpen, false, inTerminal);
                dirToOpen = null;
                inTerminal = null;
            }
        }
    }
}
