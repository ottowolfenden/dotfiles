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
            source: DailyWallpaperService.path
            width: Screen.width
            height: Screen.height
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }

        Rectangle {
            anchors.fill: parent
            color: ColoursConf.cutoutBg
        }
    }

    FastBlur {
        id: blurredContainer
        anchors.fill: parent
        source: maskContainer
        radius: DesignConf.blurRadius
        visible: false
    }

    Rectangle {
        id: maskShape
        anchors.fill: parent
        radius: DesignConf.radius
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: blurredContainer
        maskSource: maskShape
    }

    Timer {
        id: initTimer
        interval: 1
        running: true
        repeat: false
        onTriggered: {
            wallpaperImage.x = -root.parent.mapToItem(root.parent.Window.contentItem, 0, 0).x;
            wallpaperImage.y = -root.parent.mapToItem(root.parent.Window.contentItem, 0, 0).y;
        }
    }
}
