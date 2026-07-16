pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../.."
import "../../components"

Repeater {
    id: appSearch
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property DesktopEntry activeItem: model[activeIndex] ?? null
    readonly property string modeSupplied: "apps"
    signal activeIndexSet(index: int)

    model: AppSearchService.search(searchInput.text, mode)
    delegate: Rectangle {
        id: appRect
        required property DesktopEntry modelData
        required property int index

        color: {
            if (mouseArea.pressed)
                return ColoursConf.buttonPressedBg;
            else if (index == appSearch.activeIndex)
                return ColoursConf.buttonHoveredBg;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: appName.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            property bool hovering: containsMouse || hideButton.hovering || openInNewWsButton.hovering
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onHoveringChanged: {
                if (hovering)
                    appSearch.activeIndexSet(appRect.index);
            }
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton) {
                    AppSearchService.exec(appRect.modelData);
                    appSearch.searchInput.reset();
                } else if (mouse.button == Qt.MiddleButton)
                    AppSearchService.hide(appRect.modelData);
            }
        }
        RowLayout {
            anchors.fill: parent
            Text {
                id: appName
                text: appRect.modelData.name
                color: ColoursConf[appSearch.activeIndex == appRect.index ? "fg1" : "fg3"]
                font.family: FontsConf.mainFamily
                font.pixelSize: FontsConf.pixelSize
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: DesignConf.spacing / 2
                Layout.rightMargin: DesignConf.spacing / 2
                Behavior on color {
                    ColorAnimation {
                        duration: DesignConf.buttonColourAnimationDuration
                    }
                }
            }
            IconButton {
                id: hideButton
                isTransparentOnInactive: true
                visible: mouseArea.hovering
                opacity: visible
                iconName: IconsConf.appSearchHideButton
                Layout.alignment: Qt.AlignRight
                buttonPixelSize: appRect.Layout.preferredHeight - DesignConf.spacing
                onClicked: AppSearchService.hide(appRect.modelData)
                Behavior on opacity {
                    NumberAnimation {
                        duration: DesignConf.buttonColourAnimationDuration
                    }
                }
            }
            IconButton {
                id: openInNewWsButton
                isTransparentOnInactive: true
                visible: mouseArea.hovering
                opacity: visible
                iconName: IconsConf.appSearchOpenInNewWsButton
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: DesignConf.spacing / 2
                buttonPixelSize: appRect.Layout.preferredHeight - DesignConf.spacing
                onClicked: {
                    AppSearchService.exec(appRect.modelData, true);
                    appSearch.searchInput.reset();
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
