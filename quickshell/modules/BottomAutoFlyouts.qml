import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../components"
import "../singletons"

Scope {
    id: root
    BottomAutoFlyout {
        type: "volume"
        Slider {
            value: Pipewire.defaultAudioSink?.audio?.volume ?? 0
            onChanged: newValue => Pipewire.defaultAudioSink.audio.volume = newValue
            iconName: Icons.volume?.find(i => i.muted == Pipewire.defaultAudioSink?.audio?.muted || Math.round(Pipewire.defaultAudioSink?.audio.volume * 100) <= i.max)?.icon
        }
    }

    property int maxBrightness: 496
    property int brightness: 0
    property bool increasing: false
    BottomAutoFlyout {
        type: "brightness"
        Slider {
            value: root.brightness / root.maxBrightness

            onChanged: newValue => {
                root.brightness = root.maxBrightness * newValue;
                console.log(root.brightness);

                Quickshell.execDetached(["brightnessctl", "-n" + Config.minBrightness, "s", root.brightness]);
            }
            iconName: Icons.brightness.find(i => i.max >= root.brightness / root.maxBrightness).icon
        }
    }
    function setBrightness(text) {
        const {
            2: current,
            4: max
        } = text.trim().split(",");
        root.maxBrightness = max;
        root.brightness = (max / (max - Config.minBrightness)) * (current - Config.minBrightness);
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
        command: ["brightnessctl", "-n" + Config.minBrightness, "-m", "s", "10%" + (root.increasing ? "+" : "-")]
        stdout: StdioCollector {
            onStreamFinished: root.setBrightness(text)
        }
    }
    IpcHandler {
        target: "brightnessHandler"
        function change(type: string): void {
            QsState.bafsHandler.showBaf("brightness");
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
