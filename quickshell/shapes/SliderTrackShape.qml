import QtQuick
import QtQuick.Shapes
import ".."

Shape {
    id: root
    required property bool isActiveTrack
    required property real value

    readonly property int smallRadius: (isActiveTrack ? value > 0.02 : value < 0.98) * 2
    readonly property int r1: isActiveTrack ? smallRadius : DesignConf.radius
    readonly property int r2: isActiveTrack ? DesignConf.radius : smallRadius

    layer.enabled: true
    layer.samples: 20
    anchors.fill: parent

    ShapePath {
        fillColor: root.isActiveTrack ? ColoursConf.lightblue : ColoursConf.bg3.t
        strokeWidth: 0
        Component.onCompleted: pathElements.forEach(p => {
            if (p instanceof PathArc)
                p.radiusY = p.radiusX;
        })

        startX: DesignConf.radius
        startY: 0

        PathLine {
            x: root.parent.width - root.r1
            y: 0
        }
        PathArc {
            x: root.parent.width
            y: root.r1
            radiusX: root.r1
        }
        PathLine {
            x: root.parent.width
            y: root.parent.height - root.r1
        }
        PathArc {
            x: root.parent.width - root.r1
            y: root.parent.height
            radiusX: root.r1
        }
        PathLine {
            x: root.r2
            y: root.parent.height
        }
        PathArc {
            x: 0
            y: root.parent.height - root.r2
            radiusX: root.r2
        }
        PathLine {
            x: 0
            y: root.r2
        }
        PathArc {
            x: root.r2
            y: 0
            radiusX: root.r2
        }
    }
}
