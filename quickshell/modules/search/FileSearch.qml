pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../.."

Repeater {
    id: fileSearch
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property DesktopEntry activeItem: model[activeIndex] ?? null
    signal activeIndexSet(index: int)

    model: AppSearchService.search(searchInput.text, mode)
    delegate: Rectangle {
        id: fileRect
        required property DesktopEntry modelData
        required property int index
        property bool pressed: mouseArea.pressed
        property bool active: (index == fileSearch.activeIndex)

        color: {
            if (pressed)
                return ColoursConf.buttonPressedBg;
            else if (active)
                return ColoursConf.buttonHoveredBg;
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
            onContainsMouseChanged: {
                if (containsMouse)
                    fileSearch.activeIndexSet(fileRect.index);
            }
            onClicked: mouse => {
                FileSearchService.open(fileRect.modelData);
                fileSearch.searchInput.reset();
            }
        }
        RowLayout {
            anchors.fill: parent
            Text {
                id: appName
                text: fileRect.modelData.name
                color: ColoursConf.fg1
                font.family: DesignConf.fontFamily
                font.pixelSize: DesignConf.smallFontSize
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: DesignConf.spacing / 2
                Layout.rightMargin: DesignConf.spacing / 2
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
            }
        }
    }
}
