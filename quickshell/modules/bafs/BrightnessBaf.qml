import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../components"

Scope {
    id: root

    property int brightness: 0
    property bool increasing: false

    function setBrightness(text) {
        const {
            2: current,
            4: max
        } = text.trim().split(",");
        SystemConf.maxBrightness = max;
        root.brightness = (max / (max - SystemConf.minBrightness)) * (current - SystemConf.minBrightness);
    }

    BottomAutoFlyout {
        type: "brightness"
        Slider {
            value: root.brightness / SystemConf.maxBrightness
            onChanged: newValue => {
                root.brightness = SystemConf.maxBrightness * newValue;
                Quickshell.execDetached(["brightnessctl", "-n" + SystemConf.minBrightness, "s", root.brightness]);
            }
            iconName: IconsConf.brightness.find(i => i.max >= root.brightness / SystemConf.maxBrightness).icon
        }
    }

    Process {
        id: getBrightnessProc
        command: ["brightnessctl", "-m"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.setBrightness(text)
        }
    }

    Process {
        id: changeBrightnessProc
        command: ["brightnessctl", "-n" + SystemConf.minBrightness, "-m", "s", "10%" + (root.increasing ? "+" : "-")]
        stdout: StdioCollector {
            onStreamFinished: root.setBrightness(text)
        }
    }

    IpcHandler {
        target: "brightnessHandler"
        function change(type: string): void {
            FlyoutsService.bafsHandler.showBaf("brightness");
            if (type == "increase")
                root.increasing = true;
            else if (type == "decrease")
                root.increasing = false;
            else
                return;
            changeBrightnessProc.running = true;
        }
    }
}
