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
    readonly property var activeItem: model[activeIndex] ?? null
    readonly property string modeSupplied: "dirs"
    signal activeIndexSet(index: int)

    model: DirSearchService.results
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
        Layout.preferredHeight: dirPath.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            property bool hovering: containsMouse || openInNewWsButton.hovering || openInTerminalButton.hovering
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
            RowLayout {
                Layout.leftMargin: DesignConf.spacing / 2
                Layout.rightMargin: DesignConf.spacing / 2
                Icon {
                    iconName: IconsConf.dirs[(() => {
                                let dir = dirRect.modelData;
                                if (dir.rootOwned)
                                    return "rootOwned";
                                if (dir.hasGit)
                                    return "repo";
                                if (dir.homeRelativePath == "~")
                                    return "home";
                                if (dir.name.toLowerCase().includes("config"))
                                    return "conf";
                                return "default";
                            })()]
                    colour: dirPath.color
                }
                Text {
                    id: dirPath
                    text: dirRect.modelData.homeRelativePath
                    color: ColoursConf[dirSearch.activeIndex == dirRect.index ? "fg1" : "fg2"]
                    font.family: FontsConf.mainFamily
                    font.pixelSize: FontsConf.pixelSize
                    elide: Text.ElideRight
                    Layout.leftMargin: DesignConf.spacing / 2
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    Behavior on color {
                        ColorAnimation {
                            duration: DesignConf.buttonColourAnimationDuration
                        }
                    }
                }
            }
            IconButton {
                id: openInTerminalButton
                isTransparentOnInactive: true
                visible: mouseArea.hovering
                opacity: visible
                iconName: IconsConf.terminal
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: DesignConf.spacing / 2
                buttonPixelSize: dirRect.Layout.preferredHeight - DesignConf.spacing
                onClicked: {
                    DirSearchService.open(dirRect.modelData, false, true);
                    dirSearch.searchInput.reset();
                }
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
