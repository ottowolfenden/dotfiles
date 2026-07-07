pragma Singleton
import QtQuick
import Quickshell.Networking

QtObject {
    property string forward: "chevron_forward"
    property string backward: "chevron_backward"
    property string tick: "check"
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
    property var volume: [
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
    property var power: ({
            onOff: "power_settings_new",
            shutDown: "power_settings_new",
            restart: "restart_alt",
            sleep: "bedtime",
            lock: "lock"
        })
    property var powerProfiles: ["energy_savings_leaf", "balance", "rocket_launch"]
    property var devices: {
        "ac-adapter": "power",
        "audio-card": "music_note",
        "audio-card-analog": "laptop_windows",
        "audio-headphones": "headphones",
        "audio-headset": "headset_mic",
        "audio-input-microphone": "mic",
        "audio-speakers": "laptop_windows",
        "auth-face": "familiar_face_and_zone",
        "auth-fingerprint": "fingerprint",
        "auth-sim": "sim_card",
        "auth-smartcard": "id_card",
        "battery": "battery_full",
        "bluetooth": "bluetooth",
        "camera-photo": "photo_camera",
        "camera-video": "videocam",
        "camera-web": "camera",
        "computer-apple-ipad": "tablet_mac",
        "computer": "laptop_windows",
        "drive-harddisk": "hard_drive_2",
        "drive-harddisk-ieee1394": "hard_drive_2",
        "drive-harddisk-solidstate": "hard_drive",
        "drive-harddisk-system": "hard_drive",
        "drive-harddisk-usb": "security_key",
        "drive-multidisk": "storage",
        "drive-optical": "hard_disk",
        "drive-removable-media": "hard_drive",
        "ebook-reader": "tablet_android",
        "earbud": "earbud_left",
        "input-dialpad": "dialpad",
        "input-touchpad": "trackpad_input",
        "input-gaming": "sports_esports",
        "input-keyboard": "keyboard",
        "input-mouse": "mouse",
        "input-tablet": "tablet",
        "media-flash": "sd_card",
        "media-floppy": "save",
        "media-optical": "album",
        "media-optical-bd": "album",
        "media-optical-cd-audio": "album",
        "media-optical-cd": "album",
        "media-optical-dvd": "album",
        "media-removable": "security_key",
        "media-tape": "voicemail_2",
        "modem": "router",
        "microphone": "mic",
        "multimedia-player-apple-ipod-touch": "mobile",
        "multimedia-player": "mobile",
        "network-cellular": "cell_tower",
        "network-wired": "polyline",
        "network-wireless": "network_wifi",
        "phone-apple-iphone": "mobile",
        "phone-old": "phone_enabled",
        "phone": "mobile",
        "printer-network": "print",
        "printer": "print",
        "scanner": "scanner",
        "tablet": "tablet",
        "thunderbolt": "electric_bolt",
        "tv": "tv",
        "uninterruptible-power-supply": "power",
        "video-display": "tv",
        "video-joined-displays": "tv_displays",
        "video-single-display": "monitor"
    }
    property var media: ({
            play: "play_arrow",
            pause: "pause",
            skip: "skip_next",
            skipBack: "skip_previous"
        })
    property var brightness: [
        {
            max: 0.2,
            icon: "brightness_empty"
        },
        {
            max: 0.8,
            icon: "brightness_6"
        },
        {
            max: 1,
            icon: "brightness_7"
        },
    ]
}
