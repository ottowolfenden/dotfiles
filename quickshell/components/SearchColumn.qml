import QtQuick
import QtQuick.Layouts
import ".."

ColumnLayout {
    id: col
    default property alias content: contentContainer.children
    required property Repeater child
    visible: col.child.model.length > 0

    spacing: DesignConf.spacing / 2
    RowLayout {
        visible: col.child.model.length > 0 && col.child.visible
        Layout.leftMargin: DesignConf.radius / 2
        Icon {
            iconName: IconsConf.searchMode[col.child.modeSupplied]
            colour: ColoursConf.fg3.t
            pixelSize: 16
        }
        Text {
            text: SearchConf.modes.find(m => m.name == col.child.modeSupplied)?.displayName ?? ""
            color: ColoursConf.fg3.t
            font.pixelSize: FontsConf.smallPixelSize
            Layout.leftMargin: -2
        }
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: contentContainer.implicitHeight + DesignConf.spacing * (col.child.model.length > 0 ? 2 : 0)
        visible: col.child.model.length > 0
        color: ColoursConf.bg3.t
        radius: DesignConf.radius
        ColumnLayout {
            id: contentContainer
            width: parent.width - DesignConf.spacing * 2
            anchors.centerIn: parent
            spacing: DesignConf.spacing / 2
        }
    }
}
