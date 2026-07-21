pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
        if (!["default", "web"].includes(mode) || !searchInput.text || UtilsService.isInternetDisconnected())
            return [];
        let firstSuggestionResult = {
            type: "suggestion",
            text: searchInput.text,
            url: WebSearchService.getSearchURL(searchInput.text)
        };
        let groupedResults = [...WebSearchService.browserHistoryResults, firstSuggestionResult, ...WebSearchService.suggestionResults];
        return UtilsService.getDistinctByAnyKeys(groupedResults, ["text", "url"]).slice(0, WebSearchService.getMax());
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
        Layout.preferredHeight: title.implicitHeight + DesignConf.spacing

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
                iconName: result.modelData.type == "history" ? IconsConf.history : IconsConf.webSearch
                colour: title.color.toString()
            }

            RowLayout {
                id: textRow
                spacing: DesignConf.spacing
                property int resultantWidth: DesignConf.searchFlyoutWidth - DesignConf.resultantSearchPadding

                Text {
                    id: title
                    text: result.modelData.text
                    Layout.preferredWidth: Math.min(title.implicitWidth, textRow.resultantWidth * SearchConf.maxHistoryTitleWidthProportion)
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
                    text: result.modelData.trimmedUrl ?? ""
                    Layout.preferredWidth: textRow.resultantWidth - title.Layout.preferredWidth
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

        Behavior on color {
            ColorAnimation {
                duration: DesignConf.buttonColourAnimationDuration
            }
        }
    }
}
