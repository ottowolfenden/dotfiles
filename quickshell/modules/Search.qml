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
            Layout.fillHeight: true
            Layout.fillWidth: true
            onTextEdited: {}
            onAccepted: {
                if (search.mode == "command")
                    Quickshell.execDetached(["/bin/sh", "-c", text]);
                reset();
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
            }

            Keys.onReleased: e => {
                let mode = SearchConf.modes.find(m => m.prefixes.some(p => text.startsWith(p)));
                let prefix = mode?.prefixes.find(p => text.startsWith(p));
                if (mode && search.mode != mode.name) {
                    search.mode = mode.name;
                    text = text.replace(prefix, "");
                }
            }

            function reset() {
                text = "";
                search.mode = "default";
                FlyoutsService.hideFlyout(searchFlyout);
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

        Pane {
            id: pane
            padding: appsRepeater.model.length == 0 ? 0 : DesignConf.spacing
            anchors.left: parent.left
            anchors.right: parent.right
            background: null

            ColumnLayout {
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
                        property bool hovered: (index == appsRepeater.activeIndex) || mouseArea.containsMouse

                        color: {
                            if (pressed)
                                return ColoursConf.buttonPressedBg;
                            else if (hovered)
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
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }
            }
        }
    }
}
