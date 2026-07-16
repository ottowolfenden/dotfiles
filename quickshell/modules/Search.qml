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
    onModeChanged: DirSearchService.search(searchInput.text, mode)

    color: ColoursConf.bg2.t
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
            color: ColoursConf.fg1.t
            placeholderText: SearchConf.modes.find(m => m.name == search.mode).placeholder
            background: null
            font.pixelSize: FontsConf.pixelSize
            font.family: search.mode == "command" ? FontsConf.monospaceFamily : FontsConf.mainFamily
            selectionColor: ColoursConf.textselectionbg.t
            selectedTextColor: ColoursConf.fg1.t
            Layout.fillHeight: true
            Layout.fillWidth: true

            property var binds: ({
                    inNewWs: {
                        active: false,
                        key: Qt.Key_Return,
                        set: function (e) {
                            this.active = !!(e.key == Qt.Key_Return && (e.modifiers & Qt.ShiftModifier));
                        }
                    },
                    inTerminal: {
                        active: false,
                        key: Qt.Key_Return,
                        set: function (e) {
                            this.active = !!(e.key == Qt.Key_Return && (e.modifiers & Qt.ControlModifier));
                        }
                    },
                    inVsCode: {
                        active: false,
                        key: Qt.Key_C,
                        set: function (e) {
                            this.active = !!(e.key == Qt.Key_C && (e.modifiers & Qt.MetaModifier));
                        }
                    }
                })

            property string prevText

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

            Keys.onPressed: e => {
                if (!search.isOpen) {
                    e.accepted = true;
                    return;
                }

                prevText = text;
                Object.keys(binds).forEach(k => binds[k].set(e));

                if (Object.keys(binds).some(b => b.active && b.key != Qt.Key_Return))
                    searchInput.accepted = true;
                else if (e.key == Qt.Key_Backspace && text == "")
                    search.mode = "default";
                else if (e.key == Qt.Key_Tab)
                    search.cycleMode();
                else if (e.key == Qt.Key_Up && (e.modifiers & Qt.ControlModifier))
                    jumpToRepeater("up");
                else if (e.key == Qt.Key_Down && (e.modifiers & Qt.ControlModifier))
                    jumpToRepeater("down");
                else if (e.key == Qt.Key_Down)
                    searchColumn.activeIndex = (searchColumn.activeIndex + 1) % searchColumn.totalResults;
                else if (e.key == Qt.Key_Up)
                    searchColumn.activeIndex = (searchColumn.activeIndex - 1 + searchColumn.totalResults) % searchColumn.totalResults;
                else if (e.key == Qt.Key_Return || e.key == Qt.Key_Shift || e.key == Qt.Key_Control)
                    return;
                else if (e.key == Qt.Key_Escape)
                    reset();
                else
                    searchColumn.activeIndex = 0;
            }

            Keys.onReleased: e => {
                if (text == prevText && e.key == Qt.Key_Backspace)
                    search.mode = "default";
                let mode = SearchConf.modes.find(m => m.prefixes.some(p => text.startsWith(p)));
                let prefix = mode?.prefixes.find(p => text.startsWith(p));
                if (mode && search.mode != mode.name) {
                    search.mode = mode.name;
                    text = text.replace(prefix, "");
                }
                if (text != prevText || e.key == Qt.Key_Tab)
                    DirSearchService.search(text, search.mode);
            }

            onAccepted: {
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
        }
    }

    Flyout {
        id: searchFlyout
        parentX: search.x
        rectWidth: DesignConf.searchFlyoutWidth
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
            }
        }
    }
}
