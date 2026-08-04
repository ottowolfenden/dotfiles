import QtQuick
import Quickshell
import Quickshell.Io
import "../../services"
import "../.."
import "../../components"

Scope {
    id: root
    onBrightnessChanged: BatteryService.brightness = brightness
    property int brightness: 0
    property bool increasing: false
    property int max: Math.floor(BatteryService.brightnessProportion * SystemConf.maxBrightness)

    function setBrightness(text) {
        const {
            2: current,
            4: max
        } = text.trim().split(",");
        SystemConf.maxBrightness = max;
        root.brightness = (root.max / (root.max - SystemConf.minBrightness)) * (current - SystemConf.minBrightness);
    }

    BottomAutoFlyout {
        type: "brightness"
        Slider {
            value: Math.min(root.brightness / root.max, 1)
            onChanged: newValue => {
                root.brightness = root.max * newValue;
                Quickshell.execDetached(["brightnessctl", "-n" + SystemConf.minBrightness, "s", root.brightness]);
            }
            iconName: IconsConf.brightness.find(i => i.max >= value).icon
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
        command: {
            let targetBrightness = root.brightness + (Math.trunc(root.max * 0.1) * (root.increasing ? 1 : -1));
            targetBrightness = UtilsService.clamp(targetBrightness, SystemConf.minBrightness, root.max);
            return ["brightnessctl", "-n" + SystemConf.minBrightness, "-m", "s", targetBrightness];
        }
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
        function refresh(): void {
            getBrightnessProc.running = true;
        }
    }
}
