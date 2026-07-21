pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import ".."
import "search"
import "../components"

Rectangle {
    id: root
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
        DirSearchService.mode = FileSearchService.mode = WebSearchService.mode = mode;
        DirSearchService.search(searchInput.text.trim());
        FileSearchService.search(searchInput.text.trim());
        WebSearchService.search(searchInput.text.trim(), root.mode);
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
            if (root.isOpen)
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
            placeholderText: SearchConf.modes.find(m => m.name == root.mode).placeholder
            background: null
            font.pixelSize: FontsConf.pixelSize
            font.family: root.mode == "command" ? FontsConf.monospaceFamily : FontsConf.mainFamily
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
                root.mode = "default";
                FlyoutsService.hideFlyout(searchFlyout);
                DirSearchService.results = FileSearchService.results = [];
                WebSearchService.reset();
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
                if (root.mode == "command")
                    return;
                let mode = SearchConf.modes.find(m => m.prefixes.some(p => (text).startsWith(p)));
                let prefix = mode?.prefixes.find(p => text.startsWith(p));
                if (mode && prefix && root.mode != mode.name) {
                    root.mode = mode.name;
                    text = text.replace(prefix, "");
                }
            }

            Keys.onPressed: e => {
                if (!root.isOpen)
                    return;

                prevText = text;
                setBinds(e);

                if (Object.keys(binds).some(k => binds[k].active && binds[k].key != Qt.Key_Return)) {
                    e.accepted = true;
                    open();
                } else if ((e.key == Qt.Key_Backspace && text == "") || (e.key == Qt.Key_Delete && (e.modifiers & Qt.ControlModifier))) {
                    e.accepted = true;
                    root.mode = "default";
                } else if (e.key == Qt.Key_Tab)
                    root.changeMode(1, true);
                else if (e.key == Qt.Key_Backtab)
                    root.changeMode(-1, true);
                else if (SearchConf.shiftBindsEnabled && root.mode != "command" && (e.modifiers & Qt.ShiftModifier)) {
                    let mode = SearchConf.modes.find(m => m.shiftKey == e.key)?.name;
                    if (mode) {
                        root.mode = mode;
                        e.accepted = true;
                    }
                } else if (e.key == Qt.Key_Up && (e.modifiers & Qt.ControlModifier))
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
                    root.mode = "default";
                if (text != prevText || e.key == Qt.Key_Tab) {
                    if (root.mode == "dirs")
                        DirSearchService.hideOutput();
                    else if (root.mode == "files")
                        FileSearchService.hideOutput();
                    DirSearchService.search(text.trim(), root.mode);
                    FileSearchService.search(text.trim(), root.mode);
                    WebSearchService.search(text.trim(), root.mode);
                }
            }

            onAccepted: open()
        }
    }

    Flyout {
        id: searchFlyout
        parentX: root.x
        rectWidth: DesignConf.searchFlyoutWidth
        rectHeight: pane.height
        focusable: false
        onIsOpenChanged: {
            if (isOpen) {
                searchInput.forceActiveFocus();
                DirSearchService.mode = FileSearchService.mode = WebSearchService.mode = root.mode;
                DirSearchService.searchOpen = FileSearchService.searchOpen = true;
            } else {
                searchInput.reset();
                DirSearchService.searchOpen = FileSearchService.searchOpen = false;
                DirSearchService.hideOutput();
                FileSearchService.hideOutput();
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

                SearchColumn {
                    child: appSearch
                    onModeChanged: root.mode = mode
                    AppSearch {
                        id: appSearch
                        visible: root.mode == "apps" || root.mode == "default"
                        property int indexOffset: 0
                        mode: root.mode
                        searchInput: searchInput
                        activeIndex: searchColumn.activeIndex - indexOffset
                        onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                    }
                }

                SearchColumn {
                    child: dirSearch
                    onModeChanged: root.mode = mode
                    DirSearch {
                        id: dirSearch
                        visible: root.mode == "dirs" || root.mode == "default"
                        property int indexOffset: appSearch.model.length
                        mode: root.mode
                        searchInput: searchInput
                        activeIndex: searchColumn.activeIndex - indexOffset
                        onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                    }
                }

                SearchColumn {
                    child: fileSearch
                    onModeChanged: root.mode = mode
                    FileSearch {
                        id: fileSearch
                        visible: root.mode == "files" || root.mode == "default"
                        property int indexOffset: dirSearch.indexOffset + dirSearch.model.length
                        mode: root.mode
                        searchInput: searchInput
                        activeIndex: searchColumn.activeIndex - indexOffset
                        onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                    }
                }

                SearchColumn {
                    child: webSearch
                    onModeChanged: root.mode = mode
                    WebSearch {
                        id: webSearch
                        visible: root.mode == "web" || root.mode == "default"
                        property int indexOffset: fileSearch.indexOffset + fileSearch.model.length
                        mode: root.mode
                        searchInput: searchInput
                        activeIndex: searchColumn.activeIndex - indexOffset
                        onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                    }
                }

                SearchColumn {
                    child: commandSearch
                    onModeChanged: root.mode = mode
                    CommandSearch {
                        id: commandSearch
                        visible: root.mode == "command" || root.mode == "default"
                        property int indexOffset: webSearch.indexOffset + webSearch.model.length
                        mode: root.mode
                        searchInput: searchInput
                        activeIndex: searchColumn.activeIndex - indexOffset
                        onActiveIndexSet: i => searchColumn.activeIndex = i + indexOffset
                    }
                }

                LoadingBar {
                    id: loadingBar
                    visible: DirSearchService.loading || FileSearchService.loading
                }
            }
        }
    }
}
