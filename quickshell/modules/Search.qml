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
        let modes = Misc.searchModes.map(m => m.name);
        mode = modes[Math.max((modes.indexOf(mode) + 1) % modes.length, 1)];
    }

    color: Colours.bg2
    radius: Design.radius
    width: search.isOpen ? 300 : Design.componentHeight
    height: Design.componentHeight

    Behavior on width {
        NumberAnimation {
            duration: Design.animationDuration
            easing: Design.easing
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
            Layout.preferredWidth: Design.componentHeight
            Layout.preferredHeight: Design.componentHeight
            Icon {
                id: icon
                iconName: Icons.searchMode[search.mode] ?? Icons.searchMode["default"]
                anchors.fill: parent
            }
        }

        TextField {
            id: searchInput
            color: Colours.fg1
            placeholderText: Misc.searchModes.find(m => m.name == search.mode).placeholder
            background: null
            font.pixelSize: Design.fontSize
            font.family: search.mode == "command" ? Design.monospaceFontFamily : Design.fontFamily
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
                let mode = Misc.searchModes.find(m => m.prefixes.some(p => text.startsWith(p)));
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
        rectWidth: pane.implicitWidth
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
            padding: 0
            background: null
        }
    }
}
