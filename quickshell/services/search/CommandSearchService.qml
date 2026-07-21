pragma Singleton
import QtQuick
import ".."
import "../.."

QtObject {
    function search(text: string, mode: string) {
        let max = UtilsService.getMaxSearchResults("command", mode);
    }
}
