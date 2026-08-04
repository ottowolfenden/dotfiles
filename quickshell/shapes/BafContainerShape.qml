import QtQuick
import QtQuick.Shapes
import ".."
import "../animations/transitions"

Shape {
    id: root
    required property bool isOpen

    opacity: isOpen || y < parent.height ? 1 : 0
    x: parent.width / 2 - width / 2
    y: {
        if (parent.height <= 0)
            return Screen.height;
        return isOpen ? (parent.height - height) : parent.height;
    }

    DefaultTrans on y {
        enabled: root.parent.height > 0
    }

    ShapePath {
        fillColor: ColoursConf.bg1
        strokeWidth: 0
        Component.onCompleted: UtilsService.setAllPathArcRadii(pathElements)

        startX: 0
        startY: root.height

        PathLine {
            x: 0
            y: DesignConf.radius
        }
        PathArc {
            x: DesignConf.radius
            y: 0
        }
        PathLine {
            x: root.width - DesignConf.radius
            y: 0
        }
        PathArc {
            x: root.width
            y: DesignConf.radius
        }
        PathLine {
            x: root.width
            y: root.height
        }
        PathLine {
            x: 0
            y: root.height
        }
    }
}
