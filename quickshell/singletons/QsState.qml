pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."
import "../components"

QtObject {
    id: qsState

    property var darkMode: null
    property Process darkModeProcess: Process {
        command: "gsettings get org.gnome.desktop.interface color-scheme".split(" ")
        running: true
        stdout: StdioCollector {
            onStreamFinished: qsState.darkMode = text.trim() == "'prefer-dark'"
        }
    }

    property list<Flyout> flyouts: []
    property IpcHandler flyoutsHandler: IpcHandler {
        target: "flyoutsHandler"
        function hideNonHoveredFlyouts() {
            for (const flyout of qsState.flyouts)
                if (!flyout.hovering)
                    flyout.isOpen = false;
            if (![...qsState.flyouts, ...qsState.bafs].some(x => x.hovering))
                Quickshell.execDetached(Config.hyprlandCommands.reset);
        }
    }
    function hideAllFlyouts() {
        for (const flyout of qsState.flyouts)
            flyout.isOpen = false;
        Quickshell.execDetached(Config.hyprlandCommands.reset);
    }
    function hideAllFlyoutsExcept(openFlyout) {
        for (const flyout of qsState.flyouts)
            if (flyout != openFlyout)
                flyout.isOpen = false;
        Quickshell.execDetached(Config.hyprlandCommands[qsState.flyouts.some(f => f.isOpen) ? "flyoutOpen" : "reset"]);
    }

    property list<BottomAutoFlyout> bafs: []
    property IpcHandler bafsHandler: IpcHandler {
        target: "bafsHandler"
        function showBaf(type: string): void {
            for (const baf of qsState.bafs)
                if (baf.type == type) {
                    baf.isOpen = true;
                    baf.autoHideTimer.restart();
                }
            Quickshell.execDetached(Config.hyprlandCommands[qsState.bafs.some(b => b.isOpen) ? "bafOpen" : "reset"]);
        }
        function hideAllBafs(): void {
            for (const baf of qsState.bafs)
                if (!baf.hovering)
                    baf.isOpen = false;
            if (![...qsState.flyouts, ...qsState.bafs].some(x => x.hovering))
                Quickshell.execDetached(Config.hyprlandCommands.reset);
        }
    }
    function hideBaf(baf: BottomAutoFlyout): void {
        if (baf.hovering) {
            baf.autoHideTimer.restart();
            return;
        }
        baf.isOpen = false;
        if (!qsState.flyouts.some(f => f.isOpen))
            Quickshell.execDetached(Config.hyprlandCommands.reset);
    }

    property string dailyWallpaperPath
    property Process dailyWallpaperProcess: Process {
        command: [Config.scriptsDir + "daily-wallpaper.sh", qsState.darkMode ? "dark" : "light"]
        running: qsState.darkMode != null
        stdout: StdioCollector {
            onStreamFinished: {
                qsState.dailyWallpaperPath = text.trim();
                Quickshell.execDetached(["awww", "img", text.trim(), "--transition-type", "none"]);
            }
        }
    }
    property Timer dailyWallpaperTimer: Timer {
        running: true
        interval: new Date(new Date().setHours(24, 0, 0, 0)) - new Date()
        onTriggered: {
            qsState.dailyWallpaperProcess.running = true;
            interval = 24 * 60 * 60 * 1000;
            restart();
        }
    }
    property IpcHandler dailyWallpaperHandler: IpcHandler {
        target: "dailyWallpaperHandler"
        function refresh() {
            qsState.dailyWallpaperProcess.running = true;
        }
    }
}
