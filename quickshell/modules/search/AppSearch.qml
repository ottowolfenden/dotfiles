pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../.."

Repeater {
    id: root
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property DesktopEntry activeItem: model[activeIndex] ?? null
    readonly property string modeSupplied: "apps"
    signal activeIndexSet(index: int)

    model: AppSearchService.search(searchInput.text.trim(), mode)
    delegate: Rectangle {
        id: result
        required property DesktopEntry modelData
        required property int index
        readonly property bool isActive: index == root.activeIndex

        color: {
            if (mouseArea.pressed)
                return ColoursConf.pressedbg.t;
            else if (isActive)
                return ColoursConf.hoveredbg.t;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: appName.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onContainsMouseChanged: (containsMouse ? () => root.activeIndexSet(result.index) : () => {})()
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton) {
                    AppSearchService.open(result.modelData);
                    root.searchInput.reset();
                } else if (mouse.button == Qt.MiddleButton)
                    AppSearchService.hide(result.modelData);
            }
        }
        Text {
            id: appName
            text: result.modelData.name
            color: result.isActive ? ColoursConf.fg1.t : ColoursConf.fg3.t
            font.family: FontsConf.mainFamily
            font.pixelSize: FontsConf.pixelSize
            elide: Text.ElideRight
            anchors.fill: parent
            anchors.leftMargin: DesignConf.spacing / 2
            anchors.rightMargin: DesignConf.spacing / 2
            verticalAlignment: Qt.AlignVCenter
            Behavior on color {
                ColorAnimation {
                    duration: DesignConf.buttonColourAnimationDuration
                }
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
            }
        }
    }
}
