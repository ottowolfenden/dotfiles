pragma Singleton
import QtQuick
import Quickshell.Io
import ".."
import "../.."

QtObject {
    id: webSearchService
    property var results: []
    property string mode

    function search(text: string, mode: string): var {
        if (text.length < SearchConf.modes.find(m => m.name == "web").minChars || getMax() == 0) {
            results = [];
            return;
        }

        webSearchProcess.input = text;
        webSearchProcess.running = true;
    }

    function getMax(): int {
        return UtilsService.getMaxSearchResults("web", mode);
    }

    function getSuggestionsURL(input: string): string {
        let url = "https://ac.duckduckgo.com/ac/";
        let firstSep = url.includes("?") ? "&" : "?";
        let region = encodeURIComponent(SearchConf.searchEngineRegion);
        let query = encodeURIComponent(input);
        return url + `${firstSep}type=list&kl=${region}&q=${query}`;
    }

    function getSearchURL(input: string): string {
        let url = "https://duckduckgo.com/";
        let firstSep = url.includes("?") ? "&" : "?";
        let region = encodeURIComponent(SearchConf.searchEngineRegion);
        let query = encodeURIComponent(input);
        return url + `${firstSep}kl=${region}&q=${query}`;
    }

    function processSuggestionsOutput(output: string): var {
        let suggestions = (() => {
                try {
                    return JSON.parse(output)[1];
                } catch (e) {
                    return [];
                }
            })() ?? [];

        return suggestions.slice(0, getMax());
    }

    property Process webSearchProcess: Process {
        id: webSearchProcess
        property var input: null
        command: input ? ["curl", webSearchService.getSuggestionsURL(input)] : []
        stdout: StdioCollector {
            onStreamFinished: webSearchService.results = webSearchService.processSuggestionsOutput(text)
        }
    }

    function open(result: var, bindsRef: var, timerFinished: bool): void {
        const binds = UtilsService.clone(bindsRef);
        if (binds?.inNewWs?.active && !timerFinished) {
            HyprlandService.focusWs("emptynm");
            openTimer.resultToOpen = result;
            openTimer.binds = binds;
            openTimer.running = true;
        } else {
            let flag = binds?.inNewWs?.active ? "--new-window" : "";
            HyprlandService.execWithQsTag(`${SearchConf.browserCommand} ${flag} '${getSearchURL(result)}'`);
        }
    }

    property Timer openTimer: Timer {
        property var resultToOpen: null
        property var binds: null
        interval: SearchConf.msToSwitchHyprlandWs
        onTriggered: {
            if (!resultToOpen || !binds)
                return;
            webSearchService.open(resultToOpen, binds, true);
            resultToOpen = binds = null;
        }
    }
}
