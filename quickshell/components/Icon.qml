import QtQuick
import ".."

Item {
    property string iconName: "category"
    property int pixelSize: 18
    property string colour: Config.colours.fg1
    property bool fill: false
    property int horizontalMargin: 0
    property int verticalMargin: 0

    width: icon.width + horizontalMargin
    height: icon.width + verticalMargin

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
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    // DebugBox {}
}
