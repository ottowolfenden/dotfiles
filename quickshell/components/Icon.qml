import QtQuick
import ".."

Item {
    property string iconName: "category"
    property int pixelSize: 18
    property string colour: Config.colours.fg1
    anchors.fill: parent
    Text {
        id: icon
        text: parent.iconName
        font.pixelSize: parent.pixelSize
        color: parent.colour
        font.family: "Material Symbols Outlined"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
