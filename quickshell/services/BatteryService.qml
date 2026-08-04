pragma Singleton
import QtQuick
import Quickshell
import ".."

QtObject {
    readonly property var actions: {
        "power-saver": () => {
            HyprlandService.setRefreshRate(60);
            let maxBrightness = Math.round(SystemConf.powerSaverBrightnessProportion * SystemConf.maxBrightness);
            Quickshell.execDetached(["brightnessctl", "s", Math.min(maxBrightness, brightness)]);
            Quickshell.execDetached(["qs", "ipc", "call", "brightnessHandler", "refresh"]);
            brightnessProportion = SystemConf.powerSaverBrightnessProportion;
        },
        "balanced": () => {
            HyprlandService.setRefreshRate(120);
        },
        "performance": () => {
            HyprlandService.setRefreshRate(120);
            brightnessProportion = 1;
        }
    }

    property real brightnessProportion: 1
    property int brightness: 0
}
