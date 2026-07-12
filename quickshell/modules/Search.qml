pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import ".."
import "search"
import "../components"

Rectangle {
    id: search
    property bool isOpen: searchFlyout.isOpen
    property string mode: "default"
    function cycleMode() {
        let modes = SearchConf.modes.map(m => m.name);
        mode = modes[Math.max((modes.indexOf(mode) + 1) % modes.length, 1)];
    }

    color: ColoursConf.bg2
    radius: DesignConf.radius
    width: search.isOpen ? DesignConf.searchBoxWidth : DesignConf.componentHeight
    height: DesignConf.componentHeight

    Behavior on width {
        NumberAnimation {
            duration: DesignConf.animationDuration
            easing: DesignConf.easing
        }
    }

    Cutout {}

    FlyoutMouseArea {
        id: flyoutMouseArea
        flyout: searchFlyout
    }

    IpcHandler {
        target: "searchHandler"
        function toggle(): void {
            if (search.isOpen)
                FlyoutsService.hideAllFlyouts();
            else
                flyoutMouseArea.open();
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.preferredWidth: DesignConf.componentHeight
            Layout.preferredHeight: DesignConf.componentHeight
            Icon {
                id: icon
                iconName: IconsConf.searchMode[search.mode] ?? IconsConf.searchMode["default"]
                anchors.fill: parent
            }
        }

        TextField {
            id: searchInput
            color: ColoursConf.fg1
            placeholderText: SearchConf.modes.find(m => m.name == search.mode).placeholder
            background: null
            font.pixelSize: FontsConf.pixelSize
            font.family: search.mode == "command" ? FontsConf.monospaceFamily : FontsConf.mainFamily
            selectionColor: ColoursConf.textSelectionBg
            selectedTextColor: ColoursConf.fg1
            Layout.fillHeight: true
            Layout.fillWidth: true

            property bool shiftReturn: false

            function reset() {
                text = "";
                search.mode = "default";
                FlyoutsService.hideFlyout(searchFlyout);
                shiftReturn = false;
            }

            Keys.onPressed: e => {
                if (!search.isOpen) {
                    e.accepted = true;
                    return;
                }
                if (e.key == Qt.Key_Backspace && text == "")
                    search.mode = "default";
                else if (e.key == Qt.Key_Tab)
                    search.cycleMode();
                else if (e.key == Qt.Key_Down)
                    searchColumn.activeIndex = (searchColumn.activeIndex + 1) % searchColumn.totalResults;
                else if (e.key == Qt.Key_Up)
                    searchColumn.activeIndex = (searchColumn.activeIndex - 1 + searchColumn.totalResults) % searchColumn.totalResults;
                else if (e.key == Qt.Key_Return && (e.modifiers & Qt.ShiftModifier))
                    shiftReturn = true;
                else if (e.key == Qt.Key_Return || e.key == Qt.Key_Shift || e.key == Qt.Key_Control)
                    return;
                else if (e.key == Qt.Key_Escape)
                    reset();
                else
                    searchColumn.activeIndex = 0;
            }

            Keys.onReleased: e => {
                let mode = SearchConf.modes.find(m => m.prefixes.some(p => text.startsWith(p)));
                let prefix = mode?.prefixes.find(p => text.startsWith(p));
                if (mode && search.mode != mode.name) {
                    search.mode = mode.name;
                    text = text.replace(prefix, "");
                }
            }

            onAccepted: {
                if (search.mode == "command")
                    Quickshell.execDetached(["/bin/sh", "-c", text]);
                else if (appSearch.activeItem)
                    AppSearchService.exec(appSearch.activeItem, shiftReturn);
                else if (fileSearch.activeItem)
                    FileSearchService.open(fileSearch.activeItem, shiftReturn);
                else if (webSearch.activeItem)
                    WebSearchService.open(webSearch.activeItem, shiftReturn);
                else if (commandSearch.activeItem)
                    CommandSearchService.exec(commandSearch.activeItem, shiftReturn);
                else
                    return;
                reset();
            }
        }
    }

    Flyout {
        id: searchFlyout
        parentX: search.x
        rectWidth: search.width + DesignConf.spacing
        rectHeight: pane.height
        focusable: false
        onIsOpenChanged: {
            if (isOpen)
                searchInput.forceActiveFocus();
            else
                searchInput.reset();
        }
        onHoveringChanged: {
            if (!hovering)
                searchColumn.activeIndex = 0;
        }

        Pane {
            id: pane
            padding: searchColumn.totalResults == 0 ? 0 : DesignConf.spacing
            anchors.left: parent.left
            anchors.right: parent.right
            background: null

            ColumnLayout {
                id: searchColumn
                anchors.fill: parent
                spacing: DesignConf.spacing / 2
                readonly property list<Repeater> components: [appSearch, fileSearch, webSearch, commandSearch]
                readonly property int totalResults: components.reduce((acc, c) => c.model.length + acc, 0)
                property int activeIndex: 0
                function getIndexOffset(component) {
                    if (components.indexOf(component) == 0)
                        return 0;
                    return components[components.indexOf(component) - 1].model.length;
                }

                AppSearch {
                    id: appSearch
                    property int indexOffset: searchColumn.getIndexOffset(this)
                    mode: search.mode
                    searchInput: searchInput
                    activeIndex: searchColumn.activeIndex - indexOffset
                    onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                }

                FileSearch {
                    id: fileSearch
                    property int indexOffset: searchColumn.getIndexOffset(this)
                    mode: search.mode
                    searchInput: searchInput
                    activeIndex: searchColumn.activeIndex - indexOffset
                    onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                }

                WebSearch {
                    id: webSearch
                    property int indexOffset: searchColumn.getIndexOffset(this)
                    mode: search.mode
                    searchInput: searchInput
                    activeIndex: fileSearch.activeIndex - indexOffset
                    onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                }

                CommandSearch {
                    id: commandSearch
                    property int indexOffset: searchColumn.getIndexOffset(this)
                    mode: search.mode
                    searchInput: searchInput
                    activeIndex: webSearch.activeIndex - indexOffset
                    onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                }
            }
        }
    }
}
