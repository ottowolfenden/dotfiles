pragma Singleton
import QtQuick
import Quickshell.Networking
import ".."

QtObject {
    function clamp(num: real, min: real, max: real): real {
        return Math.min(Math.max(num, min), max);
    }

    function secsToHrsMins(secs: real): string {
        secs = Math.round(secs);

        if (secs <= 0)
            return "0 secs";

        var hrs = Math.trunc(secs / 3600);
        var minsLeft = Math.trunc((secs % 3600) / 60);
        var secsLeft = secs % 60;

        var hrsLabel = "hr" + (hrs == 1 ? "" : "s");
        var minsLabel = "min" + (minsLeft == 1 ? "" : "s");
        var secsLabel = "sec" + (secsLeft == 1 ? "" : "s");

        if (hrs == 0 && minsLeft == 0)
            return `${secsLeft} ${secsLabel}`;
        if (hrs == 0)
            return `${minsLeft} ${minsLabel}`;
        return `${hrs} ${hrsLabel} ${minsLeft} ${minsLabel}`;
    }

    function getDistinctNonNull(array: var): var {
        return [...new Set(array.filter(el => el != null))];
    }

    function getDistinctByAnyKeys(array: var, keys: var): var {
        for (const key of keys) {
            let seen = new Set();
            array = array.filter(el => {
                const value = el[key];
                if (seen.has(value))
                    return false;
                seen.add(value);
                return true;
            });
        }
        return array;
    }

    function getMaxSearchResults(modeProvider: string, mode: string): int {
        if (!modeProvider || !mode || !["default", modeProvider].includes(mode))
            return 0;
        return SearchConf.modes.find(m => m.name == modeProvider).maxResults[mode == "default" ? "all" : "filtered"];
    }

    function clone(obj: var): var {
        if (obj)
            return JSON.parse(JSON.stringify(obj));
    }

    function getRandBetween(min: real, max: real): double {
        return Math.random() * (max - min) + min;
    }

    function replaceAll(str: string, pattern: string, replacement: string): string {
        return str.replace(new RegExp(pattern, 'g'), replacement);
    }

    function escapeSqlWildcards(str) {
        return str.replace(/\\/g, "\\\\").replace(/%/g, "\\%").replace(/_/g, "\\_");
    }

    function isInternetDisconnected() {
        return ![NetworkConnectivity.Full, NetworkConnectivity.Unknown].includes(Networking.connectivity);
    }
}
