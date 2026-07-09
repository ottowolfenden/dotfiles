import QtQuick
import Quickshell.Services.Pipewire
import "../.."
import "../../components"

BottomAutoFlyout {
    type: "volume"
    Slider {
        value: Pipewire.defaultAudioSink?.audio?.volume ?? 0
        onChanged: newValue => Pipewire.defaultAudioSink.audio.volume = newValue
        iconName: IconsConf.volume?.find(i => i.muted == Pipewire.defaultAudioSink?.audio?.muted || Math.round(Pipewire.defaultAudioSink?.audio.volume * 100) <= i.max)?.icon
    }
}
