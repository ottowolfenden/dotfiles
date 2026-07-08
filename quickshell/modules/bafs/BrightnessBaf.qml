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
        System.maxBrightness = max;
        root.brightness = (max / (max - System.minBrightness)) * (current - System.minBrightness);
    }

    BottomAutoFlyout {
        type: "brightness"
        Slider {
            value: root.brightness / System.maxBrightness
            onChanged: newValue => {
                root.brightness = System.maxBrightness * newValue;
                Quickshell.execDetached(["brightnessctl", "-n" + System.minBrightness, "s", root.brightness]);
            }
            iconName: Icons.brightness.find(i => i.max >= root.brightness / System.maxBrightness).icon
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
        command: ["brightnessctl", "-n" + System.minBrightness, "-m", "s", "10%" + (root.increasing ? "+" : "-")]
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
