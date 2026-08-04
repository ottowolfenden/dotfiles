pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import ".."

QtObject {
    function getWsIsEmpty(id: int): bool {
        let ws = Hyprland.workspaces.values.find(ws => ws.id == id);
        return !ws || ws.toplevels.values.length == 0;
    }

    function getLastWsId(): int {
        return Math.max(...Hyprland.workspaces.values.map(v => v.id));
    }

    function getActiveWs(): HyprlandWorkspace {
        if (!Hyprland.workspaces?.values || Hyprland.workspaces.values.length == 0)
            return null;
        return Hyprland.workspaces.values.find(ws => ws.active);
    }

    function setRefreshRate(refreshRateHz: var): void {
        let monitorConf = SystemConf.hyprlandLaptopMonitor.replace(/(mode\s*=\s*"\d+x\d+@)[^"]+/, "$1" + refreshRateHz);
        Quickshell.execDetached(["hyprctl", "eval", monitorConf]);
    }

    function reload(): void {
        Quickshell.execDetached(["hyprctl", "reload"]);
    }

    function focusWs(selector: var): void {
        if (typeof selector == "number" && selector > maxWs)
            return;
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "${selector}" })`);
    }

    function focusWindow(selector: var): void {
        Hyprland.dispatch(`hl.dsp.focus({ window = "${selector}" })`);
    }

    function focusActiveWindow(): void {
        Hyprland.dispatch(`
            hl.dsp[hl.get_active_window() and "focus" or "no_op"]({ window = hl.get_active_window() })
        `);
    }

    function applyFlyoutConf(): void {
        Quickshell.execDetached(["hyprctl", "eval", `
                hl.config({
                    input = { follow_mouse = 0 },
                    decoration = {
                        active_opacity = 1.0 - 0.3,
                        inactive_opacity = 0.85 - 0.3
                    }
                })
            `]);
    }

    function applyBafConf(): void {
        Quickshell.execDetached(["hyprctl", "eval", `
                hl.config({
                    decoration = {
                        active_opacity = 1.0 - 0.2,
                        inactive_opacity = 0.85 - 0.2
                    }
                })
            `]);
    }

    function reloadFlyoutBafConf(): void {
        Quickshell.execDetached(["hyprctl", "eval", `
                hl.config({
                    input = { follow_mouse = 1 },
                    decoration = {
                        active_opacity = 1.0,
                        inactive_opacity = 0.85
                    }
                })
            `]);
    }

    property Process activeWsClientsProcess: Process {
        id: activeWsClientsProcess
        property var callbackFunc: null
        property var leftParams: null
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (!activeWsClientsProcess.callbackFunc)
                    return;
                let clients = JSON.parse(text);
                let activeClients = clients.filter(c => c.workspace.id == HyprlandService.getActiveWs()?.id);
                activeWsClientsProcess.callbackFunc(...activeWsClientsProcess.leftParams, activeClients);
            }
        }
    }

    property var maxWs: null
    property Process maxWsProcess: Process {
        command: ["hyprctl", "repl", "print(Max_ws)"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: HyprlandService.maxWs = isNaN(text.trim()) ? 9 : text.trim()
        }
    }
}
