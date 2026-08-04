import QtQuick
import QtQuick.Shapes
import ".."

Shape {
    id: root
    required property FlyoutContainerShape flyoutContainer
    property int scaledHeight: Math.min(flyoutContainer.height + flyoutContainer.y - DesignConf.radius, DesignConf.radius)

    ShapePath {
        fillColor: ColoursConf.bg1
        strokeWidth: 0
        Component.onCompleted: UtilsService.setAllPathArcRadii(pathElements)

        startX: root.flyoutContainer.x
        startY: 0

        PathLine {
            x: root.flyoutContainer.x - DesignConf.radius
            y: 0
        }
        PathArc {
            x: root.flyoutContainer.x
            y: root.scaledHeight
        }
        PathLine {
            x: root.flyoutContainer.x
            y: 0
        }
    }

    ShapePath {
        fillColor: ColoursConf.bg1
        strokeWidth: 0
        Component.onCompleted: UtilsService.setAllPathArcRadii(pathElements)

        startX: root.flyoutContainer.x + root.flyoutContainer.width
        startY: 0

        PathLine {
            x: root.flyoutContainer.x + root.flyoutContainer.width + DesignConf.radius
            y: 0
        }
        PathArc {
            x: root.flyoutContainer.x + root.flyoutContainer.width
            y: root.scaledHeight
            direction: PathArc.Counterclockwise
        }
        PathLine {
            x: root.flyoutContainer.x + root.flyoutContainer.width
            y: 0
        }
    }
}
