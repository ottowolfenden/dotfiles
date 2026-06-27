pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects
import ".."

Item {
    id: root
    anchors.fill: parent

    Item {
        id: maskContainer
        anchors.fill: parent
        visible: false

        Image {
            source: Config.wallpaper
            width: Screen.width
            height: Screen.height
            fillMode: Image.PreserveAspectCrop
            x: -root.parent.mapToItem(root.parent.Window.contentItem, 0, 0).x
            y: -root.parent.mapToItem(root.parent.Window.contentItem, 0, 0).y
        }

        Rectangle {
            anchors.fill: parent
            color: Config.colours.bg2
        }
    }

    FastBlur {
        id: blurredContainer
        anchors.fill: parent
        source: maskContainer
        radius: Config.blurRadius
        visible: false
    }

    Rectangle {
        id: maskShape
        anchors.fill: parent
        radius: Config.radius
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: blurredContainer
        maskSource: maskShape
    }
}
