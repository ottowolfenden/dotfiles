pragma Singleton
import QtQuick
import Quickshell.Io
import ".."
import "../.."

QtObject {
    id: root
    property var results: [...historyResults].slice(0, getMax())
    property var historyResults: []
    property string mode

    function search(text: string, mode: string): var {
        if (text.length < SearchConf.modes.find(m => m.name == "commands").minChars || getMax() == 0) {
            historyResults = [];
            return;
        }

        historyProcess.input = text;
        historyProcess.running = true;
    }

    function reset() {
        historyResults = [];
    }

    function getMax(type): int {
        let total = UtilsService.getMaxSearchResults("commands", mode);
        if (type == "history")
            return Math.round(total * SearchConf.browserHistoryProportion);
        if (type == "whence")
            return Math.round(total * (1 - SearchConf.browserHistoryProportion));
        return total;
    }

    property Process historyProcess: Process {
        property var input: null
        command: ["sh", "-c", `cat '${PathsConf.zshHistory}' | grep ";${input}.*"`]
        stdout: StdioCollector {
            onStreamFinished: {
                let entries = text.split("\n: ").map(l => ({
                            type: "history",
                            time: parseInt(l.split(";")[0].slice(0, -2)),
                            command: l.split(";")[1]
                        })).filter(e => e.time && e.command && !SearchConf.commandSubstrExclusions.some(ex => e.command.includes(ex)));
                let entriesCopy = [...entries];
                let seenCommands = new Set();
                let results = [];

                entriesCopy.forEach(entry => {
                    if (seenCommands.has(entry.command))
                        return;

                    let matchingEntries = entries.filter(e => entry.command == e.command);
                    matchingEntries.sort((a, b) => b.time - a.time);
                    let mostRecent = matchingEntries[0];

                    results.push(matchingEntries[0]);
                    seenCommands.add(entry.command);
                });

                results.sort((a, b) => b.time - a.time);
                root.historyResults = results;

                console.log(JSON.stringify(results, null, 2));
            }
        }
    }

    function exec(result: var, bindsRef: var) {
        const binds = UtilsService.clone(bindsRef);
        if (binds?.inNewWs?.active) {
            HyprlandService.focusWs("emptynm");
            openTimer.resultToOpen = result;
            openTimer.binds = binds;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(`kitty --hold -- zsh -ic "${result.command}"`);
    }

    property Timer openTimer: Timer {
        property var resultToOpen: null
        property var binds: null
        interval: SearchConf.msToSwitchHyprlandWs
        onTriggered: {
            if (!resultToOpen || !binds)
                return;
            binds.inNewWs.active = false;
            root.exec(resultToOpen, binds, true);
            resultToOpen = binds = null;
        }
    }
}
