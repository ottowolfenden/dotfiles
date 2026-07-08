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
    property string mode: "search"

    color: Config.colours.bg2
    radius: Config.radius
    width: search.isOpen ? 300 : Config.componentHeight
    height: Config.componentHeight

    Behavior on width {
        NumberAnimation {
            duration: Config.animationDuration
            easing: Config.easing
        }
    }

    Cutout {}

    FlyoutMouseArea {
        id: flyoutMouseArea
        flyout: searchFlyout
    }

    IpcHandler {
        target: "searchHandler"
        function toggle() {
            if (search.isOpen)
                QsState.hideAllFlyouts();
            else
                flyoutMouseArea.open();
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.preferredWidth: Config.componentHeight
            Layout.preferredHeight: Config.componentHeight
            Icon {
                id: icon
                iconName: Icons.searchMode[search.mode] ?? Icons.searchMode["search"]
                anchors.fill: parent
            }
        }

        TextField {
            id: searchInput
            color: Config.colours.fg1
            placeholderText: Config.searchModePlaceholder[search.mode] ?? Config.searchModePlaceholder["search"]
            background: null
            font.pixelSize: Config.fontSize
            font.family: search.mode == "terminal" ? Config.monospaceFontFamily : Config.fontFamily
            Layout.fillHeight: true
            Layout.fillWidth: true
            onTextEdited: {
                if (text == ">" && search.mode != "terminal") {
                    search.mode = "terminal";
                    text = "";
                }
            }
            onAccepted: {
                if (search.mode == "terminal")
                    Quickshell.execDetached(["kitty", "sh", "-c", text + "; exec $SHELL"]);
                reset();
            }
            Keys.onPressed: e => {
                if (e.key == Qt.Key_Backspace && text == "")
                    search.mode = "search";
            }

            function reset() {
                text = "";
                search.mode = "search";
                QsState.hideAllFlyouts();
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
