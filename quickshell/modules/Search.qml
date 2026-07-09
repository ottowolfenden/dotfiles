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
        rectHeight: pane.implicitHeight
        focusable: false
        onIsOpenChanged: {
            if (isOpen)
                searchInput.forceActiveFocus();
            else
                searchInput.reset();
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
                    model: SearchService.getApps(searchInput.text, 6)
                    delegate: Rectangle {
                        id: appItem
                        required property DesktopEntry modelData

                        color: ColoursConf.bg2
                        radius: DesignConf.radius / 2
                        Layout.fillWidth: true
                        Layout.preferredHeight: appName.implicitHeight + DesignConf.spacing

                        Text {
                            id: appName
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: DesignConf.spacing / 2
                            text: appItem.modelData.name
                            color: ColoursConf.fg1
                            font.family: DesignConf.fontFamily
                            font.pixelSize: DesignConf.smallFontSize
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
}
