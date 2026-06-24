import QtQuick
import Quickshell
import ".."

PanelWindow {
    id: root
    default property alias content: contentContainer.children
    required property int rectWidth
    required property int rectHeight
    property int parentX
    property int parentWidth
    color: "transparent"
    focusable: true
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    mask: Region {
        item: rectangle
    }

    property bool isOpen: false
    visible: isOpen || rectangle.y > -rectangle.height
    onIsOpenChanged: {
        if (isOpen)
            openAnimation.start();
        else
            closeAnimation.start();
    }

    property bool hovering: false
    Rectangle {
        id: rectangle
        width: root.parentWidth
        height: root.rectHeight
        color: Config.colours.bg
        radius: Config.radius
        x: Helpers.clamp(root.parentX - width / 2, Config.spacing, root.width - width - Config.spacing)
        y: -height

        ParallelAnimation {
            id: openAnimation
            NumberAnimation {
                target: rectangle
                property: "y"
                from: -rectangle.height
                to: Config.spacing
                duration: 200
                easing: Easing.InCirc
            }
            SequentialAnimation {
                PauseAnimation {
                    duration: 100
                }
                NumberAnimation {
                    target: rectangle
                    property: "width"
                    from: root.parentWidth
                    to: root.rectWidth
                    duration: 200
                    easing: Easing.InCirc
                }
            }
        }
        ParallelAnimation {
            id: closeAnimation
            NumberAnimation {
                target: rectangle
                property: "width"
                from: root.rectWidth
                to: root.parentWidth
                duration: 200
                easing: Easing.InCirc
            }
            SequentialAnimation {
                PauseAnimation {
                    duration: 100
                }
                NumberAnimation {
                    target: rectangle
                    property: "y"
                    from: Config.spacing
                    to: -rectangle.height
                    duration: 200
                    easing: Easing.InCirc
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hovering = true
            onExited: root.hovering = false
        }

        Item {
            id: contentContainer
            anchors.fill: parent
        }
    }

    Component.onCompleted: QsState.flyouts.push(this)
}
