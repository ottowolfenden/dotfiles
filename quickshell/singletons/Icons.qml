pragma Singleton
import QtQuick
import Quickshell.Networking

QtObject {
    property var battery: [
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
    property var wifi: [
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
    property var vpn: ({
            on: "vpn_key",
            off: "vpn_key_off"
        })
    property var audio: [
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
    property var bluetooth: ({
            enabled: "bluetooth",
            disabled: "bluetooth_disabled",
            connected: "bluetooth_connected"
        })
    property var mode: ({
            light: "light_mode",
            dark: "dark_mode"
        })
    property var power: "power_settings_new"
    property var powerProfiles: ["energy_savings_leaf", "balance", "rocket_launch"]
}
