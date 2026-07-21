pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
import "../components"

Rectangle {
    id: root
    required property list<string> icons
    property var onClickedCommands
    property Timer checkTimer
    property bool ignoreUpdates: false
    property int activeIndex: -1

    implicitHeight: rowLayout.implicitHeight + DesignConf.spacing * 2
    implicitWidth: rowLayout.implicitWidth + DesignConf.spacing * 2
    Layout.alignment: Qt.AlignHCenter
    color: ColoursConf.bg3.t
    radius: Infinity

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: DesignConf.spacing

        Repeater {
            id: repeater
            model: root.icons

            delegate: Rectangle {
                required property int index
                required property string modelData

                implicitWidth: DesignConf.circleButtonDiameter
                implicitHeight: DesignConf.circleButtonDiameter

                color: {
                    if (index == root.activeIndex)
                        return ColoursConf.lightblue;
                    if (mouseArea.pressed)
                        return ColoursConf.pressedbg.t;
                    else if (mouseArea.containsMouse)
                        return ColoursConf.hoveredbg.t;
                    return ColoursConf.inactivebg.t;
                }
                radius: Infinity
                Icon {
                    iconName: parent.modelData
                    anchors.fill: parent
                    colour: parent.index == root.activeIndex ? ColoursConf.invfg : ColoursConf.fg1.t
                }
                MouseArea {
                    id: mouseArea
                    cursorShape: root.activeIndex == parent.index ? undefined : Qt.PointingHandCursor
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.activeIndex = parent.index;
                        root.ignoreUpdates = true;
                        cooldownTimer.restart();

                        if (root.onClickedCommands)
                            Quickshell.execDetached(root.onClickedCommands[parent.index]);

                        if (root.checkTimer)
                            root.checkTimer.restart();
                    }
                }
                Timer {
                    id: cooldownTimer
                    interval: 1000
                    onTriggered: root.ignoreUpdates = false
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
