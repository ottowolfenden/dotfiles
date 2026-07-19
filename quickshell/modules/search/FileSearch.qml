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
    readonly property string modeSupplied: "files"
    signal activeIndexSet(index: int)

    model: FileSearchService.results
    delegate: Rectangle {
        id: result
        required property var modelData
        required property int index
        readonly property bool isActive: index == fileSearch.activeIndex

        color: {
            if (mouseArea.pressed)
                return ColoursConf.pressedbg.t;
            else if (index == fileSearch.activeIndex)
                return ColoursConf.hoveredbg.t;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: textRow.implicitHeight + DesignConf.spacing

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onContainsMouseChanged: (containsMouse ? () => fileSearch.activeIndexSet(result.index) : () => {})()
            onClicked: mouse => {
                FileSearchService.open(result.modelData);
                fileSearch.searchInput.reset();
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: DesignConf.spacing
            anchors.leftMargin: DesignConf.spacing / 2
            anchors.rightMargin: DesignConf.spacing / 2

            Icon {
                id: icon
                iconName: result.modelData.icon
                colour: nameNoExt.color.toString()
            }

            RowLayout {
                id: textRow
                spacing: DesignConf.spacing
                property int resultantWidth: DesignConf.searchFlyoutWidth - DesignConf.resultantSearchPadding

                Row {
                    id: fileName
                    spacing: 0
                    Layout.preferredWidth: Math.min(nameNoExt.implicitWidth + fileExt.implicitWidth, textRow.resultantWidth * SearchConf.maxFileNameWidthProportion)

                    Text {
                        id: nameNoExt
                        text: result.modelData.split()[0]
                        width: Math.min(fileName.width - fileExt.width, implicitWidth)
                        color: result.isActive ? ColoursConf.fg1.t : ColoursConf.fg3.t
                        font.family: FontsConf.mainFamily
                        font.pixelSize: FontsConf.pixelSize
                        elide: Text.ElideRight
                        Behavior on color {
                            ColorAnimation {
                                duration: DesignConf.buttonColourAnimationDuration
                            }
                        }
                    }
                    Text {
                        id: fileExt
                        text: result.modelData.split()[1]
                        width: Math.min(implicitWidth, Math.max(fileName.width / 2, fileName.width - nameNoExt.implicitWidth))
                        color: result.isActive ? ColoursConf.fg1.t : ColoursConf.fg3.t
                        font.family: FontsConf.mainFamily
                        font.pixelSize: FontsConf.pixelSize
                        elide: Text.ElideRight
                        Behavior on color {
                            ColorAnimation {
                                duration: DesignConf.buttonColourAnimationDuration
                            }
                        }
                    }
                }

                Text {
                    id: path
                    text: result.modelData.homeRelativePathPrefix
                    Layout.preferredWidth: textRow.resultantWidth - fileName.width
                    color: result.isActive ? ColoursConf.fg3.t : ColoursConf.fg4.t
                    font.family: FontsConf.mainFamily
                    font.pixelSize: FontsConf.smallPixelSize
                    elide: Text.ElideRight
                    Behavior on color {
                        ColorAnimation {
                            duration: DesignConf.buttonColourAnimationDuration
                        }
                    }
                }
            }
        }
    }
}
