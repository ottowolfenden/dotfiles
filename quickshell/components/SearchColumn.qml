import QtQuick
import QtQuick.Layouts
import ".."

ColumnLayout {
    id: root
    default property alias content: contentContainer.children
    required property Repeater child
    property string mode

    visible: child.model.length > 0
    spacing: child.mode == child.modeSupplied ? 0 : DesignConf.spacing / 2

    Item {
        visible: root.child.model.length > 0 && root.child.visible
        Layout.leftMargin: DesignConf.radius / 2
        Layout.preferredHeight: root.child.mode == root.child.modeSupplied ? 0 : label.implicitHeight
        Layout.preferredWidth: label.implicitWidth
        opacity: root.child.mode != root.child.modeSupplied

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
                iconName: IconsConf.searchMode[root.child.modeSupplied]
                colour: ColoursConf.fg3.t
                pixelSize: 16
            }

            Text {
                text: SearchConf.modes.find(m => m.name == root.child.modeSupplied)?.displayName ?? ""
                color: ColoursConf.fg3.t
                font.pixelSize: FontsConf.smallPixelSize
                Layout.leftMargin: -2
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.mode = root.child.modeSupplied
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: contentContainer.implicitHeight + DesignConf.spacing * (root.child.model.length > 0 ? 2 : 0)
        visible: root.child.model.length > 0
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
