pragma Singleton
import QtQuick
import Quickshell

QtObject {
    readonly property string scripts: `${Quickshell.env("HOME")}/dotfiles/scripts/`
    readonly property string appSearchCache: `${Quickshell.env("HOME")}/.cache/`
}
