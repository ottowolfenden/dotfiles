pragma Singleton
import QtQuick
import "../../types"
import "../.."

QtObject {
    function search(text: string, mode: string): list<FsEntry> {
        let max = MiscService.getMaxSearchResults("files", mode);
        return [];
    }

    function open(fsEntry: FsEntry, inNewWs: bool): void {
        console.log(fsEntry.name);
    }
}
