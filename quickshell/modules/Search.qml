pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import ".."
import "search"
import "../components"

Rectangle {
    id: search
    property bool isOpen: searchFlyout.isOpen
    property string mode: "default"
    function changeMode(direction: int, includeDefault: bool): void {
        if (![-1, 1].includes(direction))
            return;
        let modes = SearchConf.modes.map(m => m.name).filter(n => n != "default" || includeDefault);
        let offset = direction == -1 ? direction + modes.length : direction;
        let newIndex = direction == -1 && mode == "default" && !includeDefault ? modes.length - 1 : (modes.indexOf(mode) + offset) % modes.length;
        mode = modes[newIndex];
    }
    onModeChanged: {
        DirSearchService.mode = mode;
        DirSearchService.search(searchInput.text);
    }

    color: ColoursConf.bg2.t
    radius: DesignConf.radius
    height: DesignConf.componentHeight

    Cutout {}

    FlyoutMouseArea {
        id: flyoutMouseArea
        flyout: searchFlyout
    }

    IpcHandler {
        target: "searchHandler"
        function toggle(): void {
            if (search.isOpen)
                FlyoutsService.flyoutsHandler.hideAllFlyouts();
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
                iconName: IconsConf.search
                anchors.fill: parent
            }
        }

        TextField {
            id: searchInput
            color: ColoursConf.fg1.t
            placeholderText: SearchConf.modes.find(m => m.name == search.mode).placeholder
            background: null
            font.pixelSize: FontsConf.pixelSize
            font.family: search.mode == "command" ? FontsConf.monospaceFamily : FontsConf.mainFamily
            selectionColor: ColoursConf.textselectionbg.t
            selectedTextColor: ColoursConf.fg1.t
            Layout.fillHeight: true
            Layout.fillWidth: true

            property string prevText
            property var binds: SearchConf.binds

            function setBinds(e): void {
                Object.keys(binds).forEach(k => binds[k].active = !!(e.key == binds[k].key && (e.modifiers & binds[k].mod)));
            }

            function reset(): void {
                text = "";
                search.mode = "default";
                FlyoutsService.hideFlyout(searchFlyout);
                DirSearchService.results = [];
                searchColumn.activeIndex = 0;
                Object.keys(binds).forEach(k => binds[k].active = false);
            }

            function jumpToRepeater(direction: string): void {
                if (!["up", "down"].includes(direction))
                    return;
                let visibleRepeaters = searchColumn.repeaters.filter(r => (r.model?.length ?? 0) != 0);
                let activeRep = visibleRepeaters.find(r => r.activeItem);
                let indexOffsets = visibleRepeaters.map(r => r.indexOffset);
                let repIndex = visibleRepeaters.indexOf(activeRep);
                if (indexOffsets.length < 0)
                    return;
                let newIndexOffset = repIndex + (direction == "up" ? -1 : 1);
                if (repIndex == indexOffsets.length - 1 && direction == "down") {
                    searchColumn.activeIndex = activeRep.model.length + activeRep.indexOffset - 1;
                } else
                    searchColumn.activeIndex = indexOffsets[UtilsService.clamp(newIndexOffset, 0, indexOffsets.length - 1)];
            }

            function open() {
                if (appSearch.activeItem)
                    AppSearchService.open(appSearch.activeItem, binds);
                else if (dirSearch.activeItem)
                    DirSearchService.open(dirSearch.activeItem, binds);
                else if (fileSearch.activeItem)
                    FileSearchService.open(fileSearch.activeItem, binds);
                else if (webSearch.activeItem)
                    WebSearchService.open(webSearch.activeItem, binds);
                else if (commandSearch.activeItem)
                    CommandSearchService.exec(commandSearch.activeItem, binds);
                else
                    return;
                reset();
            }

            onTextEdited: {
                let mode = SearchConf.modes.find(m => m.prefixes.some(p => (text).startsWith(p)));
                let prefix = mode?.prefixes.find(p => text.startsWith(p));
                if (mode && prefix && search.mode != mode.name) {
                    search.mode = mode.name;
                    text = text.replace(prefix, "");
                }
            }

            Keys.onPressed: e => {
                if (!search.isOpen)
                    return;

                prevText = text;
                setBinds(e);

                if (Object.keys(binds).some(k => binds[k].active && binds[k].key != Qt.Key_Return)) {
                    e.accepted = true;
                    open();
                } else if ((e.key == Qt.Key_Backspace && text == "") || (e.key == Qt.Key_Delete && (e.modifiers & Qt.ControlModifier))) {
                    e.accepted = true;
                    search.mode = "default";
                } else if (e.key == Qt.Key_Tab)
                    search.changeMode(1, true);
                else if (e.key == Qt.Key_Backtab)
                    search.changeMode(-1, true);
                else if (e.key == Qt.Key_Up && (e.modifiers & Qt.ControlModifier))
                    jumpToRepeater("up");
                else if (e.key == Qt.Key_Down && (e.modifiers & Qt.ControlModifier))
                    jumpToRepeater("down");
                else if (e.key == Qt.Key_Down)
                    searchColumn.activeIndex = (searchColumn.activeIndex + 1) % searchColumn.totalResults;
                else if (e.key == Qt.Key_Up)
                    searchColumn.activeIndex = (searchColumn.activeIndex - 1 + searchColumn.totalResults) % searchColumn.totalResults;
                else if ([Qt.Key_Return, Qt.Key_Shift, Qt.Key_Control, Qt.Key_Meta, Qt.Key_Alt].includes(e.key))
                    return;
                else if (e.key == Qt.Key_Escape)
                    reset();
                else
                    searchColumn.activeIndex = 0;
            }

            Keys.onReleased: e => {
                if (text == prevText && e.key == Qt.Key_Backspace)
                    search.mode = "default";
                if (text != prevText || e.key == Qt.Key_Tab)
                    DirSearchService.search(text, search.mode);
            }

            onAccepted: open()
        }
    }

    Flyout {
        id: searchFlyout
        parentX: search.x
        rectWidth: DesignConf.searchFlyoutWidth
        rectHeight: pane.height
        focusable: false
        onIsOpenChanged: {
            if (isOpen) {
                searchInput.forceActiveFocus();
                DirSearchService.mode = search.mode;
                DirSearchService.searchOpen = true;
            } else {
                searchInput.reset();
                DirSearchService.searchOpen = false;
                DirSearchService.hideOutput();
            }
        }
        onHoveringChanged: {
            if (!hovering)
                searchColumn.activeIndex = 0;
        }

        Pane {
            id: pane
            padding: searchColumn.totalResults > 0 || loadingBar.visible ? DesignConf.spacing : 0
            anchors.left: parent.left
            anchors.right: parent.right
            background: null

            ColumnLayout {
                id: searchColumn
                anchors.fill: parent
                spacing: DesignConf.spacing
                readonly property list<Repeater> repeaters: [appSearch, dirSearch, fileSearch, webSearch, commandSearch]
                readonly property int totalResults: repeaters.reduce((acc, c) => (c.model?.length ?? 0) + acc, 0)
                property int activeIndex: 0
                function getIndexOffset(repeater: Repeater): int {
                    if (repeaters.indexOf(repeater) == 0)
                        return 0;
                    return repeaters[repeaters.indexOf(repeater) - 1]?.model?.length ?? 0;
                }

                SearchColumn {
                    child: appSearch
                    onModeChanged: search.mode = mode
                    AppSearch {
                        id: appSearch
                        visible: search.mode == "apps" || search.mode == "default"
                        property int indexOffset: searchColumn.getIndexOffset(this)
                        mode: search.mode
                        searchInput: searchInput
                        activeIndex: searchColumn.activeIndex - indexOffset
                        onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                    }
                }

                SearchColumn {
                    child: dirSearch
                    onModeChanged: search.mode = mode
                    DirSearch {
                        id: dirSearch
                        visible: search.mode == "dirs" || search.mode == "default"
                        property int indexOffset: searchColumn.getIndexOffset(this)
                        mode: search.mode
                        searchInput: searchInput
                        activeIndex: searchColumn.activeIndex - indexOffset
                        onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                    }
                }

                FileSearch {
                    id: fileSearch
                    visible: search.mode == "files" || search.mode == "default"
                    property int indexOffset: searchColumn.getIndexOffset(this)
                    mode: search.mode
                    searchInput: searchInput
                    activeIndex: searchColumn.activeIndex - indexOffset
                    onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                }

                WebSearch {
                    id: webSearch
                    visible: search.mode == "web" || search.mode == "default"
                    property int indexOffset: searchColumn.getIndexOffset(this)
                    mode: search.mode
                    searchInput: searchInput
                    activeIndex: fileSearch.activeIndex - indexOffset
                    onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                }

                CommandSearch {
                    id: commandSearch
                    visible: search.mode == "command" || search.mode == "default"
                    property int indexOffset: searchColumn.getIndexOffset(this)
                    mode: search.mode
                    searchInput: searchInput
                    activeIndex: webSearch.activeIndex - indexOffset
                    onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                }

                LoadingBar {
                    id: loadingBar
                    visible: DirSearchService.loading
                }
            }
        }
    }
}
