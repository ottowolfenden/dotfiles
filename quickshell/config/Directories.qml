pragma Singleton
import QtQuick

QtObject {
    readonly property string scripts: "/home/otto/dotfiles/scripts/"
    readonly property list<string> appSearchInput: ["/usr/share/applications/", "/home/otto/.local/share/applications/"]
    readonly property string appSearchOutput: "/home/otto/.cache/"
}
