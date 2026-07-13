pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../.."
import "../../components"

Repeater {
    id: fileSearch
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property var activeItem: model[activeIndex] ?? null
    signal activeIndexSet(index: int)

    model: FileSearchService.search(searchInput.text, mode)
    delegate: Rectangle {
        id: fileRect
        required property var modelData
        required property int index

        color: {
            if (mouseArea.pressed)
                return ColoursConf.buttonPressedBg;
            else if (index == fileSearch.activeIndex)
                return ColoursConf.buttonHoveredBg;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: fileName.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            property bool hovering: containsMouse || openInNewWsButton.hovering
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onHoveringChanged: {
                if (hovering)
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
                id: fileName
                text: fileRect.modelData.name
                color: ColoursConf.fg1
                font.family: FontsConf.mainFamily
                font.pixelSize: FontsConf.smallPixelSize
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: DesignConf.spacing / 2
                Layout.rightMargin: DesignConf.spacing / 2
            }
            IconButton {
                id: openInNewWsButton
                isTransparentOnInactive: true
                visible: mouseArea.hovering
                opacity: visible
                iconName: IconsConf.appSearchOpenInNewWsButton
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: DesignConf.spacing / 2
                buttonPixelSize: fileRect.Layout.preferredHeight - DesignConf.spacing
                onClicked: {
                    FileSearchService.open(fileRect.modelData, true);
                    fileSearch.searchInput.reset();
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: DesignConf.buttonColourAnimationDuration
                    }
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
