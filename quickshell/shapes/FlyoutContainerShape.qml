import QtQuick
import QtQuick.Shapes
import ".."
import "../animations/transitions"

Shape {
    id: rect
    required property bool isOpen
    required property int parentX

    x: UtilsService.clamp(parentX - width / 2, 0, parent.width - width)
    y: isOpen ? 0 : -height
    clip: true

    DefaultTrans on y {}
    DefaultTrans on height {}

    ShapePath {
        fillColor: ColoursConf.bg1
        strokeWidth: 0
        Component.onCompleted: UtilsService.setAllPathArcRadii(pathElements)

        startX: 0
        startY: 0

        PathLine {
            x: rect.width
            y: 0
        }
        PathLine {
            x: rect.width
            y: rect.height - DesignConf.radius
        }
        PathArc {
            x: rect.width - DesignConf.radius
            y: rect.height
        }
        PathLine {
            x: DesignConf.radius
            y: rect.height
        }
        PathArc {
            x: 0
            y: rect.height - DesignConf.radius
        }
        PathLine {
            x: 0
            y: 0
        }
    }
}
