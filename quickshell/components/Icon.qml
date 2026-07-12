import QtQuick
import ".."

Item {
    required property string iconName

    property int pixelSize: 18
    property color colour: ColoursConf.fg1
    property bool fill: false
    property int horizontalMargin: 0
    property int verticalMargin: 0

    width: pixelSize + horizontalMargin
    height: pixelSize + verticalMargin

    Text {
        id: icon
        text: parent.iconName.replace("custom:", "")
        font.pixelSize: parent.pixelSize
        color: parent.colour
        font.family: parent.iconName.startsWith("custom:") ? FontsConf.customMaterialSymbolsOutlined : FontsConf.materialSymbolsOutlined
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
}
