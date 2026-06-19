pragma Singleton
import QtQuick

QtObject {
    function getWorkspaceExists(workspaces, id) {
        if (workspaces && workspaces.values)
            for (var i = 0; i < workspaces.values.length; i++)
                if (workspaces.values[i] && workspaces.values[i].id == id)
                    return true;
        return false;
    }

    function getRelevantWorkspaceIds(workspaces) {
        var ids = workspaces.values.map(value => value.id);
        return Array.from({
            length: Math.max(...ids)
        }, (_, i) => i + 1);
    }
}
