pragma Singleton
import QtQuick
import Quickshell
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
}
