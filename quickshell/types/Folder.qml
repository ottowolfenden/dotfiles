import QtQuick
import ".."

FsEntry {
    property date created
    property date modified
    property date accessed
    property int byteSize
    property int numFiles
    property int numFolders
    property bool isRootOwned

    readonly property int numItems: numFiles + numFolders
    readonly property string name: path.split("/").at(-1)
    readonly property string icon: IconsConf.folders.default
}
