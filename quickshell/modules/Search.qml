pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import ".."
import "../components"

Rectangle {
    id: search
    property bool isOpen: searchFlyout.isOpen
    property string mode: "default"
    function cycleMode() {
        let modes = SearchConf.modes.map(m => m.name);
        mode = modes[Math.max((modes.indexOf(mode) + 1) % modes.length, 1)];
    }

    property bool exclusive: false

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
            font.pixelSize: DesignConf.fontSize
            font.family: search.mode == "command" ? DesignConf.monospaceFontFamily : DesignConf.fontFamily
            selectionColor: ColoursConf.textSelectionBg
            selectedTextColor: ColoursConf.fg1
            Layout.fillHeight: true
            Layout.fillWidth: true

            property bool shiftReturn: false

            function reset() {
                text = "";
                search.mode = "default";
                appsRepeater.activeIndex;
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
                    appsRepeater.activeIndex++;
                else if (e.key == Qt.Key_Up)
                    appsRepeater.activeIndex--;
                else if (e.key == Qt.Key_Return && (e.modifiers & Qt.ShiftModifier))
                    shiftReturn = true;
                else if (e.key == Qt.Key_Return || e.key == Qt.Key_Shift || e.key == Qt.Key_Control)
                    return;
                else if (e.key == Qt.Key_Escape)
                    reset();
                else
                    appsRepeater.activeIndex = 0;
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
                else {
                    let app = appsRepeater.model[appsRepeater.activeIndex];
                    if (shiftReturn) {
                        Quickshell.execDetached(HyprlandService.commands.focusEmptyWorkspace);
                        appExecTimer.appToExec = app;
                        appExecTimer.running = true;
                    } else
                        app.execute();
                    SearchService.updateAppHistory(app);
                }
                reset();
            }

            Timer {
                id: appExecTimer
                property DesktopEntry appToExec: null
                interval: 100
                onTriggered: {
                    appToExec?.execute();
                    appToExec = null;
                }
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
            if (isOpen) {
                searchInput.forceActiveFocus();
                search.exclusive = true;
            } else {
                searchInput.reset();
                search.exclusive = false;
            }
        }
        onHoveringChanged: {
            if (!hovering)
                appsRepeater.activeIndex = 0;
        }

        Pane {
            id: pane
            padding: appsRepeater.model.length == 0 ? 0 : DesignConf.spacing
            anchors.left: parent.left
            anchors.right: parent.right
            background: null

            ColumnLayout {
                id: appsColumn
                anchors.fill: parent
                spacing: DesignConf.spacing / 2

                Repeater {
                    id: appsRepeater
                    property int activeIndex: 0
                    model: SearchService.searchApps(searchInput.text, 6)
                    delegate: Rectangle {
                        required property DesktopEntry modelData
                        required property int index
                        property bool pressed: mouseArea.pressed
                        property bool active: (index == appsRepeater.activeIndex) || mouseArea.containsMouse

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

                        Text {
                            id: appName
                            text: parent.modelData.name
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: DesignConf.spacing / 2
                            color: ColoursConf.fg1
                            font.family: DesignConf.fontFamily
                            font.pixelSize: DesignConf.smallFontSize
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            anchors.margins: -appsColumn.spacing / 2
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                            onContainsMouseChanged: appsRepeater.activeIndex = containsMouse ? parent.index : -1
                            onClicked: mouse => {
                                if (mouse.button == Qt.LeftButton) {
                                    parent.modelData.execute();
                                    SearchService.updateAppHistory(parent.modelData);
                                    searchInput.reset();
                                } else if (mouse.button == Qt.MiddleButton)
                                    SearchService.hideApp(parent.modelData);
                            }
                        }

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
}
