pragma Singleton
import QtQuick
import Quickshell
import ".."

QtObject {
    function search(text: string, mode: string): list<DesktopEntry> {
        let max = UtilsService.getMaxSearchResults("command", mode);
    }
}
