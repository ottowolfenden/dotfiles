import QtQuick
import QtQuick.Layouts
import ".."

ColumnLayout {
    id: col
    default property alias content: contentContainer.children
    required property Repeater child
    property string mode

    visible: child.model.length > 0
    spacing: child.mode == child.modeSupplied ? 0 : DesignConf.spacing / 2

    Item {
        visible: col.child.model.length > 0 && col.child.visible
        Layout.leftMargin: DesignConf.radius / 2
        Layout.preferredHeight: col.child.mode == col.child.modeSupplied ? 0 : label.implicitHeight
        Layout.preferredWidth: label.implicitWidth
        opacity: col.child.mode != col.child.modeSupplied

        Behavior on Layout.preferredHeight {
            NumberAnimation {
                duration: DesignConf.animationDuration
                easing: DesignConf.easing
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: DesignConf.buttonColourAnimationDuration
                easing: DesignConf.easing
            }
        }

        RowLayout {
            id: label
            anchors.fill: parent

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

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: col.mode = col.child.modeSupplied
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
