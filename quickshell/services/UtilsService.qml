pragma Singleton
import QtQuick
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

    function formatItems(n, itemName) {
        if (n == 1)
            return n + (itemName ? " " + itemName : "");

        let units = ["", "K", "M", "B", "T", "Qa"];
        let log1000 = n => Math.log(n) / Math.log(1000);

        let suffix = itemName ? ` ${itemName}s` : "";
        let i = Math.floor(log1000(n));
        let num = (n / (1000 ** i));
        num = num.toFixed(n > 1000 && Math.round(num).toString().length <= 2 && !num.toFixed(1).toString().endsWith("0"));
        return num + units[i] + suffix;
    }

    function formatBytes(bytes) {
        if (bytes < 1024)
            return `${bytes} B`;

        let units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB"];
        let log1024 = n => Math.log(n) / Math.log(1024);

        let i = Math.floor(log1024(bytes));
        let num = (bytes / (1024 ** i));
        num = num.toFixed(Math.round(num).toString().length <= 2 && !num.toFixed(1).toString().endsWith("0"));
        return `${num} ${units[i]}`;
    }
}
