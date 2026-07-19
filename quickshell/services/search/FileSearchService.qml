pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

QtObject {
    id: fileSearchService

    property var results: []
    property bool searchOpen: false
    property string mode
    property var lastHideOutputCall: null
    property bool loading: false

    function search(text: string): void {
        if (text.length < SearchConf.modes.find(m => m.name == "files").minChars || getMax() == 0) {
            results = [];
            return;
        }

        searchProc.running = false;
        searchProc.input = text;
        searchProc.running = true;
    }

    function getMax() {
        return UtilsService.getMaxSearchResults("files", mode);
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
                get homeRelativePathPrefix() {
                    return this.homeRelativePath.slice(0, -this.name.length - 1);
                },
                get fileExt() {
                    return this.name.includes(".") ? this.name.substring(this.name.lastIndexOf(".")) : "";
                },
                get icon() {
                    let format = this.fileExt.toLowerCase().replace(".", "");
                    let icon = Object.keys(IconsConf.fileFormats).find(k => IconsConf.fileFormats[k].includes(format));
                    return icon ?? IconsConf.otherFileFormat;
                },
                split() {
                    let nameNoExt = this.fileExt == "" ? this.name : this.name.slice(0, -this.fileExt.length);
                    return [nameNoExt, this.fileExt];
                }
            }));
    }

    function getSearchCommand(opts: var): var {
        return [PathsConf.scripts + "find.sh", opts.dir, opts.text, "f", opts.max, "--exclude", ...opts.exclusions];
    }

    function hideOutput(): void {
        lastHideOutputCall = Date.now();
        searchProc.running = extraSearchProc.running = false;
        fileSearchService.loading = false;
    }

    property Process searchProc: Process {
        property var input: null
        property var startedDate: null
        onRunningChanged: startedDate = running ? Date.now() : null
        command: getSearchCommand({
            dir: SearchConf.fileParentDir,
            text: input,
            max: getMax(),
            exclusions: SearchConf.pathExclusions.files.default
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text || !searchOpen || lastHideOutputCall > searchProc.startedDate)
                    return;
                results = processScriptOutput(text);
                if (results.length < getMax() && mode == "files" && searchOpen) {
                    extraSearchProc.running = false;
                    extraSearchProc.input = searchProc.input;
                    extraSearchProc.running = true;
                    fileSearchService.loading = true;
                }
            }
        }
    }

    property Process extraSearchProc: Process {
        property var input: null
        property var startedDate: null
        onRunningChanged: startedDate = running ? Date.now() : null
        command: getSearchCommand({
            dir: SearchConf.fileParentDir,
            text: input,
            max: getMax() - results.length,
            exclusions: [...results.map(r => r.path), ...SearchConf.pathExclusions.files.always]
        })
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text || results.length >= getMax() || mode != "files" || !searchOpen || lastHideOutputCall > extraSearchProc.startedDate)
                    return;
                fileSearchService.loading = false;
                results = [...results, ...processScriptOutput(text)];
            }
        }
    }

    function open(file: var, bindsRef: var, checkStatus: var): void {
        const binds = UtilsService.clone(bindsRef);
        if (!checkStatus) {
            checkCanOpenProcess.file = file;
            checkCanOpenProcess.binds = binds;
            checkCanOpenProcess.running = true;
        } else if (binds?.inNewWs?.active) {
            HyprlandService.focusWs("emptynm");
            openTimer.fileToOpen = file;
            openTimer.checkStatus = checkStatus;
            openTimer.binds = binds;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(`${(() => {
                    if (binds?.inVsCode?.active)
                        return "code";
                    if (checkStatus == "success")
                        return "xdg-open";
                    if (checkStatus == "fail")
                        return "thunar";
                })()} '${file.path}'`);
        Quickshell.execDetached(["touch", "-a", file.path]);
    }

    property Process checkCanOpenProcess: Process {
        id: checkCanOpenProcess
        property var file: null
        property var binds: null
        command: file?.path ? ["sh", "-c", `xdg-mime query default $(xdg-mime query filetype '${file.path}')`] : []
        stdout: StdioCollector {
            onStreamFinished: {
                fileSearchService.open(checkCanOpenProcess.file, checkCanOpenProcess.binds, text.trim() == "" ? "fail" : "success");
                checkCanOpenProcess.file = null;
                checkCanOpenProcess.binds = null;
            }
        }
    }

    property Timer openTimer: Timer {
        property var fileToOpen: null
        property var binds: null
        property var checkStatus: null
        interval: SearchConf.msToSwitchHyprlandWs
        onTriggered: {
            if (!fileToOpen || !binds || !checkStatus)
                return;
            binds.inNewWs.active = false;
            parent.open(fileToOpen, binds, checkStatus);
            fileToOpen = null;
            binds = null;
            checkStatus = null;
        }
    }
}
