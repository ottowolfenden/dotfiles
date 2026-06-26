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
        x: root.xPos - Config.radius
        y: root.yPos
        width: root.parentWidth + Config.radius + Config.radius
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
                            x: mask.width - Config.radius
                            y: Config.radius
                            radiusX: Config.radius
                            radiusY: Config.radius
                            direction: PathArc.Counterclockwise
                        }
                        PathLine {
                            x: mask.width - Config.radius
                            y: mask.height - Config.radius
                        }
                        PathArc {
                            x: mask.width - Config.radius - Config.radius
                            y: mask.height
                            radiusX: Config.radius
                            radiusY: Config.radius
                        }
                        PathLine {
                            x: Config.radius * 2
                            y: mask.height
                        }
                        PathArc {
                            x: Config.radius
                            y: mask.height - Config.radius
                            radiusX: Config.radius
                            radiusY: Config.radius
                        }
                        PathLine {
                            x: Config.radius
                            y: Config.radius
                        }
                        PathArc {
                            x: 0
                            y: 0
                            radiusX: Config.radius
                            radiusY: Config.radius
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
