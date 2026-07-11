pragma Singleton
import QtQuick
import Quickshell
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
}
