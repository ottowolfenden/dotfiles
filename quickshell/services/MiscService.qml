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

    function getFileFormatIcon(fileExt: string): string {
        if (fileExt.startsWith("."))
            fileExt = fileExt.replace(".", "");
        return Object.keys(IconsConf.fileFormats).find(icon => IconsConf.fileFormats[icon].includes(fileExt.toLowerCase())) ?? IconsConf.otherFileFormat;
    }

    function toOpaque(colour) {
        if (!colour || colour.length == 7)
            return colour;

        let bg = ModeService.mode == "light" ? 0xff : 0x00;

        let a = parseInt(colour.substring(1, 3), 16) / 0xff;
        let r = parseInt(colour.substring(3, 5), 16);
        let g = parseInt(colour.substring(5, 7), 16);
        let b = parseInt(colour.substring(7, 9), 16);

        r = Math.round((r * a) + (bg * (1 - a)));
        g = Math.round((g * a) + (bg * (1 - a)));
        b = Math.round((b * a) + (bg * (1 - a)));

        let toHex = val => val.toString(16).padStart(2, '0').toUpperCase();
        return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
    }
}
