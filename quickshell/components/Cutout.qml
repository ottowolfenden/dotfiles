pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
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
        x: root.xPos - 10
        y: root.yPos
        width: root.parentWidth + 20
        height: root.parentHeight
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                id: mask
                width: root.parentWidth
                height: root.parentHeight
                Shape {
                    preferredRendererType: Shape.GeometryRenderer
                    ShapePath {
                        startX: 0
                        startY: 0

                        PathLine {
                            x: mask.width
                            y: 0
                        }
                        PathArc {
                            x: mask.width - 10
                            y: 10
                            radiusX: 10
                            radiusY: 10
                            direction: PathArc.Counterclockwise
                        }
                        PathLine {
                            x: mask.width - 10
                            y: mask.height - 10
                        }
                        PathArc {
                            x: mask.width - 20
                            y: mask.height
                            radiusX: 10
                            radiusY: 10
                        }
                        PathLine {
                            x: 20
                            y: mask.height
                        }
                        PathArc {
                            x: 10
                            y: mask.height - 10
                            radiusX: 10
                            radiusY: 10
                        }
                        PathLine {
                            x: 10
                            y: 10
                        }
                        PathArc {
                            x: 0
                            y: 0
                            radiusX: 10
                            radiusY: 10
                            direction: PathArc.Counterclockwise
                        }
                    }
                }
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
