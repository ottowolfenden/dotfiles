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
        hiddenApps = UtilsService.getDistinctNonNull([...hiddenApps, app.id]);
        hiddenAppsFile.setText(JSON.stringify(hiddenApps, null, 4));
    }

    function search(text: string, mode: string): list<DesktopEntry> {
        let max = UtilsService.getMaxSearchResults("apps", mode);
        if (!text || text.length < SearchConf.modes.find(m => m.name == "apps").minChars || max == 0)
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
        return UtilsService.getDistinctNonNull(sortedResults).slice(0, max);
    }

    function open(app: DesktopEntry, bindsRef: var): void {
        const binds = UtilsService.clone(bindsRef);
        if (binds.inNewWs.active) {
            HyprlandService.focusWs("emptynm");
            openTimer.appToExec = app;
            openTimer.binds = binds;
            openTimer.running = true;
        } else
            HyprlandService.execWithQsTag(app.runInTerminal ? `kitty --class ${app.command[0]} -e ${app.command[0]}` : app.command.join(" "));
        updateHistory(app);
    }

    property Timer openTimer: Timer {
        property DesktopEntry appToExec: null
        property var binds: null
        interval: 100
        onTriggered: {
            if (!appToExec || !binds)
                return;
            binds.inNewWs.active = false;
            parent.open(appToExec, binds);
            appToExec = null;
            binds = null;
        }
    }
}
