pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: pathsConf
    readonly property string scripts: Quickshell.env("HOME") + "/dotfiles/scripts/"
    readonly property string appHistory: Quickshell.env("HOME") + "/.cache/qs-app-history.json"
    readonly property string hiddenApps: Quickshell.env("HOME") + "/.config/qs-hidden-apps.json"
    readonly property string chromiumHistory: Quickshell.env("HOME") + "/.config/net.imput.helium/Default/History"

    readonly property var xdgDirs: {
        "DOWNLOAD": "",
        "DESKTOP": "",
        "TEMPLATES": "",
        "PUBLICSHARE": "",
        "DOCUMENTS": "",
        "MUSIC": "",
        "PICTURES": "",
        "VIDEOS": "",
        "PROJECTS": ""
    }
    readonly property Process xdgDirsProcess: Process {
        running: true
        command: ["sh", "-c", Object.keys(pathsConf.xdgDirs).reduce((acc, val) => acc + `xdg-user-dir ${val};`, "")]
        stdout: StdioCollector {
            onStreamFinished: {
                let paths = text.trim().split("\n");
                Object.keys(pathsConf.xdgDirs).forEach((k, i) => pathsConf.xdgDirs[k] = paths[i] == Quickshell.env("HOME") ? "" : paths[i]);
            }
        }
    }
}
