pragma Singleton
import QtQuick
import ".."

QtObject {
    property var theme: ModeService.mode == "light" ? lightTheme : darkTheme

    readonly property var lightTheme: ({
            bg1: "#ffffff",
            bg2: "#03000000",
            bg3: "#05000000",
            bg4: "#09000000",
            bg5: "#0c000000",
            bg6: "#0f000000",
            fg1: "#e0000000",
            fg2: "#a0000000",
            fg3: "#7b000000",
            fg4: "#48000000",
            fg5: "#15000000",
            invfg: "#ffffff",
            cutoutbg: "#cff8f8f8",
            inactivebg: "#08000000",
            hoveredbg: "#0e000000",
            pressedbg: "#1e000000",
            selectedbg: "#184285f4",
            textselectionbg: "#28000000",
            red: "#ea4335",
            orange: "#fd6132",
            yellow: "#f1b911",
            green: "#34a853",
            lightblue: "#4285f4",
            darkblue: "#0057ca",
            purple: "#7248b9",
            pink: "#ff80ab"
        })

    readonly property var darkTheme: ({
            bg1: "#000000",
            bg2: "#08ffffff",
            bg3: "#0bffffff",
            bg4: "#0effffff",
            bg5: "#11ffffff",
            bg6: "#14ffffff",
            fg1: "#e0ffffff",
            fg2: "#a0ffffff",
            fg3: "#7bffffff",
            fg4: "#48ffffff",
            fg5: "#15ffffff",
            invfg: "#000000",
            cutoutbg: "#10ffffff",
            inactivebg: "#0effffff",
            hoveredbg: "#12ffffff",
            pressedbg: "#1effffff",
            selectedbg: "#1889ddff",
            textselectionbg: "#28ffffff",
            red: "#f07178",
            orange: "#f78c6c",
            yellow: "#ffcb6b",
            green: "#c3e88d",
            lightblue: "#89ddff",
            darkblue: "#82aaff",
            purple: "#c792ea",
            pink: "#ff9cac"
        })

    function createColour(colour: string): var {
        if (!colour || colour.length != 9)
            return colour;

        return {
            get translucent() {
                return colour;
            },
            get opaque() {
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
            },
            get t() {
                return this.translucent;
            },
            get o() {
                return this.opaque;
            }
        };
    }

    readonly property var bg1: createColour(theme.bg1)
    readonly property var bg2: createColour(theme.bg2)
    readonly property var bg3: createColour(theme.bg3)
    readonly property var bg4: createColour(theme.bg4)
    readonly property var bg5: createColour(theme.bg5)
    readonly property var bg6: createColour(theme.bg6)
    readonly property var fg1: createColour(theme.fg1)
    readonly property var fg2: createColour(theme.fg2)
    readonly property var fg3: createColour(theme.fg3)
    readonly property var fg4: createColour(theme.fg4)
    readonly property var fg5: createColour(theme.fg5)
    readonly property var invfg: createColour(theme.invfg)
    readonly property var cutoutbg: createColour(theme.cutoutbg)
    readonly property var inactivebg: createColour(theme.inactivebg)
    readonly property var hoveredbg: createColour(theme.hoveredbg)
    readonly property var pressedbg: createColour(theme.pressedbg)
    readonly property var selectedbg: createColour(theme.selectedbg)
    readonly property var textselectionbg: createColour(theme.textselectionbg)
    readonly property var red: createColour(theme.red)
    readonly property var orange: createColour(theme.orange)
    readonly property var yellow: createColour(theme.yellow)
    readonly property var green: createColour(theme.green)
    readonly property var lightblue: createColour(theme.lightblue)
    readonly property var darkblue: createColour(theme.darkblue)
    readonly property var purple: createColour(theme.purple)
    readonly property var pink: createColour(theme.pink)
}
