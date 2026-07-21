pragma Singleton
import QtQuick
import Quickshell.Io
import ".."
import "../.."

QtObject {
    id: webSearchService
    property var results: [...browserHistoryResults, ...suggestionResults].slice(0, getMax())
    property var suggestionResults: []
    property var browserHistoryResults: []
    property string mode

    function search(text: string, mode: string): var {
        if (text.length < SearchConf.modes.find(m => m.name == "web").minChars || getMax() == 0) {
            suggestionResults = browserHistoryResults = [];
            return;
        }

        webSearchProcess.input = browserHistoryProcess.input = text;
        webSearchProcess.running = browserHistoryProcess.running = true;
    }

    function reset() {
        suggestionResults = browserHistoryResults = [];
    }

    function getMax(type): int {
        let total = UtilsService.getMaxSearchResults("web", mode);
        if (type == "history")
            return Math.round(total * SearchConf.browserHistoryProportion);
        else if (type == "suggestion")
            return Math.round(total * (1 - SearchConf.browserHistoryProportion));
        else
            return total;
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

        return suggestions.map(s => ({
                    type: "suggestion",
                    text: s.trim(),
                    url: getSearchURL(s)
                })).slice(0, getMax("suggestion"));
    }

    property Process webSearchProcess: Process {
        id: webSearchProcess
        property var input: null
        command: input ? ["curl", webSearchService.getSuggestionsURL(input)] : []
        stdout: StdioCollector {
            onStreamFinished: webSearchService.suggestionResults = webSearchService.processSuggestionsOutput(text)
        }
    }

    function getBrowserHistoryCommand(input: string): var {
        let uri = `file:${PathsConf.chromiumHistory}?mode=ro&nolock=1`;
        input = UtilsService.escapeSqlWildcards(input);

        let sqlQuery = `
            SELECT url, title
            FROM (
                SELECT url, title FROM urls
                WHERE (
                    url LIKE '%${input}%'
                    OR title LIKE '%${input}%'
                )
                AND NOT (
                    hidden = 1
                    OR title = ''
                    OR title IS NULL
                    ${SearchConf.searchHistorySqlExclusions.map(s => `OR url LIKE '${s}'`).join(" ")}
                )
                ORDER BY (visit_count * 200) + (last_visit_time / 500000000000) DESC
                LIMIT ${getMax("history") * 10}
            )
            ORDER BY
                CASE
                    WHEN url LIKE 'http%://${input}%' THEN 1
                    WHEN url LIKE 'http%://www.${input}%' THEN 1
                    WHEN title LIKE '${input}%' THEN 1
                    WHEN url LIKE '%${input}%' THEN 2
                    WHEN title LIKE '%${input}%' THEN 3
                END ASC
            LIMIT ${getMax("history")};
        `;

        return ["sqlite3", "-json", uri, sqlQuery];
    }

    function processHistoryOutput(output: string): var {
        let history = (() => {
                try {
                    return JSON.parse(output);
                } catch (e) {
                    return [];
                }
            })() ?? [];

        history = history.map(h => ({
                    type: "history",
                    text: h.title.trim(),
                    url: h.url
                }));

        return UtilsService.getDistinctByAnyKeys(history, ["text", "url"]).slice(0, getMax("history"));
    }

    property Process browserHistoryProcess: Process {
        property var input: null
        command: webSearchService.getBrowserHistoryCommand(input)
        stdout: StdioCollector {
            onStreamFinished: webSearchService.browserHistoryResults = webSearchService.processHistoryOutput(text)
        }
    }

    function open(result: var, bindsRef: var, timerFinished: bool, activeClients: var): void {
        const binds = UtilsService.clone(bindsRef);
        if (binds?.inNewWs?.active && !timerFinished) {
            HyprlandService.focusWs("emptynm");
            openTimer.resultToOpen = result;
            openTimer.binds = binds;
            openTimer.running = true;
            return;
        } else if (binds?.inNewWs?.active && timerFinished) {
            HyprlandService.execWithQsTag(`${SearchConf.browserCommand} --new-window '${result.url}'`);
            return;
        }

        if (!activeClients) {
            HyprlandService.activeWsClientsProcess.callbackFunc = WebSearchService.open;
            HyprlandService.activeWsClientsProcess.leftParams = [result, false, false];
            HyprlandService.activeWsClientsProcess.running = true;
        } else {
            let flag = activeClients.map(c => c.class).includes(SearchConf.browserClass) ? "" : "--new-window";
            HyprlandService.execWithQsTag(`${SearchConf.browserCommand} ${flag} '${result.url}'`);
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
