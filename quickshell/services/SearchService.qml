pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."

QtObject {
    property FileView appHistoryFile: FileView {
        path: PathsConf.appHistory
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: setText("[]")
    }

    property var appHistory: JSON.parse(appHistoryFile.text() || "[]")

    function updateAppHistory(app: DesktopEntry): void {
        let entry = appHistory.find(a => a.id == app.id);
        if (entry)
            entry.lastOpened = Date.now();
        else
            appHistory.push({
                id: app.id,
                lastOpened: Date.now()
            });
        appHistoryFile.setText(JSON.stringify(appHistory, null, 4));
    }

    property FileView hiddenAppsFile: FileView {
        path: PathsConf.hiddenApps
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: setText("[]")
    }

    property list<string> hiddenApps: JSON.parse(hiddenAppsFile.text() || "[]")

    function hideApp(app: DesktopEntry): void {
        hiddenApps = MiscService.getDistinctNonNull([...hiddenApps, app.id]);
        hiddenAppsFile.setText(JSON.stringify(hiddenApps, null, 4));
    }

    function getMaxResults(modeProvider: string, mode: string): int {
        if (!["default", modeProvider].includes(mode))
            return 0;
        return SearchConf.modes.find(m => m.name == modeProvider).maxResults[mode == "default" ? "all" : "filtered"];
    }

    function searchApps(text: string, mode: string): list<DesktopEntry> {
        let max = getMaxResults("apps", mode);
        if (!text || !max || text.length == 0 || max == 0)
            return [];
        text = text.toLowerCase();
        let apps = DesktopEntries.applications.values.filter(a => !hiddenApps.includes(a.id));

        let hasWordPrefixMatches = attr => (attr ?? "").toLowerCase().split(" ").some(w => w.startsWith(text));
        let getLastOpened = app => appHistory.find(entry => entry.id == app.id)?.lastOpened ?? 0;
        let search = attr => {
            if (Array.isArray(attr))
                attr = attr.reduce((acc, el) => acc + el);
            let prefixMatches = ["name", "execString"].includes(attr) ? apps.filter(a => hasWordPrefixMatches(a[attr])) : [];
            let substringMatches = apps.filter(a => a[attr]?.toLowerCase().includes(text));
            return [...prefixMatches, ...substringMatches];
        };
        let allAttrsSearch = () => SearchConf.appAttrPriority.reduce((acc, attr) => [...acc, ...search(attr)], []);
        let recentSearch = () => {
            let matches = apps.filter(a => hasWordPrefixMatches(a["name"]) || hasWordPrefixMatches(a["execString"]));
            return matches.sort((a, b) => getLastOpened(b) - getLastOpened(a));
        };

        let sortedResults = [...recentSearch(), ...allAttrsSearch()];
        return MiscService.getDistinctNonNull(sortedResults).slice(0, max);
    }

    function execApp(app: DesktopEntry, inNewWs: bool): void {
        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            appExecTimer.appToExec = app;
            appExecTimer.running = true;
        } else
            HyprlandService.execWithQsTag(app.runInTerminal ? `kitty --class ${app.command[0]} -e ${app.command[0]}` : app.command.join(" "));
        updateAppHistory(app);
    }

    property Timer appExecTimer: Timer {
        property DesktopEntry appToExec: null
        interval: 100
        onTriggered: {
            if (appToExec) {
                parent.execApp(appToExec);
                appToExec = null;
            }
        }
    }
}
