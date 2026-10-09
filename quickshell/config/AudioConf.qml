pragma Singleton
import QtQuick

QtObject {
    readonly property list<string> excludedSinks: ["alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink", "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink"]
    readonly property list<string> earbudSubstrings: ["bud", "airpod", " ear", "tws"]
    readonly property list<string> playerRequirements: ["canPlay", "canPause", "canControl", "canTogglePlaying"]
    readonly property var playerIdentityNames: {
        "com.github.th-ch.youtube-music": "YouTube Music"
    }
}
