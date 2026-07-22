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

    function processHistoryOutput(input: string, output: string) {
        let entries = UtilsService.getDistinctNonNull(output.trim().split("\n").map(line => {
            let prefix = line.slice(0, line.indexOf(";"));
            let command = line.slice(line.indexOf(";") + 1);
            let time = prefix.split(":")[1];
            if (!time || !command)
                return;
            return {
                type: "history",
                time: parseInt(time.trim()),
                command: command.trim()
            };
        })).filter(entry => {
            let isExcluded = SearchConf.commandSubstrExclusions.some(ex => entry.command.includes(ex));
            let isTooLong = entry.command.length > SearchConf.maxCommandChars;
            let isMultiLine = entry.command.endsWith("\\");
            return !isExcluded && !isTooLong && !isMultiLine;
        });

        let recencySort = array => [...array].sort((a, b) => b.time - a.time);
        let isPrefixMatch = r => r.command.toLowerCase().startsWith(input.toLowerCase());
        let seenCommands = new Set();
        let prefixMatches = [];
        let substringMatches = [];

        [...entries].forEach(entry => {
            if (seenCommands.has(entry.command))
                return;
            let matchingEntries = entries.filter(e => entry.command == e.command);
            let mostRecentEntry = recencySort(matchingEntries)[0];
            if (isPrefixMatch(mostRecentEntry))
                prefixMatches.push(mostRecentEntry);
            else
                substringMatches.push(mostRecentEntry);
            seenCommands.add(entry.command);
        });

        root.historyResults = [...recencySort(prefixMatches), ...recencySort(substringMatches)];
    }

    property Process historyProcess: Process {
        id: historyProcess
        property var input: null
        command: ["sh", "-c", `grep -Ei ':[ 0-9]+:[0-9]+;.*${input}' ${PathsConf.zshHistory}`]
        stdout: StdioCollector {
            onStreamFinished: root.processHistoryOutput(historyProcess.input, text)
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
