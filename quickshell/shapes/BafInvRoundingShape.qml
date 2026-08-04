import QtQuick
import QtQuick.Shapes
import ".."

Shape {
    id: root
    required property BafContainerShape bafContainer
    required property bool isOpen
    property int scaledHeight: Math.max(bafContainer.y + DesignConf.radius, parent.height - DesignConf.radius)

    layer.enabled: true
    layer.samples: 20
    opacity: isOpen || bafContainer.y < parent.height ? 1 : 0

    ShapePath {
        fillColor: ColoursConf.bg1
        strokeWidth: 0
        Component.onCompleted: UtilsService.setAllPathArcRadii(pathElements)

        startX: root.bafContainer.x
        startY: root.parent.height

        PathLine {
            x: root.bafContainer.x - DesignConf.radius
            y: root.parent.height
        }
        PathArc {
            x: root.bafContainer.x
            y: root.scaledHeight
            direction: PathArc.Counterclockwise
        }
        PathLine {
            x: root.bafContainer.x
            y: root.parent.height
        }
    }

    ShapePath {
        fillColor: ColoursConf.bg1
        strokeWidth: 0
        Component.onCompleted: UtilsService.setAllPathArcRadii(pathElements)

        startX: root.bafContainer.x + root.bafContainer.width
        startY: root.parent.height

        PathLine {
            x: root.bafContainer.x + root.bafContainer.width + DesignConf.radius
            y: root.parent.height
        }
        PathArc {
            x: root.bafContainer.x + root.bafContainer.width
            y: root.scaledHeight
        }
        PathLine {
            x: root.bafContainer.x + root.bafContainer.width
            y: root.parent.height
        }
    }
}
