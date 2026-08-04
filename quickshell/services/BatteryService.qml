pragma Singleton
import QtQuick
import ".."

QtObject {
    readonly property var actions: {
        "power-saver": () => {
            HyprlandService.setRefreshRate(60);
        },
        "balanced": () => {
            HyprlandService.setRefreshRate(120);
        },
        "performance": () => {
            HyprlandService.setRefreshRate(120);
        }
    }
}
