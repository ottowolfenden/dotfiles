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
            id: wallpaperImage
            source: Config.wallpaper
            width: Screen.width
            height: Screen.height
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
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

    function updateCoords() {
        wallpaperImage.x = -root.parent.mapToItem(root.parent.Window.contentItem, 0, 0).x;
        wallpaperImage.y = -root.parent.mapToItem(root.parent.Window.contentItem, 0, 0).y;
    }

    Timer {
        id: initTimer
        interval: 1
        running: true
        repeat: false
        onTriggered: root.updateCoords()
    }
}
