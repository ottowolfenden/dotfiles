import QtQuick
import ".."

Item {
    property string iconName: "category"
    property int pixelSize: 18
    property string colour: Config.colours.fg1
    property bool iconOnly: true
    property bool fill: false

    anchors.fill: iconOnly ? parent : undefined
    Text {
        id: icon
        text: parent.iconName
        font.pixelSize: parent.pixelSize
        color: parent.colour
        font.family: "Material Symbols Outlined"
        renderType: Text.NativeRendering
        font.variableAxes: ({
                "FILL": parent.fill ? 1 : 0,
                "wght": 400,
                "GRAD": 0,
                "opsz": 24
            })
        anchors.horizontalCenter: parent.iconOnly ? parent.horizontalCenter : undefined
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
