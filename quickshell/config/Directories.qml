pragma Singleton
import QtQuick
import Quickshell

QtObject {
    readonly property string scripts: `${Quickshell.env("HOME")}/dotfiles/scripts/`
    readonly property list<string> appSearchInput: ["/usr/share/applications/", `${Quickshell.env("HOME")}/.local/share/applications/`]
    readonly property string appSearchOutput: `${Quickshell.env("HOME")}/.cache/`
}
