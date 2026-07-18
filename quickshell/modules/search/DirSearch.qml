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
        id: result
        required property var modelData
        required property int index
        readonly property bool isActive: index == dirSearch.activeIndex

        color: {
            if (mouseArea.pressed)
                return ColoursConf.pressedbg.t;
            else if (isActive)
                return ColoursConf.hoveredbg.t;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: dirPath.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onContainsMouseChanged: (containsMouse ? () => dirSearch.activeIndexSet(result.index) : () => {})()
            onClicked: mouse => {
                DirSearchService.open(result.modelData);
                dirSearch.searchInput.reset();
            }
        }
        RowLayout {
            anchors.fill: parent
            spacing: DesignConf.spacing

            RowLayout {
                Layout.leftMargin: DesignConf.spacing / 2
                Layout.rightMargin: DesignConf.spacing / 2

                Icon {
                    iconName: result.modelData.icon
                    colour: dirName.color.toString()
                }

                Row {
                    id: dirPath
                    spacing: 0
                    Layout.fillWidth: true

                    Text {
                        id: dirPathPrefix
                        text: result.modelData.split()[0]
                        color: result.isActive ? ColoursConf.fg2.t : ColoursConf.fg3.t
                        font.family: FontsConf.mainFamily
                        font.pixelSize: FontsConf.pixelSize
                        width: Math.min(dirPath.width - dirName.width, implicitWidth)
                        elide: Text.ElideRight
                        Behavior on color {
                            ColorAnimation {
                                duration: DesignConf.buttonColourAnimationDuration
                            }
                        }
                    }
                    Text {
                        id: dirName
                        text: result.modelData.split()[1]
                        color: result.isActive ? ColoursConf.fg1.t : ColoursConf.fg3.t
                        font.family: FontsConf.mainFamily
                        font.pixelSize: FontsConf.pixelSize
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, Math.max(dirPath.width / 2, dirPath.width - dirPathPrefix.implicitWidth))
                        Behavior on color {
                            ColorAnimation {
                                duration: DesignConf.buttonColourAnimationDuration
                            }
                        }
                    }
                }
            }

            Text {
                text: UtilsService.toMetricPrefixForm(result.modelData.numItems, "item")
                font.pixelSize: FontsConf.smallPixelSize
                color: result.isActive ? ColoursConf.fg4.t : ColoursConf.fg5.t
                visible: SearchConf.metadataVisibility.numDirItems
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: DesignConf.spacing / 2
                Behavior on color {
                    ColorAnimation {
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
