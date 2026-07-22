pragma Singleton
import QtQuick
import Quickshell
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

    function processHistoryOutput(output: string) {
        let entries = output.split("\n: ").map(l => ({
                    type: "history",
                    time: parseInt(l.split(";")[0].slice(0, -2)),
                    command: l.split(";")[1].trim()
                })).filter(e => e.time && e.command);
        let entriesCopy = [...entries];
        let seenCommands = new Set();
        let results = [];

        entriesCopy.forEach(entry => {
            if (seenCommands.has(entry.command))
                return;

            let excluded = SearchConf.commandSubstrExclusions.some(ex => entry.command.includes(ex));

            let matchingEntries = entries.filter(e => entry.command == e.command && !excluded);
            matchingEntries.sort((a, b) => b.time - a.time);

            matchingEntries.forEach(e => e.command = e.command.trim());

            results.push(matchingEntries[0]);
            seenCommands.add(entry.command);
        });

        results.sort((a, b) => b.time - a.time);
        root.historyResults = UtilsService.getDistinctNonNull(results);
    }

    property Process historyProcess: Process {
        property var input: null
        command: ["sh", "-c", `cat '${PathsConf.zshHistory}' | grep ";${input}.*"`]
        stdout: StdioCollector {
            onStreamFinished: root.processHistoryOutput(text.trim())
        }
    }

    function exec(result: var, bindsRef: var) {
        const binds = UtilsService.clone(bindsRef);
        if (binds?.inNewWs?.active) {
            HyprlandService.focusWs("emptynm");
            openTimer.resultToOpen = result;
            openTimer.binds = binds;
            openTimer.running = true;
        } else {
            Quickshell.execDetached(["zsh", "-ic", `print -s "${result.command}"`]);
            HyprlandService.execWithQsTag(`kitty -- zsh -ic '${result.command}; echo; exec zsh'`);
        }
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
