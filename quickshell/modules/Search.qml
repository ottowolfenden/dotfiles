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
        mode = Misc.searchModes[Math.max((Misc.searchModes.indexOf(mode) + 1) % Misc.searchModes.length, 1)];
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
            placeholderText: Misc.searchModePlaceholder[search.mode] ?? Misc.searchModePlaceholder["default"]
            background: null
            font.pixelSize: Design.fontSize
            font.family: search.mode == "terminal" ? Design.monospaceFontFamily : Design.fontFamily
            Layout.fillHeight: true
            Layout.fillWidth: true
            onTextEdited: {}
            onAccepted: {
                if (search.mode == "terminal")
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
                else if (Object.values(Misc.searchModeBinds).some(v => v.includes(e.key)) && (Misc.isCopilotKey(e) || Misc.isFunctionKey(e))) {
                    search.mode = Object.keys(Misc.searchModeBinds).find(k => Misc.searchModeBinds[k].includes(e.key));
                    e.accepted = true;
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
