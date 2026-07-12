import QtQuick
import ".."

FsEntry {
    property Image preview: null
    property date created
    property date modified
    property date accessed
    property int byteSize

    readonly property string name: path.split("/").at(-1)
    readonly property string format: name.split(".").at(-1).toLowerCase()
    readonly property string icon: IconsConf.fileFormats.find(f => f == format) ?? IconsConf.fileFormats.default
}
