pragma Singleton
import QtQuick

QtObject {
    readonly property list<string> vpnIdentifiers: ["vpn", "wireguard", "proton"]
    readonly property list<string> devicesToAutoconnect: ["B0:F0:0C:07:BC:07", "AC:3E:B1:62:43:27"]
    readonly property string mainPwNodeName: "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
    readonly property bool showHdmiSinks: false
    readonly property int minBrightness: 4
    property int maxBrightness: 496
}
