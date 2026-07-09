pragma Singleton
import QtQuick
import Quickshell

QtObject {
    function getApps(text, max) {
        if (!text || text.length == 0 || max == 0)
            return [];

        let search = attr => DesktopEntries.applications.values.filter(a => a[attr].toLowerCase().includes(text.toLowerCase()));
        let getDistinct = array => [...new Set(array)];

        return getDistinct([DesktopEntries.heuristicLookup(text), ...["name", "execString", "genericName", "comment"].flatMap(search)]).filter(el => el).slice(0, max);
    }
}
