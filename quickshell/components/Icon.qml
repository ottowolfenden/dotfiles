import QtQuick
import ".."

Item {
    required property string iconName

    property int pixelSize: 18
    property string colour: ColoursConf.fg1.t
    property int horizontalMargin: 0
    property int verticalMargin: 0

    width: pixelSize + horizontalMargin
    height: pixelSize + verticalMargin

    Text {
        id: icon
        text: parent.iconName.replace("fill:", "")
        font.pixelSize: parent.pixelSize
        color: parent.colour
        font.family: parent.iconName.startsWith("fill:") ? FontsConf.materialSymbolsExtendedFill : FontsConf.materialSymbolsExtended
        renderType: Text.NativeRendering
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
