pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import ".."
import "../components"

Rectangle {
    id: root
    required property list<string> icons
    property var onClickeds
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
                id: item
                required property int index
                required property string modelData

                implicitWidth: DesignConf.circleButtonDiameter
                implicitHeight: DesignConf.circleButtonDiameter
                color: {
                    if (mouseArea.pressed)
                        return ColoursConf.pressedbg.t;
                    else if (mouseArea.containsMouse)
                        return ColoursConf.hoveredbg.t;
                    return ColoursConf.inactivebg.t;
                }
                radius: Infinity
                opacity: root.activeIndex != index

                Behavior on color {
                    ColorAnimation {
                        duration: DesignConf.buttonColourAnimationDuration
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: item.opacity ? DesignConf.listAnimationDuration : 0
                        easing: DesignConf.easing
                    }
                }

                Icon {
                    iconName: item.modelData
                    anchors.fill: parent
                    colour: ColoursConf.fg1.t
                }

                MouseArea {
                    id: mouseArea
                    cursorShape: root.activeIndex == item.index ? undefined : Qt.PointingHandCursor
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.activeIndex = item.index;
                        root.ignoreUpdates = true;
                        cooldownTimer.restart();

                        if (root.onClickeds)
                            root.onClickeds[item.index]();

                        if (root.checkTimer)
                            root.checkTimer.restart();
                    }
                }

                Timer {
                    id: cooldownTimer
                    interval: 1000
                    onTriggered: root.ignoreUpdates = false
                }
            }
        }
    }

    Rectangle {
        color: ColoursConf.lightblue
        width: DesignConf.circleButtonDiameter
        height: DesignConf.circleButtonDiameter
        radius: Infinity
        x: DesignConf.spacing + (DesignConf.circleButtonDiameter + DesignConf.spacing) * root.activeIndex
        y: (root.implicitHeight - height) / 2

        Behavior on x {
            NumberAnimation {
                duration: DesignConf.listAnimationDuration
                easing: DesignConf.easing
            }
        }

        Icon {
            iconName: root.icons[root.activeIndex] ?? ""
            anchors.fill: parent
            colour: ColoursConf.invfg
        }
    }
}
