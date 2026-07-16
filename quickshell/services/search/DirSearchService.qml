pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

QtObject {
    id: dirSearchService

    property var results: []

    function search(text: string, mode: string): void {
        if (text.length < SearchConf.modes.find(m => m.name == "dirs").minChars || MiscService.getMaxSearchResults("dirs", mode) == 0) {
            results = [];
            return;
        }
        searchProc1.running = false;
        searchProc1.input = text;
        searchProc1.mode = mode;
        searchProc1.running = true;
    }

    function processScriptOutput(output) {
        return JSON.parse(output).map(r => Object.assign({}, r, {
                get name() {
                    let parts = r.path.split("/");
                    return parts[parts.length - 1];
                },
                get homeRelativePath() {
                    if (r.path.startsWith(Quickshell.env("HOME")))
                        return r.path.replace(Quickshell.env("HOME"), "~");
                    return r.path;
                },
                split() {
                    if (this.homeRelativePath == "~")
                        return ["", "~"];
                    return [this.homeRelativePath.slice(0, -this.name.length).trim(), this.name.trim()];
                }
            }));
    }

    function getSearchCommand(opts: var): var {
        return [PathsConf.scripts + "find-fsentries.sh", opts.dir, opts.text, "d", opts.max, "--exclude", ...opts.exclusions];
    }

    property Process searchProc1: Process {
        property var input: null
        property var mode: null
        command: getSearchCommand({
            dir: SearchConf.dirParentDir,
            text: input,
            max: MiscService.getMaxSearchResults("dirs", mode),
            exclusions: SearchConf.pathExclusions.dirs.default
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text)
                    return;
                results = processScriptOutput(text);
                if (results.length < MiscService.getMaxSearchResults("dirs", searchProc1.mode) && searchProc1.mode == "dirs") {
                    searchProc2.running = false;
                    searchProc2.input = searchProc1.input;
                    searchProc2.mode = searchProc1.mode;
                    searchProc2.running = true;
                }
            }
        }
    }

    property Process searchProc2: Process {
        property var input: null
        property var mode: null
        command: getSearchCommand({
            dir: SearchConf.dirParentDir,
            text: input,
            max: MiscService.getMaxSearchResults("dirs", mode) - results.length,
            exclusions: [...results.map(r => r.path), ...SearchConf.pathExclusions.dirs.always]
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text || results.length >= MiscService.getMaxSearchResults("dirs", searchProc1.mode) || searchProc1.mode != "dirs")
                    return;
                results = [...results, ...processScriptOutput(text)];
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
