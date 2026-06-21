pragma Singleton
import QtQuick
import Quickshell.Networking

QtObject {
    property bool darkMode: false
    property int spacing: 10
    property int iconTextSpacing: 4
    property int barHeight: 30
    property int fontSize: 15
    property int borderRadius: 4
    property string fontFamily: "Google Sans Flex"
    property var colours: this.darkMode ? {
        bg: "#aa000000",
        fg1: "#d8ffffff",
        fg2: "#55ffffff",
        fg3: '#15ffffff',
        invfg: "#000000",
        red: "#f07178",
        orange: "#f78c6c",
        yellow: "#ffcb6b",
        green: "#c3e88d",
        lightblue: "#89ddff",
        darkblue: "#82aaff",
        purple: "#c792ea",
        pink: "#ff9cac"
    } : {
        bg: "#aaffffff",
        fg1: "#d8000000",
        fg2: "#55000000",
        fg3: '#15000000',
        invfg: "#ffffff",
        red: "#ea4335",
        orange: "#f57c00",
        yellow: "#fbbc05",
        green: "#34a853",
        lightblue: "#4285f4",
        darkblue: "#0057ca",
        purple: "#7248b9",
        pink: "#ff80ab"
    }
    property var batteryIcons: [
        {
            max: 10,
            charging: "battery_charging_full",
            discharging: "battery_alert"
        },
        {
            max: 20,
            charging: "battery_charging_20",
            discharging: "battery_1_bar"
        },
        {
            max: 30,
            charging: "battery_charging_30",
            discharging: "battery_2_bar"
        },
        {
            max: 50,
            charging: "battery_charging_50",
            discharging: "battery_3_bar"
        },
        {
            max: 60,
            charging: "battery_charging_60",
            discharging: "battery_4_bar"
        },
        {
            max: 80,
            charging: "battery_charging_80",
            discharging: "battery_5_bar"
        },
        {
            max: 95,
            charging: "battery_charging_90",
            discharging: "battery_6_bar"
        },
        {
            max: 100,
            charging: "battery_charging_full",
            discharging: "battery_full",
            fill: true
        },
    ]
    property var wifiIcons: [
        {
            connectivity: NetworkConnectivity.Unknown,
            icons: [
                {
                    secured: "signal_wifi_statusbar_not_connected",
                    open: "signal_wifi_statusbar_not_connected"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.Portal,
            icons: [
                {
                    secured: "perm_scan_wifi",
                    open: "perm_scan_wifi"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.Limited,
            icons: [
                {
                    secured: "signal_wifi_bad",
                    open: "signal_wifi_bad"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.None,
            icons: [
                {
                    secured: "signal_wifi_off",
                    open: "signal_wifi_off"
                }
            ]
        },
        {
            connectivity: NetworkConnectivity.Full,
            icons: [
                {
                    max: 0.05,
                    secured: "wifi_lock",
                    open: "signal_wifi_0_bar"
                },
                {
                    max: 0.2,
                    secured: "network_wifi_1_bar_locked",
                    open: "network_wifi_1_bar"
                },
                {
                    max: 0.5,
                    secured: "network_wifi_2_bar_locked",
                    open: "network_wifi_2_bar"
                },
                {
                    max: 0.8,
                    secured: "network_wifi_3_bar_locked",
                    open: "network_wifi_3_bar"
                },
                {
                    max: 1,
                    secured: "wifi_lock",
                    open: "signal_wifi_4_bar",
                    fill: true
                },
            ]
        }
    ]
    property var audioIcons: [
        {
            muted: true,
            icon: "no_sound"
        },
        {
            max: 0,
            icon: "volume_mute"
        },
        {
            max: 35,
            icon: "volume_down"
        },
        {
            max: 100,
            icon: "volume_up"
        }
    ]
    property var vpnIdentifiers: ["vpn", "wireguard", "proton"]
}
