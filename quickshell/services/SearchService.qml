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

    function searchApps(text: string, max: int): list<DesktopEntry> {
        if (!text || text.length == 0 || max == 0)
            return [];
        text = text.toLowerCase();

        let search = attr => {
            if (Array.isArray(attr))
                attr = attr.reduce((acc, el) => acc + el);
            let startsWith = ["name", "execString"].includes(attr) ? DesktopEntries.applications.values.filter(a => a[attr]?.toLowerCase().startsWith(text)) : [];
            let includes = text.length >= 2 ? DesktopEntries.applications.values.filter(a => a[attr]?.toLowerCase().includes(text)) : [];
            return [...startsWith, ...includes];
        };
        let getLastOpened = app => appHistory.find(entry => entry.id == app.id)?.lastOpened ?? 0;
        let getDistinctNonNull = array => [...new Set(array)].filter(el => el);

        let results = SearchConf.appAttrPriority.reduce((acc, attr) => [...acc, ...search(attr)], []);
        results = results.sort((a, b) => getLastOpened(b) - getLastOpened(a));
        return getDistinctNonNull(results).slice(0, max);
    }
}
