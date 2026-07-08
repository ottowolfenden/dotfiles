pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "../components"

Rectangle {
    id: toggleGroup
    required property list<string> icons
    property var onClickedCommands
    property Timer checkTimer
    property bool ignoreUpdates: false
    property int activeIndex: -1

    implicitHeight: rowLayout.implicitHeight + Design.spacing * 2
    implicitWidth: rowLayout.implicitWidth + Design.spacing * 2
    Layout.alignment: Qt.AlignHCenter
    color: Colours.bg2
    radius: Infinity

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Design.spacing

        Repeater {
            id: repeater
            model: toggleGroup.icons

            delegate: Rectangle {
                required property int index
                required property string modelData

                implicitWidth: Design.circleButtonDiameter
                implicitHeight: Design.circleButtonDiameter

                color: {
                    if (index == toggleGroup.activeIndex)
                        return Colours.lightblue;
                    if (mouseArea.pressed)
                        return Colours.buttonPressedBg;
                    else if (mouseArea.containsMouse)
                        return Colours.buttonHoveredBg;
                    return Colours.buttonInactiveBg;
                }
                radius: Infinity
                Icon {
                    iconName: parent.modelData
                    anchors.fill: parent
                    colour: parent.index == toggleGroup.activeIndex ? Colours.invfg : Colours.fg1
                }
                MouseArea {
                    id: mouseArea
                    cursorShape: toggleGroup.activeIndex == parent.index ? undefined : Qt.PointingHandCursor
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        toggleGroup.activeIndex = parent.index;
                        toggleGroup.ignoreUpdates = true;
                        cooldownTimer.restart();

                        if (toggleGroup.onClickedCommands)
                            Quickshell.execDetached(toggleGroup.onClickedCommands[parent.index]);

                        if (toggleGroup.checkTimer)
                            toggleGroup.checkTimer.restart();
                    }
                }
                Timer {
                    id: cooldownTimer
                    interval: 1000
                    onTriggered: toggleGroup.ignoreUpdates = false
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
