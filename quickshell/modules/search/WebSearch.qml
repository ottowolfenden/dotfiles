pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Networking
import "../.."
import "../../components"

Repeater {
    id: webSearch
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property var activeItem: model[activeIndex] ?? null
    readonly property string modeSupplied: "web"
    signal activeIndexSet(index: int)

    model: {
        if (!["default", "web"].includes(mode) || !searchInput.text || ![NetworkConnectivity.Full, NetworkConnectivity.Unknown].includes(Networking.connectivity))
            return [];
        return UtilsService.getDistinctNonNull([searchInput.text, ...WebSearchService.results]);
    }
    delegate: Rectangle {
        id: result
        required property var modelData
        required property int index
        readonly property bool isActive: index == webSearch.activeIndex

        color: {
            if (mouseArea.pressed)
                return ColoursConf.pressedbg.t;
            else if (isActive)
                return ColoursConf.hoveredbg.t;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: text.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onContainsMouseChanged: (containsMouse ? () => webSearch.activeIndexSet(result.index) : () => {})()
            onClicked: {
                WebSearchService.open(result.modelData);
                webSearch.searchInput.reset();
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: DesignConf.spacing
            anchors.leftMargin: DesignConf.spacing / 2
            anchors.rightMargin: DesignConf.spacing / 2

            Icon {
                iconName: IconsConf.webSearch
                colour: text.color.toString()
            }

            Text {
                id: text
                text: result.modelData
                color: result.isActive ? ColoursConf.fg1.t : ColoursConf.fg3.t
                font.family: FontsConf.mainFamily
                font.pixelSize: FontsConf.pixelSize
                elide: Text.ElideRight
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
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
