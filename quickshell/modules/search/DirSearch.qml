pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../.."
import "../../components"

Repeater {
    id: dirSearch
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property var activeItem: {
        if (model)
            return model[activeIndex] ?? null;
        return null;
    }
    signal activeIndexSet(index: int)

    model: DirSearchService.search(searchInput.text, mode)
    delegate: Rectangle {
        id: dirRect
        required property var modelData
        required property int index

        color: {
            if (mouseArea.pressed)
                return ColoursConf.buttonPressedBg;
            else if (index == dirSearch.activeIndex)
                return ColoursConf.buttonHoveredBg;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: dirName.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            property bool hovering: containsMouse || openInNewWsButton.hovering
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onHoveringChanged: {
                if (hovering)
                    dirSearch.activeIndexSet(dirRect.index);
            }
            onClicked: mouse => {
                DirSearchService.open(dirRect.modelData);
                dirSearch.searchInput.reset();
            }
        }
        RowLayout {
            anchors.fill: parent
            Text {
                id: dirName
                text: dirRect.modelData.name
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
                buttonPixelSize: dirRect.Layout.preferredHeight - DesignConf.spacing
                onClicked: {
                    DirSearchService.open(dirRect.modelData, true);
                    dirSearch.searchInput.reset();
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
