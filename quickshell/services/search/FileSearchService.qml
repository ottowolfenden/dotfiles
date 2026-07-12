pragma Singleton
import QtQuick
import Quickshell
import ".."
import "../.."

QtObject {
    function search(text: string, mode: string): list<DesktopEntry> {
        let max = MiscService.getMaxSearchResults("files", mode);
    }

    function open(fsEntry: DesktopEntry, inNewWs: bool): void {
        console.log(fsEntry.name);
    }
}
