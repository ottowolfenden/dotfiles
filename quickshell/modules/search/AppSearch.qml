pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../.."
import "../../components"

Repeater {
    id: appsRep
    required property string mode
    required property TextField searchInput
    property int activeIndex: 0

    model: SearchService.searchApps(searchInput.text, mode)
    delegate: Rectangle {
        id: appRect
        required property DesktopEntry modelData
        required property int index
        property bool pressed: mouseArea.pressed
        property bool active: (index == appsRep.activeIndex) || mouseArea.containsMouse

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
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onContainsMouseChanged: appsRep.activeIndex = (containsMouse || hideButton.hovering || openInNewWsButton.hovering) ? appRect.index : -1
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton) {
                    SearchService.execApp(appRect.modelData);
                    SearchService.updateAppHistory(appRect.modelData);
                    appsRep.searchInput.reset();
                } else if (mouse.button == Qt.MiddleButton)
                    SearchService.hideApp(appRect.modelData);
            }
        }
        RowLayout {
            anchors.fill: parent
            Text {
                id: appName
                text: appRect.modelData.name
                color: ColoursConf.fg1
                font.family: DesignConf.fontFamily
                font.pixelSize: DesignConf.smallFontSize
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: DesignConf.spacing / 2
                Layout.rightMargin: DesignConf.spacing / 2
            }

            IconButton {
                id: hideButton
                isTransparentOnInactive: true
                visible: mouseArea.containsMouse || hovering || openInNewWsButton.hovering
                opacity: visible
                iconName: IconsConf.appSearchHideButton
                Layout.alignment: Qt.AlignRight
                buttonPixelSize: appRect.Layout.preferredHeight - DesignConf.spacing
                onClicked: SearchService.hideApp(appRect.modelData)
                Behavior on opacity {
                    NumberAnimation {
                        duration: DesignConf.buttonColourAnimationDuration
                    }
                }
            }
            IconButton {
                id: openInNewWsButton
                isTransparentOnInactive: true
                visible: mouseArea.containsMouse || hovering || hideButton.hovering
                opacity: visible
                iconName: IconsConf.appSearchOpenInNewWsButton
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: DesignConf.spacing / 2
                buttonPixelSize: appRect.Layout.preferredHeight - DesignConf.spacing
                onClicked: {
                    SearchService.execApp(appRect.modelData, true);
                    appsRep.searchInput.reset();
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
