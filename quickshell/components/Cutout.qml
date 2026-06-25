pragma ComponentBehavior: Bound

import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import ".."

PanelWindow {
    id: root

    required property int xPos
    required property int yPos
    required property int parentWidth
    required property int parentHeight

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    mask: Region {
        item: cutout
    }

    Item {
        id: cutout
        x: root.xPos
        y: root.yPos
        width: root.parentWidth
        height: root.parentHeight
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: root.parentWidth
                height: root.parentHeight
                radius: Config.radius
            }
        }

        Image {
            id: image
            source: "file:///home/otto/wallpapers/clouds/23260.jpg"
            width: root.width
            height: root.height
            fillMode: Image.PreserveAspectCrop

            x: -cutout.x
            y: -cutout.y
        }
    }
}
