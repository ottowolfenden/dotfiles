pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

QtObject {
    id: dirSearchService

    property var results: []

    function search(text: string, mode: string): void {
        if (text.length < SearchConf.modes.find(m => m.name == "dirs").minChars || UtilsService.getMaxSearchResults("dirs", mode) == 0) {
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
                get icon() {
                    return IconsConf.dirs[(() => {
                                let xdgDirName = Object.keys(PathsConf.xdgDirs).find(k => PathsConf.xdgDirs[k] == r.path);
                                if (xdgDirName)
                                    return "xdg" + xdgDirName;
                                if (r.hasGit)
                                    return "repo";
                                if (this.homeRelativePath == "~")
                                    return "home";
                                if (this.name.toLowerCase().includes("config"))
                                    return "conf";
                                return "default";
                            })()];
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
            max: UtilsService.getMaxSearchResults("dirs", mode),
            exclusions: SearchConf.pathExclusions.dirs.default
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text)
                    return;
                results = processScriptOutput(text);
                if (results.length < UtilsService.getMaxSearchResults("dirs", searchProc1.mode) && searchProc1.mode == "dirs") {
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
            max: UtilsService.getMaxSearchResults("dirs", mode) - results.length,
            exclusions: [...results.map(r => r.path), ...SearchConf.pathExclusions.dirs.always]
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text || results.length >= UtilsService.getMaxSearchResults("dirs", searchProc1.mode) || searchProc1.mode != "dirs")
                    return;
                results = [...results, ...processScriptOutput(text)];
            }
        }
    }

    function open(dir: var, bindsRef: var): void {
        const binds = UtilsService.clone(bindsRef);
        if (binds.inNewWs.active) {
            HyprlandService.focusWs("emptynm");
            openTimer.dirToOpen = dir;
            openTimer.binds = binds;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(`${(() => {
                    if (binds.inTerminal.active)
                        return "kitty";
                    else if (binds.inVsCode.active)
                        return "code";
                    else
                        return "thunar";
                })()} '${dir.path}'`);
        Quickshell.execDetached(["touch", "-a", dir.path]);
    }

    property Timer openTimer: Timer {
        property var dirToOpen: null
        property var binds: null
        interval: SearchConf.msToSwitchHyprlandWs
        onTriggered: {
            if (!dirToOpen || !binds)
                return;
            binds.inNewWs.active = false;
            parent.open(dirToOpen, binds);
            dirToOpen = null;
            binds = null;
        }
    }
}
