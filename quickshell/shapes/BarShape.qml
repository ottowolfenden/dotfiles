import QtQuick
import QtQuick.Shapes
import ".."

Shape {
    id: root
    layer.enabled: true
    layer.samples: 4

    ShapePath {
        fillColor: ColoursConf.bg1
        strokeWidth: 0
        Component.onCompleted: UtilsService.setAllPathArcRadii(pathElements)

        startX: 0
        startY: 0

        PathLine {
            x: root.parent.width
            y: 0
        }
        PathLine {
            x: root.parent.width
            y: root.parent.height
        }
        PathArc {
            x: root.parent.width - DesignConf.radius
            y: root.parent.height - DesignConf.radius
            direction: PathArc.Counterclockwise
        }
        PathLine {
            x: DesignConf.radius
            y: root.parent.height - DesignConf.radius
        }
        PathArc {
            x: 0
            y: root.parent.height
            direction: PathArc.Counterclockwise
        }
        PathLine {
            x: 0
            y: 0
        }
    }
}
