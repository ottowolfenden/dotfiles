pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

QtObject {
    function getWsExists(id: int): bool {
        return Hyprland.workspaces?.values.some(ws => ws.id == id);
    }

    function getFilteredWsIds(): list<int> {
        if (!Hyprland.workspaces?.values || Hyprland.workspaces.values.length == 0)
            return [];
        let maxId = Math.max(...Hyprland.workspaces.values.map(value => value.id));
        return [...Array(maxId)].map((_, i) => i + 1);
    }

    function getActiveWs(): HyprlandWorkspace {
        if (!Hyprland.workspaces?.values || Hyprland.workspaces.values.length == 0)
            return null;
        return Hyprland.workspaces.values.find(ws => ws.active);
    }

    function reload(): void {
        Quickshell.execDetached(["hyprctl", "reload"]);
    }

    function focusWs(selector: var): void {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = "${selector}" })`);
    }

    function focusWindow(selector: var): void {
        Hyprland.dispatch(`hl.dsp.focus({ window = "${selector}" })`);
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

    function execWithQsTag(command: string): void {
        Hyprland.dispatch(`hl.dsp.exec_cmd(${JSON.stringify(command)}, { tag = "+qs" })`);
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
}
