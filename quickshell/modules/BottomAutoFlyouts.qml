import QtQuick
import QtQuick.Layouts
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
            Layout.preferredWidth: 250
            Layout.preferredHeight: 45
            Layout.alignment: Qt.AlignHCenter

            value: Pipewire.defaultAudioSink?.audio?.volume ?? 0
            onChanged: newValue => Pipewire.defaultAudioSink.audio.volume = newValue
            iconName: Icons.volume?.find(i => i.muted == Pipewire.defaultAudioSink?.audio?.muted || Math.round(Pipewire.defaultAudioSink?.audio.volume * 100) <= i.max)?.icon
        }
    }

    property int percentBrightness: 0
    BottomAutoFlyout {
        type: "brightness"
        Slider {
            Layout.preferredWidth: 250
            Layout.preferredHeight: 45
            Layout.alignment: Qt.AlignHCenter

            value: Helpers.getRawBrightness(root.percentBrightness) / 100
            onChanged: newValue => {
                let newPercent = Helpers.getExpBrightness(newValue * 100);
                root.percentBrightness = newPercent;
                Quickshell.execDetached(["brightnessctl", "-e" + Config.brightnessExpPower, "-n" + Config.minBrightness, "s", newPercent + "%"]);
            }
            iconName: Icons.brightness.find(i => i.max >= root.percentBrightness).icon
        }
    }
    Process {
        id: brightnessProc
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: root.percentBrightness = Helpers.getExpBrightness(text.trim().split(",")[3].slice(0, -1))
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: brightnessProc.running = true
    }
}
