pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

QtObject {
    id: dirSearchService

    property var results: []
    property bool searchOpen: false
    property string mode
    property var lastHideOutputCall: null
    property bool loading: false
    onModeChanged: {
        if (loading && mode != "dirs")
            loading = false;
    }

    function search(text: string): void {
        if (text.startsWith("~"))
            text = text.replace("~", Quickshell.env("HOME"));

        if (text.length < SearchConf.modes.find(m => m.name == "dirs").minChars || getMax() == 0) {
            results = [];
            return;
        }

        searchProc.running = false;
        searchProc.input = text;
        searchProc.running = true;
    }

    function getMax() {
        return UtilsService.getMaxSearchResults("dirs", mode);
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
                                if (["conf", "setting"].some(s => this.name.toLowerCase().includes(s)))
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
        return [PathsConf.scripts + "find.sh", opts.dir, opts.text, "d", opts.max, "--exclude", ...opts.exclusions];
    }

    function hideOutput(): void {
        lastHideOutputCall = Date.now();
        searchProc.running = extraSearchProc.running = false;
    }

    property Process searchProc: Process {
        property var input: null
        property var startedDate: null
        onRunningChanged: startedDate = running ? Date.now() : null
        command: getSearchCommand({
            dir: SearchConf.dirParentDir,
            text: input,
            max: getMax(),
            exclusions: SearchConf.pathExclusions.dirs.default
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text || !searchOpen || lastHideOutputCall > searchProc.startedDate)
                    return;
                results = processScriptOutput(text);
                if (results.length < getMax() && mode == "dirs" && searchOpen) {
                    extraSearchProc.running = false;
                    extraSearchProc.input = searchProc.input;
                    extraSearchProc.running = true;
                    dirSearchService.loading = true;
                }
            }
        }
    }

    property Process extraSearchProc: Process {
        property var input: null
        property var startedDate: null
        onRunningChanged: startedDate = running ? Date.now() : null
        command: getSearchCommand({
            dir: SearchConf.dirParentDir,
            text: input,
            max: getMax() - results.length,
            exclusions: [...results.map(r => r.path), ...SearchConf.pathExclusions.dirs.always]
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text || results.length >= getMax() || mode != "dirs" || !searchOpen || lastHideOutputCall > extraSearchProc.startedDate)
                    return;
                dirSearchService.loading = false;
                results = [...results, ...processScriptOutput(text)];
            }
        }
    }

    function open(dir: var, bindsRef: var): void {
        const binds = UtilsService.clone(bindsRef);
        if (binds?.inNewWs?.active) {
            HyprlandService.focusWs("emptynm");
            openTimer.dirToOpen = dir;
            openTimer.binds = binds;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(`${(() => {
                    if (binds?.inTerminal?.active)
                        return "kitty";
                    else if (binds?.inVsCode?.active || dir.hasGit)
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
