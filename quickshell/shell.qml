import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import "./components"

PanelWindow {
    id: w
    implicitHeight: 40
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
    }

    Pane {
        anchors.fill: parent
        padding: Config.spacing
        bottomPadding: 0
        background: Rectangle {
            color: "transparent"
        }

        RowLayout {
            id: leftContainer
            spacing: Config.spacing
            anchors.fill: parent
            Time {}
        }
    }
}
