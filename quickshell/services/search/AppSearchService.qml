pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."
import "../.."

QtObject {
    property FileView historyFile: FileView {
        path: PathsConf.appHistory
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: setText("[]")
    }

    property var history: JSON.parse(historyFile.text() || "[]")

    function updateHistory(app: DesktopEntry): void {
        let entry = history.find(a => a.id == app.id);
        if (entry)
            entry.lastOpened = Date.now();
        else
            history.push({
                id: app.id,
                lastOpened: Date.now()
            });
        historyFile.setText(JSON.stringify(history, null, 4));
    }

    property FileView hiddenAppsFile: FileView {
        path: PathsConf.hiddenApps
        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: setText("[]")
    }

    property list<string> hiddenApps: JSON.parse(hiddenAppsFile.text() || "[]")

    function hide(app: DesktopEntry): void {
        hiddenApps = MiscService.getDistinctNonNull([...hiddenApps, app.id]);
        hiddenAppsFile.setText(JSON.stringify(hiddenApps, null, 4));
    }

    function search(text: string, mode: string): list<DesktopEntry> {
        let max = MiscService.getMaxSearchResults("apps", mode);
        if (!text || text.length == 0 || max == 0)
            return [];
        text = text.toLowerCase();
        let apps = DesktopEntries.applications.values.filter(a => !hiddenApps.includes(a.id));

        let hasWordPrefixMatches = attr => (attr ?? "").toLowerCase().split(" ").some(w => w.startsWith(text));
        let getLastOpened = app => history.find(entry => entry.id == app.id)?.lastOpened ?? 0;
        let allAppsSearch = attr => {
            if (Array.isArray(attr))
                attr = attr.reduce((acc, el) => acc + el);
            let prefixMatches = ["name", "execString"].includes(attr) ? apps.filter(a => hasWordPrefixMatches(a[attr])) : [];
            let substringMatches = apps.filter(a => a[attr]?.toLowerCase().includes(text));
            return [...prefixMatches, ...substringMatches];
        };
        let allAttrsSearch = () => SearchConf.appAttrPriority.reduce((acc, attr) => [...acc, ...allAppsSearch(attr)], []);
        let recentSearch = () => {
            let matches = apps.filter(a => hasWordPrefixMatches(a["name"]) || hasWordPrefixMatches(a["execString"]));
            return matches.sort((a, b) => getLastOpened(b) - getLastOpened(a));
        };

        let sortedResults = [...recentSearch(), ...allAttrsSearch()];
        return MiscService.getDistinctNonNull(sortedResults).slice(0, max);
    }

    function exec(app: DesktopEntry, inNewWs: bool): void {
        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            execTimer.appToExec = app;
            execTimer.running = true;
        } else
            HyprlandService.execWithQsTag(app.runInTerminal ? `kitty --class ${app.command[0]} -e ${app.command[0]}` : app.command.join(" "));
        updateHistory(app);
    }

    property Timer execTimer: Timer {
        property DesktopEntry appToExec: null
        interval: 100
        onTriggered: {
            if (appToExec) {
                parent.exec(appToExec);
                appToExec = null;
            }
        }
    }
}
