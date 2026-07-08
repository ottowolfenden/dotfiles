pragma Singleton
import QtQuick

QtObject {
    readonly property var hyprlandCommands: ({
            flyoutOpen: ["hyprctl", "eval", `
                hl.config({
                    input = { follow_mouse = 0 },
                    decoration = {
                        active_opacity = 1.0 - 0.3,
                        inactive_opacity = 0.85 - 0.3
                    }
                })
            `],
            bafOpen: ["hyprctl", "eval", `
                hl.config({
                    decoration = {
                        active_opacity = 1.0 - 0.2,
                        inactive_opacity = 0.85 - 0.2
                    }
                })
            `],
            reset: ["hyprctl", "reload"]
        })

    function getWorkspaceExists(workspaces: var, id: int): bool {
        if (workspaces && workspaces.values)
            for (var i = 0; i < workspaces.values.length; i++)
                if (workspaces.values[i] && workspaces.values[i].id == id)
                    return true;
        return false;
    }

    function getRelevantWorkspaceIds(workspaces: var): list<int> {
        var ids = workspaces.values.map(value => value.id);
        return Array.from({
            length: Math.max(...ids)
        }, (_, i) => i + 1);
    }
}
