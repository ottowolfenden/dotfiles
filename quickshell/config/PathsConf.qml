pragma Singleton
import QtQuick
import Quickshell

QtObject {
    readonly property string scripts: `${Quickshell.env("HOME")}/dotfiles/scripts/`
    readonly property string appHistory: `${Quickshell.env("HOME")}/.cache/qs-app-history.json`
}
