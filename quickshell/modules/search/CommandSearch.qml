pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../.."
import "../../components"
import "../../animations/transitions"

Repeater {
    id: root
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property var activeItem: model[activeIndex] ?? null
    readonly property string modeSupplied: "commands"
    signal activeIndexSet(index: int)

    model: {
        if (mode == "commands" && searchInput.text.length != 0)
            return [...CommandSearchService.results,
                {
                    type: "input",
                    command: searchInput.text
                }
            ];

        return CommandSearchService.results;
    }
    delegate: Rectangle {
        id: result
        required property var modelData
        required property int index
        readonly property bool isActive: index == root.activeIndex

        color: {
            if (mouseArea.pressed)
                return ColoursConf.pressedbg.t;
            else if (isActive)
                return ColoursConf.hoveredbg.t;
            return "transparent";
        }
        radius: DesignConf.smallRadius
        Layout.fillWidth: true
        Layout.preferredHeight: command.implicitHeight + DesignConf.spacing

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.margins: -DesignConf.spacing / 4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onContainsMouseChanged: (containsMouse ? () => root.activeIndexSet(result.index) : () => {})()
            onClicked: {
                CommandSearchService.exec(result.modelData);
                root.searchInput.reset();
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: DesignConf.spacing
            anchors.leftMargin: DesignConf.spacing / 2
            anchors.rightMargin: DesignConf.spacing / 2

            Icon {
                iconName: result.modelData.type == "history" ? IconsConf.terminalHistory : IconsConf.terminal
                colour: command.color.toString()
            }

            Text {
                id: command
                text: result.modelData.command
                color: result.isActive ? ColoursConf.fg1.t : ColoursConf.fg3.t
                font.family: FontsConf.monospaceFamily
                font.pixelSize: FontsConf.pixelSize
                elide: Text.ElideRight
                Layout.fillWidth: true
                ButtonStateTrans on color {}
            }
        }

        ButtonStateTrans on color {}
    }
}
