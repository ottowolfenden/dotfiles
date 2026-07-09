pragma Singleton
import QtQuick
import Quickshell
import ".."

QtObject {
    function searchApps(text, max) {
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
        let getDistinctNonNull = array => [...new Set(array)].filter(el => el);

        let results = SearchConf.appAttrPriority.reduce((acc, attr) => [...acc, ...search(attr)], []);

        return getDistinctNonNull(results).slice(0, max);
    }
}
